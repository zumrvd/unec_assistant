import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/subject_detail.dart';
import '../../../models/seminar_entry.dart';

class SeminarGradesCard extends StatefulWidget {
  final SubjectDetail data;

  const SeminarGradesCard({
    required this.data,
    super.key,
  });

  @override
  State<SeminarGradesCard> createState() => _SeminarGradesCardState();
}

class _SeminarGradesCardState extends State<SeminarGradesCard> {
  bool _isExpanded = false;

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

  Widget _seminarRow(SeminarEntry e) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      e.title,
                      softWrap: true,
                      style: GoogleFonts.redditSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                        color: const Color(0xFF1F1F1F),
                      ),
                    ),
                    Text(
                      e.date,
                      style: GoogleFonts.redditSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 10,
                        color: const Color(0x80838A97),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                "${e.score}",
                style: GoogleFonts.redditSans(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: const Color(0xFF1F1F1F),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Divider(color: Color(0xFFE0E4F0), thickness: 1),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE0E4F0), width: 1),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.flag_rounded, size: 20, color: Color(0xFF0F6E11)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Seminars",
                  style: GoogleFonts.redditSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: const Color(0xFF1F1F1F),
                  ),
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "${widget.data.seminarScore}",
                      style: GoogleFonts.redditSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        color: const Color(0xFF1F1F1F),
                      ),
                    ),
                    TextSpan(
                      text: "/${widget.data.seminarMax}",
                      style: GoogleFonts.redditSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: const Color(0x80838A97),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                "${widget.data.seminarsGraded}/${widget.data.seminarsTotal} seminars graded",
                style: GoogleFonts.redditSans(
                  fontWeight: FontWeight.w700,
                  fontSize: 10,
                  color: const Color(0x80838A97),
                ),
              ),
              const SizedBox(width: 6),
              const Icon(Icons.schedule_rounded, size: 14, color: Color(0xFF0F6E11)),
              const Spacer(),
              GestureDetector(
                onTap: () => setState(() => _isExpanded = !_isExpanded),
                child: AnimatedRotation(
                  turns: _isExpanded ? 0.5 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: const Color(0x80E0E4F0),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(Icons.keyboard_arrow_down_rounded, size: 14, color: Color(0x80838A97)),
                  ),
                ),
              ),
            ],
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox(height: 0, width: double.infinity),
            secondChild: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Column(
                children: widget.data.seminarEntries.map((e) => _seminarRow(e)).toList(),
              ),
            ),
            crossFadeState: _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: _buttonGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.grid_view_rounded, size: 18, color: Color(0xFFF8F9FC)),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Open in Unec Cabinet",
                          style: GoogleFonts.redditSans(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            color: const Color(0xFFF8F9FC),
                          ),
                        ),
                        Text(
                          "See your results in Unec Cabinet",
                          style: GoogleFonts.redditSans(
                            fontWeight: FontWeight.w700,
                            fontSize: 9,
                            color: const Color(0x80F8F9FC),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Icon(Icons.arrow_outward_rounded, size: 18, color: Color(0xFFF8F9FC)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
