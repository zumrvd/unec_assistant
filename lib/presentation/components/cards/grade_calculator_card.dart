import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unec_assistant/providers/theme_provider.dart';
import 'package:unec_assistant/presentation/theme/app_colors.dart';
import '../../../models/subject_detail.dart';

class GradeCalculatorCard extends ConsumerStatefulWidget {
  final List<SubjectDetail> subjects;
  final BorderRadius? borderRadius;

  const GradeCalculatorCard({
    required this.subjects,
    this.borderRadius,
    super.key,
  });

  @override
  ConsumerState<GradeCalculatorCard> createState() =>
      _GradeCalculatorCardState();
}

class _GradeCalculatorCardState extends ConsumerState<GradeCalculatorCard> {
  String? _selectedSubject;
  String? _selectedGrade;
  String? _hoveredGrade;
  bool _calculated = false;

  static const Map<String, String> _gradeRanges = {
    'A': '91–100',
    'B': '81–90',
    'C': '71–80',
    'D': '61–70',
  };
  static const Map<String, int> _gradeMinScore = {
    'A': 91,
    'B': 81,
    'C': 71,
    'D': 61,
  };

  @override
  Widget build(BuildContext context) {
    final appColors = ref.watch(appColorsProvider);
    final Map<String, Color> gradeColors = {
      'A': appColors.success,
      'B': appColors.primary,
      'C': appColors.attendanceOrange,
      'D': appColors.error,
    };

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: appColors.cardBackground,
        borderRadius: widget.borderRadius ?? BorderRadius.circular(18),
        border: Border.all(color: appColors.borderColor, width: 1),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "CALCULATE FOR",
            style: GoogleFonts.redditSans(
              fontWeight: FontWeight.w700,
              fontSize: 12,
              color: appColors.textMuted,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            decoration: BoxDecoration(
              color: appColors.surface,
              border: Border.all(color: appColors.borderColor),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedSubject,
                hint: Text(
                  "Choose a Subject you want to calculate...",
                  style: GoogleFonts.redditSans(
                    fontSize: 14,
                    color: appColors.textMuted,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                isExpanded: true,
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: appColors.textSecondary,
                ),
                dropdownColor: appColors.cardBackground,
                borderRadius: BorderRadius.circular(12),
                onChanged: (val) => setState(() {
                  _selectedSubject = val;
                  _calculated = false;
                }),
                items: widget.subjects.map((s) {
                  return DropdownMenuItem(
                    value: s.subjectName,
                    child: Text(
                      s.subjectName,
                      style: GoogleFonts.redditSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: appColors.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            "I want to achieve",
            style: GoogleFonts.redditSans(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: appColors.textSecondary,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: ['A', 'B', 'C', 'D'].map((grade) {
              final isSelected = _selectedGrade == grade;
              final isHovered = _hoveredGrade == grade;
              final gradeColor = gradeColors[grade]!;

              Color bgColor = appColors.surface;
              Color borderColor = appColors.borderColor;
              double borderWidth = 1.0;

              if (isSelected) {
                bgColor = gradeColor.withValues(alpha: 0.15);
                borderColor = gradeColor.withValues(alpha: 0.2);
              } else if (isHovered) {
                bgColor = appColors.cardBackground;
                borderColor = gradeColor;
                borderWidth = 1.5;
              }

              return Expanded(
                child: MouseRegion(
                  onEnter: (_) => setState(() => _hoveredGrade = grade),
                  onExit: (_) => setState(() => _hoveredGrade = null),
                  child: GestureDetector(
                    onTap: () => setState(() {
                      _selectedGrade = grade;
                      _calculated = false;
                    }),
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      margin: EdgeInsets.only(right: grade != 'D' ? 8 : 0),
                      decoration: BoxDecoration(
                        color: bgColor,
                        border: Border.all(
                          color: borderColor,
                          width: borderWidth,
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            grade,
                            style: GoogleFonts.redditSans(
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                              color: gradeColor,
                            ),
                          ),
                          Text(
                            _gradeRanges[grade]!,
                            style: GoogleFonts.redditSans(
                              fontWeight: FontWeight.w700,
                              fontSize: 10,
                              color: appColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 18),
          if (!_calculated)
            GestureDetector(
              onTap: () {
                if (_selectedSubject != null && _selectedGrade != null) {
                  setState(() => _calculated = true);
                }
              },
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF0569FF),
                      Color(0xCC0569FF),
                      Color(0xFF035CE1),
                    ],
                    stops: [0.0, 0.5, 1.0],
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: Text(
                    "CALCULATE",
                    style: GoogleFonts.redditSans(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                      color: const Color(0xFFF8F9FC),
                    ),
                  ),
                ),
              ),
            )
          else
            _buildResultSection(appColors),
        ],
      ),
    );
  }

  Widget _buildResultSection(AppColors appColors) {
    final subject = widget.subjects.firstWhere(
      (s) => s.subjectName == _selectedSubject,
    );
    final targetMin = _gradeMinScore[_selectedGrade]!;
    final ptsNeeded = (targetMin - subject.currentScore).clamp(0, 100);
    final double haveProgress = subject.currentScore / 100;
    final double needProgress = targetMin / 100;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: appColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: appColors.borderColor),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Current\nScore",
                style: GoogleFonts.redditSans(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: appColors.textSecondary,
                  height: 1.1,
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "${subject.currentScore}",
                      style: GoogleFonts.redditSans(
                        fontWeight: FontWeight.w800,
                        fontSize: 36,
                        color: appColors.textPrimary,
                      ),
                    ),
                    TextSpan(
                      text: "/${subject.maxScore}",
                      style: GoogleFonts.redditSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 22,
                        color: appColors.textMuted,
                      ),
                    ),
                    TextSpan(
                      text: " pts so far",
                      style: GoogleFonts.redditSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: appColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Stack(
            children: [
              Container(
                height: 12,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: appColors.borderColor,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              FractionallySizedBox(
                widthFactor: needProgress,
                child: Container(
                  height: 12,
                  decoration: BoxDecoration(
                    color: appColors.success.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
              FractionallySizedBox(
                widthFactor: haveProgress,
                child: Container(
                  height: 12,
                  decoration: BoxDecoration(
                    color: appColors.primary,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Have: ${subject.currentScore}",
                    style: GoogleFonts.redditSans(
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                      color: appColors.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Need: $ptsNeeded",
                    style: GoogleFonts.redditSans(
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                      color: appColors.success,
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
              ),
              const SizedBox(width: 12),
              Column(
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: appColors.success.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                      border: Border.all(color: appColors.success, width: 1.5),
                    ),
                    child: Center(
                      child: Text(
                        "$ptsNeeded",
                        style: GoogleFonts.redditSans(
                          fontWeight: FontWeight.w800,
                          fontSize: 24,
                          color: appColors.success,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "pts needed to reach $targetMin",
              style: GoogleFonts.redditSans(
                fontWeight: FontWeight.w700,
                fontSize: 11,
                color: appColors.textMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
