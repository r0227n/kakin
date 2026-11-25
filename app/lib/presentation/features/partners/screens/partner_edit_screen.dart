import 'dart:async';

import 'package:app/application/application.dart';
import 'package:app/core/formatting/kakin_formats.dart';
import 'package:app/core/gen/slang.g.dart';
import 'package:app/presentation/dependencies/application_providers.dart';
import 'package:app/presentation/shared/controllers/local_data.dart';
import 'package:app/presentation/shared/feedback/action_feedback.dart';
import 'package:app/presentation/shared/keys/app_keys.dart';
import 'package:app/presentation/shared/widgets/common_widgets.dart';
import 'package:app/presentation/shared/widgets/visuals.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// チェキ相手の登録と編集。登録したら相手の ID を返して閉じる。
class PartnerEditScreen extends ConsumerStatefulWidget {
  /// [partnerId] があれば編集する。
  const PartnerEditScreen({this.partnerId, super.key});

  /// 編集する相手。
  final int? partnerId;

  @override
  ConsumerState<PartnerEditScreen> createState() => _PartnerEditScreenState();
}

class _PartnerEditScreenState extends ConsumerState<PartnerEditScreen> {
  final _name = TextEditingController();
  final _group = TextEditingController();
  bool _loaded = false;
  bool _saving = false;
  bool _showErrors = false;

  /// 登録前に選んだ画像。編集では選んだ時点で保存する。
  String? _pendingIcon;

  bool get _isEditing => widget.partnerId != null;

  @override
  void dispose() {
    _name.dispose();
    _group.dispose();
    super.dispose();
  }

  void _fill(Partner partner) {
    if (_loaded) return;
    _loaded = true;
    _name.text = partner.name;
    _group.text = partner.groupName ?? '';
  }

  Future<void> _pickIcon(PartnerIconSource source) async {
    final useCase = ref.read(partnerUseCaseProvider);
    final path = await runWithFeedback(
      context,
      ref,
      () => useCase.pickIcon(source),
      failureLog: 'Picking a partner icon failed',
    );
    if (path == null || !mounted) return;
    if (!_isEditing) {
      setState(() => _pendingIcon = path);
      return;
    }
    await runWithFeedback(
      context,
      ref,
      () => useCase.replaceIcon(widget.partnerId!, path),
      failureLog: 'Saving a partner icon failed',
    );
  }

  Future<void> _removeIcon() async {
    if (!_isEditing) {
      setState(() => _pendingIcon = null);
      return;
    }
    await runWithFeedback(
      context,
      ref,
      () =>
          ref.read(partnerUseCaseProvider).replaceIcon(widget.partnerId!, null),
      failureLog: 'Removing a partner icon failed',
    );
  }

  Future<void> _chooseSource() async {
    final t = Translations.of(context);
    final source = await showModalBottomSheet<PartnerIconSource>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              key: AppKeys.iconSourceCamera,
              leading: const Icon(Icons.photo_camera_outlined),
              title: Text(t.partner.camera),
              onTap: () => Navigator.pop(context, PartnerIconSource.camera),
            ),
            ListTile(
              key: AppKeys.iconSourceGallery,
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(t.partner.gallery),
              onTap: () => Navigator.pop(context, PartnerIconSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source == null || !mounted) return;
    await _pickIcon(source);
  }

  Future<void> _save() async {
    if (_name.text.trim().isEmpty) {
      setState(() => _showErrors = true);
      return;
    }
    setState(() => _saving = true);
    final useCase = ref.read(partnerUseCaseProvider);
    final draft = PartnerDraft(name: _name.text, groupName: _group.text);
    final id = await runWithFeedback(
      context,
      ref,
      () async {
        if (_isEditing) {
          await useCase.update(widget.partnerId!, draft);
          return widget.partnerId!;
        }
        return useCase.create(draft, iconSourcePath: _pendingIcon);
      },
      failureLog: 'Saving a partner failed',
    );
    if (!mounted) return;
    setState(() => _saving = false);
    if (id != null) context.pop(id);
  }

