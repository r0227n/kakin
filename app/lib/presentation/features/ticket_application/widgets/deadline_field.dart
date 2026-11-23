import 'package:app/core/formatting/kakin_formats.dart';
import 'package:app/core/gen/slang.g.dart';
import 'package:app/domain/domain.dart';
import 'package:app/presentation/shared/keys/app_keys.dart';
import 'package:app/presentation/shared/widgets/visuals.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

/// 期限1つの日時の入力。日付を選ぶと種類ごとの既定の時刻を入れる。
class DeadlineField extends StatelessWidget {
  /// [value] は UTC の瞬間。
  const DeadlineField({
    required this.kind,
    required this.value,
    required this.isReminded,
    required this.defaultDate,
    required this.onChanged,
    super.key,
  });

  /// 期限の種類。
  final TicketDeadlineKind kind;

  /// 入力済みの期限。
  final DateTime? value;

  /// 今の段階でリマインドする期限か。
  final bool isReminded;

  /// 日付の選択の初期値。
  final LocalDate defaultDate;

  /// 期限を変える。null でクリア。
  final ValueChanged<DateTime?> onChanged;

  Future<void> _pick(BuildContext context) async {
    final current = value;
    final initialDate = current == null
        ? defaultDate
        : JapanTime.dateOf(current);
    final date = await showDatePicker(
      context: context,
      initialDate: initialDate.asDateTime,
      firstDate: DateTime.utc(2000),
      lastDate: DateTime.utc(2100),
    );
    if (date == null || !context.mounted) return;
    final wall = current == null ? null : JapanTime.wallClockOf(current);
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: wall?.hour ?? kind.defaultHour,
        minute: wall?.minute ?? kind.defaultMinute,
      ),
    );
    if (!context.mounted) return;
    final picked =
        time ?? TimeOfDay(hour: kind.defaultHour, minute: kind.defaultMinute);
    onChanged(
      JapanTime.instantOf(
        LocalDate(date.year, date.month, date.day),
        hour: picked.hour,
        minute: picked.minute,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final palette = context.palette;
    final current = value;
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.sm,
        AppSpacing.s,
        AppSpacing.xs,
        AppSpacing.s,
      ),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(AppRadius.m),
        border: Border.all(
          color: isReminded ? palette.accent : palette.border,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.xxs,
              children: [
                Wrap(
                  spacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      kind.label(t),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (isReminded)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 2,
                        children: [
                          Icon(
                            Icons.notifications_active_outlined,
                            size: 12,
                            color: palette.accentStrong,
                          ),
                          Text(
                            t.application.reminded,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: palette.accentStrong,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                TextButton(
                  key: AppKeys.deadline(kind),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 36),
                    alignment: Alignment.centerLeft,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () => _pick(context),
                  child: Text(
                    current == null
                        ? t.application.pickDateTime
                        : KakinFormats.dateTime(current),
                    style: AppTypography.numeric(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: current == null
                          ? palette.accentStrong
                          : palette.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (current != null)
            IconButton(
              key: AppKeys.deadlineClear(kind),
              tooltip: t.application.clear,
              onPressed: () => onChanged(null),
              icon: const Icon(Icons.close, size: 20),
            ),
        ],
      ),
    );
  }
}
