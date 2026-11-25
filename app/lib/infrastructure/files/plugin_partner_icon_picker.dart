import 'package:app/application/application.dart';
import 'package:app/application/errors/record_error.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

/// `image_picker` で撮影・選択し、`image_cropper` で正方形に切り抜く。
final class PluginPartnerIconPicker implements PartnerIconPicker {
  /// plugin を注入する。省略時は既定の instance を使う。
  PluginPartnerIconPicker({ImagePicker? picker, ImageCropper? cropper})
    : _picker = picker ?? ImagePicker(),
      _cropper = cropper ?? ImageCropper();

  /// 保存する画像の一辺。
  static const iconSize = 512;

  final ImagePicker _picker;
  final ImageCropper _cropper;

  @override
  Future<String?> pick(PartnerIconSource source) async {
    try {
      final picked = await _picker.pickImage(
        source: source == PartnerIconSource.camera
            ? ImageSource.camera
            : ImageSource.gallery,
        maxWidth: 2048,
        maxHeight: 2048,
      );
      if (picked == null) return null;
      final cropped = await _cropper.cropImage(
        sourcePath: picked.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        maxWidth: iconSize,
        maxHeight: iconSize,
        compressQuality: 88,
        uiSettings: [
          AndroidUiSettings(
            lockAspectRatio: true,
            cropStyle: CropStyle.circle,
            hideBottomControls: true,
          ),
          IOSUiSettings(
            aspectRatioLockEnabled: true,
            resetAspectRatioEnabled: false,
            aspectRatioPickerButtonHidden: true,
            cropStyle: CropStyle.circle,
          ),
        ],
      );
      return cropped?.path;
    } on PlatformException catch (error, stackTrace) {
      throw PartnerIconException(cause: error, causeStackTrace: stackTrace);
    }
  }
}
