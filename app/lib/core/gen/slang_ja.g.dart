///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import

part of 'slang.g.dart';

// Path: <root>
typedef TranslationsJa = Translations; // ignore: unused_element

class Translations with BaseTranslations<AppLocale, Translations> {
  /// Returns the current translations of the given [context].
  ///
  /// Usage:
  /// final t = Translations.of(context);
  static Translations of(BuildContext context) =>
      InheritedLocaleData.of<AppLocale, Translations>(context).translations;

  /// You can call this constructor and build your own translation instance of this locale.
  /// Constructing via the enum [AppLocale.build] is preferred.
  Translations({
    Map<String, Node>? overrides,
    PluralResolver? cardinalResolver,
    PluralResolver? ordinalResolver,
    TranslationMetadata<AppLocale, Translations>? meta,
  }) : assert(
         overrides == null,
         'Set "translation_overrides: true" in order to enable this feature.',
       ),
       $meta =
           meta ??
           TranslationMetadata(
             locale: AppLocale.ja,
             overrides: overrides ?? {},
             cardinalResolver: cardinalResolver,
             ordinalResolver: ordinalResolver,
           ) {
    $meta.setFlatMapFunction(_flatMapFunction);
  }

  /// Metadata for the translations of <ja>.
  @override
  final TranslationMetadata<AppLocale, Translations> $meta;

  /// Access flat map
  dynamic operator [](String key) => $meta.getTranslation(key);

  late final Translations _root = this; // ignore: unused_field

  Translations $copyWith({
    TranslationMetadata<AppLocale, Translations>? meta,
  }) => Translations(meta: meta ?? this.$meta);

  // Translations

  /// ja: 'Kakin'
  String get appName => 'Kakin';

  /// ja: 'アプリを起動できませんでした。もう一度お試しください。'
  String get bootstrapFailed => 'アプリを起動できませんでした。もう一度お試しください。';

  /// ja: '再試行'
  String get retry => '再試行';

  late final TranslationsCommonJa common = TranslationsCommonJa._(_root);
  late final TranslationsFormatJa format = TranslationsFormatJa._(_root);
  late final TranslationsTabsJa tabs = TranslationsTabsJa._(_root);
  late final TranslationsCategoryJa category = TranslationsCategoryJa._(_root);
  late final TranslationsCategoryShortJa categoryShort =
      TranslationsCategoryShortJa._(_root);
  late final TranslationsStageJa stage = TranslationsStageJa._(_root);
  late final TranslationsServiceJa service = TranslationsServiceJa._(_root);
  late final TranslationsDeadlineJa deadline = TranslationsDeadlineJa._(_root);
  late final TranslationsQuickActionJa quickAction =
      TranslationsQuickActionJa._(_root);
  late final TranslationsBasisJa basis = TranslationsBasisJa._(_root);
  late final TranslationsSummaryJa summary = TranslationsSummaryJa._(_root);
  late final TranslationsCalendarJa calendar = TranslationsCalendarJa._(_root);
  late final TranslationsListJa list = TranslationsListJa._(_root);
  late final TranslationsUpcomingJa upcoming = TranslationsUpcomingJa._(_root);
  late final TranslationsPerformanceJa performance =
      TranslationsPerformanceJa._(_root);
  late final TranslationsExpenseJa expense = TranslationsExpenseJa._(_root);
  late final TranslationsPartnerJa partner = TranslationsPartnerJa._(_root);
  late final TranslationsApplicationJa application =
      TranslationsApplicationJa._(_root);
  late final TranslationsSettingsJa settings = TranslationsSettingsJa._(_root);
  late final TranslationsOnboardingJa onboarding = TranslationsOnboardingJa._(
    _root,
  );
  late final TranslationsReminderJa reminder = TranslationsReminderJa._(_root);
  late final TranslationsErrorsJa errors = TranslationsErrorsJa._(_root);
}

// Path: common
class TranslationsCommonJa {
  TranslationsCommonJa._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// ja: '保存する'
  String get save => '保存する';

  /// ja: 'キャンセル'
  String get cancel => 'キャンセル';

  /// ja: '削除する'
  String get delete => '削除する';

  /// ja: '閉じる'
  String get close => '閉じる';

  /// ja: '戻る'
  String get back => '戻る';

  /// ja: '元に戻す'
  String get undo => '元に戻す';

  /// ja: '任意'
  String get optional => '任意';

  /// ja: 'あとで設定する'
  String get skip => 'あとで設定する';

  /// ja: '次へ'
  String get next => '次へ';

  /// ja: '今日'
  String get today => '今日';

  /// ja: '未設定'
  String get notSet => '未設定';

  /// ja: '保存中'
  String get saving => '保存中';

  /// ja: '削除しますか？'
  String get deleteConfirmTitle => '削除しますか？';

  /// ja: 'この操作は元に戻せません。'
  String get deleteConfirmBody => 'この操作は元に戻せません。';
}

// Path: format
class TranslationsFormatJa {
  TranslationsFormatJa._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  List<String> get weekdays => [
    '月',
    '火',
    '水',
    '木',
    '金',
    '土',
    '日',
  ];
  List<String> get monthNames => [
    '1月',
    '2月',
    '3月',
    '4月',
    '5月',
    '6月',
    '7月',
    '8月',
    '9月',
    '10月',
    '11月',
    '12月',
  ];

  /// ja: '${year}年${monthName}'
  String yearMonth({required Object year, required Object monthName}) =>
      '${year}年${monthName}';

  /// ja: '${month}/${day}（${weekday}）'
  String monthDay({
    required Object month,
    required Object day,
    required Object weekday,
  }) => '${month}/${day}（${weekday}）';

  /// ja: '${monthName}${day}日（${weekday}）'
  String dayTitle({
    required Object monthName,
    required Object day,
    required Object weekday,
  }) => '${monthName}${day}日（${weekday}）';

  /// ja: '${year}/${month}/${day}（${weekday}）'
  String fullDate({
    required Object year,
    required Object month,
    required Object day,
    required Object weekday,
  }) => '${year}/${month}/${day}（${weekday}）';

  /// ja: '${date} ${time}'
  String dateTime({required Object date, required Object time}) =>
      '${date} ${time}';

  /// ja: '¥${amount}'
  String yen({required Object amount}) => '¥${amount}';

  /// ja: '−¥${amount}'
  String negativeYen({required Object amount}) => '−¥${amount}';

  /// ja: '¥•••'
  String get hiddenYen => '¥•••';

  /// ja: '•••'
  String get hiddenNumber => '•••';

  /// ja: 'あと${days}日'
  String daysLeft({required Object days}) => 'あと${days}日';

  /// ja: '${count}枚'
  String shots({required Object count}) => '${count}枚';

  /// ja: '${count}人'
  String people({required Object count}) => '${count}人';

  /// ja: '${count}件'
  String count({required Object count}) => '${count}件';
}

// Path: tabs
class TranslationsTabsJa {
  TranslationsTabsJa._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// ja: 'カレンダー'
  String get calendar => 'カレンダー';

  /// ja: 'リスト'
  String get list => 'リスト';

  /// ja: '今後の公演'
  String get upcoming => '今後の公演';

  /// ja: '設定'
  String get settings => '設定';
}

// Path: category
class TranslationsCategoryJa {
  TranslationsCategoryJa._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// ja: 'チケット代'
  String get ticket => 'チケット代';

  /// ja: 'ドリンク代'
  String get drink => 'ドリンク代';

  /// ja: 'チェキ代'
  String get cheki => 'チェキ代';

  /// ja: 'グッズ代'
  String get goods => 'グッズ代';

  /// ja: '交通費'
  String get transport => '交通費';