  Future<void> _delete(Partner partner) async {
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
        await ref.read(partnerUseCaseProvider).delete(partner);
        return true;
      },
      failureLog: 'Deleting a partner failed',
    );
    if ((deleted ?? false) && mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final palette = context.palette;
    final loadedPartners = ref.watch(partnersProvider);
    final partners = loadedPartners.value;
    final partner = _isEditing
        ? partners?.where((p) => p.id == widget.partnerId).firstOrNull
        : null;
    if (partner != null) _fill(partner);
    final iconPath = _isEditing
        ? (partner == null
              ? null
              : ref.read(partnerUseCaseProvider).iconPathOf(partner))
        : _pendingIcon;
    final loading = _isEditing && partner == null;
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? t.partner.editTitle : t.partner.newTitle),
      ),
      bottomNavigationBar: BottomActionBar(
        child: FilledButton(
          key: AppKeys.partnerSave,
          onPressed: _saving || loading ? null : _save,
          child: Text(_isEditing ? t.common.save : t.partner.createAndSelect),
        ),
      ),
      body: loading
          ? Center(
              child: loadedPartners.hasError
                  ? Text(t.errors.recordStorage)
                  : const CircularProgressIndicator(),
            )
          : ListView(
              padding: const EdgeInsets.all(AppSpacing.m),
              children: [
                Text(
                  _isEditing ? t.partner.icon : t.partner.iconOptional,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.s),
                Row(
                  spacing: AppSpacing.m,
                  children: [
                    PartnerAvatar(
                      key: ValueKey(iconPath),
                      name: _name.text,
                      imagePath: iconPath,
                      toneIndex: widget.partnerId ?? 0,
                      size: 72,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: AppSpacing.xs,
                        children: [
                          Wrap(
                            spacing: AppSpacing.s,
                            children: [
                              OutlinedButton(
                                key: AppKeys.partnerPickIcon,
                                onPressed: _chooseSource,
                                child: Text(
                                  iconPath == null
                                      ? t.partner.pickImage
                                      : t.partner.changeImage,
                                ),
                              ),
                              if (iconPath != null)
                                TextButton(
                                  key: AppKeys.partnerRemoveIcon,
                                  onPressed: _removeIcon,
                                  child: Text(t.partner.removeImage),
                                ),
                            ],
                          ),
                          Text(
                            '${t.partner.iconNote}\n${t.partner.iconLocal}',
                            style: TextStyle(
                              fontSize: 11,
                              color: palette.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.l),
                TextField(
                  key: AppKeys.partnerNameField,
                  controller: _name,
                  autofocus: !_isEditing,
                  maxLength: 50,
                  textInputAction: TextInputAction.next,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    labelText: t.partner.name,
                    counterText: '',
                    errorText: _showErrors && _name.text.trim().isEmpty
                        ? t.partner.nameRequired
                        : null,
                  ),
                ),
                const SizedBox(height: AppSpacing.m),
                TextField(
                  key: AppKeys.partnerGroupField,
                  controller: _group,
                  maxLength: 50,
                  decoration: InputDecoration(
                    labelText: t.partner.group,
                    helperText: t.partner.groupHint,
                    counterText: '',
                  ),
                ),
                if (partner != null) ...[
                  const SizedBox(height: AppSpacing.l),
                  SectionHeader(title: t.partner.records),
                  const SizedBox(height: AppSpacing.s),
                  SurfaceCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: AppSpacing.xs,
                      children: partner.chekiCount == 0
                          ? [Text(t.partner.noRecords)]
                          : [
                              Text(
                                t.partner.stats(
                                  count: partner.chekiCount,
                                  shots: partner.shotTotal,
                                ),
                                style: AppTypography.numeric(fontSize: 14),
                              ),
                              if (partner.firstShotOn != null &&
                                  partner.lastShotOn != null)
                                Text(
                                  t.partner.history(
                                    first: KakinFormats.fullDate(
                                      partner.firstShotOn!.asDateTime,
                                    ),
                                    last: KakinFormats.fullDate(
                                      partner.lastShotOn!.asDateTime,
                                    ),
                                  ),
                                  style: AppTypography.numeric(
                                    fontSize: 12,
                                    color: palette.textSecondary,
                                  ),
                                ),
                            ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  OutlinedButton.icon(
                    key: AppKeys.partnerDelete,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: palette.negative,
                    ),
                    onPressed: partner.chekiCount > 0
                        ? null
                        : () => _delete(partner),
                    icon: const Icon(Icons.delete_outline),
                    label: Text(t.partner.delete),
                  ),
                  if (partner.chekiCount > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.xs),
                      child: Text(
                        t.partner.inUse,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: palette.textSecondary,
                        ),
                      ),
                    ),
                ],
              ],
            ),
    );
  }
}
