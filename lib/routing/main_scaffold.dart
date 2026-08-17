/// Zümrüd Verdiyeva Elşad qızı.
/// UNEC İnformasiya Texnologiyaları 1-ci kurs.
/// 2026-ci ildə UNEC Asisstant programını düzəltməyə başladım.
/// həmin ilin iyun ayında Rektor Cəfərov Elman və UNEC Extern mərkəzindən programı rəsmiləşdirmək üçün icazə aldım.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:unec_assistant/presentation/components/drawer/subscribed_channels_drawer.dart';
import 'package:unec_assistant/presentation/components/drawer/general_drawer.dart';
import 'package:unec_assistant/presentation/providers/theme_provider.dart';
import 'package:unec_assistant/providers/notification_provider.dart';
import 'package:unec_assistant/presentation/components/dialogs/profile_pop_up.dart';

/// Static global top bar — fixed across all shell branch transitions.
class GlobalAppBar extends ConsumerWidget {
  const GlobalAppBar({super.key});

  static const double _contentHeight = 80.0;
  static const double _avatarSize = 50.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColors = ref.watch(appColorsProvider);
    final int unreadCount = ref.watch(unreadNotificationsCountProvider);
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Container(
      height: _contentHeight + statusBarHeight,
      color: appColors.background,
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
                  behavior: HitTestBehavior.opaque,
                  child: Icon(Icons.menu, color: appColors.textPrimary, size: 30),
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: Text.rich(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'UNEC ',
                          style: GoogleFonts.redditSans(
                            color: appColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        TextSpan(
                          text: 'Assistant',
                          style: GoogleFonts.redditSans(
                            color: appColors.textPrimary,
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
              GestureDetector(
                onTap: () => context.push('/home/notifications-wall'),
                behavior: HitTestBehavior.opaque,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(
                      unreadCount > 0
                          ? Icons.notifications_active_rounded
                          : Icons.notifications_none_rounded,
                      color: appColors.primary,
                      size: 30,
                    ),
                    if (unreadCount > 0)
                      Positioned(
                        right: -2,
                        top: -2,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: appColors.badgeRed,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            unreadCount > 9 ? '9+' : unreadCount.toString(),
                            style: GoogleFonts.redditSans(
                              color: appColors.textInverse,
                              fontSize: 8,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () => _showProfilePopUp(context),
                behavior: HitTestBehavior.opaque,
                child: Container(
                  width: _avatarSize,
                  height: _avatarSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: appColors.primary.withValues(alpha: 0.15),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Z.V',
                    style: GoogleFonts.redditSans(
                      color: appColors.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () => _showMorePopUp(context, ref),
                behavior: HitTestBehavior.opaque,
                child: Icon(Icons.more_horiz, color: appColors.textPrimary, size: 30),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showProfilePopUp(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) => const ProfilePopUp(),
    );
  }

  void _showMorePopUp(BuildContext context, WidgetRef ref) {
    final appColors = ref.read(appColorsProvider);
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Navigator.of(context).overlay!.context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset(button.size.width, 80), ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero),
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    showMenu(
      context: context,
      position: position,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: appColors.borderColor, width: 1),
      ),
      elevation: 0,
      color: appColors.surface,
      items: [
        PopupMenuItem(
          onTap: () {},
          child: Row(
            children: [
              Icon(Icons.help_outline_rounded,
                  size: 20, color: appColors.textPrimary),
              const SizedBox(width: 12),
              Text(
                'Need help?',
                style: GoogleFonts.redditSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: appColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          onTap: () {},
          child: Row(
            children: [
              Icon(Icons.bug_report_outlined,
                  size: 20, color: appColors.textPrimary),
              const SizedBox(width: 12),
              Text(
                'Report a bug',
                style: GoogleFonts.redditSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: appColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class MainScaffold extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final appColors = ref.watch(appColorsProvider);
    final bool isFeedBranch = navigationShell.currentIndex == 2;

    return Scaffold(
      backgroundColor: appColors.background,
      drawer: isFeedBranch
          ? const SubscribedChannelsDrawer()
          : const GeneralDrawer(),
      body: Column(
        children: [
          const GlobalAppBar(),
          Expanded(child: navigationShell),
        ],
      ),
      bottomNavigationBar: Container(
        color: appColors.background,
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
                    -1.0 +
                        (navigationShell.currentIndex *
                            (2.0 / (_navItems.length - 1))),
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
                          color: appColors.primary.withValues(alpha: 0.15),
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

class NavBarItem extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final appColors = ref.watch(appColorsProvider);
    final color = active ? appColors.navActive : appColors.navInactive;

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