  /// ja: 'コインロッカー代'
  String get locker => 'コインロッカー代';

  /// ja: 'その他'
  String get other => 'その他';
}

// Path: categoryShort
class TranslationsCategoryShortJa {
  TranslationsCategoryShortJa._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// ja: 'チケット'
  String get ticket => 'チケット';

  /// ja: 'ドリンク'
  String get drink => 'ドリンク';

  /// ja: 'チェキ'
  String get cheki => 'チェキ';

  /// ja: 'グッズ'
  String get goods => 'グッズ';

  /// ja: '交通費'
  String get transport => '交通費';

  /// ja: 'ロッカー'
  String get locker => 'ロッカー';

  /// ja: 'その他'
  String get other => 'その他';
}

// Path: stage
class TranslationsStageJa {
  TranslationsStageJa._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// ja: '申込予定'
  String get planned => '申込予定';

  /// ja: '結果待ち'
  String get awaitingResult => '結果待ち';

  /// ja: '入金待ち'
  String get awaitingPayment => '入金待ち';

  /// ja: '確保済み'
  String get secured => '確保済み';

  /// ja: '落選'
  String get lost => '落選';
}

// Path: service
class TranslationsServiceJa {
  TranslationsServiceJa._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// ja: 'eplus'
  String get eplus => 'eplus';

  /// ja: 'ライブポケット'
  String get livepocket => 'ライブポケット';

  /// ja: 'その他'
  String get other => 'その他';
}

// Path: deadline
class TranslationsDeadlineJa {
  TranslationsDeadlineJa._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// ja: '申込締切'
  String get apply => '申込締切';

  /// ja: '当落発表日時'
  String get result => '当落発表日時';

  /// ja: '入金期限'
  String get payment => '入金期限';

  /// ja: '当落発表'
  String get resultShort => '当落発表';
}

// Path: quickAction
class TranslationsQuickActionJa {
  TranslationsQuickActionJa._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// ja: '申し込んだ'
  String get applied => '申し込んだ';

  /// ja: '当選'
  String get won => '当選';

  /// ja: '落選'
  String get lost => '落選';

  /// ja: '支払った'
  String get paid => '支払った';
}

// Path: basis
class TranslationsBasisJa {
  TranslationsBasisJa._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// ja: '計上基準'
  String get label => '計上基準';

  /// ja: '支払日'
  String get paidOn => '支払日';

  /// ja: '公演日'
  String get performanceDate => '公演日';
}

// Path: summary
class TranslationsSummaryJa {
  TranslationsSummaryJa._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// ja: '今月の概要'
  String get label => '今月の概要';

  /// ja: '残高'
  String get balance => '残高';

  /// ja: '推し活代'
  String get budget => '推し活代';

  /// ja: '繰越'
  String get carryover => '繰越';

  /// ja: '支出'
  String get spend => '支出';

  /// ja: '支出（公演日）'
  String get spendByPerformanceDate => '支出（公演日）';

  /// ja: 'マイナス分は翌月へ繰り越します'
  String get negativeNote => 'マイナス分は翌月へ繰り越します';

  /// ja: '予算オーバー'
  String get overBudget => '予算オーバー';

  /// ja: '予算内'
  String get withinBudget => '予算内';

  /// ja: '金額は非表示中 · 超えた分は翌月へ繰り越し'
  String get hiddenNote => '金額は非表示中 · 超えた分は翌月へ繰り越し';

  /// ja: '支出は公演日で集計中。残高は常に支払日で計算します。'
  String get performanceBasisNote => '支出は公演日で集計中。残高は常に支払日で計算します。';

  /// ja: '推し活代を設定すると、残高と繰越を表示します'
  String get unconfigured => '推し活代を設定すると、残高と繰越を表示します';

  /// ja: '開始月より前の月です。残高には含めません'
  String get beforeStart => '開始月より前の月です。残高には含めません';

  /// ja: '金額を表示'
  String get showAmounts => '金額を表示';

  /// ja: '金額を隠す'
  String get hideAmounts => '金額を隠す';
}

// Path: calendar
class TranslationsCalendarJa {
  TranslationsCalendarJa._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// ja: '前の月'
  String get previousMonth => '前の月';

  /// ja: '次の月'
  String get nextMonth => '次の月';

  /// ja: 'この日の記録はありません'
  String get noRecords => 'この日の記録はありません';

  /// ja: '支出を追加'
  String get addExpense => '支出を追加';

  /// ja: '${date}'
  String dayLabel({required Object date}) => '${date}';

  /// ja: '支出 ${amount}'
  String daySpend({required Object amount}) => '支出 ${amount}';

  /// ja: '支出あり'
  String get daySpendHidden => '支出あり';

  /// ja: '公演あり'
  String get dayHasPerformance => '公演あり';

  /// ja: '${time} 開演'
  String performanceMeta({required Object time}) => '${time} 開演';

  /// ja: '${time} 開演 · ${venue}'
  String performanceMetaVenue({required Object time, required Object venue}) =>
      '${time} 開演 · ${venue}';

  /// ja: 'Gmail'
  String get gmailBadge => 'Gmail';

  /// ja: '二重計上？'
  String get duplicateBadge => '二重計上？';
}

// Path: list
class TranslationsListJa {
  TranslationsListJa._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// ja: 'すべて'
  String get all => 'すべて';

  /// ja: 'このカテゴリの支出はありません'
  String get emptyCategory => 'このカテゴリの支出はありません';

  /// ja: 'この月の支出はありません'
  String get emptyMonth => 'この月の支出はありません';

  /// ja: '公演 ${date}'
  String performanceOn({required Object date}) => '公演 ${date}';

  /// ja: '超過'
  String get overspent => '超過';

  /// ja: 'カテゴリで絞り込む'
  String get filterLabel => 'カテゴリで絞り込む';
}

// Path: upcoming
class TranslationsUpcomingJa {
  TranslationsUpcomingJa._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// ja: '申込を追加'
  String get addApplication => '申込を追加';

  /// ja: 'やること'
  String get todo => 'やること';

  /// ja: '期限が近い順'
  String get todoOrder => '期限が近い順';

  /// ja: '期限が近いチケット申込はありません。'
  String get noTodo => '期限が近いチケット申込はありません。';

  /// ja: '公演'
  String get performances => '公演';

  /// ja: 'これからの公演はまだありません。チケット代かチケット申込を登録すると表示します。'
  String get noPerformances => 'これからの公演はまだありません。チケット代かチケット申込を登録すると表示します。';

  /// ja: '${kind}を過ぎました · 結果を記録'
  String overdue({required Object kind}) => '${kind}を過ぎました · 結果を記録';

  /// ja: '要更新'
  String get needsUpdate => '要更新';

  /// ja: '「${title}」を${stage}にしました'
  String stageChanged({required Object title, required Object stage}) =>
      '「${title}」を${stage}にしました';

  /// ja: '${title}を${stage}にする'
  String actionLabel({required Object title, required Object stage}) =>
      '${title}を${stage}にする';

  /// ja: '${time} 開演'
  String startsAt({required Object time}) => '${time} 開演';

  /// ja: '${time} 開演 · ${venue}'
  String startsAtVenue({required Object time, required Object venue}) =>
      '${time} 開演 · ${venue}';

  /// ja: '申込なし'
  String get noApplication => '申込なし';

  /// ja: '通知が許可されていないため、リマインドは届きません。端末の設定アプリから通知を許可してください。'
  String get notificationsDenied =>
      '通知が許可されていないため、リマインドは届きません。端末の設定アプリから通知を許可してください。';
}

// Path: performance
class TranslationsPerformanceJa {
  TranslationsPerformanceJa._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// ja: '公演'
  String get title => '公演';

