import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../providers/subject_detail_provider.dart';
import '../../../presentation/components/cards/subject_name_card.dart';
import '../../../presentation/components/buttons/open_action_button.dart';
import '../../../presentation/components/cards/teacher_card.dart';
import '../../../presentation/components/cards/subject_hours_card.dart';
import '../../../presentation/components/cards/class_load_card.dart';
import '../../../presentation/components/cards/subject_credit_card.dart';

class Subject5Screen extends StatelessWidget {
  const Subject5Screen({super.key});

  @override
  Widget build(BuildContext context) {
    const data = kInfoDetail;
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(85),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: Color(0xFFE0E4F0), width: 1),
              bottom: BorderSide(color: Color(0xFFE0E4F0), width: 1),
            ),
          ),
          child: Container(
            height: 70,
            width: double.infinity,
            color: const Color(0xFFF8F9FC),
            padding: const EdgeInsets.symmetric(horizontal: 35.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0x80E0E4F0),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            size: 20,
                            color: Color(0x80838A97),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          data.subjectName,
                          style: GoogleFonts.redditSans(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            color: const Color(0xFF838A97),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SubjectNameCard(data: data),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OpenActionButton(
                    label: 'Open Grades',
                    sublabel: 'For this subject',
                    icon: Icons.star_rounded,
                    onTap: () {},
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OpenActionButton(
                    label: 'Open Materials',
                    sublabel: 'For this subject',
                    icon: Icons.article_rounded,
                    onTap: () {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const TeacherCard(data: data),
            const SizedBox(height: 12),
            const SubjectHoursCard(data: data),
            const SizedBox(height: 12),
            const ClassLoadCard(data: data),
            const SizedBox(height: 12),
            const SubjectCreditCard(data: data),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
