import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:unec_assistant/presentation/components/lists/labels.dart';
import 'package:unec_assistant/providers/student_profile_provider.dart';
import 'package:unec_assistant/utils/app_toast.dart';

class ShareProfileScreen extends ConsumerWidget {
  const ShareProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(studentProfileProvider);
    final shareText = profile.toShareableText();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
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
            _buildSummaryCard(profile),
            const SizedBox(height: 25),

            // Generated Text Card
            _buildGeneratedTextCard(context, shareText),
            const SizedBox(height: 25),

            const SectionLabel('ALSO SHARE VIA'),
            const SizedBox(height: 12),

            // Share Actions Card
            _buildShareActionsCard(context, shareText),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(dynamic profile) {
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE7F4F0),
                          borderRadius: BorderRadius.circular(12),
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
                  '${profile.groupCode} ·',
                  style: GoogleFonts.redditSans(
                    fontSize: 14,
                    color: const Color(0xFF838A97),
                  ),
                ),
                Text(
                  profile.year,
                  style: GoogleFonts.redditSans(
                    fontSize: 14,
                    color: const Color(0xFF838A97).withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGeneratedTextCard(BuildContext context, String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE0E4F0)),
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
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF838A97),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: text));
                  AppToast.show(context, 'Copied to clipboard!');
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF4FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Copy',
                    style: GoogleFonts.redditSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF0569FF),
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
              color: const Color(0xFF1E1E1E),
              height: 1.8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShareActionsCard(BuildContext context, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE0E4F0)),
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
            const Color(0xFFE1F5FE),
          ),
          _buildShareIcon(
            context,
            'Email',
            const Icon(
              Icons.email_outlined,
              color: Color(0xFF0569FF),
              size: 28,
            ),
            const Color(0xFFEEF4FF),
          ),
          _buildShareIcon(
            context,
            'Copy',
            const Icon(Icons.copy_rounded, color: Color(0xFF1E1E1E), size: 28),
            const Color(0xFFF5F5F7),
          ),
          _buildShareIcon(
            context,
            'More',
            const Icon(
              Icons.share_outlined,
              color: Color(0xFFE67E22),
              size: 28,
            ),
            const Color(0xFFFFF3E0),
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
  ) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            if (label == 'Copy') {
              // Copy action is already tested in the card, but let's keep it here too
              Clipboard.setData(ClipboardData(text: 'Mock profile text...'));
            }
            AppToast.show(context, 'Sharing via $label...');
          },
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
            color: const Color(0xFF838A97),
          ),
        ),
      ],
    );
  }
}
