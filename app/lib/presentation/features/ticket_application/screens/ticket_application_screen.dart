import 'dart:async';

import 'package:app/application/application.dart';
import 'package:app/core/formatting/kakin_formats.dart';
import 'package:app/core/gen/slang.g.dart';
import 'package:app/domain/domain.dart';
import 'package:app/presentation/dependencies/application_providers.dart';
import 'package:app/presentation/features/ticket_application/widgets/deadline_field.dart';
import 'package:app/presentation/features/ticket_application/widgets/stage_selector.dart';
import 'package:app/presentation/shared/controllers/app_preferences_controller.dart';
import 'package:app/presentation/shared/controllers/local_data.dart';
import 'package:app/presentation/shared/feedback/action_feedback.dart';
import 'package:app/presentation/shared/keys/app_keys.dart';
import 'package:app/presentation/shared/widgets/common_widgets.dart';
import 'package:app/presentation/shared/widgets/performance_picker_sheet.dart';
import 'package:app/presentation/shared/widgets/visuals.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// チケット申込の追加と編集。
class TicketApplicationScreen extends ConsumerStatefulWidget {
  /// [applicationId] があれば編集する。
  const TicketApplicationScreen({
    this.applicationId,
    this.initialPerformanceId,
    super.key,
  });

  /// 編集するチケット申込。
  final int? applicationId;

  /// 追加のときに最初に選ぶ公演。
  final int? initialPerformanceId;

  @override
  ConsumerState<TicketApplicationScreen> createState() =>
      _TicketApplicationScreenState();
}

