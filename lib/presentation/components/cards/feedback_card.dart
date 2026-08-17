import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unec_assistant/presentation/providers/theme_provider.dart';
import 'package:unec_assistant/presentation/theme/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedbackCard extends ConsumerStatefulWidget {
  const FeedbackCard({super.key});

  @override
  ConsumerState<FeedbackCard> createState() => _FeedbackCardState();
}

class _FeedbackCardState extends ConsumerState<FeedbackCard> {
  String _selectedTarget = 'To Faculty';
  final TextEditingController _feedbackController = TextEditingController();

  static const _targetOptions = [
    'To Faculty',
    'To Developer Team',
    'To Other',
  ];

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  TextStyle _targetTextStyle({required bool isSelected, required AppColors appColors}) {
    return GoogleFonts.redditSans(
      fontWeight: FontWeight.w700,
      fontSize: 11,
      color: isSelected ? appColors.pillSelectedText : appColors.pillUnselectedText,
    );
  }

  Widget _targetToggle(String option, AppColors appColors) {
    final isSelected = _selectedTarget == option;
    return GestureDetector(
      onTap: () => setState(() => _selectedTarget = option),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? appColors.primary : appColors.pillUnselectedBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: appColors.borderColor,
            width: 1,
          ),
        ),
        child: Text(option, style: _targetTextStyle(isSelected: isSelected, appColors: appColors)),
      ),
    );
  }

  Future<void> _launchLearnMore() async {
    final uri = Uri.parse('http://kabinet.unec.edu.az/az/login');
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final appColors = ref.watch(appColorsProvider);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: appColors.cardBackground,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: appColors.borderColor,
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 10,
            runSpacing: 10,
            children: [
              _targetToggle(_targetOptions[0], appColors),
              _targetToggle(_targetOptions[1], appColors),
              _targetToggle(_targetOptions[2], appColors),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            height: 72,
            decoration: BoxDecoration(
              color: appColors.inputBackground,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: appColors.borderColor,
                width: 0.5,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: TextField(
              controller: _feedbackController,
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              style: GoogleFonts.redditSans(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: appColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'Write your feedback here...',
                hintStyle: GoogleFonts.redditSans(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  color: appColors.textMuted,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.gpp_maybe_rounded,
                      size: 30,
                      color: appColors.primary,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Your information is ',
                              style: GoogleFonts.redditSans(
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                                color: appColors.textSecondary,
                              ),
                            ),
                            TextSpan(
                              text: 'never shared',
                              style: GoogleFonts.redditSans(
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                                color: appColors.textPrimary,
                              ),
                            ),
                            TextSpan(
                              text: '. All feedbacks are completely ',
                              style: GoogleFonts.redditSans(
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                                color: appColors.textSecondary,
                              ),
                            ),
                            TextSpan(
                              text: 'anonymous',
                              style: GoogleFonts.redditSans(
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                                color: appColors.textPrimary,
                              ),
                            ),
                            TextSpan(
                              text: ' and used only for improvement.',
                              style: GoogleFonts.redditSans(
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                                color: appColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () {},
                behavior: HitTestBehavior.opaque,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  decoration: BoxDecoration(
                    color: appColors.primary,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: appColors.borderColor,
                      width: 0.5,
                    ),
                  ),
                  child: Text(
                    'Submit',
                    style: GoogleFonts.redditSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: appColors.pillSelectedText,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: _launchLearnMore,
            behavior: HitTestBehavior.opaque,
            child: Text(
              'Learn more about anonymous feedbacks',
              style: GoogleFonts.redditSans(
                fontWeight: FontWeight.w700,
                fontSize: 12,
                color: appColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
