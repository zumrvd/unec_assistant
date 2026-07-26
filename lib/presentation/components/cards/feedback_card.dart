import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedbackCard extends StatefulWidget {
  const FeedbackCard({super.key});

  @override
  State<FeedbackCard> createState() => _FeedbackCardState();
}

class _FeedbackCardState extends State<FeedbackCard> {
  String _selectedTarget = 'To Faculty';
  final TextEditingController _feedbackController = TextEditingController();

  static const _borderColor = Color(0xFFE0E4F0);
  static const _primaryBlue = Color(0xFF0569FF);
  static const _inactiveBackground = Color(0xFFF8F9FC);
  static const _inactiveText = Color(0xFF838A97);
  static const _activeText = Color(0xFFF8F9FC);
  static const _inputBackground = Color(0x26838A97);
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

  TextStyle _targetTextStyle({required bool isSelected}) {
    return GoogleFonts.redditSans(
      fontWeight: FontWeight.w700,
      fontSize: 11,
      color: isSelected ? _activeText : _inactiveText,
    );
  }

  Widget _targetToggle(String option) {
    final isSelected = _selectedTarget == option;
    return GestureDetector(
      onTap: () => setState(() => _selectedTarget = option),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? _primaryBlue : _inactiveBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _borderColor,
            width: 1,
          ),
        ),
        child: Text(option, style: _targetTextStyle(isSelected: isSelected)),
      ),
    );
  }

  Future<void> _launchLearnMore() async {
    final uri = Uri.parse('http://kabinet.unec.edu.az/az/login');
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: _borderColor,
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
              _targetToggle(_targetOptions[0]),
              _targetToggle(_targetOptions[1]),
              _targetToggle(_targetOptions[2]),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            height: 72,
            decoration: BoxDecoration(
              color: _inputBackground,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: _borderColor,
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
                color: const Color(0xFF1F1F1F),
              ),
              decoration: InputDecoration(
                hintText: 'Write your feedback here...',
                hintStyle: GoogleFonts.redditSans(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  color: const Color(0x80838A97),
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
                    const Icon(
                      Icons.gpp_maybe_rounded,
                      size: 30,
                      color: Color(0xFF1C488A),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Your information is ',
                              style: GoogleFonts.redditSans(
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                                color: const Color(0xFF838A97),
                              ),
                            ),
                            TextSpan(
                              text: 'never shared',
                              style: GoogleFonts.redditSans(
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                                color: const Color(0xFF2C415C),
                              ),
                            ),
                            TextSpan(
                              text: '. All feedbacks are completely ',
                              style: GoogleFonts.redditSans(
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                                color: const Color(0xFF838A97),
                              ),
                            ),
                            TextSpan(
                              text: 'anonymous',
                              style: GoogleFonts.redditSans(
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                                color: const Color(0xFF2C415C),
                              ),
                            ),
                            TextSpan(
                              text: ' and used only for improvement.',
                              style: GoogleFonts.redditSans(
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                                color: const Color(0xFF838A97),
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
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  decoration: BoxDecoration(
                    color: _primaryBlue,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _borderColor,
                      width: 0.5,
                    ),
                  ),
                  child: Text(
                    'Submit',
                    style: GoogleFonts.redditSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: _activeText,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: _launchLearnMore,
            child: Text(
              'Learn more about anonymous feedbacks',
              style: GoogleFonts.redditSans(
                fontWeight: FontWeight.w700,
                fontSize: 12,
                color: _primaryBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
