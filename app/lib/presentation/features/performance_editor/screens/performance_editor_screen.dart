import 'dart:async';

import 'package:app/application/application.dart';
import 'package:app/core/formatting/kakin_formats.dart';
import 'package:app/core/gen/slang.g.dart';
import 'package:app/domain/domain.dart';
import 'package:app/presentation/dependencies/application_providers.dart';
import 'package:app/presentation/shared/feedback/action_feedback.dart';
import 'package:app/presentation/shared/keys/app_keys.dart';
import 'package:app/presentation/shared/widgets/common_widgets.dart';
import 'package:app/presentation/shared/widgets/visuals.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// 公演の登録と編集。登録したら公演の ID を返して閉じる。
class PerformanceEditorScreen extends ConsumerStatefulWidget {
  /// [performanceId] があれば編集する。
  const PerformanceEditorScreen({this.performanceId, super.key});

  /// 編集する公演。
  final int? performanceId;

  @override
  ConsumerState<PerformanceEditorScreen> createState() =>
      _PerformanceEditorScreenState();
}

class _PerformanceEditorScreenState
    extends ConsumerState<PerformanceEditorScreen> {
  final _title = TextEditingController();
  final _venue = TextEditingController();
  late LocalDate _date = JapanTime.dateOf(ref.read(clockProvider).now());
  TimeOfDay _time = const TimeOfDay(hour: 18, minute: 0);
  bool _loading = false;
  bool _saving = false;
  bool _showErrors = false;

  bool get _isEditing => widget.performanceId != null;

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
    _title.dispose();
    _venue.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final performance = await runWithFeedback(
      context,
      ref,
      () => ref.read(performanceUseCaseProvider).find(widget.performanceId!),
      failureLog: 'Loading a performance failed',
    );
    if (!mounted) return;
    if (performance == null) {
      context.pop();
      return;
    }
    final wall = JapanTime.wallClockOf(performance.startsAt);
    setState(() {
      _loading = false;
      _title.text = performance.title;
      _venue.text = performance.venue ?? '';
      _date = performance.startsOn;
      _time = TimeOfDay(hour: wall.hour, minute: wall.minute);
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date.asDateTime,
      firstDate: DateTime.utc(2000),
      lastDate: DateTime.utc(2100),
    );
    if (picked == null || !mounted) return;
    setState(() => _date = LocalDate(picked.year, picked.month, picked.day));
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(context: context, initialTime: _time);
    if (picked == null || !mounted) return;
    setState(() => _time = picked);
  }

  Future<void> _save() async {
    if (_title.text.trim().isEmpty) {
      setState(() => _showErrors = true);
      return;
    }
    setState(() => _saving = true);
    final draft = PerformanceDraft(
      title: _title.text,
      startsAt: JapanTime.instantOf(
        _date,
        hour: _time.hour,
        minute: _time.minute,
      ),
      venue: _venue.text,
    );
    final useCase = ref.read(performanceUseCaseProvider);
    final id = await runWithFeedback(
      context,
      ref,
      () async {
        if (_isEditing) {
          await useCase.update(widget.performanceId!, draft);
          return widget.performanceId!;
        }
        return useCase.create(draft);
      },
      failureLog: 'Saving a performance failed',
    );
    if (!mounted) return;
    setState(() => _saving = false);
    if (id != null) context.pop(id);
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final startsAt = JapanTime.instantOf(
      _date,
      hour: _time.hour,
      minute: _time.minute,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditing ? t.performance.editTitle : t.performance.newTitle,
        ),
      ),
      bottomNavigationBar: BottomActionBar(
        child: FilledButton(
          key: AppKeys.performanceSave,
          onPressed: _saving || _loading ? null : _save,
          child: Text(t.common.save),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(AppSpacing.m),
              children: [
                TextField(
                  key: AppKeys.performanceTitleField,
                  controller: _title,
                  autofocus: !_isEditing,
                  maxLength: 100,
                  textInputAction: TextInputAction.next,
                  onChanged: (_) {
                    if (_showErrors) setState(() {});
                  },
                  decoration: InputDecoration(
                    labelText: t.performance.name,
                    counterText: '',
                    errorText: _showErrors && _title.text.trim().isEmpty
                        ? t.performance.titleRequired
                        : null,
                  ),
                ),
                const SizedBox(height: AppSpacing.m),
                Text(
                  t.performance.startsAt,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.s),
                Row(
                  spacing: AppSpacing.s,
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        key: AppKeys.performanceDate,
                        onPressed: _pickDate,
                        icon: const Icon(Icons.event_outlined),
                        label: Text(KakinFormats.fullDate(_date.asDateTime)),
                      ),
                    ),
                    OutlinedButton.icon(
                      key: AppKeys.performanceTime,
                      onPressed: _pickTime,
                      icon: const Icon(Icons.schedule),
                      label: Text(KakinFormats.time(startsAt)),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.m),
                TextField(
                  key: AppKeys.performanceVenueField,
                  controller: _venue,
                  maxLength: 100,
                  decoration: InputDecoration(
                    labelText: t.performance.venueOptional,
                    counterText: '',
                  ),
                ),
              ],
            ),
    );
  }
}
