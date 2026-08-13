import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:unec_assistant/presentation/components/lists/labels.dart';
import 'package:unec_assistant/providers/student_profile_provider.dart';

class AcademicProfileScreen extends ConsumerWidget {
  const AcademicProfileScreen({super.key});

  static const _buttonGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0569FF),
      Color(0xCC0569FF),
      Color(0xFF035CE1),
    ],
    stops: [0.0, 0.5, 1.0],
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(studentProfileProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: CustomAppBar(
        title: 'Academic profile',
        onBackTap: () => context.pop(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
        child: Column(
          children: [
            // Card 1: Student Name + Status
            _buildMainInfoCard(profile),
            const SizedBox(height: 16),

            // Card 2: Academic Information
            _buildInfoCard(
              icon: Icons.menu_rounded,
              iconColor: const Color(0xFF0569FF),
              iconBgColor: const Color(0xFFEEF4FF),
              title: 'Academic information',
              rows: [
                _buildInfoRow('Faculty', profile.faculty),
                _buildInfoRow('Major', profile.major),
                _buildInfoRow('Year', profile.year),
                _buildInfoRow('Enrolled', profile.enrollmentDate),
              ],
            ),
            const SizedBox(height: 16),

            // Card 3: Academic Standing
            _buildInfoCard(
              icon: Icons.star_rounded,
              iconColor: const Color(0xFF0F6E56),
              iconBgColor: const Color(0xFFE7F4F0),
              title: 'Academic standing',
              rows: [
                _buildInfoRow('Cumulative GPA', '${profile.gpa.toStringAsFixed(2)} / 100.00', isBoldValue: true, valueColor: const Color(0xFF6E8E15)),
              ],
            ),
            const SizedBox(height: 16),

            // Card 4: Club Memberships
            _buildInfoCard(
              icon: Icons.person_rounded,
              iconColor: const Color(0xFF5E5CE6),
              iconBgColor: const Color(0xFFF0F0FF),
              title: 'Club memberships',
              rows: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: Center(
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 10,
                      alignment: WrapAlignment.center,
                      children: profile.clubMemberships.map((club) => _buildClubBadge(club)).toList(),
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

  Widget _buildMainInfoCard(dynamic profile) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE0E4F0)),
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFEEF4FF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                profile.initials,
                style: GoogleFonts.redditSans(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF0569FF),
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
                          color: const Color(0xFF1E1E1E),
                        ),
                      ),
                    ),
                    if (profile.isActive)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE7F4F0),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF6E8E15).withOpacity(0.2)),
                        ),
                        child: Text(
                          'Active',
                          style: GoogleFonts.redditSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF6E8E15),
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
                    color: const Color(0xFF838A97),
                  ),
                ),
                Text(
                  profile.studentId,
                  style: GoogleFonts.redditSans(
                    fontSize: 14,
                    color: const Color(0xFF838A97).withOpacity(0.6),
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
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE0E4F0)),
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
                    color: const Color(0xFF1E1E1E),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE0E4F0)),
          ...rows,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {
    bool isBoldValue = false, 
    Color? valueColor, 
    bool showLabel = true,
    bool isCenterValue = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: showLabel ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
        children: [
          if (showLabel)
            Text(
              label,
              style: GoogleFonts.redditSans(
                fontSize: 14,
                color: const Color(0xFF838A97).withOpacity(0.6),
              ),
            ),
          Expanded(
            child: Text(
              value,
              textAlign: isCenterValue ? TextAlign.start : TextAlign.end,
              style: GoogleFonts.redditSans(
                fontSize: 14,
                fontWeight: isBoldValue ? FontWeight.w700 : FontWeight.w600,
                color: valueColor ?? const Color(0xFF1E1E1E),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClubBadge(String club) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF5E5CE6).withOpacity(0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.stars_rounded, size: 14, color: Color(0xFF5E5CE6)),
          const SizedBox(width: 6),
          Text(
            club,
            style: GoogleFonts.redditSans(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF5E5CE6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShareButton(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/profile/share_profile'),
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
                color: const Color(0xFFF8F9FC).withOpacity(0.15),
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
                      color: const Color(0xFFF8F9FC).withOpacity(0.6),
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
