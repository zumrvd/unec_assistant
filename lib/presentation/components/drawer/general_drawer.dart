import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class GeneralDrawer extends StatelessWidget {
  const GeneralDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.85,
      backgroundColor: const Color(0xFFF8F9FC),
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
                    'App Directory',
                    style: GoogleFonts.redditSans(
                      fontWeight: FontWeight.w800,
                      fontSize: 24,
                      color: const Color(0xFF1F1F1F),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Quick access to all features',
                    style: GoogleFonts.redditSans(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: const Color(0xFF838A97),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFE0E4F0)),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                children: [
                  _SectionHeader(label: 'NEWS & SOCIAL', icon: Icons.campaign_rounded),
                  _MenuTile(label: 'News Feed', icon: Icons.newspaper_rounded, route: '/feed'),
                  _MenuTile(label: 'Create Post', icon: Icons.add_box_outlined, route: '/feed/create-post'),
                  _MenuTile(label: 'Manage Channels', icon: Icons.settings_input_component_rounded, route: '/feed/manage-channels'),
                  
                  const SizedBox(height: 20),
                  _SectionHeader(label: 'ACADEMIC', icon: Icons.school_rounded),
                  _MenuTile(label: 'Attendance', icon: Icons.rule_rounded, route: '/functions/attendance_function'),
                  _MenuTile(label: 'Weekly Schedule', icon: Icons.calendar_today_rounded, route: '/functions/schedule_function'),
                  _MenuTile(label: 'Current Class', icon: Icons.class_rounded, route: '/functions/current_class_function'),
                  _MenuTile(label: 'All Grades', icon: Icons.grade_rounded, route: '/functions/grades'),
                  _MenuTile(label: 'Grade Calculator', icon: Icons.calculate_rounded, route: '/functions/grades/calculator'),

                  const SizedBox(height: 20),
                  _SectionHeader(label: 'MATERIALS & NOTES', icon: Icons.menu_book_rounded),
                  _MenuTile(label: 'Subjects', icon: Icons.subject_rounded, route: '/functions/subjects'),
                  _MenuTile(label: 'Teaching Materials', icon: Icons.folder_shared_rounded, route: '/functions/teaching-materials'),
                  _MenuTile(label: 'Smart Sync', icon: Icons.sync_rounded, route: '/functions/teaching-materials/smart-sync'),
                  _MenuTile(label: 'Notes', icon: Icons.note_alt_rounded, route: '/notes'),

                  const SizedBox(height: 20),
                  _SectionHeader(label: 'ACCOUNT', icon: Icons.person_rounded),
                  _MenuTile(label: 'My Profile', icon: Icons.account_circle_rounded, route: '/profile'),
                  _MenuTile(label: 'Profile Info', icon: Icons.badge_rounded, route: '/profile/profile_info'),
                  _MenuTile(label: 'Academic Profile', icon: Icons.history_edu_rounded, route: '/profile/academic_profile'),
                  _MenuTile(label: 'Security & Password', icon: Icons.lock_person_rounded, route: '/profile/change_pass'),
                  _MenuTile(label: 'Share Profile', icon: Icons.share_rounded, route: '/profile/share_profile'),
                  _MenuTile(label: 'About App', icon: Icons.info_outline_rounded, route: '/profile/about'),
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

  const _SectionHeader({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: const Color(0xFF0569FF).withOpacity(0.7)),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.redditSans(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF838A97),
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

  const _MenuTile({
    required this.label,
    required this.icon,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      visualDensity: VisualDensity.compact,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      leading: Icon(icon, color: const Color(0xFF0569FF), size: 22),
      title: Text(
        label,
        style: GoogleFonts.redditSans(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF1F1F1F),
        ),
      ),
      trailing: const Icon(Icons.chevron_right_rounded, size: 18, color: Color(0xFFE0E4F0)),
      onTap: () {
        Navigator.pop(context);
        context.go(route);
      },
    );
  }
}
