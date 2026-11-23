import 'package:app/core/gen/slang.g.dart';
import 'package:app/presentation/shared/keys/app_keys.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 画面下部の4つのタブ。
class AppShell extends StatelessWidget {
  /// タブごとの Navigator を保つ [navigationShell] を表示する。
  const AppShell({required this.navigationShell, super.key});

  /// 現在のタブと各タブの Navigator。
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Theme.of(context).dividerColor),
          ),
        ),
        child: NavigationBar(
          key: AppKeys.mainTabs,
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: (index) => navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          ),
          destinations: [
            NavigationDestination(
              key: AppKeys.tabCalendar,
              icon: const Icon(Icons.calendar_month_outlined),
              selectedIcon: const Icon(Icons.calendar_month),
              label: t.tabs.calendar,
            ),
            NavigationDestination(
              key: AppKeys.tabList,
              icon: const Icon(Icons.format_list_bulleted),
              label: t.tabs.list,
            ),
            NavigationDestination(
              key: AppKeys.tabUpcoming,
              icon: const Icon(Icons.confirmation_number_outlined),
              selectedIcon: const Icon(Icons.confirmation_number),
              label: t.tabs.upcoming,
            ),
            NavigationDestination(
              key: AppKeys.tabSettings,
              icon: const Icon(Icons.tune),
              label: t.tabs.settings,
            ),
          ],
        ),
      ),
    );
  }
}
