import 'package:app/application/application.dart';
import 'package:app/core/formatting/kakin_formats.dart';
import 'package:app/core/gen/slang.g.dart';
import 'package:app/presentation/dependencies/application_providers.dart';
import 'package:app/presentation/features/partners/widgets/partner_tile.dart';
import 'package:app/presentation/navigation/routes.dart';
import 'package:app/presentation/shared/controllers/local_data.dart';
import 'package:app/presentation/shared/keys/app_keys.dart';
import 'package:app/presentation/shared/widgets/common_widgets.dart';
import 'package:app/presentation/shared/widgets/visuals.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// チェキ相手を複数選ぶ。決定すると選んだ相手の ID を返す。
class PartnerPickerScreen extends ConsumerStatefulWidget {
  /// [initialSelection] を選んだ状態で開く。
  const PartnerPickerScreen({this.initialSelection = const [], super.key});

  /// 選択済みの相手。
  final List<int> initialSelection;

  @override
  ConsumerState<PartnerPickerScreen> createState() =>
      _PartnerPickerScreenState();
}

class _PartnerPickerScreenState extends ConsumerState<PartnerPickerScreen> {
  late final List<int> _selected = [...widget.initialSelection];
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _toggle(int id) => setState(() {
    if (!_selected.remove(id)) _selected.add(id);
  });

  Future<void> _create() async {
    final id = await const NewPartnerRoute().push<int>(context);
    if (id == null || !mounted) return;
    setState(() {
      if (!_selected.contains(id)) _selected.add(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final palette = context.palette;
    final partners = ref.watch(partnersProvider).value ?? const <Partner>[];
    final useCase = ref.read(partnerUseCaseProvider);
    final query = _search.text.trim().toLowerCase();
    final byId = {for (final p in partners) p.id: p};
    // 最近撮った相手は所属ごとの一覧にも出るため、key は一覧の側だけに付ける。
    List<Widget> tiles(Iterable<Partner> list, {bool keyed = true}) => [
      for (final partner in list)
        PartnerTile(
          key: keyed ? AppKeys.partnerOption(partner.id) : null,
          partner: partner,
          iconPath: useCase.iconPathOf(partner),
          selected: _selected.contains(partner.id),
          subtitle: partner.lastShotOn == null
              ? t.partner.notShotYet
              : t.partner.lastShot(
                  date: KakinFormats.monthDay(partner.lastShotOn!.asDateTime),
                ),
          onTap: () => _toggle(partner.id),
          onEdit: () =>
              EditPartnerRoute(partnerId: partner.id).push<void>(context),
        ),
    ];
    final sections = <Widget>[];
    if (query.isNotEmpty) {
      final matches = partners.where(
        (p) =>
            p.name.toLowerCase().contains(query) ||
            (p.groupName?.toLowerCase().contains(query) ?? false),
      );
      sections.addAll([
        SectionHeader(title: t.partner.searchResults),
        ...tiles(matches),
      ]);
    } else {
      final recent = partners.where((p) => p.lastShotOn != null).toList()
        ..sort((a, b) => b.lastShotOn!.compareTo(a.lastShotOn!));
      if (recent.isNotEmpty) {
        sections.addAll([
          SectionHeader(title: t.partner.recent),
          ...tiles(recent.take(5), keyed: false),
          const SizedBox(height: AppSpacing.m),
        ]);
      }
      final groups = <String, List<Partner>>{};
      for (final partner in partners) {
        final group = partner.groupName;
        groups
            .putIfAbsent(
              group == null || group.isEmpty ? t.partner.noGroup : group,
              () => [],
            )
            .add(partner);
      }
      final names = groups.keys.toList()
        ..sort((a, b) {
          if (a == t.partner.noGroup) return 1;
          if (b == t.partner.noGroup) return -1;
          return a.compareTo(b);
        });
      for (final name in names) {
        sections.addAll([
          SectionHeader(title: name),
          ...tiles(groups[name]!..sort((a, b) => a.name.compareTo(b.name))),
          const SizedBox(height: AppSpacing.m),
        ]);
      }
      if (partners.isEmpty) {
        sections.add(
          Padding(
            padding: const EdgeInsets.all(AppSpacing.m),
            child: Text(
              t.partner.empty,
              textAlign: TextAlign.center,
              style: TextStyle(color: palette.textSecondary),
            ),
          ),
        );
      }
    }
    final selected = [
      for (final id in _selected) ?byId[id],
    ];
    return Scaffold(
      appBar: AppBar(title: Text(t.partner.pickerTitle)),
      bottomNavigationBar: BottomActionBar(
        child: FilledButton(
          key: AppKeys.partnerPickerConfirm,
          onPressed: selected.isEmpty
              ? null
              : () => context.pop([for (final p in selected) p.id]),
          child: Text(
            selected.isEmpty
                ? t.partner.selectPrompt
                : t.partner.confirm(count: selected.length),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.m,
              AppSpacing.s,
              AppSpacing.m,
              AppSpacing.s,
            ),
            child: TextField(
              key: AppKeys.partnerSearch,
              controller: _search,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: t.partner.search,
                prefixIcon: const Icon(Icons.search),
                isDense: true,
              ),
            ),
          ),
          if (selected.isNotEmpty)
            SizedBox(
              height: 44,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
                children: [
                  for (final partner in selected)
                    Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.xs + 2),
                      child: InputChip(
                        label: Text(partner.name),
                        deleteButtonTooltipMessage: t.partner.deselect(
                          name: partner.name,
                        ),
                        onDeleted: () => _toggle(partner.id),
                      ),
                    ),
                ],
              ),
            ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.m,
                AppSpacing.s,
                AppSpacing.m,
                AppSpacing.l,
              ),
              children: [
                ...sections,
                OutlinedButton(
                  key: AppKeys.partnerCreate,
                  onPressed: _create,
                  child: Text(t.partner.createNew),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
