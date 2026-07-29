import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SubjectAttendanceCard extends StatefulWidget {
  final String subjectName;
  final int absencesUsed;
  final int absenceLimit;

  const SubjectAttendanceCard({
    required this.subjectName,
    required this.absencesUsed,
    required this.absenceLimit,
    super.key,
  });

  @override
  State<SubjectAttendanceCard> createState() => _SubjectAttendanceCardState();
}

class _SubjectAttendanceCardState extends State<SubjectAttendanceCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final int absencesLeft = widget.absenceLimit - widget.absencesUsed;
    final double usedRatio = widget.absencesUsed / widget.absenceLimit;
    final bool isSafe = usedRatio < 0.5;
    final bool isDanger = widget.absencesUsed >= widget.absenceLimit;
    final bool isCaution = !isSafe && !isDanger;

    // Status colors
    final Color dotColor = isDanger
        ? const Color(0xFFD54829)
        : isCaution
            ? const Color(0xFFE3993C)
            : const Color(0xFF0569FF);

    final Color borderColor = isDanger
        ? const Color(0x80D54829)
        : isCaution
            ? const Color(0x80E3993C)
            : const Color(0xFFE0E4F0);

    final Color pillBg = isDanger
        ? const Color(0x26D54829) // 15% used as ~0x26
        : isCaution
            ? const Color(0x26E3993C)
            : const Color(0x260F6E11);

    final Color pillTextColor = isDanger
        ? const Color(0xFFD54829)
        : isCaution
            ? const Color(0xFF985909)
            : const Color(0xFF0F6E11);

    final Color barColor = isDanger
        ? const Color(0xFFD54829)
        : isCaution
            ? const Color(0xFFE3993C)
            : const Color(0xFF0F6E11);

    final String pillLabel = "$absencesLeft Left";

    final String absencesLeftLabel = isDanger
        ? "no absence left"
        : "$absencesLeft absences left";

    final Color statusBg = isDanger
        ? const Color(0x0DD54829) // 5% used as ~0x0D
        : isCaution
            ? const Color(0x0DE3993C)
            : const Color(0x260F6E11);

    final Color statusBorder = isDanger
        ? const Color(0x26D54829)
        : isCaution
            ? const Color(0x26E3993C)
            : const Color(0x260F6E11);

    final IconData statusIcon = isDanger
        ? Icons.warning_rounded
        : isCaution
            ? Icons.report_rounded
            : Icons.check_circle_rounded;

    final Color statusIconColor = isDanger
        ? const Color(0xFFD54829)
        : isCaution
            ? const Color(0xFFE3993C)
            : const Color(0xFF0F6E11);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
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
                        widget.subjectName,
                        style: GoogleFonts.redditSans(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: const Color(0xFF1F1F1F),
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
                    child: AnimatedRotation(
                      turns: _isExpanded ? 0.5 : 0.0,
                      duration: const Duration(milliseconds: 300),
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: const Color(0x80E0E4F0),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 18,
                          color: Color(0x80838A97),
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
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FC),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: const Color(0xFFE0E4F0), width: 1),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "${widget.absencesUsed}",
                    style: GoogleFonts.redditSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 45,
                      color: const Color(0xFF1F1F1F),
                      height: 1.1,
                    ),
                  ),
                  Text(
                    "used",
                    style: GoogleFonts.redditSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: const Color(0xFF838A97),
                      height: 1.1,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              Container(width: 1, height: 50, color: const Color(0xFFE0E4F0)),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Limit : ${widget.absenceLimit}",
                      style: GoogleFonts.redditSans(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: const Color(0xFF838A97),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      absencesLeftLabel,
                      style: GoogleFonts.redditSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: const Color(0xFF1F1F1F),
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
                          backgroundColor: const Color(0xFFE0E4F0),
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
                    children: _buildStatusSpans(isSafe, isCaution, isDanger),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<TextSpan> _buildStatusSpans(bool isSafe, bool isCaution, bool isDanger) {
    final normalStyle = GoogleFonts.redditSans(
      fontWeight: FontWeight.w600,
      fontSize: 12,
      color: const Color(0xFF838A97),
    );
    final boldStyle = GoogleFonts.redditSans(
      fontWeight: FontWeight.w700,
      fontSize: 12,
      color: const Color(0xFF1F1F1F),
    );

    if (isSafe) {
      return [
        TextSpan(text: "You are safe. ", style: normalStyle),
        TextSpan(text: "Less than 50%", style: boldStyle),
        TextSpan(
          text:
              " of your absence allowance has been used. Use the rest wisely.",
          style: normalStyle,
        ),
      ];
    } else if (isCaution) {
      return [
        TextSpan(text: "Caution. ", style: normalStyle),
        TextSpan(text: "More than 50%", style: boldStyle),
        TextSpan(
          text:
              " of your absence allowance has been used. Use the rest wisely.",
          style: normalStyle,
        ),
      ];
    } else {
      return [
        TextSpan(
          text: "You have reached your limit. Any further absences will result in a ",
          style: normalStyle,
        ),
        TextSpan(text: "course failure.", style: boldStyle),
      ];
    }
  }
}
