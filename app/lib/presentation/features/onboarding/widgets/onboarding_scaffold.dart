import 'package:app/core/gen/slang.g.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

/// 初回案内の各ステップの共通の枠。
class OnboardingScaffold extends StatelessWidget {
  /// [step] は 0 始まりの段階。null なら進捗を出さない。
  const OnboardingScaffold({
    required this.children,
    required this.actions,
    this.step,
    this.onBack,
    super.key,
  });

  /// 本文。
  final List<Widget> children;

  /// 画面下の操作。
  final List<Widget> actions;

  /// 進捗の段階。
  final int? step;

  /// 戻る操作。
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final step = this.step;
    return Scaffold(
      appBar: step == null
          ? null
          : AppBar(
              automaticallyImplyLeading: false,
              leading: onBack == null
                  ? null
                  : IconButton(
                      tooltip: Translations.of(context).common.back,
                      onPressed: onBack,
                      icon: const Icon(Icons.chevron_left),
                    ),
              title: _StepProgress(step: step),
            ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.l,
              AppSpacing.sm,
              AppSpacing.l,
              AppSpacing.l,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight - AppSpacing.sm - AppSpacing.l,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: AppSpacing.l,
                  children: [
                    ...children,
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      spacing: AppSpacing.xs + 2,
                      children: actions,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 2段階のうち [step] までを塗った進捗。
class _StepProgress extends StatelessWidget {
  const _StepProgress({required this.step});

  final int step;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return ExcludeSemantics(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 6,
        children: [
          for (var i = 0; i < 2; i++)
            Container(
              width: 24,
              height: 6,
              decoration: BoxDecoration(
                color: i <= step ? palette.accent : palette.border,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
        ],
      ),
    );
  }
}

/// 案内の見出しと説明。
class OnboardingHeading extends StatelessWidget {
  /// [eyebrow] は段階の表示。
  const OnboardingHeading({
    required this.title,
    required this.body,
    this.eyebrow,
    super.key,
  });

  /// 段階の表示。
  final String? eyebrow;

  /// 見出し。
  final String title;

  /// 説明。
  final String body;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.s + 2,
      children: [
        if (eyebrow != null)
          Text(
            eyebrow!,
            style: AppTypography.numeric(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: palette.accentStrong,
            ),
          ),
        Semantics(
          header: true,
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 26,
              height: 1.35,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Text(
          body,
          style: TextStyle(
            fontSize: 14,
            height: 1.7,
            color: palette.textTertiary,
          ),
        ),
      ],
    );
  }
}

/// 案内の小さな注記。
class OnboardingNote extends StatelessWidget {
  /// 中央寄せの注記。
  const OnboardingNote(this.text, {super.key});

  /// 文言。
  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text,
    textAlign: TextAlign.center,
    style: TextStyle(fontSize: 11, color: context.palette.textSecondary),
  );
}
