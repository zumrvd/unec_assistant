import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:unec_assistant/presentation/components/lists/labels.dart';
import 'package:unec_assistant/presentation/providers/theme_provider.dart';
import 'package:unec_assistant/presentation/theme/app_colors.dart';
import 'package:unec_assistant/providers/student_profile_provider.dart';

class AcademicProfileScreen extends ConsumerWidget {
  const AcademicProfileScreen({super.key});

  static const _buttonGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0569FF), Color(0xCC0569FF), Color(0xFF035CE1)],
    stops: [0.0, 0.5, 1.0],
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(studentProfileProvider);
    final appColors = ref.watch(appColorsProvider);

    return Scaffold(
      backgroundColor: appColors.background,
      appBar: CustomAppBar(
        title: 'Academic profile',
        onBackTap: () => context.pop(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
        child: Column(
          children: [
            // Card 1: Student Name + Status
            _buildMainInfoCard(profile, appColors),
            const SizedBox(height: 16),

            // Card 2: Academic Information
            _buildInfoCard(
              icon: Icons.menu_rounded,
              iconColor: appColors.primary,
              iconBgColor: appColors.primaryContainer,
              title: 'Academic information',
              appColors: appColors,
              rows: [
                _buildInfoRow('Faculty', profile.faculty, appColors),
                _buildInfoRow('Major', profile.major, appColors),
                _buildInfoRow('Year', profile.year, appColors),
                _buildInfoRow('Enrolled', profile.enrollmentDate, appColors),
              ],
            ),
            const SizedBox(height: 16),

            // Card 3: Academic Standing
            _buildInfoCard(
              icon: Icons.star_rounded,
              iconColor: appColors.success,
              iconBgColor: appColors.success.withValues(alpha: 0.15),
              title: 'Academic standing',
              appColors: appColors,
              rows: [
                _buildInfoRow(
                  'Cumulative GPA',
                  '${profile.gpa.toStringAsFixed(2)} / 100.00',
                  appColors,
                  isBoldValue: true,
                  valueColor: appColors.success,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Card 4: Club Memberships
            _buildInfoCard(
              icon: Icons.person_rounded,
              iconColor: appColors.notificationPurple,
              iconBgColor: appColors.notificationPurpleContainer,
              title: 'Club memberships',
              appColors: appColors,
              rows: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  child: Center(
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 10,
                      alignment: WrapAlignment.center,
                      children: profile.clubMemberships
                          .map((club) => _buildClubBadge(club, appColors))
                          .toList(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Share Button
            _buildShareButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMainInfoCard(dynamic profile, AppColors appColors) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: appColors.cardBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: appColors.borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: appColors.primaryContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                profile.initials,
                style: GoogleFonts.redditSans(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: appColors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        profile.studentName,
                        style: GoogleFonts.redditSans(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: appColors.textPrimary,
                        ),
                      ),
                    ),
                    if (profile.isActive)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: appColors.success.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: appColors.success.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          'Active',
                          style: GoogleFonts.redditSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: appColors.success,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'ID:',
                  style: GoogleFonts.redditSans(
                    fontSize: 14,
                    color: appColors.textSecondary,
                  ),
                ),
                Text(
                  profile.studentId,
                  style: GoogleFonts.redditSans(
                    fontSize: 14,
                    color: appColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required List<Widget> rows,
    required AppColors appColors,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: appColors.cardBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: appColors.borderColor),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: GoogleFonts.redditSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: appColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: appColors.divider),
          ...rows,
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value,
    AppColors appColors, {
    bool isBoldValue = false,
    Color? valueColor,
    bool showLabel = true,
    bool isCenterValue = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: showLabel
            ? MainAxisAlignment.spaceBetween
            : MainAxisAlignment.center,
        children: [
          if (showLabel)
            Text(
              label,
              style: GoogleFonts.redditSans(
                fontSize: 14,
                color: appColors.textSecondary,
              ),
            ),
          Expanded(
            child: Text(
              value,
              textAlign: isCenterValue ? TextAlign.start : TextAlign.end,
              style: GoogleFonts.redditSans(
                fontSize: 14,
                fontWeight: isBoldValue ? FontWeight.w700 : FontWeight.w600,
                color: valueColor ?? appColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClubBadge(String club, AppColors appColors) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: appColors.notificationPurpleContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: appColors.notificationPurple.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.stars_rounded, size: 14, color: appColors.notificationPurple),
          const SizedBox(width: 6),
          Text(
            club,
            style: GoogleFonts.redditSans(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: appColors.notificationPurple,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShareButton(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/profile/share_profile'),
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 90,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: _buttonGradient,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFF0569FF), width: 1.5),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FC).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.share_rounded,
                size: 28,
                color: Color(0xFFF8F9FC),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Share student profile',
                    style: GoogleFonts.redditSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFF8F9FC),
                    ),
                  ),
                  Text(
                    'Generate a clean shareable text',
                    style: GoogleFonts.redditSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFFF8F9FC).withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_right_rounded,
              color: Color(0xFFF8F9FC),
              size: 30,
            ),
          ],
        ),
      ),
    );
  }
}

