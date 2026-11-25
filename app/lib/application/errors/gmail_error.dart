import 'package:app/application/errors/app_error_code.dart';
import 'package:app/application/errors/app_exception.dart';

/// 認証の期限切れや権限の取り消しで、Gmail の再連携が必要なことを表す。
final class GmailReauthRequiredException extends AppException {
  /// 認証の失敗を保持する。
  const GmailReauthRequiredException({super.cause, super.causeStackTrace});

  @override
  AppErrorCode get code => AppErrorCode.gmailReauthRequired;
}

/// Gmail の連携や同期に失敗したことを表す。
final class GmailSyncException extends AppException {
  /// 通信や API の失敗を保持する。
  const GmailSyncException({super.cause, super.causeStackTrace});

  @override
  AppErrorCode get code => AppErrorCode.gmailSync;
}
