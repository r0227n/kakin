import 'package:app/application/errors/app_error_code.dart';
import 'package:app/application/errors/app_exception.dart';
import 'package:app/core/gen/slang.g.dart';
import 'package:app/presentation/dependencies/observability_providers.dart';
import 'package:app/presentation/shared/keys/app_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 失敗の分類に対応する翻訳済みの文言。
String errorMessageFor(Translations t, AppException failure) =>
    switch (failure.code) {
      AppErrorCode.settingsWrite => t.errors.settingsWrite,
      AppErrorCode.recordStorage => t.errors.recordStorage,
      AppErrorCode.invalidInput => t.errors.invalidInput,
      AppErrorCode.partnerInUse => t.errors.partnerInUse,
      AppErrorCode.partnerIcon => t.errors.partnerIcon,
      AppErrorCode.gmailReauthRequired => t.errors.gmailReauthRequired,
      AppErrorCode.gmailSync => t.errors.gmailSync,
      AppErrorCode.unexpected => t.errors.unexpected,
    };

/// [action] を実行し、失敗を一度だけ報告して画面が残っていれば知らせる。
///
/// 成功したら結果を、失敗したら null を返す。画面が破棄されても報告は行う。
Future<T?> runWithFeedback<T>(
  BuildContext context,
  WidgetRef ref,
  Future<T> Function() action, {
  required String failureLog,
  String? successMessage,
}) async {
  final reporter = ref.read(errorReporterProvider);
  final messenger = ScaffoldMessenger.maybeOf(context);
  try {
    final result = await action();
    if (successMessage != null && context.mounted) {
      messenger
        ?..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(successMessage)));
    }
    return result;
  } on Object catch (error, stackTrace) {
    reporter.report(error, stackTrace, message: failureLog);
    if (!context.mounted) return null;
    final failure = appExceptionForDisplay(error, stackTrace);
    messenger
      ?..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(errorMessageFor(Translations.of(context), failure)),
        ),
      );
    return null;
  }
}

/// 削除などの確認ダイアログ。確定したら true。
Future<bool> confirmDestructive(
  BuildContext context, {
  required String title,
  required String body,
  String? confirmLabel,
}) async {
  final t = Translations.of(context);
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(body, key: AppKeys.confirmBody),
      actions: [
        TextButton(
          key: AppKeys.confirmCancel,
          onPressed: () => Navigator.pop(context, false),
          child: Text(t.common.cancel),
        ),
        TextButton(
          key: AppKeys.confirmOk,
          onPressed: () => Navigator.pop(context, true),
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.error,
          ),
          child: Text(confirmLabel ?? t.common.delete),
        ),
      ],
    ),
  );
  return confirmed ?? false;
}
