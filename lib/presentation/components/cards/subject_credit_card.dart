import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/subject_detail.dart';

class SubjectCreditCard extends StatelessWidget {
  final SubjectDetail data;

  const SubjectCreditCard({
    required this.data,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const iconColor = Color(0xFFE3993C);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE0E4F0),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
            child: Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.diamond_rounded,
                    size: 18,
                    color: iconColor,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  "SUBJECT CREDIT",
                  style: GoogleFonts.redditSans(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: iconColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Divider(color: Color(0xFFE0E4F0), thickness: 1, height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 60,
                  height: 110,
                  decoration: BoxDecoration(
                    color: const Color(0x4DE0E4F0),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE0E4F0), width: 1),
                  ),
                  child: Center(
                    child: Text(
                      "${data.subjectCredit}",
                      style: GoogleFonts.redditSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 35,
                        color: const Color(0xFF1F1F1F),
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
                        children: [
                          const Icon(
                            Icons.info_rounded,
                            size: 20,
                            color: Color(0x80838A97),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "What are credits?",
                            style: GoogleFonts.redditSans(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              color: const Color(0xFF1F1F1F),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F9FC),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE0E4F0), width: 1),
                        ),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Educational units measuring course ",
                                style: GoogleFonts.redditSans(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11,
                                  color: const Color(0xFF838A97),
                                ),
                              ),
                              TextSpan(
                                text: "workload",
                                style: GoogleFonts.redditSans(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11,
                                  color: const Color(0xFF1F1F1F),
                                ),
                              ),
                              TextSpan(
                                text: ". Subjects with more credits have a greater impact on your overall ",
                                style: GoogleFonts.redditSans(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11,
                                  color: const Color(0xFF838A97),
                                ),
                              ),
                              TextSpan(
                                text: "grades.",
                                style: GoogleFonts.redditSans(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11,
                                  color: const Color(0xFF1F1F1F),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