  /// ja: '公演を登録'
  String get newTitle => '公演を登録';

  /// ja: '公演を編集'
  String get editTitle => '公演を編集';

  /// ja: '公演名'
  String get name => '公演名';

  /// ja: '開始日時'
  String get startsAt => '開始日時';

  /// ja: '日付'
  String get date => '日付';

  /// ja: '開演時刻'
  String get time => '開演時刻';

  /// ja: '会場'
  String get venue => '会場';

  /// ja: '公演を選ぶ'
  String get pick => '公演を選ぶ';

  /// ja: '公演（任意）'
  String get pickOptional => '公演（任意）';

  /// ja: '紐づけない'
  String get none => '紐づけない';

  /// ja: '登録済みの公演はありません'
  String get noPerformances => '登録済みの公演はありません';

  /// ja: '新しい公演を登録'
  String get createNew => '新しい公演を登録';

  /// ja: 'チケット申込'
  String get applications => 'チケット申込';

  /// ja: 'チケット申込はまだありません'
  String get noApplications => 'チケット申込はまだありません';

  /// ja: 'この公演を削除'
  String get delete => 'この公演を削除';

  /// ja: '公演を削除しますか？'
  String get deleteTitle => '公演を削除しますか？';

  /// ja: 'チケット代・ドリンク代・チェキ代 ${count}件（${amount}）と、チケット申込 ${applications}件も一緒に削除します。グッズ代などは公演との紐づけだけを外します。'
  String deleteBody({
    required Object count,
    required Object amount,
    required Object applications,
  }) =>
      'チケット代・ドリンク代・チェキ代 ${count}件（${amount}）と、チケット申込 ${applications}件も一緒に削除します。グッズ代などは公演との紐づけだけを外します。';

  /// ja: '公演名を入力してください'
  String get titleRequired => '公演名を入力してください';
}

// Path: expense
class TranslationsExpenseJa {
  TranslationsExpenseJa._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// ja: '支出を追加'
  String get addTitle => '支出を追加';

  /// ja: '支出を編集'
  String get editTitle => '支出を編集';

  /// ja: '公演'
  String get performance => '公演';

  /// ja: '支払日'
  String get paidOn => '支払日';

  /// ja: '今日 ${date}'
  String today({required Object date}) => '今日 ${date}';

  /// ja: 'カテゴリ'
  String get categoryGroup => 'カテゴリ';

  /// ja: '金額'
  String get amount => '金額';

  /// ja: '1枚あたり'
  String get unitPrice => '1枚あたり';

  /// ja: '数字キー'
  String get keypad => '数字キー';

  /// ja: '1文字消す'
  String get deleteKey => '1文字消す';

  /// ja: 'チェキ相手'
  String get partners => 'チェキ相手';

  /// ja: '相手を選ぶ'
  String get pickPartners => '相手を選ぶ';

  /// ja: 'チェキ相手を選んでください'
  String get noPartners => 'チェキ相手を選んでください';

  /// ja: '${name}の枚数を増やす'
  String increase({required Object name}) => '${name}の枚数を増やす';

  /// ja: '${name}の枚数を減らす（0枚で外す）'
  String decrease({required Object name}) => '${name}の枚数を減らす（0枚で外す）';

  /// ja: '${group} · ${amount}'
  String partnerSub({required Object group, required Object amount}) =>
      '${group} · ${amount}';

  /// ja: '前回のドリンク代を入力済み'
  String get drinkPrefilled => '前回のドリンク代を入力済み';

  /// ja: '合計 ${amount}（相手ごとに1件ずつ記録します）'
  String chekiTotal({required Object amount}) => '合計 ${amount}（相手ごとに1件ずつ記録します）';

  /// ja: '${amount} を記録'
  String recordAmount({required Object amount}) => '${amount} を記録';

  /// ja: '${count}件 · ${amount} を記録'
  String recordCheki({required Object count, required Object amount}) =>
      '${count}件 · ${amount} を記録';

  /// ja: '金額を入力'
  String get enterAmount => '金額を入力';

  /// ja: '相手を選んでください'
  String get selectPartnerCta => '相手を選んでください';

  /// ja: '公演を選んでください'
  String get selectPerformanceCta => '公演を選んでください';

  /// ja: '続けて記録'
  String get recordAndContinue => '続けて記録';

  /// ja: '記録しました'
  String get recorded => '記録しました';

  /// ja: 'メモ'
  String get note => 'メモ';

  /// ja: 'Gmail から取り込み'
  String get importedNote => 'Gmail から取り込み';

  /// ja: 'この支出を削除'
  String get delete => 'この支出を削除';

  /// ja: '撮影枚数'
  String get shotCount => '撮影枚数';
}

// Path: partner
class TranslationsPartnerJa {
  TranslationsPartnerJa._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// ja: 'チェキ相手を選ぶ'
  String get pickerTitle => 'チェキ相手を選ぶ';

  /// ja: '名前・所属で検索'
  String get search => '名前・所属で検索';

  /// ja: '最近撮った相手'
  String get recent => '最近撮った相手';

  /// ja: '所属なし'
  String get noGroup => '所属なし';

  /// ja: '検索結果'
  String get searchResults => '検索結果';

  /// ja: 'まだ撮っていません'
  String get notShotYet => 'まだ撮っていません';

  /// ja: '前回 ${date}'
  String lastShot({required Object date}) => '前回 ${date}';

  /// ja: '${name}を編集'
  String edit({required Object name}) => '${name}を編集';

  /// ja: '${name}の選択を外す'
  String deselect({required Object name}) => '${name}の選択を外す';

  /// ja: '${count}人で決定'
  String confirm({required Object count}) => '${count}人で決定';

  /// ja: '相手を選んでください'
  String get selectPrompt => '相手を選んでください';

  /// ja: '＋ 新しいチェキ相手を登録'
  String get createNew => '＋ 新しいチェキ相手を登録';

  /// ja: '新しいチェキ相手'
  String get newTitle => '新しいチェキ相手';

  /// ja: '名前'
  String get name => '名前';

  /// ja: '所属'
  String get group => '所属';

  /// ja: '任意 · 同じ名前の相手を見分けます'
  String get groupHint => '任意 · 同じ名前の相手を見分けます';

  /// ja: 'アイコン画像'
  String get icon => 'アイコン画像';

  /// ja: 'アイコン画像 · 任意'
  String get iconOptional => 'アイコン画像 · 任意';

  /// ja: '画像を選ぶ'
  String get pickImage => '画像を選ぶ';

  /// ja: '画像を変える'
  String get changeImage => '画像を変える';

  /// ja: '画像を外す'
  String get removeImage => '画像を外す';

  /// ja: '写真を撮る'
  String get camera => '写真を撮る';

  /// ja: 'ライブラリから選ぶ'
  String get gallery => 'ライブラリから選ぶ';

  /// ja: '選んだ画像は正方形に切り抜いて、丸く表示します。'
  String get iconNote => '選んだ画像は正方形に切り抜いて、丸く表示します。';

  /// ja: '画像はこの端末の中だけに保存します'
  String get iconLocal => '画像はこの端末の中だけに保存します';

  /// ja: '登録して選ぶ'
  String get createAndSelect => '登録して選ぶ';

  /// ja: 'チェキ相手の編集'
  String get editTitle => 'チェキ相手の編集';

  /// ja: '記録'
  String get records => '記録';

  /// ja: 'チェキ代 ${count}件 · 撮影 ${shots}枚'
  String stats({required Object count, required Object shots}) =>
      'チェキ代 ${count}件 · 撮影 ${shots}枚';

  /// ja: '初めて ${first} · 前回 ${last}'
  String history({required Object first, required Object last}) =>
      '初めて ${first} · 前回 ${last}';

