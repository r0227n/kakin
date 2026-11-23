import 'package:app/domain/domain.dart';
import 'package:flutter/widgets.dart';

/// アプリと E2E テストで共有する Widget の key。
abstract final class AppKeys {
  /// `add_expense`。
  static const addExpense = Key('add_expense');

  /// `amount_visibility`。
  static const amountVisibility = Key('amount_visibility');

  /// `basis_toggle`。
  static const basisToggle = Key('basis_toggle');

  /// `budget_amount`。
  static const budgetAmount = Key('budget_amount');

  /// `budget_preset_…`。
  static Key budgetPreset(int amountYen) => Key('budget_preset_$amountYen');

  /// `budget_sheet_save`。
  static const budgetSheetSave = Key('budget_sheet_save');

  /// `budget_start_month`。
  static const budgetStartMonth = Key('budget_start_month');

  /// `calendar_day_…`。
  static Key calendarDay(LocalDate date) => Key('calendar_day_${date.toIso()}');

  /// `calendar_scroll`。
  static const calendarScroll = Key('calendar_scroll');

  /// `category_…`。
  static Key category(ExpenseCategory category) =>
      Key('category_${category.name}');

  /// `cheki_count_…`。
  static Key chekiCount(int partnerId) => Key('cheki_count_$partnerId');

  /// `cheki_decrease_…`。
  static Key chekiDecrease(int partnerId) => Key('cheki_decrease_$partnerId');

  /// `cheki_increase_…`。
  static Key chekiIncrease(int partnerId) => Key('cheki_increase_$partnerId');

  /// `cheki_row_…`。
  static Key chekiRow(int partnerId) => Key('cheki_row_$partnerId');

  /// `confirm_body`。
  static const confirmBody = Key('confirm_body');

  /// `confirm_cancel`。
  static const confirmCancel = Key('confirm_cancel');

  /// `confirm_ok`。
  static const confirmOk = Key('confirm_ok');

  /// `day_performance_…`。
  static Key dayPerformance(int performanceId) =>
      Key('day_performance_$performanceId');

  /// `day_records`。
  static const dayRecords = Key('day_records');

  /// `day_records_title`。
  static const dayRecordsTitle = Key('day_records_title');

  /// `day_records_total`。
  static const dayRecordsTotal = Key('day_records_total');

  /// `delete_performance`。
  static const deletePerformance = Key('delete_performance');

  /// ドロップダウンの選択肢。
  static Key dropdownOption(Object? value) => ValueKey('dropdown_$value');

  /// `duplicate_badge_…`。
  static Key duplicateBadge(int expenseId) => Key('duplicate_badge_$expenseId');

  /// `edit_performance`。
  static const editPerformance = Key('edit_performance');

  /// `expense_amount`。
  static const expenseAmount = Key('expense_amount');

  /// `expense_delete`。
  static const expenseDelete = Key('expense_delete');

  /// `expense_editor_scroll`。
  static const expenseEditorScroll = Key('expense_editor_scroll');

  /// `expense_list_empty`。
  static const expenseListEmpty = Key('expense_list_empty');

  /// `expense_list_scroll`。
  static const expenseListScroll = Key('expense_list_scroll');

  /// `expense_note`。
  static const expenseNote = Key('expense_note');

  /// `expense_paid_on`。
  static const expensePaidOn = Key('expense_paid_on');

  /// `expense_performance`。
  static const expensePerformance = Key('expense_performance');

  /// `expense_row_…`。
  static Key expenseRow(int expenseId) => Key('expense_row_$expenseId');

  /// `expense_save`。
  static const expenseSave = Key('expense_save');

  /// `expense_save_continue`。
  static const expenseSaveContinue = Key('expense_save_continue');

  /// `filter_…`。
  static Key filter(ExpenseCategory category) => Key('filter_${category.name}');

  /// `filter_all`。
  static const filterAll = Key('filter_all');

  /// `gmail_account`。
  static const gmailAccount = Key('gmail_account');

  /// `gmail_connect`。
  static const gmailConnect = Key('gmail_connect');

  /// `gmail_demo_label`。
  static const gmailDemoLabel = Key('gmail_demo_label');

  /// `gmail_disconnect`。
  static const gmailDisconnect = Key('gmail_disconnect');

  /// `gmail_reauth_banner`。
  static const gmailReauthBanner = Key('gmail_reauth_banner');

  /// `gmail_sync_failed`。
  static const gmailSyncFailed = Key('gmail_sync_failed');

  /// `gmail_sync_now`。
  static const gmailSyncNow = Key('gmail_sync_now');

  /// `icon_source_camera`。
  static const iconSourceCamera = Key('icon_source_camera');

  /// `icon_source_gallery`。
  static const iconSourceGallery = Key('icon_source_gallery');

  /// `keypad_…`。
  static Key keypad(String digits) => Key('keypad_$digits');

  /// `keypad_backspace`。
  static const keypadBackspace = Key('keypad_backspace');

