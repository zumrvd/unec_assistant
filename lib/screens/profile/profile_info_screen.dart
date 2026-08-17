import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:unec_assistant/presentation/components/lists/labels.dart';
import 'package:unec_assistant/presentation/providers/theme_provider.dart';
import 'package:unec_assistant/presentation/theme/app_colors.dart';
import 'package:unec_assistant/providers/current_user_provider.dart';
import 'package:unec_assistant/providers/user_security_provider.dart';
import 'package:intl/intl.dart';

class ProfileInfoScreen extends ConsumerWidget {
  const ProfileInfoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final security = ref.watch(userSecurityProvider);
    final appColors = ref.watch(appColorsProvider);

    return Scaffold(
      backgroundColor: appColors.background,
      appBar: CustomAppBar(
        title: 'Profile Information',
        onBackTap: () => context.pop(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionLabel('PERSONAL DETAILS'),
            const SizedBox(height: 12),
            _buildInfoCard([
              _buildInfoRow('Full Name', user.displayName, appColors),
              _buildInfoRow('User ID', user.userId, appColors),
              _buildInfoRow('Initials', user.initials, appColors),
            ], appColors),
            
            const SizedBox(height: 25),
            
            const SectionLabel('SECURITY'),
            const SizedBox(height: 12),
            _buildInfoCard([
              _buildInfoRow('Password', '••••••••', appColors),
              _buildInfoRow(
                'Last Updated', 
                security.lastChangeTimestamp != null 
                    ? DateFormat('dd MMM yyyy, HH:mm').format(security.lastChangeTimestamp!)
                    : 'Never',
                appColors,
              ),
              _buildInfoRow('Status', 'Secure', appColors, isSuccess: true),
            ], appColors),
            
            const SizedBox(height: 30),
            
            GestureDetector(
              onTap: () => context.push('/profile/change_pass'),
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: appColors.primary),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Change Password',
                  style: GoogleFonts.redditSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: appColors.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children, AppColors appColors) {
    return Container(
      decoration: BoxDecoration(
        color: appColors.cardBackground,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: appColors.borderColor),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, AppColors appColors, {bool isSuccess = false}) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.redditSans(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: appColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.redditSans(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: isSuccess ? appColors.success : appColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
