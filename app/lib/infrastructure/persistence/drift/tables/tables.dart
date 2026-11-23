// SQL の CHECK 制約は長い式を読みやすく分けて書く。
// ignore_for_file: no_adjacent_strings_in_list

import 'package:app/domain/domain.dart';
import 'package:drift/drift.dart';

/// `email_imports.service` に保存するチケットサービス。
enum StoredMailService { eplus, livepocket }

/// `gmail_sync_states.last_failure_kind` に保存する失敗の種類。
enum StoredFailureKind { reauthRequired, other }

/// 失敗の種類を snake_case の保存値に対応させる。
class FailureKindConverter extends TypeConverter<StoredFailureKind, String> {
  /// 保存値と enum を相互に変換する。
  const FailureKindConverter();

  @override
  StoredFailureKind fromSql(String fromDb) => fromDb == 'reauth_required'
      ? StoredFailureKind.reauthRequired
      : StoredFailureKind.other;

  @override
  String toSql(StoredFailureKind value) =>
      value == StoredFailureKind.reauthRequired ? 'reauth_required' : 'other';
}

/// 推し活代の月額の履歴。
@DataClassName('BudgetRateRow')
class BudgetRates extends Table {
  TextColumn get effectiveMonth => text().customConstraint(
    // drift は customConstraint に定数の文字列リテラルを求める。
    // ignore: lines_longer_than_80_chars
    "NOT NULL CHECK (date(effective_month || '-01') IS effective_month || '-01')",
  )();
  IntColumn get amountYen =>
      integer().customConstraint('NOT NULL CHECK (amount_yen >= 0)')();
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now().toUtc())();
  DateTimeColumn get updatedAt =>
      dateTime().clientDefault(() => DateTime.now().toUtc())();

  @override
  Set<Column> get primaryKey => {effectiveMonth};
}

/// 月ごとの推し活代の上書き。
@DataClassName('BudgetOverrideRow')
class BudgetOverrides extends Table {
  TextColumn get month => text().customConstraint(
    "NOT NULL CHECK (date(month || '-01') IS month || '-01')",
  )();
  IntColumn get amountYen =>
      integer().customConstraint('NOT NULL CHECK (amount_yen >= 0)')();
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now().toUtc())();
  DateTimeColumn get updatedAt =>
      dateTime().clientDefault(() => DateTime.now().toUtc())();

  @override
  Set<Column> get primaryKey => {month};
}

/// 公演。
@TableIndex(name: 'performances_starts_at', columns: {#startsAt})
@TableIndex(name: 'performances_title_starts_at', columns: {#title, #startsAt})
@DataClassName('PerformanceRow')
class Performances extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  DateTimeColumn get startsAt => dateTime()();
  TextColumn get venue => text().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now().toUtc())();
  DateTimeColumn get updatedAt =>
      dateTime().clientDefault(() => DateTime.now().toUtc())();
}

/// 支出。全カテゴリを1つの表で持つ。
@TableIndex(name: 'expenses_paid_on', columns: {#paidOn})
@TableIndex(
  name: 'expenses_performance_id_category',
  columns: {#performanceId, #category},
)
@TableIndex(name: 'expenses_partner_id', columns: {#partnerId})
@TableIndex(name: 'expenses_email_import_id', columns: {#emailImportId})
@DataClassName('ExpenseRow')
class Expenses extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get category => textEnum<ExpenseCategory>()();
  IntColumn get amountYen =>
      integer().customConstraint('NOT NULL CHECK (amount_yen >= 0)')();
  TextColumn get paidOn => text().customConstraint(
    'NOT NULL CHECK (date(paid_on) IS paid_on)',
  )();
  IntColumn get performanceId => integer().nullable().references(
    Performances,
    #id,
    onDelete: KeyAction.setNull,
  )();
  IntColumn get partnerId => integer().nullable().references(
    Partners,
    #id,
    onDelete: KeyAction.restrict,
  )();
  IntColumn get shotCount =>
      integer().nullable().customConstraint('CHECK (shot_count > 0)')();
  IntColumn get emailImportId => integer().nullable().references(
    EmailImports,
    #id,
    onDelete: KeyAction.setNull,
  )();
  TextColumn get note => text().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now().toUtc())();
  DateTimeColumn get updatedAt =>
      dateTime().clientDefault(() => DateTime.now().toUtc())();

  @override
  List<String> get customConstraints => [
    "CHECK (category IN ('ticket', 'drink', 'cheki', 'goods', 'transport', "
        "'locker', 'other'))",
    "CHECK (category NOT IN ('ticket', 'drink', 'cheki') "
        'OR performance_id IS NOT NULL)',
    "CHECK ((category = 'cheki' AND partner_id IS NOT NULL "
        'AND shot_count IS NOT NULL) '
        "OR (category <> 'cheki' AND partner_id IS NULL "
        'AND shot_count IS NULL))',
  ];
}

/// チェキ相手。
@TableIndex(name: 'partners_name', columns: {#name})
@DataClassName('PartnerRow')
class Partners extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get groupName => text().nullable()();
  TextColumn get iconFile => text().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now().toUtc())();
  DateTimeColumn get updatedAt =>
      dateTime().clientDefault(() => DateTime.now().toUtc())();
}

/// 取り込みに成功したメール。
@DataClassName('EmailImportRow')
class EmailImports extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get accountEmail => text()();
  TextColumn get gmailMessageId => text()();
  TextColumn get service => textEnum<StoredMailService>()();
  TextColumn get subject => text()();
  DateTimeColumn get receivedAt => dateTime()();
  DateTimeColumn get importedAt => dateTime()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {accountEmail, gmailMessageId},
  ];

  @override
  List<String> get customConstraints => [
    "CHECK (service IN ('eplus', 'livepocket'))",
  ];
}

/// Gmail アカウントの同期状態。
@DataClassName('GmailSyncStateRow')
class GmailSyncStates extends Table {
  TextColumn get accountEmail => text()();
  DateTimeColumn get connectedAt => dateTime()();
  DateTimeColumn get lastFetchedAt => dateTime().nullable()();
  DateTimeColumn get lastMessageReceivedAt => dateTime().nullable()();
  DateTimeColumn get lastFailedAt => dateTime().nullable()();
  TextColumn get lastFailureKind =>
      text().map(const FailureKindConverter()).nullable()();
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now().toUtc())();
  DateTimeColumn get updatedAt =>
      dateTime().clientDefault(() => DateTime.now().toUtc())();

  @override
  Set<Column> get primaryKey => {accountEmail};

  @override
  List<String> get customConstraints => [
    'CHECK (last_failure_kind IS NULL OR last_failure_kind IN '
        "('reauth_required', 'other'))",
    'CHECK ((last_failed_at IS NULL) = (last_failure_kind IS NULL))',
  ];
}