class _TicketApplicationScreenState
    extends ConsumerState<TicketApplicationScreen> {
  late int? _performanceId = widget.initialPerformanceId;
  TicketApplicationStage _stage = TicketApplicationStage.planned;
  TicketServiceKind? _service;
  final _reference = TextEditingController();
  final _note = TextEditingController();
  final _deadlines = <TicketDeadlineKind, DateTime?>{};
  TicketApplication? _editing;
  bool _loading = false;
  bool _saving = false;
  bool _showErrors = false;

  bool get _isEditing => widget.applicationId != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _loading = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => _load());
    }
  }

  @override
  void dispose() {
    _reference.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final application = await runWithFeedback(
      context,
      ref,
      () => ref
          .read(ticketApplicationUseCaseProvider)
          .find(widget.applicationId!),
      failureLog: 'Loading a ticket application failed',
    );
    if (!mounted) return;
    if (application == null) {
      context.pop();
      return;
    }
    setState(() {
      _editing = application;
      _loading = false;
      _performanceId = application.performance.id;
      _stage = application.stage;
      _service = application.service;
      _reference.text = application.referenceNo ?? '';
      _note.text = application.note ?? '';
      for (final kind in TicketDeadlineKind.values) {
        _deadlines[kind] = application.deadlineOf(kind);
      }
    });
  }

  Future<void> _pickPerformance() async {
    final choice = await PerformancePickerSheet.show(
      context,
      selectedId: _performanceId,
      allowNone: false,
    );
    if (choice == null || !mounted) return;
    setState(() => _performanceId = choice.performanceId);
  }

  Future<void> _save() async {
    final performanceId = _performanceId;
    if (performanceId == null) {
      setState(() => _showErrors = true);
      return;
    }
    setState(() => _saving = true);
    final draft = TicketApplicationDraft(
      performanceId: performanceId,
      stage: _stage,
      service: _service,
      referenceNo: _reference.text,
      applyDeadlineAt: _deadlines[TicketDeadlineKind.apply],
      resultAt: _deadlines[TicketDeadlineKind.result],
      paymentDeadlineAt: _deadlines[TicketDeadlineKind.payment],
      note: _note.text,
    );
    final saved = await runWithFeedback(
      context,
      ref,
      () async {
        await ref
            .read(ticketApplicationUseCaseProvider)
            .save(draft, id: widget.applicationId);
        return true;
      },
      failureLog: 'Saving a ticket application failed',
    );
    if (!mounted) return;
    setState(() => _saving = false);
    ref.invalidate(notificationPermissionProvider);
    if (saved ?? false) context.pop();
  }

  Future<void> _delete() async {
    final t = Translations.of(context);
    final confirmed = await confirmDestructive(
      context,
      title: t.common.deleteConfirmTitle,
      body: t.common.deleteConfirmBody,
    );
    if (!confirmed || !mounted) return;
    final deleted = await runWithFeedback(
      context,
      ref,
      () async {
        await ref
            .read(ticketApplicationUseCaseProvider)
            .delete(widget.applicationId!);
        return true;
      },
      failureLog: 'Deleting a ticket application failed',
    );
    if ((deleted ?? false) && mounted) context.pop();
  }

  String _reminderNote(Translations t, DateTime now) {
    final kind = _stage.remindedDeadline;
    if (kind == null) return t.application.noReminder;
    final enabled = ref.watch(
      appPreferencesControllerProvider.select((p) => p.enabledReminderKinds),
    );
    if (!enabled.contains(kind)) {
      return t.application.reminderOff(kind: kind.label(t));
    }
    final deadline = _deadlines[kind];
    if (deadline == null) return t.application.noDeadline(kind: kind.label(t));
    if (!deadline.isAfter(now)) {
      return switch (kind) {
        TicketDeadlineKind.apply => t.application.overdueApply,
        TicketDeadlineKind.result => t.application.overdueResult,
        TicketDeadlineKind.payment => t.application.overduePayment,
      };
    }
    final plans = planReminders(
      applications: [
        ReminderFacts(
          applicationId: 0,
          stage: _stage,
          applyDeadlineAt: _deadlines[TicketDeadlineKind.apply],
          resultAt: _deadlines[TicketDeadlineKind.result],
          paymentDeadlineAt: _deadlines[TicketDeadlineKind.payment],
        ),
      ],
      now: now,
      enabledKinds: {kind},
    );
    return t.application.willNotify(
      times: plans.map((p) => KakinFormats.dateTime(p.fireAt)).join('、'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final palette = context.palette;
    final now = ref.read(clockProvider).now();
    final performances = ref.watch(performancesProvider).value ?? const [];
    final performance = performances
        .where((p) => p.id == _performanceId)
        .firstOrNull;
    final reminded = _stage.remindedDeadline;
    final label = TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w700,
      color: palette.textPrimary,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(t.application.title),
        actions: [
          if (_isEditing)
            IconButton(
              key: AppKeys.applicationDelete,
              tooltip: t.application.delete,
              onPressed: _saving ? null : _delete,
              icon: const Icon(Icons.delete_outline),
            ),
        ],
      ),
      bottomNavigationBar: BottomActionBar(
        child: FilledButton(
          key: AppKeys.applicationSave,
          onPressed: _saving || _loading ? null : _save,
          child: Text(t.common.save),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              key: AppKeys.applicationScroll,
              padding: const EdgeInsets.all(AppSpacing.m),
              children: [
                if (_editing?.isImported ?? false) ...[
                  SurfaceCard(
                    color: palette.accentSoft,
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    child: Row(
                      spacing: AppSpacing.s,
                      children: [
                        Icon(
                          Icons.mail_outline,
                          size: 18,
                          color: palette.accentStrong,
                        ),
                        Text(
                          t.application.imported,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: palette.accentStrong,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.m),
                ],
                Text(t.application.performance, style: label),
                const SizedBox(height: AppSpacing.s),
                OutlinedButton(
                  key: AppKeys.applicationPerformance,
                  style: OutlinedButton.styleFrom(
                    alignment: Alignment.centerLeft,
                    side: BorderSide(
                      color: _showErrors && performance == null
                          ? palette.negative
                          : palette.border,
                      width: 1.5,
                    ),
                  ),
                  onPressed: _pickPerformance,
                  child: Text(
                    performance == null
                        ? t.performance.pick
                        : [
                            KakinFormats.monthDay(
                              performance.startsOn.asDateTime,
                            ),
                            performance.title,
                          ].join(' '),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (_showErrors && performance == null)
                  Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.xs),
                    child: Text(
                      t.application.performanceRequired,
                      style: TextStyle(fontSize: 12, color: palette.negative),
                    ),
                  ),
                const SizedBox(height: AppSpacing.l),
                Text(t.application.stage, style: label),
                const SizedBox(height: AppSpacing.s),
                StageSelector(
                  value: _stage,
                  onChanged: (stage) => setState(() => _stage = stage),
                ),
                const SizedBox(height: AppSpacing.l),
                Text(
                  '${t.application.service}（${t.common.optional}）',
                  style: label,
                ),
                const SizedBox(height: AppSpacing.s),
                Wrap(
                  spacing: AppSpacing.s,
                  runSpacing: AppSpacing.s,
                  children: [
                    for (final service in TicketServiceKind.values)
                      ChoiceChip(
                        key: AppKeys.service(service),
                        label: Text(service.label(t)),
                        selected: _service == service,
                        showCheckmark: false,
                        onSelected: (selected) => setState(
                          () => _service = selected ? service : null,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.l),
                TextField(
                  key: AppKeys.applicationReference,
                  controller: _reference,
                  maxLength: 50,
                  style: AppTypography.numeric(fontSize: 15),
                  decoration: InputDecoration(
                    labelText: t.application.referenceNo,
                    helperText: t.application.referenceHint,
                    counterText: '',
                  ),
                ),
                const SizedBox(height: AppSpacing.l),
                Text(t.application.deadlines, style: label),
                const SizedBox(height: AppSpacing.s),
                for (final kind in TicketDeadlineKind.values) ...[
                  DeadlineField(
                    kind: kind,
                    value: _deadlines[kind],
                    isReminded: kind == reminded,
                    defaultDate: JapanTime.dateOf(now),
                    onChanged: (value) =>
                        setState(() => _deadlines[kind] = value),
                  ),
                  const SizedBox(height: AppSpacing.s),
                ],
                Semantics(
                  liveRegion: true,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: AppSpacing.s,
                    children: [
                      Icon(
                        Icons.notifications_none,
                        size: 18,
                        color: palette.textSecondary,
                      ),
                      Expanded(
                        child: Text(
                          _reminderNote(t, now),
                          key: AppKeys.applicationReminderNote,
                          style: TextStyle(
                            fontSize: 12,
                            height: 1.5,
                            color: palette.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.l),
                TextField(
                  key: AppKeys.applicationNote,
                  controller: _note,
                  minLines: 2,
                  maxLines: 5,
                  maxLength: 500,
                  decoration: InputDecoration(
                    labelText: '${t.application.note}（${t.common.optional}）',
                    counterText: '',
                  ),
                ),
              ],
            ),
    );
  }
}