  /// ja: 'チェキ代の記録はまだありません'
  String get noRecords => 'チェキ代の記録はまだありません';

  /// ja: 'このチェキ相手を削除'
  String get delete => 'このチェキ相手を削除';

  /// ja: 'チェキ代の記録があるため削除できません'
  String get inUse => 'チェキ代の記録があるため削除できません';

  /// ja: '名前を入力してください'
  String get nameRequired => '名前を入力してください';

  /// ja: '登録済みのチェキ相手はいません'
  String get empty => '登録済みのチェキ相手はいません';
}

// Path: application
class TranslationsApplicationJa {
  TranslationsApplicationJa._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// ja: 'チケット申込'
  String get title => 'チケット申込';

  /// ja: '公演'
  String get performance => '公演';

  /// ja: '申込段階'
  String get stage => '申込段階';

  /// ja: 'チケットサービス'
  String get service => 'チケットサービス';

  /// ja: '受付番号'
  String get referenceNo => '受付番号';

  /// ja: '任意 · Gmail の照合に使います'
  String get referenceHint => '任意 · Gmail の照合に使います';

  /// ja: '期限'
  String get deadlines => '期限';

  /// ja: 'リマインド対象'
  String get reminded => 'リマインド対象';

  /// ja: '日時を選ぶ'
  String get pickDateTime => '日時を選ぶ';

  /// ja: 'クリア'
  String get clear => 'クリア';

  /// ja: 'メモ'
  String get note => 'メモ';

  /// ja: 'このチケット申込を削除'
  String get delete => 'このチケット申込を削除';

  /// ja: 'Gmail から取り込み'
  String get imported => 'Gmail から取り込み';

  /// ja: '申込締切を過ぎています。申し込んだら、段階を「結果待ち」にしてください。'
  String get overdueApply => '申込締切を過ぎています。申し込んだら、段階を「結果待ち」にしてください。';

  /// ja: '当落発表日時を過ぎています。結果が出たら段階を更新してください。'
  String get overdueResult => '当落発表日時を過ぎています。結果が出たら段階を更新してください。';

  /// ja: '入金期限を過ぎています。支払ったら段階を「確保済み」にしてください。'
  String get overduePayment => '入金期限を過ぎています。支払ったら段階を「確保済み」にしてください。';

  /// ja: '${times} に通知します。'
  String willNotify({required Object times}) => '${times} に通知します。';

  /// ja: 'この段階ではリマインドしません。発券の状況はメモに残せます。'
  String get noReminder => 'この段階ではリマインドしません。発券の状況はメモに残せます。';

  /// ja: '${kind}を入れると、期限の前に通知します。'
  String noDeadline({required Object kind}) => '${kind}を入れると、期限の前に通知します。';

  /// ja: '${kind}のリマインドは設定でオフになっています。'
  String reminderOff({required Object kind}) => '${kind}のリマインドは設定でオフになっています。';

  /// ja: '公演を選んでください'
  String get performanceRequired => '公演を選んでください';

  /// ja: 'チケット申込を追加'
  String get add => 'チケット申込を追加';
}

// Path: settings
class TranslationsSettingsJa {
  TranslationsSettingsJa._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// ja: '推し活代'
  String get budget => '推し活代';

  /// ja: '月額'
  String get monthly => '月額';

  /// ja: '開始月'
  String get startMonth => '開始月';

  /// ja: '月ごとの上書き'
  String get overrides => '月ごとの上書き';

  /// ja: '${count}件'
  String overrideCount({required Object count}) => '${count}件';

  /// ja: '${month} ${amount}'
  String overrideItem({required Object month, required Object amount}) =>
      '${month} ${amount}';

  /// ja: '上書きを追加'
  String get addOverride => '上書きを追加';

  /// ja: '上書きする月'
  String get overrideMonth => '上書きする月';

  /// ja: 'その月の推し活代'
  String get overrideAmount => 'その月の推し活代';

  /// ja: '上書きを解除'
  String get removeOverride => '上書きを解除';

  /// ja: '上書きしている月はありません'
  String get noOverrides => '上書きしている月はありません';

  /// ja: '未設定'
  String get budgetUnset => '未設定';

  /// ja: '推し活代を設定する'
  String get setBudget => '推し活代を設定する';

  /// ja: 'Gmail 連携'
  String get gmail => 'Gmail 連携';

  /// ja: '連携していません'
  String get gmailNotConnected => '連携していません';

  /// ja: 'Gmail と連携する'
  String get connect => 'Gmail と連携する';

  /// ja: 'Gmail に再連携する'
  String get reconnect => 'Gmail に再連携する';

  /// ja: 'Gmail の認証の期限が切れました。'
  String get reauthTitle => 'Gmail の認証の期限が切れました。';

  /// ja: '再連携すると、前回の同期以降のメールから取り込みを再開します。'
  String get reauthBody => '再連携すると、前回の同期以降のメールから取り込みを再開します。';

  /// ja: '前回の同期に失敗しました（${date}）。次の同期で取りこぼした範囲を取り込み直します。'
  String syncFailed({required Object date}) =>
      '前回の同期に失敗しました（${date}）。次の同期で取りこぼした範囲を取り込み直します。';

  /// ja: '最終同期'
  String get lastSync => '最終同期';

  /// ja: 'まだ同期していません'
  String get neverSynced => 'まだ同期していません';

  /// ja: '対応サービス'
  String get services => '対応サービス';

  /// ja: 'eplus · ライブポケット'
  String get servicesValue => 'eplus · ライブポケット';

  /// ja: '自動同期'
  String get autoSync => '自動同期';

  /// ja: '未対応（手動で同期してください）'
  String get autoSyncValue => '未対応（手動で同期してください）';

  /// ja: '今すぐ同期'
  String get syncNow => '今すぐ同期';

  /// ja: '同期中'
  String get syncing => '同期中';

  /// ja: '${count}通を取り込みました'
  String synced({required Object count}) => '${count}通を取り込みました';

  /// ja: '連携を解除する'
  String get disconnect => '連携を解除する';

  /// ja: '解除しても、取り込み済みの公演と支出は残ります。'
  String get disconnectNote => '解除しても、取り込み済みの公演と支出は残ります。';

  /// ja: 'Gmail の連携を解除しますか？'
  String get disconnectTitle => 'Gmail の連携を解除しますか？';

  /// ja: 'デモデータ'
  String get demo => 'デモデータ';

  /// ja: 'OAuth クライアントが未設定のため、モックデータのメールを取り込みます。'
  String get demoNote => 'OAuth クライアントが未設定のため、モックデータのメールを取り込みます。';

  /// ja: 'リマインド'
  String get reminders => 'リマインド';

  /// ja: '通知は許可されています'
  String get permissionGranted => '通知は許可されています';

  /// ja: '通知が許可されていません。端末の設定アプリから許可してください。'
  String get permissionDenied => '通知が許可されていません。端末の設定アプリから許可してください。';

  /// ja: '初めて期限を登録したときに、通知の許可を求めます'
  String get permissionUnknown => '初めて期限を登録したときに、通知の許可を求めます';

  /// ja: '表示'
  String get display => '表示';

  /// ja: '金額を表示する'
  String get showAmounts => '金額を表示する';

  /// ja: 'オフにすると、カレンダーとリストの金額を「•••」で隠します。各画面の目のボタンでも、その場で切り替えられます。今後の公演と通知には金額を表示しません。'
  String get showAmountsNote =>
      'オフにすると、カレンダーとリストの金額を「•••」で隠します。各画面の目のボタンでも、その場で切り替えられます。今後の公演と通知には金額を表示しません。';

  /// ja: 'テーマ'
  String get theme => 'テーマ';

