import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:unec_assistant/presentation/components/lists/labels.dart';
import 'package:unec_assistant/presentation/providers/theme_provider.dart';
import 'package:unec_assistant/presentation/theme/app_colors.dart';
import 'package:unec_assistant/providers/student_profile_provider.dart';
import 'package:unec_assistant/utils/app_toast.dart';

class ShareProfileScreen extends ConsumerWidget {
  const ShareProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(studentProfileProvider);
    final shareText = profile.toShareableText();
    final appColors = ref.watch(appColorsProvider);

    return Scaffold(
      backgroundColor: appColors.background,
      appBar: CustomAppBar(
        title: 'Share profile',
        onBackTap: () => context.pop(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Summary Card
            _buildSummaryCard(profile, appColors),
            const SizedBox(height: 25),

            // Generated Text Card
            _buildGeneratedTextCard(context, shareText, appColors),
            const SizedBox(height: 25),

            const SectionLabel('ALSO SHARE VIA'),
            const SizedBox(height: 12),

            // Share Actions Card
            _buildShareActionsCard(context, shareText, appColors),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(dynamic profile, AppColors appColors) {
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
                  '${profile.groupCode} ·',
                  style: GoogleFonts.redditSans(
                    fontSize: 14,
                    color: appColors.textSecondary,
                  ),
                ),
                Text(
                  profile.year,
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

  Widget _buildGeneratedTextCard(
      BuildContext context, String text, AppColors appColors) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: appColors.cardBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: appColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'GENERATED TEXT',
                style: GoogleFonts.redditSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: appColors.textSecondary,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: text));
                  AppToast.show(context, 'Copied to clipboard!');
                },
                behavior: HitTestBehavior.opaque,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: appColors.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Copy',
                    style: GoogleFonts.redditSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: appColors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            text,
            style: GoogleFonts.redditSans(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: appColors.textPrimary,
              height: 1.8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShareActionsCard(
      BuildContext context, String text, AppColors appColors) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: appColors.cardBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: appColors.borderColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildShareIcon(
            context,
            'WhatsApp',
            SvgPicture.asset(
              'assets/icons/whatsapp.svg',
              width: 28,
              height: 28,
            ),
            const Color(0xFF25D366).withValues(alpha: 0.15),
            appColors,
          ),
          _buildShareIcon(
            context,
            'Email',
            Icon(
              Icons.email_outlined,
              color: appColors.primary,
              size: 28,
            ),
            appColors.primaryContainer,
            appColors,
          ),
          _buildShareIcon(
            context,
            'Copy',
            Icon(Icons.copy_rounded, color: appColors.textPrimary, size: 28),
            appColors.iconBoxArrowBg,
            appColors,
          ),
          _buildShareIcon(
            context,
            'More',
            Icon(
              Icons.share_outlined,
              color: appColors.warningOnContainer,
              size: 28,
            ),
            appColors.warningContainer,
            appColors,
          ),
        ],
      ),
    );
  }

  Widget _buildShareIcon(
    BuildContext context,
    String label,
    Widget icon,
    Color bgColor,
    AppColors appColors,
  ) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            if (label == 'Copy') {
              Clipboard.setData(ClipboardData(text: 'Mock profile text...'));
            }
            AppToast.show(context, 'Sharing via $label...');
          },
          behavior: HitTestBehavior.opaque,
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(child: icon),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.redditSans(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: appColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

