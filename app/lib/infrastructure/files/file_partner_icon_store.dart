import 'dart:io';
import 'dart:math';

import 'package:app/application/application.dart';
import 'package:app/application/errors/record_error.dart';
import 'package:path_provider/path_provider.dart';

/// チェキ相手のアイコン画像を Application Support の `partner_icons/` に置く。
final class FilePartnerIconStore implements PartnerIconStore {
  /// `directory` に画像を置く。
  FilePartnerIconStore(this._directory);

  /// アプリ専用の領域に画像の置き場所を作る。
  static Future<FilePartnerIconStore> open() async {
    final support = await getApplicationSupportDirectory();
    final directory = Directory('${support.path}/partner_icons');
    await directory.create(recursive: true);
    return FilePartnerIconStore(directory);
  }

  final Directory _directory;
  final Random _random = Random.secure();

  File _file(String fileName) => File('${_directory.path}/$fileName');

  @override
  Future<String> save(String sourcePath) async {
    // 差し替えた画像を古いキャッシュで表示しないよう、毎回新しい名前にする。
    final name = [
      for (var i = 0; i < 16; i++) _random.nextInt(256).toRadixString(16),
    ].join();
    final fileName = '$name.jpg';
    try {
      await File(sourcePath).copy(_file(fileName).path);
    } on FileSystemException catch (error, stackTrace) {
      throw PartnerIconException(cause: error, causeStackTrace: stackTrace);
    }
    return fileName;
  }

  @override
  String? pathOf(String fileName) {
    final file = _file(fileName);
    return file.existsSync() ? file.path : null;
  }

  @override
  Future<void> delete(String fileName) async {
    final file = _file(fileName);
    if (file.existsSync()) await file.delete();
  }

  @override
  Future<void> deleteUnreferenced(Set<String> referenced) async {
    await for (final entity in _directory.list()) {
      final name = entity.uri.pathSegments.last;
      if (entity is File && !referenced.contains(name)) await entity.delete();
    }
  }
}