  /// ja: '端末に合わせる'
  String get themeSystem => '端末に合わせる';

  /// ja: 'ライト'
  String get themeLight => 'ライト';

  /// ja: 'ダーク'
  String get themeDark => 'ダーク';

  /// ja: '言語'
  String get language => '言語';

  /// ja: '日本語'
  String get languageJapanese => '日本語';

  /// ja: 'English'
  String get languageEnglish => 'English';

  /// ja: '計上基準の初期値'
  String get defaultBasis => '計上基準の初期値';

  /// ja: 'カレンダーとリストで支出をどの日に置くかの初期値です。残高は常に支払日で計算します。'
  String get defaultBasisNote => 'カレンダーとリストで支出をどの日に置くかの初期値です。残高は常に支払日で計算します。';

  /// ja: '前日 20:00 と3時間前'
  String get reminderApplyWhen => '前日 20:00 と3時間前';

  /// ja: '発表の時刻'
  String get reminderResultWhen => '発表の時刻';

  /// ja: '前日 20:00 と3時間前'
  String get reminderPaymentWhen => '前日 20:00 と3時間前';

  /// ja: '上書きを保存しました'
  String get overrideSaved => '上書きを保存しました';

  /// ja: '推し活代を保存しました'
  String get budgetSaved => '推し活代を保存しました';

  /// ja: '連携中のアカウント'
  String get gmailAccount => '連携中のアカウント';

  /// ja: '同期の失敗'
  String get gmailFailedAt => '同期の失敗';
}

// Path: onboarding
class TranslationsOnboardingJa {
  TranslationsOnboardingJa._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// ja: '推し活のお金と予定を、ひとつのアプリで。'
  String get welcomeTitle => '推し活のお金と予定を、ひとつのアプリで。';

  /// ja: '決めた予算の中で、安心して推し活を楽しむためのアプリです。'
  String get welcomeBody => '決めた予算の中で、安心して推し活を楽しむためのアプリです。';

  /// ja: '毎月の推し活代で予算を立てる'
  String get featureBudgetTitle => '毎月の推し活代で予算を立てる';

  /// ja: '使わなかった分も、使いすぎた分も翌月へ繰り越します。'
  String get featureBudgetBody => '使わなかった分も、使いすぎた分も翌月へ繰り越します。';

  /// ja: '会場ですぐ記録'
  String get featureRecordTitle => '会場ですぐ記録';

  /// ja: 'ドリンク代は前回の金額で、チェキ代は相手を選んで枚数を入れるだけ。'
  String get featureRecordBody => 'ドリンク代は前回の金額で、チェキ代は相手を選んで枚数を入れるだけ。';

  /// ja: 'チケットの期限を逃さない'
  String get featureReminderTitle => 'チケットの期限を逃さない';

  /// ja: '抽選の申込締切・当落発表・入金期限を通知でお知らせします。'
  String get featureReminderBody => '抽選の申込締切・当落発表・入金期限を通知でお知らせします。';

  /// ja: 'データはこの端末の中だけに保存します。登録やログインは要りません。'
  String get privacy => 'データはこの端末の中だけに保存します。登録やログインは要りません。';

  /// ja: 'はじめる'
  String get start => 'はじめる';

  /// ja: '1 / 2'
  String get budgetStep => '1 / 2';

  /// ja: '毎月の推し活代を決めましょう'
  String get budgetTitle => '毎月の推し活代を決めましょう';

  /// ja: '推し活に使ってよい1ヶ月あたりの予算です。毎月残高に加わり、使わなかった分もマイナスの分も翌月へ繰り越します。'
  String get budgetBody =>
      '推し活に使ってよい1ヶ月あたりの予算です。毎月残高に加わり、使わなかった分もマイナスの分も翌月へ繰り越します。';

  /// ja: '開始月より前の支出は一覧に表示しますが、残高には含めません。'
  String get budgetStartNote => '開始月より前の支出は一覧に表示しますが、残高には含めません。';

  /// ja: '${month}から毎月 ${amount} で設定'
  String budgetCta({required Object month, required Object amount}) =>
      '${month}から毎月 ${amount} で設定';

  /// ja: '推し活代は設定画面からいつでも変更できます'
  String get budgetLater => '推し活代は設定画面からいつでも変更できます';

  /// ja: '2 / 2 · 任意'
  String get gmailStep => '2 / 2 · 任意';

  /// ja: 'チケットのメールから自動で記録'
  String get gmailTitle => 'チケットのメールから自動で記録';

  /// ja: 'Gmail と連携すると、チケットの購入や抽選のメールを読み取り、チケット代とチケット申込を自動で登録します。'
  String get gmailBody =>
      'Gmail と連携すると、チケットの購入や抽選のメールを読み取り、チケット代とチケット申込を自動で登録します。';

  /// ja: '読むのは eplus・ライブポケットのチケットのメールだけ。メールの送信や削除はしません。'
  String get gmailScope => '読むのは eplus・ライブポケットのチケットのメールだけ。メールの送信や削除はしません。';

  /// ja: 'メールの本文は保存せず、読み取った内容はこの端末の中だけに置きます。'
  String get gmailPrivacy => 'メールの本文は保存せず、読み取った内容はこの端末の中だけに置きます。';

  /// ja: '連携すると、3ヶ月前までのメールをさかのぼって取り込みます。'
  String get gmailBackfill => '連携すると、3ヶ月前までのメールをさかのぼって取り込みます。';

  /// ja: '${email} と連携しました。取り込みはバックグラウンドで続きます。'
  String gmailConnected({required Object email}) =>
      '${email} と連携しました。取り込みはバックグラウンドで続きます。';

  /// ja: 'あとで連携する'
  String get gmailLater => 'あとで連携する';

  /// ja: '連携と解除は設定画面からいつでもできます'
  String get gmailLaterNote => '連携と解除は設定画面からいつでもできます';

  /// ja: '決済に関するご案内'
  String get sampleSubject => '決済に関するご案内';

  /// ja: '自動'
  String get sampleAuto => '自動';
}

// Path: reminder
class TranslationsReminderJa {
  TranslationsReminderJa._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// ja: 'チケット申込のリマインド'
  String get channelName => 'チケット申込のリマインド';

  /// ja: '申込締切・当落発表・入金期限をお知らせします'
  String get channelDescription => '申込締切・当落発表・入金期限をお知らせします';

  /// ja: '明日 ${time} が申込締切です'
  String applyEve({required Object time}) => '明日 ${time} が申込締切です';

  /// ja: '申込締切まであと3時間（${time}）'
  String applySoon({required Object time}) => '申込締切まであと3時間（${time}）';

  /// ja: '当落発表の時刻です（${dateTime}）。結果を記録しましょう'
  String resultAt({required Object dateTime}) =>
      '当落発表の時刻です（${dateTime}）。結果を記録しましょう';

  /// ja: '明日 ${time} が入金期限です'
  String paymentEve({required Object time}) => '明日 ${time} が入金期限です';

  /// ja: '入金期限まであと3時間（${time}）'
  String paymentSoon({required Object time}) => '入金期限まであと3時間（${time}）';
}

// Path: errors
class TranslationsErrorsJa {
  TranslationsErrorsJa._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// ja: '予期しないエラーが発生しました。もう一度お試しください。'
  String get unexpected => '予期しないエラーが発生しました。もう一度お試しください。';

  /// ja: '設定を保存できませんでした。もう一度お試しください。'
  String get settingsWrite => '設定を保存できませんでした。もう一度お試しください。';

  /// ja: '記録を保存できませんでした。もう一度お試しください。'
  String get recordStorage => '記録を保存できませんでした。もう一度お試しください。';

