import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unec_assistant/providers/theme_provider.dart';
import 'package:unec_assistant/providers/locale_provider.dart';
import 'package:unec_assistant/presentation/theme/app_colors.dart';

class GeneralDrawer extends ConsumerWidget {
  const GeneralDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColors = ref.watch(appColorsProvider);
    final tr = ref.watch(strProvider);

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.85,
      backgroundColor: appColors.background,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 30, 24, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tr.drawerTitle,
                    style: GoogleFonts.redditSans(
                      fontWeight: FontWeight.w800,
                      fontSize: 24,
                      color: appColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tr.drawerSubtitle,
                    style: GoogleFonts.redditSans(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: appColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: appColors.divider),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 12,
                ),
                children: [
                  _SectionHeader(
                    label: tr.drawerSectionNewsSocial,
                    icon: Icons.campaign_rounded,
                    appColors: appColors,
                  ),
                  _MenuTile(
                    label: tr.drawerNewsFeed,
                    icon: Icons.newspaper_rounded,
                    route: '/feed',
                    appColors: appColors,
                  ),
                  _MenuTile(
                    label: tr.drawerCreatePost,
                    icon: Icons.add_box_outlined,
                    route: '/feed/create-post',
                    appColors: appColors,
                  ),
                  _MenuTile(
                    label: tr.drawerManageChannels,
                    icon: Icons.settings_input_component_rounded,
                    route: '/feed/manage-channels',
                    appColors: appColors,
                  ),
                  const SizedBox(height: 20),
                  _SectionHeader(
                    label: tr.drawerSectionAcademic,
                    icon: Icons.school_rounded,
                    appColors: appColors,
                  ),
                  _MenuTile(
                    label: tr.drawerAttendance,
                    icon: Icons.rule_rounded,
                    route: '/functions/attendance_function',
                    appColors: appColors,
                  ),
                  _MenuTile(
                    label: tr.drawerWeeklySchedule,
                    icon: Icons.calendar_today_rounded,
                    route: '/functions/schedule_function',
                    appColors: appColors,
                  ),
                  _MenuTile(
                    label: tr.drawerCurrentClass,
                    icon: Icons.class_rounded,
                    route: '/functions/current_class_function',
                    appColors: appColors,
                  ),
                  _MenuTile(
                    label: tr.drawerAllGrades,
                    icon: Icons.grade_rounded,
                    route: '/functions/grades',
                    appColors: appColors,
                  ),
                  _MenuTile(
                    label: tr.drawerGradeCalculator,
                    icon: Icons.calculate_rounded,
                    route: '/functions/grades/calculator',
                    appColors: appColors,
                  ),
                  const SizedBox(height: 20),
                  _SectionHeader(
                    label: tr.drawerSectionMaterials,
                    icon: Icons.menu_book_rounded,
                    appColors: appColors,
                  ),
                  _MenuTile(
                    label: tr.drawerSubjects,
                    icon: Icons.subject_rounded,
                    route: '/functions/subjects',
                    appColors: appColors,
                  ),
                  _MenuTile(
                    label: tr.drawerTeachingMaterials,
                    icon: Icons.folder_shared_rounded,
                    route: '/functions/teaching-materials',
                    appColors: appColors,
                  ),
                  _MenuTile(
                    label: tr.drawerSmartSync,
                    icon: Icons.sync_rounded,
                    route: '/functions/teaching-materials/smart-sync',
                    appColors: appColors,
                  ),
                  _MenuTile(
                    label: tr.drawerNotes,
                    icon: Icons.note_alt_rounded,
                    route: '/notes',
                    appColors: appColors,
                  ),
                  const SizedBox(height: 20),
                  _SectionHeader(
                    label: tr.drawerSectionAccount,
                    icon: Icons.person_rounded,
                    appColors: appColors,
                  ),
                  _MenuTile(
                    label: tr.drawerMyProfile,
                    icon: Icons.account_circle_rounded,
                    route: '/profile',
                    appColors: appColors,
                  ),
                  _MenuTile(
                    label: tr.drawerStudentIdCard,
                    icon: Icons.badge_rounded,
                    route: '/profile/student_card',
                    appColors: appColors,
                  ),
                  _MenuTile(
                    label: tr.drawerAcademicProfile,
                    icon: Icons.history_edu_rounded,
                    route: '/profile/academic_profile',
                    appColors: appColors,
                  ),
                  _MenuTile(
                    label: tr.drawerSecurityPassword,
                    icon: Icons.lock_person_rounded,
                    route: '/profile/change_pass',
                    appColors: appColors,
                  ),
                  _MenuTile(
                    label: tr.drawerShareProfile,
                    icon: Icons.share_rounded,
                    route: '/profile/share_profile',
                    appColors: appColors,
                  ),
                  _MenuTile(
                    label: tr.drawerAboutApp,
                    icon: Icons.info_outline_rounded,
                    route: '/profile/about',
                    appColors: appColors,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  final IconData icon;
  final AppColors appColors;

  const _SectionHeader({
    required this.label,
    required this.icon,
    required this.appColors,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: appColors.primary.withValues(alpha: 0.8)),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.redditSans(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: appColors.textSecondary,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final String route;
  final AppColors appColors;

  const _MenuTile({
    required this.label,
    required this.icon,
    required this.route,
    required this.appColors,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        context.go(route);
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            Icon(icon, color: appColors.primary, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.redditSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: appColors.textPrimary,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 18,
              color: appColors.borderColor,
            ),
          ],
        ),
      ),
    );
  }
}
