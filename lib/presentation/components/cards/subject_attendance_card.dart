import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unec_assistant/providers/theme_provider.dart';
import 'package:unec_assistant/presentation/theme/app_colors.dart';
import 'package:unec_assistant/providers/locale_provider.dart';
import 'package:unec_assistant/l10n/translations.dart';
import '../../../models/subject_detail.dart';

class SubjectAttendanceCard extends ConsumerStatefulWidget {
  final SubjectDetail subject;

  const SubjectAttendanceCard({required this.subject, super.key});

  @override
  ConsumerState<SubjectAttendanceCard> createState() =>
      _SubjectAttendanceCardState();
}

class _SubjectAttendanceCardState extends ConsumerState<SubjectAttendanceCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final appColors = ref.watch(appColorsProvider);
    final tr = ref.watch(strProvider);
    final int absencesLeft =
        widget.subject.absenceLimit - widget.subject.absencesUsed;
    final double usedRatio =
        widget.subject.absencesUsed / widget.subject.absenceLimit;
    final bool isSafe = usedRatio < 0.5;
    final bool isDanger =
        widget.subject.absencesUsed >= widget.subject.absenceLimit;
    final bool isCaution = !isSafe && !isDanger;

    // Status colors
    final Color dotColor = isDanger
        ? appColors.error
        : isCaution
        ? appColors.attendanceOrange
        : appColors.primary;

    final Color borderColor = isDanger
        ? appColors.error.withValues(alpha: 0.5)
        : isCaution
        ? appColors.attendanceOrange.withValues(alpha: 0.5)
        : appColors.borderColor;

    final Color pillBg = isDanger
        ? appColors.error.withValues(alpha: 0.15)
        : isCaution
        ? appColors.attendanceOrange.withValues(alpha: 0.15)
        : appColors.success.withValues(alpha: 0.15);

    final Color pillTextColor = isDanger
        ? appColors.error
        : isCaution
        ? appColors.attendanceOrange
        : appColors.success;

    final Color barColor = isDanger
        ? appColors.error
        : isCaution
        ? appColors.attendanceOrange
        : appColors.success;

    final String pillLabel = tr.attendanceLeftPill(absencesLeft);

    final String absencesLeftLabel = isDanger
        ? tr.attendanceNoLeft
        : tr.attendanceAbsencesLeft(absencesLeft);

    final Color statusBg = isDanger
        ? appColors.error.withValues(alpha: 0.08)
        : isCaution
        ? appColors.attendanceOrange.withValues(alpha: 0.08)
        : appColors.success.withValues(alpha: 0.15);

    final Color statusBorder = isDanger
        ? appColors.error.withValues(alpha: 0.25)
        : isCaution
        ? appColors.attendanceOrange.withValues(alpha: 0.25)
        : appColors.success.withValues(alpha: 0.25);

    final IconData statusIcon = isDanger
        ? Icons.warning_rounded
        : isCaution
        ? Icons.report_rounded
        : Icons.check_circle_rounded;

    final Color statusIconColor = isDanger
        ? appColors.error
        : isCaution
        ? appColors.attendanceOrange
        : appColors.success;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: double.infinity,
      decoration: BoxDecoration(
        color: appColors.cardBackground,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor, width: 1),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: dotColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.subject.subjectName,
                        style: GoogleFonts.redditSans(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: appColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: pillBg,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      pillLabel,
                      style: GoogleFonts.redditSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 10,
                        color: pillTextColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => setState(() => _isExpanded = !_isExpanded),
                    behavior: HitTestBehavior.opaque,
                    child: AnimatedRotation(
                      turns: _isExpanded ? 0.5 : 0.0,
                      duration: const Duration(milliseconds: 300),
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: appColors.iconBoxArrowBg,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 18,
                          color: appColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            firstChild: const SizedBox(height: 0, width: double.infinity),
            secondChild: _buildExpandedContent(
              absencesLeftLabel,
              usedRatio,
              barColor,
              statusBg,
              statusBorder,
              statusIcon,
              statusIconColor,
              isSafe,
              isCaution,
              isDanger,
              appColors,
              tr,
            ),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedContent(
    String absencesLeftLabel,
    double usedRatio,
    Color barColor,
    Color statusBg,
    Color statusBorder,
    IconData statusIcon,
    Color statusIconColor,
    bool isSafe,
    bool isCaution,
    bool isDanger,
    AppColors appColors,
    AppStrings tr,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
          decoration: BoxDecoration(
            color: appColors.surface,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: appColors.borderColor, width: 1),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "${widget.subject.absencesUsed}",
                    style: GoogleFonts.redditSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 45,
                      color: appColors.textPrimary,
                      height: 1.1,
                    ),
                  ),
                  Text(
                    tr.attendanceUsed,
                    style: GoogleFonts.redditSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: appColors.textSecondary,
                      height: 1.1,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              Container(width: 1, height: 50, color: appColors.divider),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      tr.attendanceLimit(widget.subject.absenceLimit),
                      style: GoogleFonts.redditSans(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: appColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      absencesLeftLabel,
                      style: GoogleFonts.redditSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: appColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: usedRatio.clamp(0.0, 1.0),
                          minHeight: 8,
                          backgroundColor: appColors.borderColor,
                          valueColor: AlwaysStoppedAnimation<Color>(barColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: statusBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: statusBorder, width: 1),
          ),
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(statusIcon, size: 18, color: statusIconColor),
              const SizedBox(width: 10),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    children: _buildStatusSpans(
                      isSafe,
                      isCaution,
                      isDanger,
                      appColors,
                      tr,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<TextSpan> _buildStatusSpans(
    bool isSafe,
    bool isCaution,
    bool isDanger,
    AppColors appColors,
    AppStrings tr,
  ) {
    final normalStyle = GoogleFonts.redditSans(
      fontWeight: FontWeight.w600,
      fontSize: 12,
      color: appColors.textSecondary,
    );
    final boldStyle = GoogleFonts.redditSans(
      fontWeight: FontWeight.w700,
      fontSize: 12,
      color: appColors.textPrimary,
    );

    if (isSafe) {
      return [
        TextSpan(text: tr.attendanceSafeText1, style: normalStyle),
        TextSpan(text: tr.attendanceSafeText2, style: boldStyle),
        TextSpan(text: tr.attendanceSafeText3, style: normalStyle),
      ];
    } else if (isCaution) {
      return [
        TextSpan(text: tr.attendanceCautionText1, style: normalStyle),
        TextSpan(text: tr.attendanceCautionText2, style: boldStyle),
        TextSpan(text: tr.attendanceCautionText3, style: normalStyle),
      ];
    } else {
      return [
        TextSpan(text: tr.attendanceDangerText1, style: normalStyle),
        TextSpan(text: tr.attendanceDangerText2, style: boldStyle),
      ];
    }
  }
}
