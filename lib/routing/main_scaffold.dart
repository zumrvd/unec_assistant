/// Zümrüd Verdiyeva Elşad qızı.
/// UNEC İnformasiya Texnologiyaları 1-ci kurs.
/// 2026-ci ildə UNEC Asisstant programını düzəltməyə başladım.
/// həmin ilin iyun ayında Rektor Cəfərov Elman və UNEC Extern mərkəzindən programı rəsmiləşdirmək üçün icazə aldım.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:unec_assistant/presentation/components/drawer/subscribed_channels_drawer.dart';

/// Figma palette shared by the global app bar and nav indicator.
abstract final class _AppColors {
  static const Color background = Color(0xFFF8F9FC);
  static const Color blue = Color(0xFF0569FF);
  static const Color black = Color(0xFF1F1F1F);
  static const Color inactive = Color(0xFF838A97);
}

/// Static global top bar — fixed across all shell branch transitions.
class GlobalAppBar extends StatelessWidget {
  const GlobalAppBar({super.key});

  static const double _contentHeight = 80.0;
  static const double _avatarSize = 50.0;

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Container(
      height: _contentHeight + statusBarHeight,
      color: _AppColors.background,
      padding: EdgeInsets.only(
        top: statusBarHeight,
        left: 20.0,
        right: 20.0,
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Scaffold.of(context).openDrawer(),
                  child: const Icon(Icons.menu, color: _AppColors.black, size: 30),
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: Text.rich(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    TextSpan(
                      children: const [
                        TextSpan(
                          text: 'UNEC ',
                          style: TextStyle(
                            color: _AppColors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        TextSpan(
                          text: 'Assistant',
                          style: TextStyle(
                            color: _AppColors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.notifications_none_rounded,
                color: _AppColors.blue,
                size: 30,
              ),
              const SizedBox(width: 10),
              Container(
                width: _avatarSize,
                height: _avatarSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _AppColors.blue.withValues(alpha: 0.15),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'U',
                  style: TextStyle(
                    color: _AppColors.blue,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const Icon(Icons.more_horiz, color: _AppColors.black, size: 30),
            ],
          ),
        ],
      ),
    );
  }
}

class MainScaffold extends StatelessWidget {
  const MainScaffold({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  static const _navItems = [
    (icon: Icons.home_rounded, label: 'Home'),
    (icon: Icons.school_rounded, label: 'Functions'),
    (icon: Icons.newspaper_outlined, label: 'Feed'),
    (icon: Icons.account_circle_outlined, label: 'Profile'),
  ];

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SubscribedChannelsDrawer(),
      body: Column(
        children: [
          const GlobalAppBar(),
          Expanded(child: navigationShell),
        ],
      ),
      bottomNavigationBar: Container(
        color: _AppColors.background,
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: SafeArea(
          child: SizedBox(
            height: 80.0,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Sliding indicator pill
                AnimatedAlign(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOutCubic,
                  alignment: Alignment(
                    -1.0 + (navigationShell.currentIndex * (2.0 / (_navItems.length - 1))),
                    0.0,
                  ),
                  child: FractionallySizedBox(
                    widthFactor: 1 / _navItems.length,
                    child: Center(
                      child: Container(
                        width: 50.0,
                        height: 50.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _AppColors.blue.withValues(alpha: 0.15),
                        ),
                      ),
                    ),
                  ),
                ),
                // Navigation items
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    for (var (index, item) in _navItems.indexed)
                      Expanded(
                        child: NavBarItem(
                          index: index,
                          active: navigationShell.currentIndex == index,
                          icon: item.icon,
                          label: item.label,
                          onTap: _onTap,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NavBarItem extends StatelessWidget {
  static const Color _activeColor = _AppColors.blue;
  static const Color _inactiveColor = _AppColors.inactive;

  final int index;
  final bool active;
  final IconData icon;
  final String label;
  final void Function(int) onTap;

  const NavBarItem({
    super.key,
    required this.index,
    required this.active,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = active ? _activeColor : _inactiveColor;

    return Semantics(
      label: label,
      selected: active,
      container: true,
      button: true,
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.linear,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 30.0,
                color: color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