  /// ja: '入力内容を確認してください。'
  String get invalidInput => '入力内容を確認してください。';

  /// ja: 'チェキ代の記録があるため削除できません。'
  String get partnerInUse => 'チェキ代の記録があるため削除できません。';

  /// ja: '画像を読み込めませんでした。'
  String get partnerIcon => '画像を読み込めませんでした。';

  /// ja: 'Gmail の再連携が必要です。'
  String get gmailReauthRequired => 'Gmail の再連携が必要です。';

  /// ja: 'Gmail と同期できませんでした。時間をおいてもう一度お試しください。'
  String get gmailSync => 'Gmail と同期できませんでした。時間をおいてもう一度お試しください。';

  /// ja: '通知を予約できませんでした。'
  String get reminderSchedule => '通知を予約できませんでした。';
}

/// The flat map containing all translations for locale <ja>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
  dynamic _flatMapFunction(String path) {
    return switch (path) {
      'appName' => 'Kakin',
      'bootstrapFailed' => 'アプリを起動できませんでした。もう一度お試しください。',
      'retry' => '再試行',
      'common.save' => '保存する',
      'common.cancel' => 'キャンセル',
      'common.delete' => '削除する',
      'common.close' => '閉じる',
      'common.back' => '戻る',
      'common.undo' => '元に戻す',
      'common.optional' => '任意',
      'common.skip' => 'あとで設定する',
      'common.next' => '次へ',
      'common.today' => '今日',
      'common.notSet' => '未設定',
      'common.saving' => '保存中',
      'common.deleteConfirmTitle' => '削除しますか？',
      'common.deleteConfirmBody' => 'この操作は元に戻せません。',
      'format.weekdays.0' => '月',
      'format.weekdays.1' => '火',
      'format.weekdays.2' => '水',
      'format.weekdays.3' => '木',
      'format.weekdays.4' => '金',
      'format.weekdays.5' => '土',
      'format.weekdays.6' => '日',
      'format.monthNames.0' => '1月',
      'format.monthNames.1' => '2月',
      'format.monthNames.2' => '3月',
      'format.monthNames.3' => '4月',
      'format.monthNames.4' => '5月',
      'format.monthNames.5' => '6月',
      'format.monthNames.6' => '7月',
      'format.monthNames.7' => '8月',
      'format.monthNames.8' => '9月',
      'format.monthNames.9' => '10月',
      'format.monthNames.10' => '11月',
      'format.monthNames.11' => '12月',
      'format.yearMonth' =>
        ({required Object year, required Object monthName}) =>
            '${year}年${monthName}',
      'format.monthDay' =>
        ({
          required Object month,
          required Object day,
          required Object weekday,
        }) => '${month}/${day}（${weekday}）',
      'format.dayTitle' =>
        ({
          required Object monthName,
          required Object day,
          required Object weekday,
        }) => '${monthName}${day}日（${weekday}）',
      'format.fullDate' =>
        ({
          required Object year,
          required Object month,
          required Object day,
          required Object weekday,
        }) => '${year}/${month}/${day}（${weekday}）',
      'format.dateTime' =>
        ({required Object date, required Object time}) => '${date} ${time}',
      'format.yen' => ({required Object amount}) => '¥${amount}',
      'format.negativeYen' => ({required Object amount}) => '−¥${amount}',
      'format.hiddenYen' => '¥•••',
      'format.hiddenNumber' => '•••',
      'format.daysLeft' => ({required Object days}) => 'あと${days}日',
      'format.shots' => ({required Object count}) => '${count}枚',
      'format.people' => ({required Object count}) => '${count}人',
      'format.count' => ({required Object count}) => '${count}件',
      'tabs.calendar' => 'カレンダー',
      'tabs.list' => 'リスト',
      'tabs.upcoming' => '今後の公演',
      'tabs.settings' => '設定',
      'category.ticket' => 'チケット代',
      'category.drink' => 'ドリンク代',
      'category.cheki' => 'チェキ代',
      'category.goods' => 'グッズ代',
      'category.transport' => '交通費',
      'category.locker' => 'コインロッカー代',
      'category.other' => 'その他',
      'categoryShort.ticket' => 'チケット',
      'categoryShort.drink' => 'ドリンク',
      'categoryShort.cheki' => 'チェキ',
      'categoryShort.goods' => 'グッズ',
      'categoryShort.transport' => '交通費',
      'categoryShort.locker' => 'ロッカー',
      'categoryShort.other' => 'その他',
      'stage.planned' => '申込予定',
      'stage.awaitingResult' => '結果待ち',
      'stage.awaitingPayment' => '入金待ち',
      'stage.secured' => '確保済み',
      'stage.lost' => '落選',
      'service.eplus' => 'eplus',
      'service.livepocket' => 'ライブポケット',
      'service.other' => 'その他',
      'deadline.apply' => '申込締切',
      'deadline.result' => '当落発表日時',
      'deadline.payment' => '入金期限',
      'deadline.resultShort' => '当落発表',
      'quickAction.applied' => '申し込んだ',
      'quickAction.won' => '当選',
      'quickAction.lost' => '落選',
      'quickAction.paid' => '支払った',
      'basis.label' => '計上基準',
      'basis.paidOn' => '支払日',
      'basis.performanceDate' => '公演日',
      'summary.label' => '今月の概要',
      'summary.balance' => '残高',
      'summary.budget' => '推し活代',
      'summary.carryover' => '繰越',
      'summary.spend' => '支出',
      'summary.spendByPerformanceDate' => '支出（公演日）',
      'summary.negativeNote' => 'マイナス分は翌月へ繰り越します',
      'summary.overBudget' => '予算オーバー',
      'summary.withinBudget' => '予算内',
      'summary.hiddenNote' => '金額は非表示中 · 超えた分は翌月へ繰り越し',
      'summary.performanceBasisNote' => '支出は公演日で集計中。残高は常に支払日で計算します。',
      'summary.unconfigured' => '推し活代を設定すると、残高と繰越を表示します',
      'summary.beforeStart' => '開始月より前の月です。残高には含めません',
      'summary.showAmounts' => '金額を表示',
      'summary.hideAmounts' => '金額を隠す',
      'calendar.previousMonth' => '前の月',
      'calendar.nextMonth' => '次の月',
      'calendar.noRecords' => 'この日の記録はありません',
      'calendar.addExpense' => '支出を追加',
      'calendar.dayLabel' => ({required Object date}) => '${date}',
      'calendar.daySpend' => ({required Object amount}) => '支出 ${amount}',
      'calendar.daySpendHidden' => '支出あり',
      'calendar.dayHasPerformance' => '公演あり',
      'calendar.performanceMeta' => ({required Object time}) => '${time} 開演',
      'calendar.performanceMetaVenue' =>
        ({required Object time, required Object venue}) =>
            '${time} 開演 · ${venue}',
      'calendar.gmailBadge' => 'Gmail',
      'calendar.duplicateBadge' => '二重計上？',
      'list.all' => 'すべて',
      'list.emptyCategory' => 'このカテゴリの支出はありません',
      'list.emptyMonth' => 'この月の支出はありません',
      'list.performanceOn' => ({required Object date}) => '公演 ${date}',
      'list.overspent' => '超過',
      'list.filterLabel' => 'カテゴリで絞り込む',
      'upcoming.addApplication' => '申込を追加',
      'upcoming.todo' => 'やること',
      'upcoming.todoOrder' => '期限が近い順',
      'upcoming.noTodo' => '期限が近いチケット申込はありません。',
      'upcoming.performances' => '公演',
      'upcoming.noPerformances' => 'これからの公演はまだありません。チケット代かチケット申込を登録すると表示します。',
      'upcoming.overdue' => ({required Object kind}) => '${kind}を過ぎました · 結果を記録',
      'upcoming.needsUpdate' => '要更新',
      'upcoming.stageChanged' =>
        ({required Object title, required Object stage}) =>
            '「${title}」を${stage}にしました',
      'upcoming.actionLabel' =>
        ({required Object title, required Object stage}) =>
            '${title}を${stage}にする',
      'upcoming.startsAt' => ({required Object time}) => '${time} 開演',
      'upcoming.startsAtVenue' =>
        ({required Object time, required Object venue}) =>
            '${time} 開演 · ${venue}',
      'upcoming.noApplication' => '申込なし',
      'upcoming.notificationsDenied' =>
        '通知が許可されていないため、リマインドは届きません。端末の設定アプリから通知を許可してください。',
      'performance.title' => '公演',
      'performance.newTitle' => '公演を登録',
      'performance.editTitle' => '公演を編集',
      'performance.name' => '公演名',
      'performance.startsAt' => '開始日時',
      'performance.date' => '日付',
      'performance.time' => '開演時刻',
      'performance.venue' => '会場',
      'performance.pick' => '公演を選ぶ',
      'performance.pickOptional' => '公演（任意）',
      'performance.none' => '紐づけない',
      'performance.noPerformances' => '登録済みの公演はありません',
      'performance.createNew' => '新しい公演を登録',
      'performance.applications' => 'チケット申込',
      'performance.noApplications' => 'チケット申込はまだありません',
      'performance.delete' => 'この公演を削除',
      'performance.deleteTitle' => '公演を削除しますか？',
      'performance.deleteBody' =>
        ({
          required Object count,
          required Object amount,
          required Object applications,
        }) =>
            'チケット代・ドリンク代・チェキ代 ${count}件（${amount}）と、チケット申込 ${applications}件も一緒に削除します。グッズ代などは公演との紐づけだけを外します。',
      'performance.titleRequired' => '公演名を入力してください',
      'expense.addTitle' => '支出を追加',
      'expense.editTitle' => '支出を編集',
      'expense.performance' => '公演',
      'expense.paidOn' => '支払日',
      'expense.today' => ({required Object date}) => '今日 ${date}',
      'expense.categoryGroup' => 'カテゴリ',
      'expense.amount' => '金額',
      'expense.unitPrice' => '1枚あたり',
      'expense.keypad' => '数字キー',
      'expense.deleteKey' => '1文字消す',
      'expense.partners' => 'チェキ相手',
      'expense.pickPartners' => '相手を選ぶ',
      'expense.noPartners' => 'チェキ相手を選んでください',
      'expense.increase' => ({required Object name}) => '${name}の枚数を増やす',
      'expense.decrease' => ({required Object name}) => '${name}の枚数を減らす（0枚で外す）',
      'expense.partnerSub' =>
        ({required Object group, required Object amount}) =>
            '${group} · ${amount}',
      'expense.drinkPrefilled' => '前回のドリンク代を入力済み',
      'expense.chekiTotal' =>
        ({required Object amount}) => '合計 ${amount}（相手ごとに1件ずつ記録します）',
      'expense.recordAmount' => ({required Object amount}) => '${amount} を記録',
      'expense.recordCheki' =>
        ({required Object count, required Object amount}) =>
            '${count}件 · ${amount} を記録',
      'expense.enterAmount' => '金額を入力',
      'expense.selectPartnerCta' => '相手を選んでください',
      'expense.selectPerformanceCta' => '公演を選んでください',
      'expense.recordAndContinue' => '続けて記録',
      'expense.recorded' => '記録しました',
      'expense.note' => 'メモ',
      'expense.importedNote' => 'Gmail から取り込み',
      'expense.delete' => 'この支出を削除',
      'expense.shotCount' => '撮影枚数',
      'partner.pickerTitle' => 'チェキ相手を選ぶ',
      'partner.search' => '名前・所属で検索',
      'partner.recent' => '最近撮った相手',
      'partner.noGroup' => '所属なし',
      'partner.searchResults' => '検索結果',
      'partner.notShotYet' => 'まだ撮っていません',
      'partner.lastShot' => ({required Object date}) => '前回 ${date}',
      'partner.edit' => ({required Object name}) => '${name}を編集',
      'partner.deselect' => ({required Object name}) => '${name}の選択を外す',
      'partner.confirm' => ({required Object count}) => '${count}人で決定',
      'partner.selectPrompt' => '相手を選んでください',
      'partner.createNew' => '＋ 新しいチェキ相手を登録',
      'partner.newTitle' => '新しいチェキ相手',
      'partner.name' => '名前',
      'partner.group' => '所属',
      'partner.groupHint' => '任意 · 同じ名前の相手を見分けます',
      'partner.icon' => 'アイコン画像',
      'partner.iconOptional' => 'アイコン画像 · 任意',
      'partner.pickImage' => '画像を選ぶ',
      'partner.changeImage' => '画像を変える',
      'partner.removeImage' => '画像を外す',
      'partner.camera' => '写真を撮る',
      'partner.gallery' => 'ライブラリから選ぶ',
      'partner.iconNote' => '選んだ画像は正方形に切り抜いて、丸く表示します。',
      'partner.iconLocal' => '画像はこの端末の中だけに保存します',
      'partner.createAndSelect' => '登録して選ぶ',
      'partner.editTitle' => 'チェキ相手の編集',
      'partner.records' => '記録',
      'partner.stats' =>
        ({required Object count, required Object shots}) =>
            'チェキ代 ${count}件 · 撮影 ${shots}枚',
      'partner.history' =>
        ({required Object first, required Object last}) =>
            '初めて ${first} · 前回 ${last}',
      'partner.noRecords' => 'チェキ代の記録はまだありません',
      'partner.delete' => 'このチェキ相手を削除',
      'partner.inUse' => 'チェキ代の記録があるため削除できません',
      'partner.nameRequired' => '名前を入力してください',
      'partner.empty' => '登録済みのチェキ相手はいません',
      'application.title' => 'チケット申込',
      'application.performance' => '公演',
      'application.stage' => '申込段階',
      'application.service' => 'チケットサービス',
      'application.referenceNo' => '受付番号',
      'application.referenceHint' => '任意 · Gmail の照合に使います',
      'application.deadlines' => '期限',
      'application.reminded' => 'リマインド対象',
      'application.pickDateTime' => '日時を選ぶ',
      'application.clear' => 'クリア',
      'application.note' => 'メモ',
      'application.delete' => 'このチケット申込を削除',
      'application.imported' => 'Gmail から取り込み',
      'application.overdueApply' => '申込締切を過ぎています。申し込んだら、段階を「結果待ち」にしてください。',
      'application.overdueResult' => '当落発表日時を過ぎています。結果が出たら段階を更新してください。',
      'application.overduePayment' => '入金期限を過ぎています。支払ったら段階を「確保済み」にしてください。',
      'application.willNotify' =>
        ({required Object times}) => '${times} に通知します。',
      'application.noReminder' => 'この段階ではリマインドしません。発券の状況はメモに残せます。',
      'application.noDeadline' =>
        ({required Object kind}) => '${kind}を入れると、期限の前に通知します。',
      'application.reminderOff' =>
        ({required Object kind}) => '${kind}のリマインドは設定でオフになっています。',
      'application.performanceRequired' => '公演を選んでください',
      'application.add' => 'チケット申込を追加',
      'settings.budget' => '推し活代',
      'settings.monthly' => '月額',
      'settings.startMonth' => '開始月',
      'settings.overrides' => '月ごとの上書き',
      'settings.overrideCount' => ({required Object count}) => '${count}件',
      'settings.overrideItem' =>
        ({required Object month, required Object amount}) =>
            '${month} ${amount}',
      'settings.addOverride' => '上書きを追加',
      'settings.overrideMonth' => '上書きする月',
      'settings.overrideAmount' => 'その月の推し活代',
      'settings.removeOverride' => '上書きを解除',
      'settings.noOverrides' => '上書きしている月はありません',
      'settings.budgetUnset' => '未設定',
      'settings.setBudget' => '推し活代を設定する',
      'settings.gmail' => 'Gmail 連携',
      'settings.gmailNotConnected' => '連携していません',
      'settings.connect' => 'Gmail と連携する',
      'settings.reconnect' => 'Gmail に再連携する',
      'settings.reauthTitle' => 'Gmail の認証の期限が切れました。',
      'settings.reauthBody' => '再連携すると、前回の同期以降のメールから取り込みを再開します。',
      'settings.syncFailed' =>
        ({required Object date}) =>
            '前回の同期に失敗しました（${date}）。次の同期で取りこぼした範囲を取り込み直します。',
      'settings.lastSync' => '最終同期',
      'settings.neverSynced' => 'まだ同期していません',
      'settings.services' => '対応サービス',
      'settings.servicesValue' => 'eplus · ライブポケット',
      'settings.autoSync' => '自動同期',
      'settings.autoSyncValue' => '未対応（手動で同期してください）',
      'settings.syncNow' => '今すぐ同期',
      'settings.syncing' => '同期中',
      'settings.synced' => ({required Object count}) => '${count}通を取り込みました',
      'settings.disconnect' => '連携を解除する',
      'settings.disconnectNote' => '解除しても、取り込み済みの公演と支出は残ります。',
      'settings.disconnectTitle' => 'Gmail の連携を解除しますか？',
      'settings.demo' => 'デモデータ',
      'settings.demoNote' => 'OAuth クライアントが未設定のため、モックデータのメールを取り込みます。',
      'settings.reminders' => 'リマインド',
      'settings.permissionGranted' => '通知は許可されています',
      'settings.permissionDenied' => '通知が許可されていません。端末の設定アプリから許可してください。',
      'settings.permissionUnknown' => '初めて期限を登録したときに、通知の許可を求めます',
      'settings.display' => '表示',
      'settings.showAmounts' => '金額を表示する',
      'settings.showAmountsNote' =>
        'オフにすると、カレンダーとリストの金額を「•••」で隠します。各画面の目のボタンでも、その場で切り替えられます。今後の公演と通知には金額を表示しません。',
      'settings.theme' => 'テーマ',
      'settings.themeSystem' => '端末に合わせる',
      'settings.themeLight' => 'ライト',
      'settings.themeDark' => 'ダーク',
      'settings.language' => '言語',
      'settings.languageJapanese' => '日本語',
      'settings.languageEnglish' => 'English',
      'settings.defaultBasis' => '計上基準の初期値',
      'settings.defaultBasisNote' =>
        'カレンダーとリストで支出をどの日に置くかの初期値です。残高は常に支払日で計算します。',
      'settings.reminderApplyWhen' => '前日 20:00 と3時間前',
      'settings.reminderResultWhen' => '発表の時刻',
      'settings.reminderPaymentWhen' => '前日 20:00 と3時間前',
      'settings.overrideSaved' => '上書きを保存しました',
      'settings.budgetSaved' => '推し活代を保存しました',
      'settings.gmailAccount' => '連携中のアカウント',
      'settings.gmailFailedAt' => '同期の失敗',
      'onboarding.welcomeTitle' => '推し活のお金と予定を、ひとつのアプリで。',
      'onboarding.welcomeBody' => '決めた予算の中で、安心して推し活を楽しむためのアプリです。',
      'onboarding.featureBudgetTitle' => '毎月の推し活代で予算を立てる',
      'onboarding.featureBudgetBody' => '使わなかった分も、使いすぎた分も翌月へ繰り越します。',
      'onboarding.featureRecordTitle' => '会場ですぐ記録',
      'onboarding.featureRecordBody' => 'ドリンク代は前回の金額で、チェキ代は相手を選んで枚数を入れるだけ。',
      'onboarding.featureReminderTitle' => 'チケットの期限を逃さない',
      'onboarding.featureReminderBody' => '抽選の申込締切・当落発表・入金期限を通知でお知らせします。',
      'onboarding.privacy' => 'データはこの端末の中だけに保存します。登録やログインは要りません。',
      'onboarding.start' => 'はじめる',
      'onboarding.budgetStep' => '1 / 2',
      'onboarding.budgetTitle' => '毎月の推し活代を決めましょう',
      'onboarding.budgetBody' =>
        '推し活に使ってよい1ヶ月あたりの予算です。毎月残高に加わり、使わなかった分もマイナスの分も翌月へ繰り越します。',
      'onboarding.budgetStartNote' => '開始月より前の支出は一覧に表示しますが、残高には含めません。',
      'onboarding.budgetCta' =>
        ({required Object month, required Object amount}) =>
            '${month}から毎月 ${amount} で設定',
      'onboarding.budgetLater' => '推し活代は設定画面からいつでも変更できます',
      'onboarding.gmailStep' => '2 / 2 · 任意',
      'onboarding.gmailTitle' => 'チケットのメールから自動で記録',
      'onboarding.gmailBody' =>
        'Gmail と連携すると、チケットの購入や抽選のメールを読み取り、チケット代とチケット申込を自動で登録します。',
      'onboarding.gmailScope' =>
        '読むのは eplus・ライブポケットのチケットのメールだけ。メールの送信や削除はしません。',
      'onboarding.gmailPrivacy' => 'メールの本文は保存せず、読み取った内容はこの端末の中だけに置きます。',
      'onboarding.gmailBackfill' => '連携すると、3ヶ月前までのメールをさかのぼって取り込みます。',
      'onboarding.gmailConnected' =>
        ({required Object email}) => '${email} と連携しました。取り込みはバックグラウンドで続きます。',
      'onboarding.gmailLater' => 'あとで連携する',
      'onboarding.gmailLaterNote' => '連携と解除は設定画面からいつでもできます',
      'onboarding.sampleSubject' => '決済に関するご案内',
      'onboarding.sampleAuto' => '自動',
      'reminder.channelName' => 'チケット申込のリマインド',
      'reminder.channelDescription' => '申込締切・当落発表・入金期限をお知らせします',
      'reminder.applyEve' => ({required Object time}) => '明日 ${time} が申込締切です',
      'reminder.applySoon' =>
        ({required Object time}) => '申込締切まであと3時間（${time}）',
      'reminder.resultAt' =>
        ({required Object dateTime}) => '当落発表の時刻です（${dateTime}）。結果を記録しましょう',
      'reminder.paymentEve' => ({required Object time}) => '明日 ${time} が入金期限です',
      'reminder.paymentSoon' =>
        ({required Object time}) => '入金期限まであと3時間（${time}）',
      'errors.unexpected' => '予期しないエラーが発生しました。もう一度お試しください。',
      'errors.settingsWrite' => '設定を保存できませんでした。もう一度お試しください。',
      'errors.recordStorage' => '記録を保存できませんでした。もう一度お試しください。',
      'errors.invalidInput' => '入力内容を確認してください。',
      'errors.partnerInUse' => 'チェキ代の記録があるため削除できません。',
      'errors.partnerIcon' => '画像を読み込めませんでした。',
      'errors.gmailReauthRequired' => 'Gmail の再連携が必要です。',
      'errors.gmailSync' => 'Gmail と同期できませんでした。時間をおいてもう一度お試しください。',
      'errors.reminderSchedule' => '通知を予約できませんでした。',
      _ => null,
    };
  }
}
