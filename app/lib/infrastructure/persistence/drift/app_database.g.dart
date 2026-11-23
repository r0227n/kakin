// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $BudgetRatesTable extends BudgetRates
    with TableInfo<$BudgetRatesTable, BudgetRateRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BudgetRatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _effectiveMonthMeta = const VerificationMeta(
    'effectiveMonth',
  );
  @override
  late final GeneratedColumn<String> effectiveMonth = GeneratedColumn<String>(
    'effective_month',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints:
        'NOT NULL CHECK (date(effective_month || \'-01\') IS effective_month || \'-01\')',
  );
  static const VerificationMeta _amountYenMeta = const VerificationMeta(
    'amountYen',
  );
  @override
  late final GeneratedColumn<int> amountYen = GeneratedColumn<int>(
    'amount_yen',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (amount_yen >= 0)',
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now().toUtc(),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now().toUtc(),
  );
  @override
  List<GeneratedColumn> get $columns => [
    effectiveMonth,
    amountYen,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'budget_rates';
  @override
  VerificationContext validateIntegrity(
    Insertable<BudgetRateRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('effective_month')) {
      context.handle(
        _effectiveMonthMeta,
        effectiveMonth.isAcceptableOrUnknown(
          data['effective_month']!,
          _effectiveMonthMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_effectiveMonthMeta);
    }
    if (data.containsKey('amount_yen')) {
      context.handle(
        _amountYenMeta,
        amountYen.isAcceptableOrUnknown(data['amount_yen']!, _amountYenMeta),
      );
    } else if (isInserting) {
      context.missing(_amountYenMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {effectiveMonth};
  @override
  BudgetRateRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BudgetRateRow(
      effectiveMonth: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}effective_month'],
      )!,
      amountYen: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_yen'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $BudgetRatesTable createAlias(String alias) {
    return $BudgetRatesTable(attachedDatabase, alias);
  }
}

class BudgetRateRow extends DataClass implements Insertable<BudgetRateRow> {
  final String effectiveMonth;
  final int amountYen;
  final DateTime createdAt;
  final DateTime updatedAt;
  const BudgetRateRow({
    required this.effectiveMonth,
    required this.amountYen,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['effective_month'] = Variable<String>(effectiveMonth);
    map['amount_yen'] = Variable<int>(amountYen);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  BudgetRatesCompanion toCompanion(bool nullToAbsent) {
    return BudgetRatesCompanion(
      effectiveMonth: Value(effectiveMonth),
      amountYen: Value(amountYen),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory BudgetRateRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BudgetRateRow(
      effectiveMonth: serializer.fromJson<String>(json['effectiveMonth']),
      amountYen: serializer.fromJson<int>(json['amountYen']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'effectiveMonth': serializer.toJson<String>(effectiveMonth),
      'amountYen': serializer.toJson<int>(amountYen),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  BudgetRateRow copyWith({
    String? effectiveMonth,
    int? amountYen,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => BudgetRateRow(
    effectiveMonth: effectiveMonth ?? this.effectiveMonth,
    amountYen: amountYen ?? this.amountYen,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  BudgetRateRow copyWithCompanion(BudgetRatesCompanion data) {
    return BudgetRateRow(
      effectiveMonth: data.effectiveMonth.present
          ? data.effectiveMonth.value
          : this.effectiveMonth,
      amountYen: data.amountYen.present ? data.amountYen.value : this.amountYen,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BudgetRateRow(')
          ..write('effectiveMonth: $effectiveMonth, ')
          ..write('amountYen: $amountYen, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(effectiveMonth, amountYen, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BudgetRateRow &&
          other.effectiveMonth == this.effectiveMonth &&
          other.amountYen == this.amountYen &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class BudgetRatesCompanion extends UpdateCompanion<BudgetRateRow> {
  final Value<String> effectiveMonth;
  final Value<int> amountYen;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const BudgetRatesCompanion({
    this.effectiveMonth = const Value.absent(),
    this.amountYen = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BudgetRatesCompanion.insert({
    required String effectiveMonth,
    required int amountYen,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : effectiveMonth = Value(effectiveMonth),
       amountYen = Value(amountYen);
  static Insertable<BudgetRateRow> custom({
    Expression<String>? effectiveMonth,
    Expression<int>? amountYen,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (effectiveMonth != null) 'effective_month': effectiveMonth,
      if (amountYen != null) 'amount_yen': amountYen,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BudgetRatesCompanion copyWith({
    Value<String>? effectiveMonth,
    Value<int>? amountYen,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return BudgetRatesCompanion(
      effectiveMonth: effectiveMonth ?? this.effectiveMonth,
      amountYen: amountYen ?? this.amountYen,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (effectiveMonth.present) {
      map['effective_month'] = Variable<String>(effectiveMonth.value);
    }
    if (amountYen.present) {
      map['amount_yen'] = Variable<int>(amountYen.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BudgetRatesCompanion(')
          ..write('effectiveMonth: $effectiveMonth, ')
          ..write('amountYen: $amountYen, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BudgetOverridesTable extends BudgetOverrides
    with TableInfo<$BudgetOverridesTable, BudgetOverrideRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BudgetOverridesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _monthMeta = const VerificationMeta('month');
  @override
  late final GeneratedColumn<String> month = GeneratedColumn<String>(
    'month',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints:
        'NOT NULL CHECK (date(month || \'-01\') IS month || \'-01\')',
  );
  static const VerificationMeta _amountYenMeta = const VerificationMeta(
    'amountYen',
  );
  @override
  late final GeneratedColumn<int> amountYen = GeneratedColumn<int>(
    'amount_yen',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (amount_yen >= 0)',
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now().toUtc(),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now().toUtc(),
  );
  @override
  List<GeneratedColumn> get $columns => [
    month,
    amountYen,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'budget_overrides';
  @override
  VerificationContext validateIntegrity(
    Insertable<BudgetOverrideRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('month')) {
      context.handle(
        _monthMeta,
        month.isAcceptableOrUnknown(data['month']!, _monthMeta),
      );
    } else if (isInserting) {
      context.missing(_monthMeta);
    }
    if (data.containsKey('amount_yen')) {
      context.handle(
        _amountYenMeta,
        amountYen.isAcceptableOrUnknown(data['amount_yen']!, _amountYenMeta),
      );
    } else if (isInserting) {
      context.missing(_amountYenMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {month};
  @override
  BudgetOverrideRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BudgetOverrideRow(
      month: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}month'],
      )!,
      amountYen: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_yen'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $BudgetOverridesTable createAlias(String alias) {
    return $BudgetOverridesTable(attachedDatabase, alias);
  }
}

class BudgetOverrideRow extends DataClass
    implements Insertable<BudgetOverrideRow> {
  final String month;
  final int amountYen;
  final DateTime createdAt;
  final DateTime updatedAt;
  const BudgetOverrideRow({
    required this.month,
    required this.amountYen,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['month'] = Variable<String>(month);
    map['amount_yen'] = Variable<int>(amountYen);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  BudgetOverridesCompanion toCompanion(bool nullToAbsent) {
    return BudgetOverridesCompanion(
      month: Value(month),
      amountYen: Value(amountYen),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory BudgetOverrideRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BudgetOverrideRow(
      month: serializer.fromJson<String>(json['month']),
      amountYen: serializer.fromJson<int>(json['amountYen']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'month': serializer.toJson<String>(month),
      'amountYen': serializer.toJson<int>(amountYen),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  BudgetOverrideRow copyWith({
    String? month,
    int? amountYen,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => BudgetOverrideRow(
    month: month ?? this.month,
    amountYen: amountYen ?? this.amountYen,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  BudgetOverrideRow copyWithCompanion(BudgetOverridesCompanion data) {
    return BudgetOverrideRow(
      month: data.month.present ? data.month.value : this.month,
      amountYen: data.amountYen.present ? data.amountYen.value : this.amountYen,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BudgetOverrideRow(')
          ..write('month: $month, ')
          ..write('amountYen: $amountYen, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(month, amountYen, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BudgetOverrideRow &&
          other.month == this.month &&
          other.amountYen == this.amountYen &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class BudgetOverridesCompanion extends UpdateCompanion<BudgetOverrideRow> {
  final Value<String> month;
  final Value<int> amountYen;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const BudgetOverridesCompanion({
    this.month = const Value.absent(),
    this.amountYen = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BudgetOverridesCompanion.insert({
    required String month,
    required int amountYen,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : month = Value(month),
       amountYen = Value(amountYen);
  static Insertable<BudgetOverrideRow> custom({
    Expression<String>? month,
    Expression<int>? amountYen,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (month != null) 'month': month,
      if (amountYen != null) 'amount_yen': amountYen,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BudgetOverridesCompanion copyWith({
    Value<String>? month,
    Value<int>? amountYen,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return BudgetOverridesCompanion(
      month: month ?? this.month,
      amountYen: amountYen ?? this.amountYen,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (month.present) {
      map['month'] = Variable<String>(month.value);
    }
    if (amountYen.present) {
      map['amount_yen'] = Variable<int>(amountYen.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BudgetOverridesCompanion(')
          ..write('month: $month, ')
          ..write('amountYen: $amountYen, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PerformancesTable extends Performances
    with TableInfo<$PerformancesTable, PerformanceRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PerformancesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startsAtMeta = const VerificationMeta(
    'startsAt',
  );
  @override
  late final GeneratedColumn<DateTime> startsAt = GeneratedColumn<DateTime>(
    'starts_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _venueMeta = const VerificationMeta('venue');
  @override
  late final GeneratedColumn<String> venue = GeneratedColumn<String>(
    'venue',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now().toUtc(),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now().toUtc(),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    startsAt,
    venue,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'performances';
  @override
  VerificationContext validateIntegrity(
    Insertable<PerformanceRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('starts_at')) {
      context.handle(
        _startsAtMeta,
        startsAt.isAcceptableOrUnknown(data['starts_at']!, _startsAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startsAtMeta);
    }
    if (data.containsKey('venue')) {
      context.handle(
        _venueMeta,
        venue.isAcceptableOrUnknown(data['venue']!, _venueMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PerformanceRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PerformanceRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      startsAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}starts_at'],
      )!,
      venue: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}venue'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $PerformancesTable createAlias(String alias) {
    return $PerformancesTable(attachedDatabase, alias);
  }
}

class PerformanceRow extends DataClass implements Insertable<PerformanceRow> {
  final int id;
  final String title;
  final DateTime startsAt;
  final String? venue;
  final DateTime createdAt;
  final DateTime updatedAt;
  const PerformanceRow({
    required this.id,
    required this.title,
    required this.startsAt,
    this.venue,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['starts_at'] = Variable<DateTime>(startsAt);
    if (!nullToAbsent || venue != null) {
      map['venue'] = Variable<String>(venue);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PerformancesCompanion toCompanion(bool nullToAbsent) {
    return PerformancesCompanion(
      id: Value(id),
      title: Value(title),
      startsAt: Value(startsAt),
      venue: venue == null && nullToAbsent
          ? const Value.absent()
          : Value(venue),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory PerformanceRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PerformanceRow(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      startsAt: serializer.fromJson<DateTime>(json['startsAt']),
      venue: serializer.fromJson<String?>(json['venue']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'startsAt': serializer.toJson<DateTime>(startsAt),
      'venue': serializer.toJson<String?>(venue),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  PerformanceRow copyWith({
    int? id,
    String? title,
    DateTime? startsAt,
    Value<String?> venue = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => PerformanceRow(
    id: id ?? this.id,
    title: title ?? this.title,
    startsAt: startsAt ?? this.startsAt,
    venue: venue.present ? venue.value : this.venue,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  PerformanceRow copyWithCompanion(PerformancesCompanion data) {
    return PerformanceRow(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      startsAt: data.startsAt.present ? data.startsAt.value : this.startsAt,
      venue: data.venue.present ? data.venue.value : this.venue,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PerformanceRow(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('startsAt: $startsAt, ')
          ..write('venue: $venue, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, title, startsAt, venue, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PerformanceRow &&
          other.id == this.id &&
          other.title == this.title &&
          other.startsAt == this.startsAt &&
          other.venue == this.venue &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PerformancesCompanion extends UpdateCompanion<PerformanceRow> {
  final Value<int> id;
  final Value<String> title;
  final Value<DateTime> startsAt;
  final Value<String?> venue;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const PerformancesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.startsAt = const Value.absent(),
    this.venue = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  PerformancesCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required DateTime startsAt,
    this.venue = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : title = Value(title),
       startsAt = Value(startsAt);
  static Insertable<PerformanceRow> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<DateTime>? startsAt,
    Expression<String>? venue,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (startsAt != null) 'starts_at': startsAt,
      if (venue != null) 'venue': venue,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  PerformancesCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<DateTime>? startsAt,
    Value<String?>? venue,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return PerformancesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      startsAt: startsAt ?? this.startsAt,
      venue: venue ?? this.venue,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (startsAt.present) {
      map['starts_at'] = Variable<DateTime>(startsAt.value);
    }
    if (venue.present) {
      map['venue'] = Variable<String>(venue.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PerformancesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('startsAt: $startsAt, ')
          ..write('venue: $venue, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $PartnersTable extends Partners
    with TableInfo<$PartnersTable, PartnerRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PartnersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _groupNameMeta = const VerificationMeta(
    'groupName',
  );
  @override
  late final GeneratedColumn<String> groupName = GeneratedColumn<String>(
    'group_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _iconFileMeta = const VerificationMeta(
    'iconFile',
  );
  @override
  late final GeneratedColumn<String> iconFile = GeneratedColumn<String>(
    'icon_file',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now().toUtc(),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now().toUtc(),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    groupName,
    iconFile,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'partners';
  @override
  VerificationContext validateIntegrity(
    Insertable<PartnerRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('group_name')) {
      context.handle(
        _groupNameMeta,
        groupName.isAcceptableOrUnknown(data['group_name']!, _groupNameMeta),
      );
    }
    if (data.containsKey('icon_file')) {
      context.handle(
        _iconFileMeta,
        iconFile.isAcceptableOrUnknown(data['icon_file']!, _iconFileMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PartnerRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PartnerRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      groupName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}group_name'],
      ),
      iconFile: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon_file'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $PartnersTable createAlias(String alias) {
    return $PartnersTable(attachedDatabase, alias);
  }
}

class PartnerRow extends DataClass implements Insertable<PartnerRow> {
  final int id;
  final String name;
  final String? groupName;
  final String? iconFile;
  final DateTime createdAt;
  final DateTime updatedAt;
  const PartnerRow({
    required this.id,
    required this.name,
    this.groupName,
    this.iconFile,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || groupName != null) {
      map['group_name'] = Variable<String>(groupName);
    }
    if (!nullToAbsent || iconFile != null) {
      map['icon_file'] = Variable<String>(iconFile);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PartnersCompanion toCompanion(bool nullToAbsent) {
    return PartnersCompanion(
      id: Value(id),
      name: Value(name),
      groupName: groupName == null && nullToAbsent
          ? const Value.absent()
          : Value(groupName),
      iconFile: iconFile == null && nullToAbsent
          ? const Value.absent()
          : Value(iconFile),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory PartnerRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PartnerRow(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      groupName: serializer.fromJson<String?>(json['groupName']),
      iconFile: serializer.fromJson<String?>(json['iconFile']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'groupName': serializer.toJson<String?>(groupName),
      'iconFile': serializer.toJson<String?>(iconFile),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  PartnerRow copyWith({
    int? id,
    String? name,
    Value<String?> groupName = const Value.absent(),
    Value<String?> iconFile = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => PartnerRow(
    id: id ?? this.id,
    name: name ?? this.name,
    groupName: groupName.present ? groupName.value : this.groupName,
    iconFile: iconFile.present ? iconFile.value : this.iconFile,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  PartnerRow copyWithCompanion(PartnersCompanion data) {
    return PartnerRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      groupName: data.groupName.present ? data.groupName.value : this.groupName,
      iconFile: data.iconFile.present ? data.iconFile.value : this.iconFile,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PartnerRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('groupName: $groupName, ')
          ..write('iconFile: $iconFile, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, groupName, iconFile, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PartnerRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.groupName == this.groupName &&
          other.iconFile == this.iconFile &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PartnersCompanion extends UpdateCompanion<PartnerRow> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> groupName;
  final Value<String?> iconFile;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const PartnersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.groupName = const Value.absent(),
    this.iconFile = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  PartnersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.groupName = const Value.absent(),
    this.iconFile = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<PartnerRow> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? groupName,
    Expression<String>? iconFile,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (groupName != null) 'group_name': groupName,
      if (iconFile != null) 'icon_file': iconFile,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  PartnersCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? groupName,
    Value<String?>? iconFile,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return PartnersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      groupName: groupName ?? this.groupName,
      iconFile: iconFile ?? this.iconFile,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (groupName.present) {
      map['group_name'] = Variable<String>(groupName.value);
    }
    if (iconFile.present) {
      map['icon_file'] = Variable<String>(iconFile.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PartnersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('groupName: $groupName, ')
          ..write('iconFile: $iconFile, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $EmailImportsTable extends EmailImports
    with TableInfo<$EmailImportsTable, EmailImportRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmailImportsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _accountEmailMeta = const VerificationMeta(
    'accountEmail',
  );
  @override
  late final GeneratedColumn<String> accountEmail = GeneratedColumn<String>(
    'account_email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _gmailMessageIdMeta = const VerificationMeta(
    'gmailMessageId',
  );
  @override
  late final GeneratedColumn<String> gmailMessageId = GeneratedColumn<String>(
    'gmail_message_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<StoredMailService, String>
  service = GeneratedColumn<String>(
    'service',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<StoredMailService>($EmailImportsTable.$converterservice);
  static const VerificationMeta _subjectMeta = const VerificationMeta(
    'subject',
  );
  @override
  late final GeneratedColumn<String> subject = GeneratedColumn<String>(
    'subject',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _receivedAtMeta = const VerificationMeta(
    'receivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> receivedAt = GeneratedColumn<DateTime>(
    'received_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _importedAtMeta = const VerificationMeta(
    'importedAt',
  );
  @override
  late final GeneratedColumn<DateTime> importedAt = GeneratedColumn<DateTime>(
    'imported_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    accountEmail,
    gmailMessageId,
    service,
    subject,
    receivedAt,
    importedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'email_imports';
  @override
  VerificationContext validateIntegrity(
    Insertable<EmailImportRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('account_email')) {
      context.handle(
        _accountEmailMeta,
        accountEmail.isAcceptableOrUnknown(
          data['account_email']!,
          _accountEmailMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_accountEmailMeta);
    }
    if (data.containsKey('gmail_message_id')) {
      context.handle(
        _gmailMessageIdMeta,
        gmailMessageId.isAcceptableOrUnknown(
          data['gmail_message_id']!,
          _gmailMessageIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_gmailMessageIdMeta);
    }
    if (data.containsKey('subject')) {
      context.handle(
        _subjectMeta,
        subject.isAcceptableOrUnknown(data['subject']!, _subjectMeta),
      );
    } else if (isInserting) {
      context.missing(_subjectMeta);
    }
    if (data.containsKey('received_at')) {
      context.handle(
        _receivedAtMeta,
        receivedAt.isAcceptableOrUnknown(data['received_at']!, _receivedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_receivedAtMeta);
    }
    if (data.containsKey('imported_at')) {
      context.handle(
        _importedAtMeta,
        importedAt.isAcceptableOrUnknown(data['imported_at']!, _importedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_importedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {accountEmail, gmailMessageId},
  ];
  @override
  EmailImportRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EmailImportRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      accountEmail: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_email'],
      )!,
      gmailMessageId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gmail_message_id'],
      )!,
      service: $EmailImportsTable.$converterservice.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}service'],
        )!,
      ),
      subject: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subject'],
      )!,
      receivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}received_at'],
      )!,
      importedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}imported_at'],
      )!,
    );
  }

  @override
  $EmailImportsTable createAlias(String alias) {
    return $EmailImportsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<StoredMailService, String, String>
  $converterservice = const EnumNameConverter<StoredMailService>(
    StoredMailService.values,
  );
}

class EmailImportRow extends DataClass implements Insertable<EmailImportRow> {
  final int id;
  final String accountEmail;
  final String gmailMessageId;
  final StoredMailService service;
  final String subject;
  final DateTime receivedAt;
  final DateTime importedAt;
  const EmailImportRow({
    required this.id,
    required this.accountEmail,
    required this.gmailMessageId,
    required this.service,
    required this.subject,
    required this.receivedAt,
    required this.importedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['account_email'] = Variable<String>(accountEmail);
    map['gmail_message_id'] = Variable<String>(gmailMessageId);
    {
      map['service'] = Variable<String>(
        $EmailImportsTable.$converterservice.toSql(service),
      );
    }
    map['subject'] = Variable<String>(subject);
    map['received_at'] = Variable<DateTime>(receivedAt);
    map['imported_at'] = Variable<DateTime>(importedAt);
    return map;
  }

  EmailImportsCompanion toCompanion(bool nullToAbsent) {
    return EmailImportsCompanion(
      id: Value(id),
      accountEmail: Value(accountEmail),
      gmailMessageId: Value(gmailMessageId),
      service: Value(service),
      subject: Value(subject),
      receivedAt: Value(receivedAt),
      importedAt: Value(importedAt),
    );
  }

  factory EmailImportRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EmailImportRow(
      id: serializer.fromJson<int>(json['id']),
      accountEmail: serializer.fromJson<String>(json['accountEmail']),
      gmailMessageId: serializer.fromJson<String>(json['gmailMessageId']),
      service: $EmailImportsTable.$converterservice.fromJson(
        serializer.fromJson<String>(json['service']),
      ),
      subject: serializer.fromJson<String>(json['subject']),
      receivedAt: serializer.fromJson<DateTime>(json['receivedAt']),
      importedAt: serializer.fromJson<DateTime>(json['importedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'accountEmail': serializer.toJson<String>(accountEmail),
      'gmailMessageId': serializer.toJson<String>(gmailMessageId),
      'service': serializer.toJson<String>(
        $EmailImportsTable.$converterservice.toJson(service),
      ),
      'subject': serializer.toJson<String>(subject),
      'receivedAt': serializer.toJson<DateTime>(receivedAt),
      'importedAt': serializer.toJson<DateTime>(importedAt),
    };
  }

  EmailImportRow copyWith({
    int? id,
    String? accountEmail,
    String? gmailMessageId,
    StoredMailService? service,
    String? subject,
    DateTime? receivedAt,
    DateTime? importedAt,
  }) => EmailImportRow(
    id: id ?? this.id,
    accountEmail: accountEmail ?? this.accountEmail,
    gmailMessageId: gmailMessageId ?? this.gmailMessageId,
    service: service ?? this.service,
    subject: subject ?? this.subject,
    receivedAt: receivedAt ?? this.receivedAt,
    importedAt: importedAt ?? this.importedAt,
  );
  EmailImportRow copyWithCompanion(EmailImportsCompanion data) {
    return EmailImportRow(
      id: data.id.present ? data.id.value : this.id,
      accountEmail: data.accountEmail.present
          ? data.accountEmail.value
          : this.accountEmail,
      gmailMessageId: data.gmailMessageId.present
          ? data.gmailMessageId.value
          : this.gmailMessageId,
      service: data.service.present ? data.service.value : this.service,
      subject: data.subject.present ? data.subject.value : this.subject,
      receivedAt: data.receivedAt.present
          ? data.receivedAt.value
          : this.receivedAt,
      importedAt: data.importedAt.present
          ? data.importedAt.value
          : this.importedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EmailImportRow(')
          ..write('id: $id, ')
          ..write('accountEmail: $accountEmail, ')
          ..write('gmailMessageId: $gmailMessageId, ')
          ..write('service: $service, ')
          ..write('subject: $subject, ')
          ..write('receivedAt: $receivedAt, ')
          ..write('importedAt: $importedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    accountEmail,
    gmailMessageId,
    service,
    subject,
    receivedAt,
    importedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EmailImportRow &&
          other.id == this.id &&
          other.accountEmail == this.accountEmail &&
          other.gmailMessageId == this.gmailMessageId &&
          other.service == this.service &&
          other.subject == this.subject &&
          other.receivedAt == this.receivedAt &&
          other.importedAt == this.importedAt);
}

class EmailImportsCompanion extends UpdateCompanion<EmailImportRow> {
  final Value<int> id;
  final Value<String> accountEmail;
  final Value<String> gmailMessageId;
  final Value<StoredMailService> service;
  final Value<String> subject;
  final Value<DateTime> receivedAt;
  final Value<DateTime> importedAt;
  const EmailImportsCompanion({
    this.id = const Value.absent(),
    this.accountEmail = const Value.absent(),
    this.gmailMessageId = const Value.absent(),
    this.service = const Value.absent(),
    this.subject = const Value.absent(),
    this.receivedAt = const Value.absent(),
    this.importedAt = const Value.absent(),
  });
  EmailImportsCompanion.insert({
    this.id = const Value.absent(),
    required String accountEmail,
    required String gmailMessageId,
    required StoredMailService service,
    required String subject,
    required DateTime receivedAt,
    required DateTime importedAt,
  }) : accountEmail = Value(accountEmail),
       gmailMessageId = Value(gmailMessageId),
       service = Value(service),
       subject = Value(subject),
       receivedAt = Value(receivedAt),
       importedAt = Value(importedAt);
  static Insertable<EmailImportRow> custom({
    Expression<int>? id,
    Expression<String>? accountEmail,
    Expression<String>? gmailMessageId,
    Expression<String>? service,
    Expression<String>? subject,
    Expression<DateTime>? receivedAt,
    Expression<DateTime>? importedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountEmail != null) 'account_email': accountEmail,
      if (gmailMessageId != null) 'gmail_message_id': gmailMessageId,
      if (service != null) 'service': service,
      if (subject != null) 'subject': subject,
      if (receivedAt != null) 'received_at': receivedAt,
      if (importedAt != null) 'imported_at': importedAt,
    });
  }

  EmailImportsCompanion copyWith({
    Value<int>? id,
    Value<String>? accountEmail,
    Value<String>? gmailMessageId,
    Value<StoredMailService>? service,
    Value<String>? subject,
    Value<DateTime>? receivedAt,
    Value<DateTime>? importedAt,
  }) {
    return EmailImportsCompanion(
      id: id ?? this.id,
      accountEmail: accountEmail ?? this.accountEmail,
      gmailMessageId: gmailMessageId ?? this.gmailMessageId,
      service: service ?? this.service,
      subject: subject ?? this.subject,
      receivedAt: receivedAt ?? this.receivedAt,
      importedAt: importedAt ?? this.importedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (accountEmail.present) {
      map['account_email'] = Variable<String>(accountEmail.value);
    }
    if (gmailMessageId.present) {
      map['gmail_message_id'] = Variable<String>(gmailMessageId.value);
    }
    if (service.present) {
      map['service'] = Variable<String>(
        $EmailImportsTable.$converterservice.toSql(service.value),
      );
    }
    if (subject.present) {
      map['subject'] = Variable<String>(subject.value);
    }
    if (receivedAt.present) {
      map['received_at'] = Variable<DateTime>(receivedAt.value);
    }
    if (importedAt.present) {
      map['imported_at'] = Variable<DateTime>(importedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EmailImportsCompanion(')
          ..write('id: $id, ')
          ..write('accountEmail: $accountEmail, ')
          ..write('gmailMessageId: $gmailMessageId, ')
          ..write('service: $service, ')
          ..write('subject: $subject, ')
          ..write('receivedAt: $receivedAt, ')
          ..write('importedAt: $importedAt')
          ..write(')'))
        .toString();
  }
}

class $ExpensesTable extends Expenses
    with TableInfo<$ExpensesTable, ExpenseRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpensesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<ExpenseCategory, String>
  category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<ExpenseCategory>($ExpensesTable.$convertercategory);
  static const VerificationMeta _amountYenMeta = const VerificationMeta(
    'amountYen',
  );
  @override
  late final GeneratedColumn<int> amountYen = GeneratedColumn<int>(
    'amount_yen',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (amount_yen >= 0)',
  );
  static const VerificationMeta _paidOnMeta = const VerificationMeta('paidOn');
  @override
  late final GeneratedColumn<String> paidOn = GeneratedColumn<String>(
    'paid_on',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (date(paid_on) IS paid_on)',
  );
  static const VerificationMeta _performanceIdMeta = const VerificationMeta(
    'performanceId',
  );
  @override
  late final GeneratedColumn<int> performanceId = GeneratedColumn<int>(
    'performance_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES performances (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _partnerIdMeta = const VerificationMeta(
    'partnerId',
  );
  @override
  late final GeneratedColumn<int> partnerId = GeneratedColumn<int>(
    'partner_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES partners (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _shotCountMeta = const VerificationMeta(
    'shotCount',
  );
  @override
  late final GeneratedColumn<int> shotCount = GeneratedColumn<int>(
    'shot_count',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'CHECK (shot_count > 0)',
  );
  static const VerificationMeta _emailImportIdMeta = const VerificationMeta(
    'emailImportId',
  );
  @override
  late final GeneratedColumn<int> emailImportId = GeneratedColumn<int>(
    'email_import_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES email_imports (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now().toUtc(),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now().toUtc(),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    category,
    amountYen,
    paidOn,
    performanceId,
    partnerId,
    shotCount,
    emailImportId,
    note,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expenses';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExpenseRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('amount_yen')) {
      context.handle(
        _amountYenMeta,
        amountYen.isAcceptableOrUnknown(data['amount_yen']!, _amountYenMeta),
      );
    } else if (isInserting) {
      context.missing(_amountYenMeta);
    }
    if (data.containsKey('paid_on')) {
      context.handle(
        _paidOnMeta,
        paidOn.isAcceptableOrUnknown(data['paid_on']!, _paidOnMeta),
      );
    } else if (isInserting) {
      context.missing(_paidOnMeta);
    }
    if (data.containsKey('performance_id')) {
      context.handle(
        _performanceIdMeta,
        performanceId.isAcceptableOrUnknown(
          data['performance_id']!,
          _performanceIdMeta,
        ),
      );
    }
    if (data.containsKey('partner_id')) {
      context.handle(
        _partnerIdMeta,
        partnerId.isAcceptableOrUnknown(data['partner_id']!, _partnerIdMeta),
      );
    }
    if (data.containsKey('shot_count')) {
      context.handle(
        _shotCountMeta,
        shotCount.isAcceptableOrUnknown(data['shot_count']!, _shotCountMeta),
      );
    }
    if (data.containsKey('email_import_id')) {
      context.handle(
        _emailImportIdMeta,
        emailImportId.isAcceptableOrUnknown(
          data['email_import_id']!,
          _emailImportIdMeta,
        ),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExpenseRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExpenseRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      category: $ExpensesTable.$convertercategory.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}category'],
        )!,
      ),
      amountYen: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_yen'],
      )!,
      paidOn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}paid_on'],
      )!,
      performanceId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}performance_id'],
      ),
      partnerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}partner_id'],
      ),
      shotCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}shot_count'],
      ),
      emailImportId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}email_import_id'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ExpensesTable createAlias(String alias) {
    return $ExpensesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ExpenseCategory, String, String>
  $convertercategory = const EnumNameConverter<ExpenseCategory>(
    ExpenseCategory.values,
  );
}

class ExpenseRow extends DataClass implements Insertable<ExpenseRow> {
  final int id;
  final ExpenseCategory category;
  final int amountYen;
  final String paidOn;
  final int? performanceId;
  final int? partnerId;
  final int? shotCount;
  final int? emailImportId;
  final String? note;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ExpenseRow({
    required this.id,
    required this.category,
    required this.amountYen,
    required this.paidOn,
    this.performanceId,
    this.partnerId,
    this.shotCount,
    this.emailImportId,
    this.note,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['category'] = Variable<String>(
        $ExpensesTable.$convertercategory.toSql(category),
      );
    }
    map['amount_yen'] = Variable<int>(amountYen);
    map['paid_on'] = Variable<String>(paidOn);
    if (!nullToAbsent || performanceId != null) {
      map['performance_id'] = Variable<int>(performanceId);
    }
    if (!nullToAbsent || partnerId != null) {
      map['partner_id'] = Variable<int>(partnerId);
    }
    if (!nullToAbsent || shotCount != null) {
      map['shot_count'] = Variable<int>(shotCount);
    }
    if (!nullToAbsent || emailImportId != null) {
      map['email_import_id'] = Variable<int>(emailImportId);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ExpensesCompanion toCompanion(bool nullToAbsent) {
    return ExpensesCompanion(
      id: Value(id),
      category: Value(category),
      amountYen: Value(amountYen),
      paidOn: Value(paidOn),
      performanceId: performanceId == null && nullToAbsent
          ? const Value.absent()
          : Value(performanceId),
      partnerId: partnerId == null && nullToAbsent
          ? const Value.absent()
          : Value(partnerId),
      shotCount: shotCount == null && nullToAbsent
          ? const Value.absent()
          : Value(shotCount),
      emailImportId: emailImportId == null && nullToAbsent
          ? const Value.absent()
          : Value(emailImportId),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ExpenseRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExpenseRow(
      id: serializer.fromJson<int>(json['id']),
      category: $ExpensesTable.$convertercategory.fromJson(
        serializer.fromJson<String>(json['category']),
      ),
      amountYen: serializer.fromJson<int>(json['amountYen']),
      paidOn: serializer.fromJson<String>(json['paidOn']),
      performanceId: serializer.fromJson<int?>(json['performanceId']),
      partnerId: serializer.fromJson<int?>(json['partnerId']),
      shotCount: serializer.fromJson<int?>(json['shotCount']),
      emailImportId: serializer.fromJson<int?>(json['emailImportId']),
      note: serializer.fromJson<String?>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'category': serializer.toJson<String>(
        $ExpensesTable.$convertercategory.toJson(category),
      ),
      'amountYen': serializer.toJson<int>(amountYen),
      'paidOn': serializer.toJson<String>(paidOn),
      'performanceId': serializer.toJson<int?>(performanceId),
      'partnerId': serializer.toJson<int?>(partnerId),
      'shotCount': serializer.toJson<int?>(shotCount),
      'emailImportId': serializer.toJson<int?>(emailImportId),
      'note': serializer.toJson<String?>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ExpenseRow copyWith({
    int? id,
    ExpenseCategory? category,
    int? amountYen,
    String? paidOn,
    Value<int?> performanceId = const Value.absent(),
    Value<int?> partnerId = const Value.absent(),
    Value<int?> shotCount = const Value.absent(),
    Value<int?> emailImportId = const Value.absent(),
    Value<String?> note = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => ExpenseRow(
    id: id ?? this.id,
    category: category ?? this.category,
    amountYen: amountYen ?? this.amountYen,
    paidOn: paidOn ?? this.paidOn,
    performanceId: performanceId.present
        ? performanceId.value
        : this.performanceId,
    partnerId: partnerId.present ? partnerId.value : this.partnerId,
    shotCount: shotCount.present ? shotCount.value : this.shotCount,
    emailImportId: emailImportId.present
        ? emailImportId.value
        : this.emailImportId,
    note: note.present ? note.value : this.note,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ExpenseRow copyWithCompanion(ExpensesCompanion data) {
    return ExpenseRow(
      id: data.id.present ? data.id.value : this.id,
      category: data.category.present ? data.category.value : this.category,
      amountYen: data.amountYen.present ? data.amountYen.value : this.amountYen,
      paidOn: data.paidOn.present ? data.paidOn.value : this.paidOn,
      performanceId: data.performanceId.present
          ? data.performanceId.value
          : this.performanceId,
      partnerId: data.partnerId.present ? data.partnerId.value : this.partnerId,
      shotCount: data.shotCount.present ? data.shotCount.value : this.shotCount,
      emailImportId: data.emailImportId.present
          ? data.emailImportId.value
          : this.emailImportId,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExpenseRow(')
          ..write('id: $id, ')
          ..write('category: $category, ')
          ..write('amountYen: $amountYen, ')
          ..write('paidOn: $paidOn, ')
          ..write('performanceId: $performanceId, ')
          ..write('partnerId: $partnerId, ')
          ..write('shotCount: $shotCount, ')
          ..write('emailImportId: $emailImportId, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    category,
    amountYen,
    paidOn,
    performanceId,
    partnerId,
    shotCount,
    emailImportId,
    note,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExpenseRow &&
          other.id == this.id &&
          other.category == this.category &&
          other.amountYen == this.amountYen &&
          other.paidOn == this.paidOn &&
          other.performanceId == this.performanceId &&
          other.partnerId == this.partnerId &&
          other.shotCount == this.shotCount &&
          other.emailImportId == this.emailImportId &&
          other.note == this.note &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ExpensesCompanion extends UpdateCompanion<ExpenseRow> {
  final Value<int> id;
  final Value<ExpenseCategory> category;
  final Value<int> amountYen;
  final Value<String> paidOn;
  final Value<int?> performanceId;
  final Value<int?> partnerId;
  final Value<int?> shotCount;
  final Value<int?> emailImportId;
  final Value<String?> note;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const ExpensesCompanion({
    this.id = const Value.absent(),
    this.category = const Value.absent(),
    this.amountYen = const Value.absent(),
    this.paidOn = const Value.absent(),
    this.performanceId = const Value.absent(),
    this.partnerId = const Value.absent(),
    this.shotCount = const Value.absent(),
    this.emailImportId = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ExpensesCompanion.insert({
    this.id = const Value.absent(),
    required ExpenseCategory category,
    required int amountYen,
    required String paidOn,
    this.performanceId = const Value.absent(),
    this.partnerId = const Value.absent(),
    this.shotCount = const Value.absent(),
    this.emailImportId = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : category = Value(category),
       amountYen = Value(amountYen),
       paidOn = Value(paidOn);
  static Insertable<ExpenseRow> custom({
    Expression<int>? id,
    Expression<String>? category,
    Expression<int>? amountYen,
    Expression<String>? paidOn,
    Expression<int>? performanceId,
    Expression<int>? partnerId,
    Expression<int>? shotCount,
    Expression<int>? emailImportId,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (category != null) 'category': category,
      if (amountYen != null) 'amount_yen': amountYen,
      if (paidOn != null) 'paid_on': paidOn,
      if (performanceId != null) 'performance_id': performanceId,
      if (partnerId != null) 'partner_id': partnerId,
      if (shotCount != null) 'shot_count': shotCount,
      if (emailImportId != null) 'email_import_id': emailImportId,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ExpensesCompanion copyWith({
    Value<int>? id,
    Value<ExpenseCategory>? category,
    Value<int>? amountYen,
    Value<String>? paidOn,
    Value<int?>? performanceId,
    Value<int?>? partnerId,
    Value<int?>? shotCount,
    Value<int?>? emailImportId,
    Value<String?>? note,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return ExpensesCompanion(
      id: id ?? this.id,
      category: category ?? this.category,
      amountYen: amountYen ?? this.amountYen,
      paidOn: paidOn ?? this.paidOn,
      performanceId: performanceId ?? this.performanceId,
      partnerId: partnerId ?? this.partnerId,
      shotCount: shotCount ?? this.shotCount,
      emailImportId: emailImportId ?? this.emailImportId,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(
        $ExpensesTable.$convertercategory.toSql(category.value),
      );
    }
    if (amountYen.present) {
      map['amount_yen'] = Variable<int>(amountYen.value);
    }
    if (paidOn.present) {
      map['paid_on'] = Variable<String>(paidOn.value);
    }
    if (performanceId.present) {
      map['performance_id'] = Variable<int>(performanceId.value);
    }
    if (partnerId.present) {
      map['partner_id'] = Variable<int>(partnerId.value);
    }
    if (shotCount.present) {
      map['shot_count'] = Variable<int>(shotCount.value);
    }
    if (emailImportId.present) {
      map['email_import_id'] = Variable<int>(emailImportId.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpensesCompanion(')
          ..write('id: $id, ')
          ..write('category: $category, ')
          ..write('amountYen: $amountYen, ')
          ..write('paidOn: $paidOn, ')
          ..write('performanceId: $performanceId, ')
          ..write('partnerId: $partnerId, ')
          ..write('shotCount: $shotCount, ')
          ..write('emailImportId: $emailImportId, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $GmailSyncStatesTable extends GmailSyncStates
    with TableInfo<$GmailSyncStatesTable, GmailSyncStateRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GmailSyncStatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _accountEmailMeta = const VerificationMeta(
    'accountEmail',
  );
  @override
  late final GeneratedColumn<String> accountEmail = GeneratedColumn<String>(
    'account_email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _connectedAtMeta = const VerificationMeta(
    'connectedAt',
  );
  @override
  late final GeneratedColumn<DateTime> connectedAt = GeneratedColumn<DateTime>(
    'connected_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastFetchedAtMeta = const VerificationMeta(
    'lastFetchedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastFetchedAt =
      GeneratedColumn<DateTime>(
        'last_fetched_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _lastMessageReceivedAtMeta =
      const VerificationMeta('lastMessageReceivedAt');
  @override
  late final GeneratedColumn<DateTime> lastMessageReceivedAt =
      GeneratedColumn<DateTime>(
        'last_message_received_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _lastFailedAtMeta = const VerificationMeta(
    'lastFailedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastFailedAt = GeneratedColumn<DateTime>(
    'last_failed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<StoredFailureKind?, String>
  lastFailureKind =
      GeneratedColumn<String>(
        'last_failure_kind',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<StoredFailureKind?>(
        $GmailSyncStatesTable.$converterlastFailureKindn,
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now().toUtc(),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now().toUtc(),
  );
  @override
  List<GeneratedColumn> get $columns => [
    accountEmail,
    connectedAt,
    lastFetchedAt,
    lastMessageReceivedAt,
    lastFailedAt,
    lastFailureKind,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'gmail_sync_states';
  @override
  VerificationContext validateIntegrity(
    Insertable<GmailSyncStateRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('account_email')) {
      context.handle(
        _accountEmailMeta,
        accountEmail.isAcceptableOrUnknown(
          data['account_email']!,
          _accountEmailMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_accountEmailMeta);
    }
    if (data.containsKey('connected_at')) {
      context.handle(
        _connectedAtMeta,
        connectedAt.isAcceptableOrUnknown(
          data['connected_at']!,
          _connectedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_connectedAtMeta);
    }
    if (data.containsKey('last_fetched_at')) {
      context.handle(
        _lastFetchedAtMeta,
        lastFetchedAt.isAcceptableOrUnknown(
          data['last_fetched_at']!,
          _lastFetchedAtMeta,
        ),
      );
    }
    if (data.containsKey('last_message_received_at')) {
      context.handle(
        _lastMessageReceivedAtMeta,
        lastMessageReceivedAt.isAcceptableOrUnknown(
          data['last_message_received_at']!,
          _lastMessageReceivedAtMeta,
        ),
      );
    }
    if (data.containsKey('last_failed_at')) {
      context.handle(
        _lastFailedAtMeta,
        lastFailedAt.isAcceptableOrUnknown(
          data['last_failed_at']!,
          _lastFailedAtMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {accountEmail};
  @override
  GmailSyncStateRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GmailSyncStateRow(
      accountEmail: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_email'],
      )!,
      connectedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}connected_at'],
      )!,
      lastFetchedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_fetched_at'],
      ),
      lastMessageReceivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_message_received_at'],
      ),
      lastFailedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_failed_at'],
      ),
      lastFailureKind: $GmailSyncStatesTable.$converterlastFailureKindn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}last_failure_kind'],
        ),
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $GmailSyncStatesTable createAlias(String alias) {
    return $GmailSyncStatesTable(attachedDatabase, alias);
  }

  static TypeConverter<StoredFailureKind, String> $converterlastFailureKind =
      const FailureKindConverter();
  static TypeConverter<StoredFailureKind?, String?> $converterlastFailureKindn =
      NullAwareTypeConverter.wrap($converterlastFailureKind);
}

class GmailSyncStateRow extends DataClass
    implements Insertable<GmailSyncStateRow> {
  final String accountEmail;
  final DateTime connectedAt;
  final DateTime? lastFetchedAt;
  final DateTime? lastMessageReceivedAt;
  final DateTime? lastFailedAt;
  final StoredFailureKind? lastFailureKind;
  final DateTime createdAt;
  final DateTime updatedAt;
  const GmailSyncStateRow({
    required this.accountEmail,
    required this.connectedAt,
    this.lastFetchedAt,
    this.lastMessageReceivedAt,
    this.lastFailedAt,
    this.lastFailureKind,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['account_email'] = Variable<String>(accountEmail);
    map['connected_at'] = Variable<DateTime>(connectedAt);
    if (!nullToAbsent || lastFetchedAt != null) {
      map['last_fetched_at'] = Variable<DateTime>(lastFetchedAt);
    }
    if (!nullToAbsent || lastMessageReceivedAt != null) {
      map['last_message_received_at'] = Variable<DateTime>(
        lastMessageReceivedAt,
      );
    }
    if (!nullToAbsent || lastFailedAt != null) {
      map['last_failed_at'] = Variable<DateTime>(lastFailedAt);
    }
    if (!nullToAbsent || lastFailureKind != null) {
      map['last_failure_kind'] = Variable<String>(
        $GmailSyncStatesTable.$converterlastFailureKindn.toSql(lastFailureKind),
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  GmailSyncStatesCompanion toCompanion(bool nullToAbsent) {
    return GmailSyncStatesCompanion(
      accountEmail: Value(accountEmail),
      connectedAt: Value(connectedAt),
      lastFetchedAt: lastFetchedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastFetchedAt),
      lastMessageReceivedAt: lastMessageReceivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastMessageReceivedAt),
      lastFailedAt: lastFailedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastFailedAt),
      lastFailureKind: lastFailureKind == null && nullToAbsent
          ? const Value.absent()
          : Value(lastFailureKind),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory GmailSyncStateRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GmailSyncStateRow(
      accountEmail: serializer.fromJson<String>(json['accountEmail']),
      connectedAt: serializer.fromJson<DateTime>(json['connectedAt']),
      lastFetchedAt: serializer.fromJson<DateTime?>(json['lastFetchedAt']),
      lastMessageReceivedAt: serializer.fromJson<DateTime?>(
        json['lastMessageReceivedAt'],
      ),
      lastFailedAt: serializer.fromJson<DateTime?>(json['lastFailedAt']),
      lastFailureKind: serializer.fromJson<StoredFailureKind?>(
        json['lastFailureKind'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'accountEmail': serializer.toJson<String>(accountEmail),
      'connectedAt': serializer.toJson<DateTime>(connectedAt),
      'lastFetchedAt': serializer.toJson<DateTime?>(lastFetchedAt),
      'lastMessageReceivedAt': serializer.toJson<DateTime?>(
        lastMessageReceivedAt,
      ),
      'lastFailedAt': serializer.toJson<DateTime?>(lastFailedAt),
      'lastFailureKind': serializer.toJson<StoredFailureKind?>(lastFailureKind),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  GmailSyncStateRow copyWith({
    String? accountEmail,
    DateTime? connectedAt,
    Value<DateTime?> lastFetchedAt = const Value.absent(),
    Value<DateTime?> lastMessageReceivedAt = const Value.absent(),
    Value<DateTime?> lastFailedAt = const Value.absent(),
    Value<StoredFailureKind?> lastFailureKind = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => GmailSyncStateRow(
    accountEmail: accountEmail ?? this.accountEmail,
    connectedAt: connectedAt ?? this.connectedAt,
    lastFetchedAt: lastFetchedAt.present
        ? lastFetchedAt.value
        : this.lastFetchedAt,
    lastMessageReceivedAt: lastMessageReceivedAt.present
        ? lastMessageReceivedAt.value
        : this.lastMessageReceivedAt,
    lastFailedAt: lastFailedAt.present ? lastFailedAt.value : this.lastFailedAt,
    lastFailureKind: lastFailureKind.present
        ? lastFailureKind.value
        : this.lastFailureKind,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  GmailSyncStateRow copyWithCompanion(GmailSyncStatesCompanion data) {
    return GmailSyncStateRow(
      accountEmail: data.accountEmail.present
          ? data.accountEmail.value
          : this.accountEmail,
      connectedAt: data.connectedAt.present
          ? data.connectedAt.value
          : this.connectedAt,
      lastFetchedAt: data.lastFetchedAt.present
          ? data.lastFetchedAt.value
          : this.lastFetchedAt,
      lastMessageReceivedAt: data.lastMessageReceivedAt.present
          ? data.lastMessageReceivedAt.value
          : this.lastMessageReceivedAt,
      lastFailedAt: data.lastFailedAt.present
          ? data.lastFailedAt.value
          : this.lastFailedAt,
      lastFailureKind: data.lastFailureKind.present
          ? data.lastFailureKind.value
          : this.lastFailureKind,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GmailSyncStateRow(')
          ..write('accountEmail: $accountEmail, ')
          ..write('connectedAt: $connectedAt, ')
          ..write('lastFetchedAt: $lastFetchedAt, ')
          ..write('lastMessageReceivedAt: $lastMessageReceivedAt, ')
          ..write('lastFailedAt: $lastFailedAt, ')
          ..write('lastFailureKind: $lastFailureKind, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    accountEmail,
    connectedAt,
    lastFetchedAt,
    lastMessageReceivedAt,
    lastFailedAt,
    lastFailureKind,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GmailSyncStateRow &&
          other.accountEmail == this.accountEmail &&
          other.connectedAt == this.connectedAt &&
          other.lastFetchedAt == this.lastFetchedAt &&
          other.lastMessageReceivedAt == this.lastMessageReceivedAt &&
          other.lastFailedAt == this.lastFailedAt &&
          other.lastFailureKind == this.lastFailureKind &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class GmailSyncStatesCompanion extends UpdateCompanion<GmailSyncStateRow> {
  final Value<String> accountEmail;
  final Value<DateTime> connectedAt;
  final Value<DateTime?> lastFetchedAt;
  final Value<DateTime?> lastMessageReceivedAt;
  final Value<DateTime?> lastFailedAt;
  final Value<StoredFailureKind?> lastFailureKind;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const GmailSyncStatesCompanion({
    this.accountEmail = const Value.absent(),
    this.connectedAt = const Value.absent(),
    this.lastFetchedAt = const Value.absent(),
    this.lastMessageReceivedAt = const Value.absent(),
    this.lastFailedAt = const Value.absent(),
    this.lastFailureKind = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GmailSyncStatesCompanion.insert({
    required String accountEmail,
    required DateTime connectedAt,
    this.lastFetchedAt = const Value.absent(),
    this.lastMessageReceivedAt = const Value.absent(),
    this.lastFailedAt = const Value.absent(),
    this.lastFailureKind = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : accountEmail = Value(accountEmail),
       connectedAt = Value(connectedAt);
  static Insertable<GmailSyncStateRow> custom({
    Expression<String>? accountEmail,
    Expression<DateTime>? connectedAt,
    Expression<DateTime>? lastFetchedAt,
    Expression<DateTime>? lastMessageReceivedAt,
    Expression<DateTime>? lastFailedAt,
    Expression<String>? lastFailureKind,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (accountEmail != null) 'account_email': accountEmail,
      if (connectedAt != null) 'connected_at': connectedAt,
      if (lastFetchedAt != null) 'last_fetched_at': lastFetchedAt,
      if (lastMessageReceivedAt != null)
        'last_message_received_at': lastMessageReceivedAt,
      if (lastFailedAt != null) 'last_failed_at': lastFailedAt,
      if (lastFailureKind != null) 'last_failure_kind': lastFailureKind,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GmailSyncStatesCompanion copyWith({
    Value<String>? accountEmail,
    Value<DateTime>? connectedAt,
    Value<DateTime?>? lastFetchedAt,
    Value<DateTime?>? lastMessageReceivedAt,
    Value<DateTime?>? lastFailedAt,
    Value<StoredFailureKind?>? lastFailureKind,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return GmailSyncStatesCompanion(
      accountEmail: accountEmail ?? this.accountEmail,
      connectedAt: connectedAt ?? this.connectedAt,
      lastFetchedAt: lastFetchedAt ?? this.lastFetchedAt,
      lastMessageReceivedAt:
          lastMessageReceivedAt ?? this.lastMessageReceivedAt,
      lastFailedAt: lastFailedAt ?? this.lastFailedAt,
      lastFailureKind: lastFailureKind ?? this.lastFailureKind,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (accountEmail.present) {
      map['account_email'] = Variable<String>(accountEmail.value);
    }
    if (connectedAt.present) {
      map['connected_at'] = Variable<DateTime>(connectedAt.value);
    }
    if (lastFetchedAt.present) {
      map['last_fetched_at'] = Variable<DateTime>(lastFetchedAt.value);
    }
    if (lastMessageReceivedAt.present) {
      map['last_message_received_at'] = Variable<DateTime>(
        lastMessageReceivedAt.value,
      );
    }
    if (lastFailedAt.present) {
      map['last_failed_at'] = Variable<DateTime>(lastFailedAt.value);
    }
    if (lastFailureKind.present) {
      map['last_failure_kind'] = Variable<String>(
        $GmailSyncStatesTable.$converterlastFailureKindn.toSql(
          lastFailureKind.value,
        ),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GmailSyncStatesCompanion(')
          ..write('accountEmail: $accountEmail, ')
          ..write('connectedAt: $connectedAt, ')
          ..write('lastFetchedAt: $lastFetchedAt, ')
          ..write('lastMessageReceivedAt: $lastMessageReceivedAt, ')
          ..write('lastFailedAt: $lastFailedAt, ')
          ..write('lastFailureKind: $lastFailureKind, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $BudgetRatesTable budgetRates = $BudgetRatesTable(this);
  late final $BudgetOverridesTable budgetOverrides = $BudgetOverridesTable(
    this,
  );
  late final $PerformancesTable performances = $PerformancesTable(this);
  late final $PartnersTable partners = $PartnersTable(this);
  late final $EmailImportsTable emailImports = $EmailImportsTable(this);
  late final $ExpensesTable expenses = $ExpensesTable(this);
  late final $GmailSyncStatesTable gmailSyncStates = $GmailSyncStatesTable(
    this,
  );
  late final Index performancesStartsAt = Index(
    'performances_starts_at',
    'CREATE INDEX performances_starts_at ON performances (starts_at)',
  );
  late final Index performancesTitleStartsAt = Index(
    'performances_title_starts_at',
    'CREATE INDEX performances_title_starts_at ON performances (title, starts_at)',
  );
  late final Index expensesPaidOn = Index(
    'expenses_paid_on',
    'CREATE INDEX expenses_paid_on ON expenses (paid_on)',
  );
  late final Index expensesPerformanceIdCategory = Index(
    'expenses_performance_id_category',
    'CREATE INDEX expenses_performance_id_category ON expenses (performance_id, category)',
  );
  late final Index expensesPartnerId = Index(
    'expenses_partner_id',
    'CREATE INDEX expenses_partner_id ON expenses (partner_id)',
  );
  late final Index expensesEmailImportId = Index(
    'expenses_email_import_id',
    'CREATE INDEX expenses_email_import_id ON expenses (email_import_id)',
  );
  late final Index partnersName = Index(
    'partners_name',
    'CREATE INDEX partners_name ON partners (name)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    budgetRates,
    budgetOverrides,
    performances,
    partners,
    emailImports,
    expenses,
    gmailSyncStates,
    performancesStartsAt,
    performancesTitleStartsAt,
    expensesPaidOn,
    expensesPerformanceIdCategory,
    expensesPartnerId,
    expensesEmailImportId,
    partnersName,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'performances',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('expenses', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'email_imports',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('expenses', kind: UpdateKind.update)],
    ),
  ]);
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$BudgetRatesTableCreateCompanionBuilder =
    BudgetRatesCompanion Function({
      required String effectiveMonth,
      required int amountYen,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$BudgetRatesTableUpdateCompanionBuilder =
    BudgetRatesCompanion Function({
      Value<String> effectiveMonth,
      Value<int> amountYen,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$BudgetRatesTableFilterComposer
    extends Composer<_$AppDatabase, $BudgetRatesTable> {
  $$BudgetRatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get effectiveMonth => $composableBuilder(
    column: $table.effectiveMonth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountYen => $composableBuilder(
    column: $table.amountYen,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BudgetRatesTableOrderingComposer
    extends Composer<_$AppDatabase, $BudgetRatesTable> {
  $$BudgetRatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get effectiveMonth => $composableBuilder(
    column: $table.effectiveMonth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountYen => $composableBuilder(
    column: $table.amountYen,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BudgetRatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $BudgetRatesTable> {
  $$BudgetRatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get effectiveMonth => $composableBuilder(
    column: $table.effectiveMonth,
    builder: (column) => column,
  );

  GeneratedColumn<int> get amountYen =>
      $composableBuilder(column: $table.amountYen, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$BudgetRatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BudgetRatesTable,
          BudgetRateRow,
          $$BudgetRatesTableFilterComposer,
          $$BudgetRatesTableOrderingComposer,
          $$BudgetRatesTableAnnotationComposer,
          $$BudgetRatesTableCreateCompanionBuilder,
          $$BudgetRatesTableUpdateCompanionBuilder,
          (
            BudgetRateRow,
            BaseReferences<_$AppDatabase, $BudgetRatesTable, BudgetRateRow>,
          ),
          BudgetRateRow,
          PrefetchHooks Function()
        > {
  $$BudgetRatesTableTableManager(_$AppDatabase db, $BudgetRatesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BudgetRatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BudgetRatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BudgetRatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> effectiveMonth = const Value.absent(),
                Value<int> amountYen = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BudgetRatesCompanion(
                effectiveMonth: effectiveMonth,
                amountYen: amountYen,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String effectiveMonth,
                required int amountYen,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BudgetRatesCompanion.insert(
                effectiveMonth: effectiveMonth,
                amountYen: amountYen,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BudgetRatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BudgetRatesTable,
      BudgetRateRow,
      $$BudgetRatesTableFilterComposer,
      $$BudgetRatesTableOrderingComposer,
      $$BudgetRatesTableAnnotationComposer,
      $$BudgetRatesTableCreateCompanionBuilder,
      $$BudgetRatesTableUpdateCompanionBuilder,
      (
        BudgetRateRow,
        BaseReferences<_$AppDatabase, $BudgetRatesTable, BudgetRateRow>,
      ),
      BudgetRateRow,
      PrefetchHooks Function()
    >;
typedef $$BudgetOverridesTableCreateCompanionBuilder =
    BudgetOverridesCompanion Function({
      required String month,
      required int amountYen,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$BudgetOverridesTableUpdateCompanionBuilder =
    BudgetOverridesCompanion Function({
      Value<String> month,
      Value<int> amountYen,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$BudgetOverridesTableFilterComposer
    extends Composer<_$AppDatabase, $BudgetOverridesTable> {
  $$BudgetOverridesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountYen => $composableBuilder(
    column: $table.amountYen,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BudgetOverridesTableOrderingComposer
    extends Composer<_$AppDatabase, $BudgetOverridesTable> {
  $$BudgetOverridesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountYen => $composableBuilder(
    column: $table.amountYen,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BudgetOverridesTableAnnotationComposer
    extends Composer<_$AppDatabase, $BudgetOverridesTable> {
  $$BudgetOverridesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get month =>
      $composableBuilder(column: $table.month, builder: (column) => column);

  GeneratedColumn<int> get amountYen =>
      $composableBuilder(column: $table.amountYen, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$BudgetOverridesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BudgetOverridesTable,
          BudgetOverrideRow,
          $$BudgetOverridesTableFilterComposer,
          $$BudgetOverridesTableOrderingComposer,
          $$BudgetOverridesTableAnnotationComposer,
          $$BudgetOverridesTableCreateCompanionBuilder,
          $$BudgetOverridesTableUpdateCompanionBuilder,
          (
            BudgetOverrideRow,
            BaseReferences<
              _$AppDatabase,
              $BudgetOverridesTable,
              BudgetOverrideRow
            >,
          ),
          BudgetOverrideRow,
          PrefetchHooks Function()
        > {
  $$BudgetOverridesTableTableManager(
    _$AppDatabase db,
    $BudgetOverridesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BudgetOverridesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BudgetOverridesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BudgetOverridesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> month = const Value.absent(),
                Value<int> amountYen = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BudgetOverridesCompanion(
                month: month,
                amountYen: amountYen,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String month,
                required int amountYen,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BudgetOverridesCompanion.insert(
                month: month,
                amountYen: amountYen,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BudgetOverridesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BudgetOverridesTable,
      BudgetOverrideRow,
      $$BudgetOverridesTableFilterComposer,
      $$BudgetOverridesTableOrderingComposer,
      $$BudgetOverridesTableAnnotationComposer,
      $$BudgetOverridesTableCreateCompanionBuilder,
      $$BudgetOverridesTableUpdateCompanionBuilder,
      (
        BudgetOverrideRow,
        BaseReferences<_$AppDatabase, $BudgetOverridesTable, BudgetOverrideRow>,
      ),
      BudgetOverrideRow,
      PrefetchHooks Function()
    >;
typedef $$PerformancesTableCreateCompanionBuilder =
    PerformancesCompanion Function({
      Value<int> id,
      required String title,
      required DateTime startsAt,
      Value<String?> venue,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$PerformancesTableUpdateCompanionBuilder =
    PerformancesCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<DateTime> startsAt,
      Value<String?> venue,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$PerformancesTableReferences
    extends BaseReferences<_$AppDatabase, $PerformancesTable, PerformanceRow> {
  $$PerformancesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ExpensesTable, List<ExpenseRow>>
  _expensesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.expenses,
    aliasName: 'performances__id__expenses__performance_id',
  );

  $$ExpensesTableProcessedTableManager get expensesRefs {
    final manager = $$ExpensesTableTableManager(
      $_db,
      $_db.expenses,
    ).filter((f) => f.performanceId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_expensesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PerformancesTableFilterComposer
    extends Composer<_$AppDatabase, $PerformancesTable> {
  $$PerformancesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startsAt => $composableBuilder(
    column: $table.startsAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get venue => $composableBuilder(
    column: $table.venue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> expensesRefs(
    Expression<bool> Function($$ExpensesTableFilterComposer f) f,
  ) {
    final $$ExpensesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expenses,
      getReferencedColumn: (t) => t.performanceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensesTableFilterComposer(
            $db: $db,
            $table: $db.expenses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PerformancesTableOrderingComposer
    extends Composer<_$AppDatabase, $PerformancesTable> {
  $$PerformancesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startsAt => $composableBuilder(
    column: $table.startsAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get venue => $composableBuilder(
    column: $table.venue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PerformancesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PerformancesTable> {
  $$PerformancesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<DateTime> get startsAt =>
      $composableBuilder(column: $table.startsAt, builder: (column) => column);

  GeneratedColumn<String> get venue =>
      $composableBuilder(column: $table.venue, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> expensesRefs<T extends Object>(
    Expression<T> Function($$ExpensesTableAnnotationComposer a) f,
  ) {
    final $$ExpensesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expenses,
      getReferencedColumn: (t) => t.performanceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensesTableAnnotationComposer(
            $db: $db,
            $table: $db.expenses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PerformancesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PerformancesTable,
          PerformanceRow,
          $$PerformancesTableFilterComposer,
          $$PerformancesTableOrderingComposer,
          $$PerformancesTableAnnotationComposer,
          $$PerformancesTableCreateCompanionBuilder,
          $$PerformancesTableUpdateCompanionBuilder,
          (PerformanceRow, $$PerformancesTableReferences),
          PerformanceRow,
          PrefetchHooks Function({bool expensesRefs})
        > {
  $$PerformancesTableTableManager(_$AppDatabase db, $PerformancesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PerformancesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PerformancesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PerformancesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<DateTime> startsAt = const Value.absent(),
                Value<String?> venue = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => PerformancesCompanion(
                id: id,
                title: title,
                startsAt: startsAt,
                venue: venue,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                required DateTime startsAt,
                Value<String?> venue = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => PerformancesCompanion.insert(
                id: id,
                title: title,
                startsAt: startsAt,
                venue: venue,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PerformancesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({expensesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (expensesRefs) db.expenses],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (expensesRefs)
                    await $_getPrefetchedData<
                      PerformanceRow,
                      $PerformancesTable,
                      ExpenseRow
                    >(
                      currentTable: table,
                      referencedTable: $$PerformancesTableReferences
                          ._expensesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$PerformancesTableReferences(
                            db,
                            table,
                            p0,
                          ).expensesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.performanceId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$PerformancesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PerformancesTable,
      PerformanceRow,
      $$PerformancesTableFilterComposer,
      $$PerformancesTableOrderingComposer,
      $$PerformancesTableAnnotationComposer,
      $$PerformancesTableCreateCompanionBuilder,
      $$PerformancesTableUpdateCompanionBuilder,
      (PerformanceRow, $$PerformancesTableReferences),
      PerformanceRow,
      PrefetchHooks Function({bool expensesRefs})
    >;
typedef $$PartnersTableCreateCompanionBuilder =
    PartnersCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> groupName,
      Value<String?> iconFile,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$PartnersTableUpdateCompanionBuilder =
    PartnersCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> groupName,
      Value<String?> iconFile,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$PartnersTableReferences
    extends BaseReferences<_$AppDatabase, $PartnersTable, PartnerRow> {
  $$PartnersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ExpensesTable, List<ExpenseRow>>
  _expensesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.expenses,
    aliasName: 'partners__id__expenses__partner_id',
  );

  $$ExpensesTableProcessedTableManager get expensesRefs {
    final manager = $$ExpensesTableTableManager(
      $_db,
      $_db.expenses,
    ).filter((f) => f.partnerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_expensesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PartnersTableFilterComposer
    extends Composer<_$AppDatabase, $PartnersTable> {
  $$PartnersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get groupName => $composableBuilder(
    column: $table.groupName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get iconFile => $composableBuilder(
    column: $table.iconFile,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> expensesRefs(
    Expression<bool> Function($$ExpensesTableFilterComposer f) f,
  ) {
    final $$ExpensesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expenses,
      getReferencedColumn: (t) => t.partnerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensesTableFilterComposer(
            $db: $db,
            $table: $db.expenses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PartnersTableOrderingComposer
    extends Composer<_$AppDatabase, $PartnersTable> {
  $$PartnersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get groupName => $composableBuilder(
    column: $table.groupName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get iconFile => $composableBuilder(
    column: $table.iconFile,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PartnersTableAnnotationComposer
    extends Composer<_$AppDatabase, $PartnersTable> {
  $$PartnersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get groupName =>
      $composableBuilder(column: $table.groupName, builder: (column) => column);

  GeneratedColumn<String> get iconFile =>
      $composableBuilder(column: $table.iconFile, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> expensesRefs<T extends Object>(
    Expression<T> Function($$ExpensesTableAnnotationComposer a) f,
  ) {
    final $$ExpensesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expenses,
      getReferencedColumn: (t) => t.partnerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensesTableAnnotationComposer(
            $db: $db,
            $table: $db.expenses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PartnersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PartnersTable,
          PartnerRow,
          $$PartnersTableFilterComposer,
          $$PartnersTableOrderingComposer,
          $$PartnersTableAnnotationComposer,
          $$PartnersTableCreateCompanionBuilder,
          $$PartnersTableUpdateCompanionBuilder,
          (PartnerRow, $$PartnersTableReferences),
          PartnerRow,
          PrefetchHooks Function({bool expensesRefs})
        > {
  $$PartnersTableTableManager(_$AppDatabase db, $PartnersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PartnersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PartnersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PartnersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> groupName = const Value.absent(),
                Value<String?> iconFile = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => PartnersCompanion(
                id: id,
                name: name,
                groupName: groupName,
                iconFile: iconFile,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> groupName = const Value.absent(),
                Value<String?> iconFile = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => PartnersCompanion.insert(
                id: id,
                name: name,
                groupName: groupName,
                iconFile: iconFile,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PartnersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({expensesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (expensesRefs) db.expenses],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (expensesRefs)
                    await $_getPrefetchedData<
                      PartnerRow,
                      $PartnersTable,
                      ExpenseRow
                    >(
                      currentTable: table,
                      referencedTable: $$PartnersTableReferences
                          ._expensesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$PartnersTableReferences(db, table, p0).expensesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.partnerId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$PartnersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PartnersTable,
      PartnerRow,
      $$PartnersTableFilterComposer,
      $$PartnersTableOrderingComposer,
      $$PartnersTableAnnotationComposer,
      $$PartnersTableCreateCompanionBuilder,
      $$PartnersTableUpdateCompanionBuilder,
      (PartnerRow, $$PartnersTableReferences),
      PartnerRow,
      PrefetchHooks Function({bool expensesRefs})
    >;
typedef $$EmailImportsTableCreateCompanionBuilder =
    EmailImportsCompanion Function({
      Value<int> id,
      required String accountEmail,
      required String gmailMessageId,
      required StoredMailService service,
      required String subject,
      required DateTime receivedAt,
      required DateTime importedAt,
    });
typedef $$EmailImportsTableUpdateCompanionBuilder =
    EmailImportsCompanion Function({
      Value<int> id,
      Value<String> accountEmail,
      Value<String> gmailMessageId,
      Value<StoredMailService> service,
      Value<String> subject,
      Value<DateTime> receivedAt,
      Value<DateTime> importedAt,
    });

final class $$EmailImportsTableReferences
    extends BaseReferences<_$AppDatabase, $EmailImportsTable, EmailImportRow> {
  $$EmailImportsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ExpensesTable, List<ExpenseRow>>
  _expensesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.expenses,
    aliasName: 'email_imports__id__expenses__email_import_id',
  );

  $$ExpensesTableProcessedTableManager get expensesRefs {
    final manager = $$ExpensesTableTableManager(
      $_db,
      $_db.expenses,
    ).filter((f) => f.emailImportId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_expensesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$EmailImportsTableFilterComposer
    extends Composer<_$AppDatabase, $EmailImportsTable> {
  $$EmailImportsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accountEmail => $composableBuilder(
    column: $table.accountEmail,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gmailMessageId => $composableBuilder(
    column: $table.gmailMessageId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<StoredMailService, StoredMailService, String>
  get service => $composableBuilder(
    column: $table.service,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get subject => $composableBuilder(
    column: $table.subject,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get receivedAt => $composableBuilder(
    column: $table.receivedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get importedAt => $composableBuilder(
    column: $table.importedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> expensesRefs(
    Expression<bool> Function($$ExpensesTableFilterComposer f) f,
  ) {
    final $$ExpensesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expenses,
      getReferencedColumn: (t) => t.emailImportId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensesTableFilterComposer(
            $db: $db,
            $table: $db.expenses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EmailImportsTableOrderingComposer
    extends Composer<_$AppDatabase, $EmailImportsTable> {
  $$EmailImportsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountEmail => $composableBuilder(
    column: $table.accountEmail,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gmailMessageId => $composableBuilder(
    column: $table.gmailMessageId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get service => $composableBuilder(
    column: $table.service,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subject => $composableBuilder(
    column: $table.subject,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get receivedAt => $composableBuilder(
    column: $table.receivedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get importedAt => $composableBuilder(
    column: $table.importedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EmailImportsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EmailImportsTable> {
  $$EmailImportsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get accountEmail => $composableBuilder(
    column: $table.accountEmail,
    builder: (column) => column,
  );

  GeneratedColumn<String> get gmailMessageId => $composableBuilder(
    column: $table.gmailMessageId,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<StoredMailService, String> get service =>
      $composableBuilder(column: $table.service, builder: (column) => column);

  GeneratedColumn<String> get subject =>
      $composableBuilder(column: $table.subject, builder: (column) => column);

  GeneratedColumn<DateTime> get receivedAt => $composableBuilder(
    column: $table.receivedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get importedAt => $composableBuilder(
    column: $table.importedAt,
    builder: (column) => column,
  );

  Expression<T> expensesRefs<T extends Object>(
    Expression<T> Function($$ExpensesTableAnnotationComposer a) f,
  ) {
    final $$ExpensesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expenses,
      getReferencedColumn: (t) => t.emailImportId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensesTableAnnotationComposer(
            $db: $db,
            $table: $db.expenses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EmailImportsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EmailImportsTable,
          EmailImportRow,
          $$EmailImportsTableFilterComposer,
          $$EmailImportsTableOrderingComposer,
          $$EmailImportsTableAnnotationComposer,
          $$EmailImportsTableCreateCompanionBuilder,
          $$EmailImportsTableUpdateCompanionBuilder,
          (EmailImportRow, $$EmailImportsTableReferences),
          EmailImportRow,
          PrefetchHooks Function({bool expensesRefs})
        > {
  $$EmailImportsTableTableManager(_$AppDatabase db, $EmailImportsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EmailImportsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EmailImportsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EmailImportsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> accountEmail = const Value.absent(),
                Value<String> gmailMessageId = const Value.absent(),
                Value<StoredMailService> service = const Value.absent(),
                Value<String> subject = const Value.absent(),
                Value<DateTime> receivedAt = const Value.absent(),
                Value<DateTime> importedAt = const Value.absent(),
              }) => EmailImportsCompanion(
                id: id,
                accountEmail: accountEmail,
                gmailMessageId: gmailMessageId,
                service: service,
                subject: subject,
                receivedAt: receivedAt,
                importedAt: importedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String accountEmail,
                required String gmailMessageId,
                required StoredMailService service,
                required String subject,
                required DateTime receivedAt,
                required DateTime importedAt,
              }) => EmailImportsCompanion.insert(
                id: id,
                accountEmail: accountEmail,
                gmailMessageId: gmailMessageId,
                service: service,
                subject: subject,
                receivedAt: receivedAt,
                importedAt: importedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$EmailImportsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({expensesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (expensesRefs) db.expenses],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (expensesRefs)
                    await $_getPrefetchedData<
                      EmailImportRow,
                      $EmailImportsTable,
                      ExpenseRow
                    >(
                      currentTable: table,
                      referencedTable: $$EmailImportsTableReferences
                          ._expensesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$EmailImportsTableReferences(
                            db,
                            table,
                            p0,
                          ).expensesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.emailImportId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$EmailImportsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EmailImportsTable,
      EmailImportRow,
      $$EmailImportsTableFilterComposer,
      $$EmailImportsTableOrderingComposer,
      $$EmailImportsTableAnnotationComposer,
      $$EmailImportsTableCreateCompanionBuilder,
      $$EmailImportsTableUpdateCompanionBuilder,
      (EmailImportRow, $$EmailImportsTableReferences),
      EmailImportRow,
      PrefetchHooks Function({bool expensesRefs})
    >;
typedef $$ExpensesTableCreateCompanionBuilder =
    ExpensesCompanion Function({
      Value<int> id,
      required ExpenseCategory category,
      required int amountYen,
      required String paidOn,
      Value<int?> performanceId,
      Value<int?> partnerId,
      Value<int?> shotCount,
      Value<int?> emailImportId,
      Value<String?> note,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$ExpensesTableUpdateCompanionBuilder =
    ExpensesCompanion Function({
      Value<int> id,
      Value<ExpenseCategory> category,
      Value<int> amountYen,
      Value<String> paidOn,
      Value<int?> performanceId,
      Value<int?> partnerId,
      Value<int?> shotCount,
      Value<int?> emailImportId,
      Value<String?> note,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$ExpensesTableReferences
    extends BaseReferences<_$AppDatabase, $ExpensesTable, ExpenseRow> {
  $$ExpensesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PerformancesTable _performanceIdTable(_$AppDatabase db) =>
      db.performances.createAlias('expenses__performance_id__performances__id');

  $$PerformancesTableProcessedTableManager? get performanceId {
    final $_column = $_itemColumn<int>('performance_id');
    if ($_column == null) return null;
    final manager = $$PerformancesTableTableManager(
      $_db,
      $_db.performances,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_performanceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PartnersTable _partnerIdTable(_$AppDatabase db) =>
      db.partners.createAlias('expenses__partner_id__partners__id');

  $$PartnersTableProcessedTableManager? get partnerId {
    final $_column = $_itemColumn<int>('partner_id');
    if ($_column == null) return null;
    final manager = $$PartnersTableTableManager(
      $_db,
      $_db.partners,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_partnerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $EmailImportsTable _emailImportIdTable(_$AppDatabase db) => db
      .emailImports
      .createAlias('expenses__email_import_id__email_imports__id');

  $$EmailImportsTableProcessedTableManager? get emailImportId {
    final $_column = $_itemColumn<int>('email_import_id');
    if ($_column == null) return null;
    final manager = $$EmailImportsTableTableManager(
      $_db,
      $_db.emailImports,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_emailImportIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ExpensesTableFilterComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ExpenseCategory, ExpenseCategory, String>
  get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get amountYen => $composableBuilder(
    column: $table.amountYen,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paidOn => $composableBuilder(
    column: $table.paidOn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get shotCount => $composableBuilder(
    column: $table.shotCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$PerformancesTableFilterComposer get performanceId {
    final $$PerformancesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.performanceId,
      referencedTable: $db.performances,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PerformancesTableFilterComposer(
            $db: $db,
            $table: $db.performances,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PartnersTableFilterComposer get partnerId {
    final $$PartnersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.partnerId,
      referencedTable: $db.partners,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartnersTableFilterComposer(
            $db: $db,
            $table: $db.partners,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EmailImportsTableFilterComposer get emailImportId {
    final $$EmailImportsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.emailImportId,
      referencedTable: $db.emailImports,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmailImportsTableFilterComposer(
            $db: $db,
            $table: $db.emailImports,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExpensesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountYen => $composableBuilder(
    column: $table.amountYen,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paidOn => $composableBuilder(
    column: $table.paidOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get shotCount => $composableBuilder(
    column: $table.shotCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$PerformancesTableOrderingComposer get performanceId {
    final $$PerformancesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.performanceId,
      referencedTable: $db.performances,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PerformancesTableOrderingComposer(
            $db: $db,
            $table: $db.performances,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PartnersTableOrderingComposer get partnerId {
    final $$PartnersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.partnerId,
      referencedTable: $db.partners,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartnersTableOrderingComposer(
            $db: $db,
            $table: $db.partners,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EmailImportsTableOrderingComposer get emailImportId {
    final $$EmailImportsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.emailImportId,
      referencedTable: $db.emailImports,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmailImportsTableOrderingComposer(
            $db: $db,
            $table: $db.emailImports,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExpensesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ExpenseCategory, String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get amountYen =>
      $composableBuilder(column: $table.amountYen, builder: (column) => column);

  GeneratedColumn<String> get paidOn =>
      $composableBuilder(column: $table.paidOn, builder: (column) => column);

  GeneratedColumn<int> get shotCount =>
      $composableBuilder(column: $table.shotCount, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$PerformancesTableAnnotationComposer get performanceId {
    final $$PerformancesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.performanceId,
      referencedTable: $db.performances,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PerformancesTableAnnotationComposer(
            $db: $db,
            $table: $db.performances,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PartnersTableAnnotationComposer get partnerId {
    final $$PartnersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.partnerId,
      referencedTable: $db.partners,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartnersTableAnnotationComposer(
            $db: $db,
            $table: $db.partners,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EmailImportsTableAnnotationComposer get emailImportId {
    final $$EmailImportsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.emailImportId,
      referencedTable: $db.emailImports,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmailImportsTableAnnotationComposer(
            $db: $db,
            $table: $db.emailImports,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExpensesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExpensesTable,
          ExpenseRow,
          $$ExpensesTableFilterComposer,
          $$ExpensesTableOrderingComposer,
          $$ExpensesTableAnnotationComposer,
          $$ExpensesTableCreateCompanionBuilder,
          $$ExpensesTableUpdateCompanionBuilder,
          (ExpenseRow, $$ExpensesTableReferences),
          ExpenseRow,
          PrefetchHooks Function({
            bool performanceId,
            bool partnerId,
            bool emailImportId,
          })
        > {
  $$ExpensesTableTableManager(_$AppDatabase db, $ExpensesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExpensesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExpensesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExpensesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<ExpenseCategory> category = const Value.absent(),
                Value<int> amountYen = const Value.absent(),
                Value<String> paidOn = const Value.absent(),
                Value<int?> performanceId = const Value.absent(),
                Value<int?> partnerId = const Value.absent(),
                Value<int?> shotCount = const Value.absent(),
                Value<int?> emailImportId = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ExpensesCompanion(
                id: id,
                category: category,
                amountYen: amountYen,
                paidOn: paidOn,
                performanceId: performanceId,
                partnerId: partnerId,
                shotCount: shotCount,
                emailImportId: emailImportId,
                note: note,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required ExpenseCategory category,
                required int amountYen,
                required String paidOn,
                Value<int?> performanceId = const Value.absent(),
                Value<int?> partnerId = const Value.absent(),
                Value<int?> shotCount = const Value.absent(),
                Value<int?> emailImportId = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ExpensesCompanion.insert(
                id: id,
                category: category,
                amountYen: amountYen,
                paidOn: paidOn,
                performanceId: performanceId,
                partnerId: partnerId,
                shotCount: shotCount,
                emailImportId: emailImportId,
                note: note,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ExpensesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                performanceId = false,
                partnerId = false,
                emailImportId = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (performanceId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.performanceId,
                                    referencedTable: $$ExpensesTableReferences
                                        ._performanceIdTable(db),
                                    referencedColumn: $$ExpensesTableReferences
                                        ._performanceIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (partnerId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.partnerId,
                                    referencedTable: $$ExpensesTableReferences
                                        ._partnerIdTable(db),
                                    referencedColumn: $$ExpensesTableReferences
                                        ._partnerIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (emailImportId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.emailImportId,
                                    referencedTable: $$ExpensesTableReferences
                                        ._emailImportIdTable(db),
                                    referencedColumn: $$ExpensesTableReferences
                                        ._emailImportIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$ExpensesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExpensesTable,
      ExpenseRow,
      $$ExpensesTableFilterComposer,
      $$ExpensesTableOrderingComposer,
      $$ExpensesTableAnnotationComposer,
      $$ExpensesTableCreateCompanionBuilder,
      $$ExpensesTableUpdateCompanionBuilder,
      (ExpenseRow, $$ExpensesTableReferences),
      ExpenseRow,
      PrefetchHooks Function({
        bool performanceId,
        bool partnerId,
        bool emailImportId,
      })
    >;
typedef $$GmailSyncStatesTableCreateCompanionBuilder =
    GmailSyncStatesCompanion Function({
      required String accountEmail,
      required DateTime connectedAt,
      Value<DateTime?> lastFetchedAt,
      Value<DateTime?> lastMessageReceivedAt,
      Value<DateTime?> lastFailedAt,
      Value<StoredFailureKind?> lastFailureKind,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$GmailSyncStatesTableUpdateCompanionBuilder =
    GmailSyncStatesCompanion Function({
      Value<String> accountEmail,
      Value<DateTime> connectedAt,
      Value<DateTime?> lastFetchedAt,
      Value<DateTime?> lastMessageReceivedAt,
      Value<DateTime?> lastFailedAt,
      Value<StoredFailureKind?> lastFailureKind,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$GmailSyncStatesTableFilterComposer
    extends Composer<_$AppDatabase, $GmailSyncStatesTable> {
  $$GmailSyncStatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get accountEmail => $composableBuilder(
    column: $table.accountEmail,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get connectedAt => $composableBuilder(
    column: $table.connectedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastFetchedAt => $composableBuilder(
    column: $table.lastFetchedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastMessageReceivedAt => $composableBuilder(
    column: $table.lastMessageReceivedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastFailedAt => $composableBuilder(
    column: $table.lastFailedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<StoredFailureKind?, StoredFailureKind, String>
  get lastFailureKind => $composableBuilder(
    column: $table.lastFailureKind,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$GmailSyncStatesTableOrderingComposer
    extends Composer<_$AppDatabase, $GmailSyncStatesTable> {
  $$GmailSyncStatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get accountEmail => $composableBuilder(
    column: $table.accountEmail,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get connectedAt => $composableBuilder(
    column: $table.connectedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastFetchedAt => $composableBuilder(
    column: $table.lastFetchedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastMessageReceivedAt => $composableBuilder(
    column: $table.lastMessageReceivedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastFailedAt => $composableBuilder(
    column: $table.lastFailedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastFailureKind => $composableBuilder(
    column: $table.lastFailureKind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GmailSyncStatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $GmailSyncStatesTable> {
  $$GmailSyncStatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get accountEmail => $composableBuilder(
    column: $table.accountEmail,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get connectedAt => $composableBuilder(
    column: $table.connectedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastFetchedAt => $composableBuilder(
    column: $table.lastFetchedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastMessageReceivedAt => $composableBuilder(
    column: $table.lastMessageReceivedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastFailedAt => $composableBuilder(
    column: $table.lastFailedAt,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<StoredFailureKind?, String>
  get lastFailureKind => $composableBuilder(
    column: $table.lastFailureKind,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$GmailSyncStatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GmailSyncStatesTable,
          GmailSyncStateRow,
          $$GmailSyncStatesTableFilterComposer,
          $$GmailSyncStatesTableOrderingComposer,
          $$GmailSyncStatesTableAnnotationComposer,
          $$GmailSyncStatesTableCreateCompanionBuilder,
          $$GmailSyncStatesTableUpdateCompanionBuilder,
          (
            GmailSyncStateRow,
            BaseReferences<
              _$AppDatabase,
              $GmailSyncStatesTable,
              GmailSyncStateRow
            >,
          ),
          GmailSyncStateRow,
          PrefetchHooks Function()
        > {
  $$GmailSyncStatesTableTableManager(
    _$AppDatabase db,
    $GmailSyncStatesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GmailSyncStatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GmailSyncStatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GmailSyncStatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> accountEmail = const Value.absent(),
                Value<DateTime> connectedAt = const Value.absent(),
                Value<DateTime?> lastFetchedAt = const Value.absent(),
                Value<DateTime?> lastMessageReceivedAt = const Value.absent(),
                Value<DateTime?> lastFailedAt = const Value.absent(),
                Value<StoredFailureKind?> lastFailureKind =
                    const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GmailSyncStatesCompanion(
                accountEmail: accountEmail,
                connectedAt: connectedAt,
                lastFetchedAt: lastFetchedAt,
                lastMessageReceivedAt: lastMessageReceivedAt,
                lastFailedAt: lastFailedAt,
                lastFailureKind: lastFailureKind,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String accountEmail,
                required DateTime connectedAt,
                Value<DateTime?> lastFetchedAt = const Value.absent(),
                Value<DateTime?> lastMessageReceivedAt = const Value.absent(),
                Value<DateTime?> lastFailedAt = const Value.absent(),
                Value<StoredFailureKind?> lastFailureKind =
                    const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GmailSyncStatesCompanion.insert(
                accountEmail: accountEmail,
                connectedAt: connectedAt,
                lastFetchedAt: lastFetchedAt,
                lastMessageReceivedAt: lastMessageReceivedAt,
                lastFailedAt: lastFailedAt,
                lastFailureKind: lastFailureKind,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GmailSyncStatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GmailSyncStatesTable,
      GmailSyncStateRow,
      $$GmailSyncStatesTableFilterComposer,
      $$GmailSyncStatesTableOrderingComposer,
      $$GmailSyncStatesTableAnnotationComposer,
      $$GmailSyncStatesTableCreateCompanionBuilder,
      $$GmailSyncStatesTableUpdateCompanionBuilder,
      (
        GmailSyncStateRow,
        BaseReferences<_$AppDatabase, $GmailSyncStatesTable, GmailSyncStateRow>,
      ),
      GmailSyncStateRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$BudgetRatesTableTableManager get budgetRates =>
      $$BudgetRatesTableTableManager(_db, _db.budgetRates);
  $$BudgetOverridesTableTableManager get budgetOverrides =>
      $$BudgetOverridesTableTableManager(_db, _db.budgetOverrides);
  $$PerformancesTableTableManager get performances =>
      $$PerformancesTableTableManager(_db, _db.performances);
  $$PartnersTableTableManager get partners =>
      $$PartnersTableTableManager(_db, _db.partners);
  $$EmailImportsTableTableManager get emailImports =>
      $$EmailImportsTableTableManager(_db, _db.emailImports);
  $$ExpensesTableTableManager get expenses =>
      $$ExpensesTableTableManager(_db, _db.expenses);
  $$GmailSyncStatesTableTableManager get gmailSyncStates =>
      $$GmailSyncStatesTableTableManager(_db, _db.gmailSyncStates);
}