  /// `main_tabs`。
  static const mainTabs = Key('main_tabs');

  /// `month_calendar`。
  static const monthCalendar = Key('month_calendar');

  /// `month_next`。
  static const monthNext = Key('month_next');

  /// `month_previous`。
  static const monthPrevious = Key('month_previous');

  /// `month_summary`。
  static const monthSummary = Key('month_summary');

  /// `month_title`。
  static const monthTitle = Key('month_title');

  /// `no_upcoming_performances`。
  static const noUpcomingPerformances = Key('no_upcoming_performances');

  /// `onboarding_budget_save`。
  static const onboardingBudgetSave = Key('onboarding_budget_save');

  /// `onboarding_budget_skip`。
  static const onboardingBudgetSkip = Key('onboarding_budget_skip');

  /// `onboarding_gmail_connect`。
  static const onboardingGmailConnect = Key('onboarding_gmail_connect');

  /// `onboarding_gmail_skip`。
  static const onboardingGmailSkip = Key('onboarding_gmail_skip');

  /// `onboarding_start`。
  static const onboardingStart = Key('onboarding_start');

  /// `override_amount`。
  static const overrideAmount = Key('override_amount');

  /// `override_save`。
  static const overrideSave = Key('override_save');

  /// `partner_create`。
  static const partnerCreate = Key('partner_create');

  /// `partner_delete`。
  static const partnerDelete = Key('partner_delete');

  /// `partner_group_field`。
  static const partnerGroupField = Key('partner_group_field');

  /// `partner_name_field`。
  static const partnerNameField = Key('partner_name_field');

  /// `partner_option_…`。
  static Key partnerOption(int partnerId) => Key('partner_option_$partnerId');

  /// `partner_picker_confirm`。
  static const partnerPickerConfirm = Key('partner_picker_confirm');

  /// `partner_pick_icon`。
  static const partnerPickIcon = Key('partner_pick_icon');

  /// `partner_remove_icon`。
  static const partnerRemoveIcon = Key('partner_remove_icon');

  /// `partner_save`。
  static const partnerSave = Key('partner_save');

  /// `partner_search`。
  static const partnerSearch = Key('partner_search');

  /// `performance_create`。
  static const performanceCreate = Key('performance_create');

  /// `performance_date`。
  static const performanceDate = Key('performance_date');

  /// `performance_none`。
  static const performanceNone = Key('performance_none');

  /// `performance_option_…`。
  static Key performanceOption(int performanceId) =>
      Key('performance_option_$performanceId');

  /// `performance_save`。
  static const performanceSave = Key('performance_save');

  /// `performance_time`。
  static const performanceTime = Key('performance_time');

  /// `performance_title`。
  static const performanceTitle = Key('performance_title');

  /// `performance_title_field`。
  static const performanceTitleField = Key('performance_title_field');

  /// `performance_venue_field`。
  static const performanceVenueField = Key('performance_venue_field');

  /// `pick_partners`。
  static const pickPartners = Key('pick_partners');

  /// `pick_partners_empty`。
  static const pickPartnersEmpty = Key('pick_partners_empty');

  /// `quick_amount_…`。
  static Key quickAmount(int amountYen) => Key('quick_amount_$amountYen');

  /// セグメントの選択肢。
  static Key segment(Object? value) => ValueKey('segment_$value');

  /// `settings_budget_monthly`。
  static const settingsBudgetMonthly = Key('settings_budget_monthly');

  /// `settings_budget_overrides`。
  static const settingsBudgetOverrides = Key('settings_budget_overrides');

  /// `settings_budget_set`。
  static const settingsBudgetSet = Key('settings_budget_set');

  /// `settings_budget_start`。
  static const settingsBudgetStart = Key('settings_budget_start');

  /// `settings_default_basis`。
  static const settingsDefaultBasis = Key('settings_default_basis');

  /// `settings_language`。
  static const settingsLanguage = Key('settings_language');

  /// `settings_scroll`。
  static const settingsScroll = Key('settings_scroll');

  /// `settings_show_amounts`。
  static const settingsShowAmounts = Key('settings_show_amounts');

  /// `settings_theme`。
  static const settingsTheme = Key('settings_theme');

  /// `summary_balance`。
  static const summaryBalance = Key('summary_balance');

  /// `summary_spend_total`。
  static const summarySpendTotal = Key('summary_spend_total');

  /// `tab_calendar`。
  static const tabCalendar = Key('tab_calendar');

  /// `tab_list`。
  static const tabList = Key('tab_list');

  /// `tab_settings`。
  static const tabSettings = Key('tab_settings');

  /// `tab_upcoming`。
  static const tabUpcoming = Key('tab_upcoming');

  /// `upcoming_performance_…`。
  static Key upcomingPerformance(int performanceId) =>
      Key('upcoming_performance_$performanceId');

  /// `upcoming_scroll`。
  static const upcomingScroll = Key('upcoming_scroll');
}
