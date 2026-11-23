import 'package:app/core/gen/slang.g.dart';
import 'package:app/presentation/dependencies/application_providers.dart';
import 'package:app/presentation/shared/feedback/action_feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 引っ張って更新したときの Gmail 同期。連携していなければ何もしない。
Future<void> refreshFromGmail(BuildContext context, WidgetRef ref) async {
  final gmail = ref.read(gmailUseCaseProvider);
  final status = await gmail.loadStatus();
  if (status.connection == null || !context.mounted) return;
  final t = Translations.of(context);
  final result = await runWithFeedback(
    context,
    ref,
    gmail.sync,
    failureLog: 'Gmail sync from pull-to-refresh failed',
  );
  if (result == null || !context.mounted) return;
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(t.settings.synced(count: result.importedMailCount)),
      ),
    );
}
