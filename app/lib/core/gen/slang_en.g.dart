///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'slang.g.dart';

// Path: <root>
class TranslationsEn
    with BaseTranslations<AppLocale, Translations>
    implements Translations {
  /// You can call this constructor and build your own translation instance of this locale.
  /// Constructing via the enum [AppLocale.build] is preferred.
  TranslationsEn({
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
             locale: AppLocale.en,
             overrides: overrides ?? {},
             cardinalResolver: cardinalResolver,
             ordinalResolver: ordinalResolver,
           ) {
    $meta.setFlatMapFunction(_flatMapFunction);
  }

  /// Metadata for the translations of <en>.
  @override
  final TranslationMetadata<AppLocale, Translations> $meta;

  /// Access flat map
  @override
  dynamic operator [](String key) => $meta.getTranslation(key);

  late final TranslationsEn _root = this; // ignore: unused_field

  @override
  TranslationsEn $copyWith({
    TranslationMetadata<AppLocale, Translations>? meta,
  }) => TranslationsEn(meta: meta ?? this.$meta);

  // Translations
  @override
  String get appName => 'Kakin';
  @override
  String get bootstrapFailed => 'The app could not start. Please try again.';
  @override
  String get retry => 'Retry';
  @override
  late final _TranslationsCommonEn common = _TranslationsCommonEn._(_root);
  @override
  late final _TranslationsFormatEn format = _TranslationsFormatEn._(_root);
  @override
  late final _TranslationsTabsEn tabs = _TranslationsTabsEn._(_root);
  @override
  late final _TranslationsCategoryEn category = _TranslationsCategoryEn._(
    _root,
  );
  @override
  late final _TranslationsCategoryShortEn categoryShort =
      _TranslationsCategoryShortEn._(_root);
  @override
  late final _TranslationsStageEn stage = _TranslationsStageEn._(_root);
  @override
  late final _TranslationsServiceEn service = _TranslationsServiceEn._(_root);
  @override
  late final _TranslationsDeadlineEn deadline = _TranslationsDeadlineEn._(
    _root,
  );
  @override
  late final _TranslationsQuickActionEn quickAction =
      _TranslationsQuickActionEn._(_root);
  @override
  late final _TranslationsBasisEn basis = _TranslationsBasisEn._(_root);
  @override
  late final _TranslationsSummaryEn summary = _TranslationsSummaryEn._(_root);
  @override
  late final _TranslationsCalendarEn calendar = _TranslationsCalendarEn._(
    _root,
  );
  @override
  late final _TranslationsListEn list = _TranslationsListEn._(_root);
  @override
  late final _TranslationsUpcomingEn upcoming = _TranslationsUpcomingEn._(
    _root,
  );
  @override
  late final _TranslationsPerformanceEn performance =
      _TranslationsPerformanceEn._(_root);
  @override
  late final _TranslationsExpenseEn expense = _TranslationsExpenseEn._(_root);
  @override
  late final _TranslationsPartnerEn partner = _TranslationsPartnerEn._(_root);
  @override
  late final _TranslationsApplicationEn application =
      _TranslationsApplicationEn._(_root);
  @override
  late final _TranslationsSettingsEn settings = _TranslationsSettingsEn._(
    _root,
  );
  @override
  late final _TranslationsOnboardingEn onboarding = _TranslationsOnboardingEn._(
    _root,
  );
  @override
  late final _TranslationsReminderEn reminder = _TranslationsReminderEn._(
    _root,
  );
  @override
  late final _TranslationsErrorsEn errors = _TranslationsErrorsEn._(_root);
}

// Path: common
class _TranslationsCommonEn implements TranslationsCommonJa {
  _TranslationsCommonEn._(this._root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get save => 'Save';
  @override
  String get cancel => 'Cancel';
  @override
  String get delete => 'Delete';
  @override
  String get close => 'Close';
  @override
  String get back => 'Back';
  @override
  String get undo => 'Undo';
  @override
  String get optional => 'Optional';
  @override
  String get skip => 'Set up later';
  @override
  String get next => 'Next';
  @override
  String get today => 'Today';
  @override
  String get notSet => 'Not set';
  @override
  String get saving => 'Saving';
  @override
  String get deleteConfirmTitle => 'Delete this?';
  @override
  String get deleteConfirmBody => 'This can\'t be undone.';
}

// Path: format
class _TranslationsFormatEn implements TranslationsFormatJa {
  _TranslationsFormatEn._(this._root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  List<String> get weekdays => [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];
  @override
  List<String> get monthNames => [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  @override
  String yearMonth({required Object monthName, required Object year}) =>
      '${monthName} ${year}';
  @override
  String monthDay({
    required Object weekday,
    required Object month,
    required Object day,
  }) => '${weekday} ${month}/${day}';
  @override
  String dayTitle({
    required Object weekday,
    required Object monthName,
    required Object day,
  }) => '${weekday}, ${monthName} ${day}';
  @override
  String fullDate({
    required Object weekday,
    required Object year,
    required Object month,
    required Object day,
  }) => '${weekday} ${year}/${month}/${day}';
  @override
  String dateTime({required Object date, required Object time}) =>
      '${date} ${time}';
  @override
  String yen({required Object amount}) => '¥${amount}';
  @override
  String negativeYen({required Object amount}) => '−¥${amount}';
  @override
  String get hiddenYen => '¥•••';
  @override
  String get hiddenNumber => '•••';
  @override
  String daysLeft({required Object days}) => 'In ${days} days';
  @override
  String shots({required Object count}) => '${count} shots';
  @override
  String people({required Object count}) => '${count}';
  @override
  String count({required Object count}) => '${count}';
}

// Path: tabs
class _TranslationsTabsEn implements TranslationsTabsJa {
  _TranslationsTabsEn._(this._root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get calendar => 'Calendar';
  @override
  String get list => 'List';
  @override
  String get upcoming => 'Upcoming';
  @override
  String get settings => 'Settings';
}

// Path: category
class _TranslationsCategoryEn implements TranslationsCategoryJa {
  _TranslationsCategoryEn._(this._root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get ticket => 'Ticket';
  @override
  String get drink => 'Drink';
  @override
  String get cheki => 'Cheki';
  @override
  String get goods => 'Merch';
  @override
  String get transport => 'Transport';
  @override
  String get locker => 'Locker';
  @override
  String get other => 'Other';
}

// Path: categoryShort
class _TranslationsCategoryShortEn implements TranslationsCategoryShortJa {
  _TranslationsCategoryShortEn._(this._root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get ticket => 'Ticket';
  @override
  String get drink => 'Drink';
  @override
  String get cheki => 'Cheki';
  @override
  String get goods => 'Merch';
  @override
  String get transport => 'Travel';
  @override
  String get locker => 'Locker';
  @override
  String get other => 'Other';
}

// Path: stage
class _TranslationsStageEn implements TranslationsStageJa {
  _TranslationsStageEn._(this._root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get planned => 'Planned';
  @override
  String get awaitingResult => 'Awaiting result';
  @override
  String get awaitingPayment => 'Awaiting payment';
  @override
  String get secured => 'Secured';
  @override
  String get lost => 'Not won';
}

// Path: service
class _TranslationsServiceEn implements TranslationsServiceJa {
  _TranslationsServiceEn._(this._root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get eplus => 'eplus';
  @override
  String get livepocket => 'LivePocket';
  @override
  String get other => 'Other';
}

// Path: deadline
class _TranslationsDeadlineEn implements TranslationsDeadlineJa {
  _TranslationsDeadlineEn._(this._root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get apply => 'Application deadline';
  @override
  String get result => 'Result announcement';
  @override
  String get payment => 'Payment deadline';
  @override
  String get resultShort => 'Result';
}

// Path: quickAction
class _TranslationsQuickActionEn implements TranslationsQuickActionJa {
  _TranslationsQuickActionEn._(this._root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get applied => 'Applied';
  @override
  String get won => 'Won';
  @override
  String get lost => 'Not won';
  @override
  String get paid => 'Paid';
}

// Path: basis
class _TranslationsBasisEn implements TranslationsBasisJa {
  _TranslationsBasisEn._(this._root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get label => 'Accounting basis';
  @override
  String get paidOn => 'Paid date';
  @override
  String get performanceDate => 'Show date';
}

// Path: summary
class _TranslationsSummaryEn implements TranslationsSummaryJa {
  _TranslationsSummaryEn._(this._root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get label => 'This month';
  @override
  String get balance => 'Balance';
  @override
  String get budget => 'Budget';
  @override
  String get carryover => 'Carried over';
  @override
  String get spend => 'Spent';
  @override
  String get spendByPerformanceDate => 'Spent (show date)';
  @override
  String get negativeNote => 'The shortfall carries over to next month';
  @override
  String get overBudget => 'Over budget';
  @override
  String get withinBudget => 'Within budget';
  @override
  String get hiddenNote => 'Amounts hidden · overspend carries over';
  @override
  String get performanceBasisNote =>
      'Spending is grouped by show date. The balance always uses the paid date.';
  @override
  String get unconfigured =>
      'Set a monthly budget to see your balance and carry-over';
  @override
  String get beforeStart =>
      'This month is before your budget starts and isn\'t counted';
  @override
  String get showAmounts => 'Show amounts';
  @override
  String get hideAmounts => 'Hide amounts';
}

// Path: calendar
class _TranslationsCalendarEn implements TranslationsCalendarJa {
  _TranslationsCalendarEn._(this._root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get previousMonth => 'Previous month';
  @override
  String get nextMonth => 'Next month';
  @override
  String get noRecords => 'Nothing recorded on this day';
  @override
  String get addExpense => 'Add expense';
  @override
  String dayLabel({required Object date}) => '${date}';
  @override
  String daySpend({required Object amount}) => 'spent ${amount}';
  @override
  String get daySpendHidden => 'has expenses';
  @override
  String get dayHasPerformance => 'has a show';
  @override
  String performanceMeta({required Object time}) => 'Starts ${time}';
  @override
  String performanceMetaVenue({required Object time, required Object venue}) =>
      'Starts ${time} · ${venue}';
  @override
  String get gmailBadge => 'Gmail';
  @override
  String get duplicateBadge => 'Duplicate?';
}

// Path: list
class _TranslationsListEn implements TranslationsListJa {
  _TranslationsListEn._(this._root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get all => 'All';
  @override
  String get emptyCategory => 'No expenses in this category';
  @override
  String get emptyMonth => 'No expenses this month';
  @override
  String performanceOn({required Object date}) => 'Show ${date}';
  @override
  String get overspent => 'Over';
  @override
  String get filterLabel => 'Filter by category';
}

// Path: upcoming
class _TranslationsUpcomingEn implements TranslationsUpcomingJa {
  _TranslationsUpcomingEn._(this._root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get addApplication => 'Add application';
  @override
  String get todo => 'To do';
  @override
  String get todoOrder => 'Soonest first';
  @override
  String get noTodo => 'No ticket deadlines coming up.';
  @override
  String get performances => 'Shows';
  @override
  String get noPerformances =>
      'No upcoming shows yet. Record a ticket or a ticket application to see it here.';
  @override
  String overdue({required Object kind}) =>
      '${kind} passed · record the result';
  @override
  String get needsUpdate => 'Update';
  @override
  String stageChanged({required Object title, required Object stage}) =>
      'Moved “${title}” to ${stage}';
  @override
  String actionLabel({required Object title, required Object stage}) =>
      'Move ${title} to ${stage}';
  @override
  String startsAt({required Object time}) => 'Starts ${time}';
  @override
  String startsAtVenue({required Object time, required Object venue}) =>
      'Starts ${time} · ${venue}';
  @override
  String get noApplication => 'No application';
  @override
  String get notificationsDenied =>
      'Notifications are off, so reminders won\'t arrive. Allow notifications in the Settings app.';
}

// Path: performance
class _TranslationsPerformanceEn implements TranslationsPerformanceJa {
  _TranslationsPerformanceEn._(this._root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Show';
  @override
  String get newTitle => 'New show';
  @override
  String get editTitle => 'Edit show';
  @override
  String get name => 'Show name';
  @override
  String get startsAt => 'Starts at';
  @override
  String get date => 'Date';
  @override
  String get time => 'Start time';
  @override
  String get venue => 'Venue';
  @override
  String get pick => 'Choose a show';
  @override
  String get pickOptional => 'Show (optional)';
  @override
  String get none => 'No show';
  @override
  String get noPerformances => 'No shows yet';
  @override
  String get createNew => 'Add a new show';
  @override
  String get applications => 'Ticket applications';
  @override
  String get noApplications => 'No ticket applications yet';
  @override
  String get delete => 'Delete this show';
  @override
  String get deleteTitle => 'Delete this show?';
  @override
  String deleteBody({
    required Object count,
    required Object amount,
    required Object applications,
  }) =>
      'This also deletes ${count} ticket, drink and cheki expenses (${amount}) and ${applications} ticket applications. Merch and other expenses stay, without the show.';
  @override
  String get titleRequired => 'Enter a show name';
}

// Path: expense
class _TranslationsExpenseEn implements TranslationsExpenseJa {
  _TranslationsExpenseEn._(this._root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get addTitle => 'Add expense';
  @override
  String get editTitle => 'Edit expense';
  @override
  String get performance => 'Show';
  @override
  String get paidOn => 'Paid on';
  @override
  String today({required Object date}) => 'Today ${date}';
  @override
  String get categoryGroup => 'Category';
  @override
  String get amount => 'Amount';
  @override
  String get unitPrice => 'Per shot';
  @override
  String get keypad => 'Number keys';
  @override
  String get deleteKey => 'Delete one digit';
  @override
  String get partners => 'Cheki partners';
  @override
  String get pickPartners => 'Choose';
  @override
  String get noPartners => 'Choose who you shot with';
  @override
  String increase({required Object name}) => 'Add a shot with ${name}';
  @override
  String decrease({required Object name}) =>
      'Remove a shot with ${name} (0 removes them)';
  @override
  String partnerSub({required Object group, required Object amount}) =>
      '${group} · ${amount}';
  @override
  String get drinkPrefilled => 'Filled in with your last drink price';
  @override
  String chekiTotal({required Object amount}) =>
      'Total ${amount} (one record per partner)';
  @override
  String recordAmount({required Object amount}) => 'Record ${amount}';
  @override
  String recordCheki({required Object count, required Object amount}) =>
      'Record ${count} · ${amount}';
  @override
  String get enterAmount => 'Enter an amount';
  @override
  String get selectPartnerCta => 'Choose a partner';
  @override
  String get selectPerformanceCta => 'Choose a show';
  @override
  String get recordAndContinue => 'Record another';
  @override
  String get recorded => 'Recorded';
  @override
  String get note => 'Note';
  @override
  String get importedNote => 'Imported from Gmail';
  @override
  String get delete => 'Delete this expense';
  @override
  String get shotCount => 'Shots';
}

// Path: partner
class _TranslationsPartnerEn implements TranslationsPartnerJa {
  _TranslationsPartnerEn._(this._root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get pickerTitle => 'Choose cheki partners';
  @override
  String get search => 'Search by name or group';
  @override
  String get recent => 'Recently shot';
  @override
  String get noGroup => 'No group';
  @override
  String get searchResults => 'Results';
  @override
  String get notShotYet => 'No shots yet';
  @override
  String lastShot({required Object date}) => 'Last ${date}';
  @override
  String edit({required Object name}) => 'Edit ${name}';
  @override
  String deselect({required Object name}) => 'Deselect ${name}';
  @override
  String confirm({required Object count}) => 'Choose ${count}';
  @override
  String get selectPrompt => 'Choose a partner';
  @override
  String get createNew => '+ Add a new cheki partner';
  @override
  String get newTitle => 'New cheki partner';
  @override
  String get name => 'Name';
  @override
  String get group => 'Group';
  @override
  String get groupHint => 'Optional · tells people with the same name apart';
  @override
  String get icon => 'Icon';
  @override
  String get iconOptional => 'Icon · optional';
  @override
  String get pickImage => 'Choose image';
  @override
  String get changeImage => 'Change image';
  @override
  String get removeImage => 'Remove image';
  @override
  String get camera => 'Take a photo';
  @override
  String get gallery => 'Choose from library';
  @override
  String get iconNote =>
      'The image is cropped to a square and shown as a circle.';
  @override
  String get iconLocal => 'Images are stored only on this device';
  @override
  String get createAndSelect => 'Add and choose';
  @override
  String get editTitle => 'Edit cheki partner';
  @override
  String get records => 'Records';
  @override
  String stats({required Object count, required Object shots}) =>
      '${count} cheki records · ${shots} shots';
  @override
  String history({required Object first, required Object last}) =>
      'First ${first} · last ${last}';
  @override
  String get noRecords => 'No cheki records yet';
  @override
  String get delete => 'Delete this partner';
  @override
  String get inUse => 'Partners with cheki records can\'t be deleted';
  @override
  String get nameRequired => 'Enter a name';
  @override
  String get empty => 'No cheki partners yet';
}

// Path: application
class _TranslationsApplicationEn implements TranslationsApplicationJa {
  _TranslationsApplicationEn._(this._root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Ticket application';
  @override
  String get performance => 'Show';
  @override
  String get stage => 'Stage';
  @override
  String get service => 'Ticket service';
  @override
  String get referenceNo => 'Reference number';
  @override
  String get referenceHint => 'Optional · used to match Gmail';
  @override
  String get deadlines => 'Deadlines';
  @override
  String get reminded => 'Reminder on';
  @override
  String get pickDateTime => 'Choose date and time';
  @override
  String get clear => 'Clear';
  @override
  String get note => 'Note';
  @override
  String get delete => 'Delete this application';
  @override
  String get imported => 'Imported from Gmail';
  @override
  String get overdueApply =>
      'The application deadline has passed. Once you\'ve applied, move it to “Awaiting result”.';
  @override
  String get overdueResult =>
      'The result announcement has passed. Update the stage once you know the result.';
  @override
  String get overduePayment =>
      'The payment deadline has passed. Once you\'ve paid, move it to “Secured”.';
  @override
  String willNotify({required Object times}) =>
      'You\'ll be notified at ${times}.';
  @override
  String get noReminder =>
      'No reminders at this stage. You can note ticket issuing in the memo.';
  @override
  String noDeadline({required Object kind}) =>
      'Add the ${kind} to get a reminder before it.';
  @override
  String reminderOff({required Object kind}) =>
      'Reminders for the ${kind} are turned off in Settings.';
  @override
  String get performanceRequired => 'Choose a show';
  @override
  String get add => 'Add ticket application';
}

// Path: settings
class _TranslationsSettingsEn implements TranslationsSettingsJa {
  _TranslationsSettingsEn._(this._root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get budget => 'Monthly budget';
  @override
  String get monthly => 'Per month';
  @override
  String get startMonth => 'Starts';
  @override
  String get overrides => 'Monthly overrides';
  @override
  String overrideCount({required Object count}) => '${count}';
  @override
  String overrideItem({required Object month, required Object amount}) =>
      '${month} ${amount}';
  @override
  String get addOverride => 'Add override';
  @override
  String get overrideMonth => 'Month';
  @override
  String get overrideAmount => 'Budget for that month';
  @override
  String get removeOverride => 'Remove override';
  @override
  String get noOverrides => 'No overridden months';
  @override
  String get budgetUnset => 'Not set';
  @override
  String get setBudget => 'Set monthly budget';
  @override
  String get gmail => 'Gmail';
  @override
  String get gmailNotConnected => 'Not connected';
  @override
  String get connect => 'Connect Gmail';
  @override
  String get reconnect => 'Reconnect Gmail';
  @override
  String get reauthTitle => 'Your Gmail sign-in has expired.';
  @override
  String get reauthBody => 'Reconnect to resume importing from your last sync.';
  @override
  String syncFailed({required Object date}) =>
      'The last sync failed (${date}). The next sync will pick up what was missed.';
  @override
  String get lastSync => 'Last sync';
  @override
  String get neverSynced => 'Not synced yet';
  @override
  String get services => 'Services';
  @override
  String get servicesValue => 'eplus · LivePocket';
  @override
  String get autoSync => 'Auto sync';
  @override
  String get autoSyncValue => 'Not supported yet (sync manually)';
  @override
  String get syncNow => 'Sync now';
  @override
  String get syncing => 'Syncing';
  @override
  String synced({required Object count}) => 'Imported ${count} emails';
  @override
  String get disconnect => 'Disconnect';
  @override
  String get disconnectNote =>
      'Imported shows and expenses stay after you disconnect.';
  @override
  String get disconnectTitle => 'Disconnect Gmail?';
  @override
  String get demo => 'Demo data';
  @override
  String get demoNote =>
      'No OAuth client is configured, so mock emails are imported.';
  @override
  String get reminders => 'Reminders';
  @override
  String get permissionGranted => 'Notifications are allowed';
  @override
  String get permissionDenied =>
      'Notifications aren\'t allowed. Allow them in the Settings app.';
  @override
  String get permissionUnknown =>
      'You\'ll be asked to allow notifications when you first add a deadline';
  @override
  String get display => 'Display';
  @override
  String get showAmounts => 'Show amounts';
  @override
  String get showAmountsNote =>
      'When off, amounts in the calendar and list show as “•••”. The eye button on each screen toggles it too. Upcoming shows and notifications never show amounts.';
  @override
  String get theme => 'Theme';
  @override
  String get themeSystem => 'System';
  @override
  String get themeLight => 'Light';
  @override
  String get themeDark => 'Dark';
  @override
  String get language => 'Language';
  @override
  String get languageJapanese => '日本語';
  @override
  String get languageEnglish => 'English';
  @override
  String get defaultBasis => 'Default accounting basis';
  @override
  String get defaultBasisNote =>
      'Which day the calendar and list place expenses on by default. The balance always uses the paid date.';
  @override
  String get reminderApplyWhen => '8:00 PM the day before and 3 hours before';
  @override
  String get reminderResultWhen => 'At the announcement time';
  @override
  String get reminderPaymentWhen => '8:00 PM the day before and 3 hours before';
  @override
  String get overrideSaved => 'Override saved';
  @override
  String get budgetSaved => 'Budget saved';
  @override
  String get gmailAccount => 'Connected account';
  @override
  String get gmailFailedAt => 'Sync failure';
}

// Path: onboarding
class _TranslationsOnboardingEn implements TranslationsOnboardingJa {
  _TranslationsOnboardingEn._(this._root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get welcomeTitle => 'Your fan spending and plans, in one app.';
  @override
  String get welcomeBody =>
      'Enjoy supporting your favorites within the budget you set.';
  @override
  String get featureBudgetTitle => 'Budget with a monthly allowance';
  @override
  String get featureBudgetBody =>
      'Leftovers and overspending both carry over to next month.';
  @override
  String get featureRecordTitle => 'Record right at the venue';
  @override
  String get featureRecordBody =>
      'Drinks reuse your last price; for cheki, just pick who and how many.';
  @override
  String get featureReminderTitle => 'Never miss a ticket deadline';
  @override
  String get featureReminderBody =>
      'Get notified about lottery deadlines, results and payment due dates.';
  @override
  String get privacy =>
      'Your data stays on this device. No sign-up or login needed.';
  @override
  String get start => 'Get started';
  @override
  String get budgetStep => '1 / 2';
  @override
  String get budgetTitle => 'Set your monthly budget';
  @override
  String get budgetBody =>
      'How much you can spend on your favorites each month. It\'s added to your balance monthly, and leftovers or overspending carry over.';
  @override
  String get budgetStartNote =>
      'Expenses before the start month are listed but not counted in the balance.';
  @override
  String budgetCta({required Object amount, required Object month}) =>
      '${amount} a month from ${month}';
  @override
  String get budgetLater => 'You can change the budget in Settings anytime';
  @override
  String get gmailStep => '2 / 2 · Optional';
  @override
  String get gmailTitle => 'Record tickets from your email';
  @override
  String get gmailBody =>
      'Connect Gmail to read ticket purchase and lottery emails and record tickets and applications automatically.';
  @override
  String get gmailScope =>
      'Only eplus and LivePocket ticket emails are read. Nothing is sent or deleted.';
  @override
  String get gmailPrivacy =>
      'Email bodies aren\'t stored; what\'s read stays on this device.';
  @override
  String get gmailBackfill =>
      'After connecting, emails from the past 3 months are imported.';
  @override
  String gmailConnected({required Object email}) =>
      'Connected to ${email}. Importing continues in the background.';
  @override
  String get gmailLater => 'Connect later';
  @override
  String get gmailLaterNote =>
      'You can connect or disconnect in Settings anytime';
  @override
  String get sampleSubject => 'Payment confirmation';
  @override
  String get sampleAuto => 'Auto';
}

// Path: reminder
class _TranslationsReminderEn implements TranslationsReminderJa {
  _TranslationsReminderEn._(this._root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get channelName => 'Ticket reminders';
  @override
  String get channelDescription =>
      'Application deadlines, results and payment due dates';
  @override
  String applyEve({required Object time}) =>
      'The application deadline is tomorrow at ${time}';
  @override
  String applySoon({required Object time}) =>
      '3 hours until the application deadline (${time})';
  @override
  String resultAt({required Object dateTime}) =>
      'Results are out (${dateTime}). Record how it went';
  @override
  String paymentEve({required Object time}) =>
      'Payment is due tomorrow at ${time}';
  @override
  String paymentSoon({required Object time}) =>
      '3 hours until payment is due (${time})';
}

// Path: errors
class _TranslationsErrorsEn implements TranslationsErrorsJa {
  _TranslationsErrorsEn._(this._root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get unexpected => 'Something went wrong. Please try again.';
  @override
  String get settingsWrite => 'Could not save settings. Please try again.';
  @override
  String get recordStorage => 'Could not save the record. Please try again.';
  @override
  String get invalidInput => 'Please check your input.';
  @override
  String get partnerInUse => 'Partners with cheki records can\'t be deleted.';
  @override
  String get partnerIcon => 'Couldn\'t load the image.';
  @override
  String get gmailReauthRequired => 'Please reconnect Gmail.';
  @override
  String get gmailSync => 'Couldn\'t sync with Gmail. Please try again later.';
  @override
  String get reminderSchedule => 'Couldn\'t schedule notifications.';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsEn {
  dynamic _flatMapFunction(String path) {
    return switch (path) {
      'appName' => 'Kakin',
      'bootstrapFailed' => 'The app could not start. Please try again.',
      'retry' => 'Retry',
      'common.save' => 'Save',
      'common.cancel' => 'Cancel',
      'common.delete' => 'Delete',
      'common.close' => 'Close',
      'common.back' => 'Back',
      'common.undo' => 'Undo',
      'common.optional' => 'Optional',
      'common.skip' => 'Set up later',
      'common.next' => 'Next',
      'common.today' => 'Today',
      'common.notSet' => 'Not set',
      'common.saving' => 'Saving',
      'common.deleteConfirmTitle' => 'Delete this?',
      'common.deleteConfirmBody' => 'This can\'t be undone.',
      'format.weekdays.0' => 'Mon',
      'format.weekdays.1' => 'Tue',
      'format.weekdays.2' => 'Wed',
      'format.weekdays.3' => 'Thu',
      'format.weekdays.4' => 'Fri',
      'format.weekdays.5' => 'Sat',
      'format.weekdays.6' => 'Sun',
      'format.monthNames.0' => 'January',
      'format.monthNames.1' => 'February',
      'format.monthNames.2' => 'March',
      'format.monthNames.3' => 'April',
      'format.monthNames.4' => 'May',
      'format.monthNames.5' => 'June',
      'format.monthNames.6' => 'July',
      'format.monthNames.7' => 'August',
      'format.monthNames.8' => 'September',
      'format.monthNames.9' => 'October',
      'format.monthNames.10' => 'November',
      'format.monthNames.11' => 'December',
      'format.yearMonth' =>
        ({required Object monthName, required Object year}) =>
            '${monthName} ${year}',
      'format.monthDay' =>
        ({
          required Object weekday,
          required Object month,
          required Object day,
        }) => '${weekday} ${month}/${day}',
      'format.dayTitle' =>
        ({
          required Object weekday,
          required Object monthName,
          required Object day,
        }) => '${weekday}, ${monthName} ${day}',
      'format.fullDate' =>
        ({
          required Object weekday,
          required Object year,
          required Object month,
          required Object day,
        }) => '${weekday} ${year}/${month}/${day}',
      'format.dateTime' =>
        ({required Object date, required Object time}) => '${date} ${time}',
      'format.yen' => ({required Object amount}) => '¥${amount}',
      'format.negativeYen' => ({required Object amount}) => '−¥${amount}',
      'format.hiddenYen' => '¥•••',
      'format.hiddenNumber' => '•••',
      'format.daysLeft' => ({required Object days}) => 'In ${days} days',
      'format.shots' => ({required Object count}) => '${count} shots',
      'format.people' => ({required Object count}) => '${count}',
      'format.count' => ({required Object count}) => '${count}',
      'tabs.calendar' => 'Calendar',
      'tabs.list' => 'List',
      'tabs.upcoming' => 'Upcoming',
      'tabs.settings' => 'Settings',
      'category.ticket' => 'Ticket',
      'category.drink' => 'Drink',
      'category.cheki' => 'Cheki',
      'category.goods' => 'Merch',
      'category.transport' => 'Transport',
      'category.locker' => 'Locker',
      'category.other' => 'Other',
      'categoryShort.ticket' => 'Ticket',
      'categoryShort.drink' => 'Drink',
      'categoryShort.cheki' => 'Cheki',
      'categoryShort.goods' => 'Merch',
      'categoryShort.transport' => 'Travel',
      'categoryShort.locker' => 'Locker',
      'categoryShort.other' => 'Other',
      'stage.planned' => 'Planned',
      'stage.awaitingResult' => 'Awaiting result',
      'stage.awaitingPayment' => 'Awaiting payment',
      'stage.secured' => 'Secured',
      'stage.lost' => 'Not won',
      'service.eplus' => 'eplus',
      'service.livepocket' => 'LivePocket',
      'service.other' => 'Other',
      'deadline.apply' => 'Application deadline',
      'deadline.result' => 'Result announcement',
      'deadline.payment' => 'Payment deadline',
      'deadline.resultShort' => 'Result',
      'quickAction.applied' => 'Applied',
      'quickAction.won' => 'Won',
      'quickAction.lost' => 'Not won',
      'quickAction.paid' => 'Paid',
      'basis.label' => 'Accounting basis',
      'basis.paidOn' => 'Paid date',
      'basis.performanceDate' => 'Show date',
      'summary.label' => 'This month',
      'summary.balance' => 'Balance',
      'summary.budget' => 'Budget',
      'summary.carryover' => 'Carried over',
      'summary.spend' => 'Spent',
      'summary.spendByPerformanceDate' => 'Spent (show date)',
      'summary.negativeNote' => 'The shortfall carries over to next month',
      'summary.overBudget' => 'Over budget',
      'summary.withinBudget' => 'Within budget',
      'summary.hiddenNote' => 'Amounts hidden · overspend carries over',
      'summary.performanceBasisNote' =>
        'Spending is grouped by show date. The balance always uses the paid date.',
      'summary.unconfigured' =>
        'Set a monthly budget to see your balance and carry-over',
      'summary.beforeStart' =>
        'This month is before your budget starts and isn\'t counted',
      'summary.showAmounts' => 'Show amounts',
      'summary.hideAmounts' => 'Hide amounts',
      'calendar.previousMonth' => 'Previous month',
      'calendar.nextMonth' => 'Next month',
      'calendar.noRecords' => 'Nothing recorded on this day',
      'calendar.addExpense' => 'Add expense',
      'calendar.dayLabel' => ({required Object date}) => '${date}',
      'calendar.daySpend' => ({required Object amount}) => 'spent ${amount}',
      'calendar.daySpendHidden' => 'has expenses',
      'calendar.dayHasPerformance' => 'has a show',
      'calendar.performanceMeta' =>
        ({required Object time}) => 'Starts ${time}',
      'calendar.performanceMetaVenue' =>
        ({required Object time, required Object venue}) =>
            'Starts ${time} · ${venue}',
      'calendar.gmailBadge' => 'Gmail',
      'calendar.duplicateBadge' => 'Duplicate?',
      'list.all' => 'All',
      'list.emptyCategory' => 'No expenses in this category',
      'list.emptyMonth' => 'No expenses this month',
      'list.performanceOn' => ({required Object date}) => 'Show ${date}',
      'list.overspent' => 'Over',
      'list.filterLabel' => 'Filter by category',
      'upcoming.addApplication' => 'Add application',
      'upcoming.todo' => 'To do',
      'upcoming.todoOrder' => 'Soonest first',
      'upcoming.noTodo' => 'No ticket deadlines coming up.',
      'upcoming.performances' => 'Shows',
      'upcoming.noPerformances' =>
        'No upcoming shows yet. Record a ticket or a ticket application to see it here.',
      'upcoming.overdue' =>
        ({required Object kind}) => '${kind} passed · record the result',
      'upcoming.needsUpdate' => 'Update',
      'upcoming.stageChanged' =>
        ({required Object title, required Object stage}) =>
            'Moved “${title}” to ${stage}',
      'upcoming.actionLabel' =>
        ({required Object title, required Object stage}) =>
            'Move ${title} to ${stage}',
      'upcoming.startsAt' => ({required Object time}) => 'Starts ${time}',
      'upcoming.startsAtVenue' =>
        ({required Object time, required Object venue}) =>
            'Starts ${time} · ${venue}',
      'upcoming.noApplication' => 'No application',
      'upcoming.notificationsDenied' =>
        'Notifications are off, so reminders won\'t arrive. Allow notifications in the Settings app.',
      'performance.title' => 'Show',
      'performance.newTitle' => 'New show',
      'performance.editTitle' => 'Edit show',
      'performance.name' => 'Show name',
      'performance.startsAt' => 'Starts at',
      'performance.date' => 'Date',
      'performance.time' => 'Start time',
      'performance.venue' => 'Venue',
      'performance.pick' => 'Choose a show',
      'performance.pickOptional' => 'Show (optional)',
      'performance.none' => 'No show',
      'performance.noPerformances' => 'No shows yet',
      'performance.createNew' => 'Add a new show',
      'performance.applications' => 'Ticket applications',
      'performance.noApplications' => 'No ticket applications yet',
      'performance.delete' => 'Delete this show',
      'performance.deleteTitle' => 'Delete this show?',
      'performance.deleteBody' =>
        ({
          required Object count,
          required Object amount,
          required Object applications,
        }) =>
            'This also deletes ${count} ticket, drink and cheki expenses (${amount}) and ${applications} ticket applications. Merch and other expenses stay, without the show.',
      'performance.titleRequired' => 'Enter a show name',
      'expense.addTitle' => 'Add expense',
      'expense.editTitle' => 'Edit expense',
      'expense.performance' => 'Show',
      'expense.paidOn' => 'Paid on',
      'expense.today' => ({required Object date}) => 'Today ${date}',
      'expense.categoryGroup' => 'Category',
      'expense.amount' => 'Amount',
      'expense.unitPrice' => 'Per shot',
      'expense.keypad' => 'Number keys',
      'expense.deleteKey' => 'Delete one digit',
      'expense.partners' => 'Cheki partners',
      'expense.pickPartners' => 'Choose',
      'expense.noPartners' => 'Choose who you shot with',
      'expense.increase' =>
        ({required Object name}) => 'Add a shot with ${name}',
      'expense.decrease' =>
        ({required Object name}) =>
            'Remove a shot with ${name} (0 removes them)',
      'expense.partnerSub' =>
        ({required Object group, required Object amount}) =>
            '${group} · ${amount}',
      'expense.drinkPrefilled' => 'Filled in with your last drink price',
      'expense.chekiTotal' =>
        ({required Object amount}) =>
            'Total ${amount} (one record per partner)',
      'expense.recordAmount' =>
        ({required Object amount}) => 'Record ${amount}',
      'expense.recordCheki' =>
        ({required Object count, required Object amount}) =>
            'Record ${count} · ${amount}',
      'expense.enterAmount' => 'Enter an amount',
      'expense.selectPartnerCta' => 'Choose a partner',
      'expense.selectPerformanceCta' => 'Choose a show',
      'expense.recordAndContinue' => 'Record another',
      'expense.recorded' => 'Recorded',
      'expense.note' => 'Note',
      'expense.importedNote' => 'Imported from Gmail',
      'expense.delete' => 'Delete this expense',
      'expense.shotCount' => 'Shots',
      'partner.pickerTitle' => 'Choose cheki partners',
      'partner.search' => 'Search by name or group',
      'partner.recent' => 'Recently shot',
      'partner.noGroup' => 'No group',
      'partner.searchResults' => 'Results',
      'partner.notShotYet' => 'No shots yet',
      'partner.lastShot' => ({required Object date}) => 'Last ${date}',
      'partner.edit' => ({required Object name}) => 'Edit ${name}',
      'partner.deselect' => ({required Object name}) => 'Deselect ${name}',
      'partner.confirm' => ({required Object count}) => 'Choose ${count}',
      'partner.selectPrompt' => 'Choose a partner',
      'partner.createNew' => '+ Add a new cheki partner',
      'partner.newTitle' => 'New cheki partner',
      'partner.name' => 'Name',
      'partner.group' => 'Group',
      'partner.groupHint' => 'Optional · tells people with the same name apart',
      'partner.icon' => 'Icon',
      'partner.iconOptional' => 'Icon · optional',
      'partner.pickImage' => 'Choose image',
      'partner.changeImage' => 'Change image',
      'partner.removeImage' => 'Remove image',
      'partner.camera' => 'Take a photo',
      'partner.gallery' => 'Choose from library',
      'partner.iconNote' =>
        'The image is cropped to a square and shown as a circle.',
      'partner.iconLocal' => 'Images are stored only on this device',
      'partner.createAndSelect' => 'Add and choose',
      'partner.editTitle' => 'Edit cheki partner',
      'partner.records' => 'Records',
      'partner.stats' =>
        ({required Object count, required Object shots}) =>
            '${count} cheki records · ${shots} shots',
      'partner.history' =>
        ({required Object first, required Object last}) =>
            'First ${first} · last ${last}',
      'partner.noRecords' => 'No cheki records yet',
      'partner.delete' => 'Delete this partner',
      'partner.inUse' => 'Partners with cheki records can\'t be deleted',
      'partner.nameRequired' => 'Enter a name',
      'partner.empty' => 'No cheki partners yet',
      'application.title' => 'Ticket application',
      'application.performance' => 'Show',
      'application.stage' => 'Stage',
      'application.service' => 'Ticket service',
      'application.referenceNo' => 'Reference number',
      'application.referenceHint' => 'Optional · used to match Gmail',
      'application.deadlines' => 'Deadlines',
      'application.reminded' => 'Reminder on',
      'application.pickDateTime' => 'Choose date and time',
      'application.clear' => 'Clear',
      'application.note' => 'Note',
      'application.delete' => 'Delete this application',
      'application.imported' => 'Imported from Gmail',
      'application.overdueApply' =>
        'The application deadline has passed. Once you\'ve applied, move it to “Awaiting result”.',
      'application.overdueResult' =>
        'The result announcement has passed. Update the stage once you know the result.',
      'application.overduePayment' =>
        'The payment deadline has passed. Once you\'ve paid, move it to “Secured”.',
      'application.willNotify' =>
        ({required Object times}) => 'You\'ll be notified at ${times}.',
      'application.noReminder' =>
        'No reminders at this stage. You can note ticket issuing in the memo.',
      'application.noDeadline' =>
        ({required Object kind}) =>
            'Add the ${kind} to get a reminder before it.',
      'application.reminderOff' =>
        ({required Object kind}) =>
            'Reminders for the ${kind} are turned off in Settings.',
      'application.performanceRequired' => 'Choose a show',
      'application.add' => 'Add ticket application',
      'settings.budget' => 'Monthly budget',
      'settings.monthly' => 'Per month',
      'settings.startMonth' => 'Starts',
      'settings.overrides' => 'Monthly overrides',
      'settings.overrideCount' => ({required Object count}) => '${count}',
      'settings.overrideItem' =>
        ({required Object month, required Object amount}) =>
            '${month} ${amount}',
      'settings.addOverride' => 'Add override',
      'settings.overrideMonth' => 'Month',
      'settings.overrideAmount' => 'Budget for that month',
      'settings.removeOverride' => 'Remove override',
      'settings.noOverrides' => 'No overridden months',
      'settings.budgetUnset' => 'Not set',
      'settings.setBudget' => 'Set monthly budget',
      'settings.gmail' => 'Gmail',
      'settings.gmailNotConnected' => 'Not connected',
      'settings.connect' => 'Connect Gmail',
      'settings.reconnect' => 'Reconnect Gmail',
      'settings.reauthTitle' => 'Your Gmail sign-in has expired.',
      'settings.reauthBody' =>
        'Reconnect to resume importing from your last sync.',
      'settings.syncFailed' =>
        ({required Object date}) =>
            'The last sync failed (${date}). The next sync will pick up what was missed.',
      'settings.lastSync' => 'Last sync',
      'settings.neverSynced' => 'Not synced yet',
      'settings.services' => 'Services',
      'settings.servicesValue' => 'eplus · LivePocket',
      'settings.autoSync' => 'Auto sync',
      'settings.autoSyncValue' => 'Not supported yet (sync manually)',
      'settings.syncNow' => 'Sync now',
      'settings.syncing' => 'Syncing',
      'settings.synced' =>
        ({required Object count}) => 'Imported ${count} emails',
      'settings.disconnect' => 'Disconnect',
      'settings.disconnectNote' =>
        'Imported shows and expenses stay after you disconnect.',
      'settings.disconnectTitle' => 'Disconnect Gmail?',
      'settings.demo' => 'Demo data',
      'settings.demoNote' =>
        'No OAuth client is configured, so mock emails are imported.',
      'settings.reminders' => 'Reminders',
      'settings.permissionGranted' => 'Notifications are allowed',
      'settings.permissionDenied' =>
        'Notifications aren\'t allowed. Allow them in the Settings app.',
      'settings.permissionUnknown' =>
        'You\'ll be asked to allow notifications when you first add a deadline',
      'settings.display' => 'Display',
      'settings.showAmounts' => 'Show amounts',
      'settings.showAmountsNote' =>
        'When off, amounts in the calendar and list show as “•••”. The eye button on each screen toggles it too. Upcoming shows and notifications never show amounts.',
      'settings.theme' => 'Theme',
      'settings.themeSystem' => 'System',
      'settings.themeLight' => 'Light',
      'settings.themeDark' => 'Dark',
      'settings.language' => 'Language',
      'settings.languageJapanese' => '日本語',
      'settings.languageEnglish' => 'English',
      'settings.defaultBasis' => 'Default accounting basis',
      'settings.defaultBasisNote' =>
        'Which day the calendar and list place expenses on by default. The balance always uses the paid date.',
      'settings.reminderApplyWhen' =>
        '8:00 PM the day before and 3 hours before',
      'settings.reminderResultWhen' => 'At the announcement time',
      'settings.reminderPaymentWhen' =>
        '8:00 PM the day before and 3 hours before',
      'settings.overrideSaved' => 'Override saved',
      'settings.budgetSaved' => 'Budget saved',
      'settings.gmailAccount' => 'Connected account',
      'settings.gmailFailedAt' => 'Sync failure',
      'onboarding.welcomeTitle' => 'Your fan spending and plans, in one app.',
      'onboarding.welcomeBody' =>
        'Enjoy supporting your favorites within the budget you set.',
      'onboarding.featureBudgetTitle' => 'Budget with a monthly allowance',
      'onboarding.featureBudgetBody' =>
        'Leftovers and overspending both carry over to next month.',
      'onboarding.featureRecordTitle' => 'Record right at the venue',
      'onboarding.featureRecordBody' =>
        'Drinks reuse your last price; for cheki, just pick who and how many.',
      'onboarding.featureReminderTitle' => 'Never miss a ticket deadline',
      'onboarding.featureReminderBody' =>
        'Get notified about lottery deadlines, results and payment due dates.',
      'onboarding.privacy' =>
        'Your data stays on this device. No sign-up or login needed.',
      'onboarding.start' => 'Get started',
      'onboarding.budgetStep' => '1 / 2',
      'onboarding.budgetTitle' => 'Set your monthly budget',
      'onboarding.budgetBody' =>
        'How much you can spend on your favorites each month. It\'s added to your balance monthly, and leftovers or overspending carry over.',
      'onboarding.budgetStartNote' =>
        'Expenses before the start month are listed but not counted in the balance.',
      'onboarding.budgetCta' =>
        ({required Object amount, required Object month}) =>
            '${amount} a month from ${month}',
      'onboarding.budgetLater' =>
        'You can change the budget in Settings anytime',
      'onboarding.gmailStep' => '2 / 2 · Optional',
      'onboarding.gmailTitle' => 'Record tickets from your email',
      'onboarding.gmailBody' =>
        'Connect Gmail to read ticket purchase and lottery emails and record tickets and applications automatically.',
      'onboarding.gmailScope' =>
        'Only eplus and LivePocket ticket emails are read. Nothing is sent or deleted.',
      'onboarding.gmailPrivacy' =>
        'Email bodies aren\'t stored; what\'s read stays on this device.',
      'onboarding.gmailBackfill' =>
        'After connecting, emails from the past 3 months are imported.',
      'onboarding.gmailConnected' =>
        ({required Object email}) =>
            'Connected to ${email}. Importing continues in the background.',
      'onboarding.gmailLater' => 'Connect later',
      'onboarding.gmailLaterNote' =>
        'You can connect or disconnect in Settings anytime',
      'onboarding.sampleSubject' => 'Payment confirmation',
      'onboarding.sampleAuto' => 'Auto',
      'reminder.channelName' => 'Ticket reminders',
      'reminder.channelDescription' =>
        'Application deadlines, results and payment due dates',
      'reminder.applyEve' =>
        ({required Object time}) =>
            'The application deadline is tomorrow at ${time}',
      'reminder.applySoon' =>
        ({required Object time}) =>
            '3 hours until the application deadline (${time})',
      'reminder.resultAt' =>
        ({required Object dateTime}) =>
            'Results are out (${dateTime}). Record how it went',
      'reminder.paymentEve' =>
        ({required Object time}) => 'Payment is due tomorrow at ${time}',
      'reminder.paymentSoon' =>
        ({required Object time}) => '3 hours until payment is due (${time})',
      'errors.unexpected' => 'Something went wrong. Please try again.',
      'errors.settingsWrite' => 'Could not save settings. Please try again.',
      'errors.recordStorage' => 'Could not save the record. Please try again.',
      'errors.invalidInput' => 'Please check your input.',
      'errors.partnerInUse' => 'Partners with cheki records can\'t be deleted.',
      'errors.partnerIcon' => 'Couldn\'t load the image.',
      'errors.gmailReauthRequired' => 'Please reconnect Gmail.',
      'errors.gmailSync' =>
        'Couldn\'t sync with Gmail. Please try again later.',
      'errors.reminderSchedule' => 'Couldn\'t schedule notifications.',
      _ => null,
    };
  }
}
