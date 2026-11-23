import 'package:app/application/errors/record_error.dart';
import 'package:app/application/models/notifications.dart';
import 'package:app/application/models/records.dart';
import 'package:app/application/ports/device_ports.dart';
import 'package:app/application/ports/record_repositories.dart';

/// チェキ相手とアイコン画像の入力境界。
final class PartnerUseCase {
  /// 保存先と画像の取得元を注入する。
  const PartnerUseCase(this._partners, this._icons, this._picker);

  final PartnerRepository _partners;
  final PartnerIconStore _icons;
  final PartnerIconPicker _picker;

  /// すべてのチェキ相手。
  Future<List<Partner>> listAll() => _partners.listAll();

  /// [id] のチェキ相手。
  Future<Partner?> find(int id) => _partners.find(id);

  /// アイコン画像の絶対パス。画像がない・ファイルがなければ null。
  String? iconPathOf(Partner partner) {
    final file = partner.iconFile;
    return file == null ? null : _icons.pathOf(file);
  }

  /// 写真を撮るか選び、正方形に切り抜いた一時ファイルのパスを返す。
  Future<String?> pickIcon(PartnerIconSource source) => _picker.pick(source);

  /// チェキ相手を登録する。[iconSourcePath] があれば画像も保存する。
  Future<int> create(PartnerDraft draft, {String? iconSourcePath}) async {
    final validated = _validated(draft);
    final iconFile = iconSourcePath == null
        ? null
        : await _icons.save(iconSourcePath);
    try {
      return await _partners.create(validated, iconFile: iconFile);
    } on Object {
      if (iconFile != null) await _icons.delete(iconFile);
      rethrow;
    }
  }

  /// 名前と所属を変える。
  Future<void> update(int id, PartnerDraft draft) =>
      _partners.update(id, _validated(draft));

  /// アイコン画像を差し替える。null なら画像を外す。元の画像のファイルは消す。
  Future<void> replaceIcon(int id, String? iconSourcePath) async {
    final iconFile = iconSourcePath == null
        ? null
        : await _icons.save(iconSourcePath);
    final String? previous;
    try {
      previous = await _partners.replaceIcon(id, iconFile);
    } on Object {
      if (iconFile != null) await _icons.delete(iconFile);
      rethrow;
    }
    if (previous != null) await _icons.delete(previous);
  }

  /// チェキ代の記録がない相手を削除し、画像のファイルも消す。
  Future<void> delete(Partner partner) async {
    if (partner.chekiCount > 0) throw const PartnerInUseException();
    final iconFile = await _partners.delete(partner.id);
    if (iconFile != null) await _icons.delete(iconFile);
  }

  /// どの相手からも参照されていない画像を消す。
  Future<void> cleanUpIcons() async =>
      _icons.deleteUnreferenced(await _partners.referencedIconFiles());

  PartnerDraft _validated(PartnerDraft draft) {
    final name = draft.name.trim();
    if (name.isEmpty) throw const InvalidInputException(InputField.name);
    final group = draft.groupName?.trim();
    return PartnerDraft(
      name: name,
      groupName: group == null || group.isEmpty ? null : group,
    );
  }
}
