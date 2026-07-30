import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unec_assistant/presentation/components/buttons/subjects/subject_button.dart';

import '../../presentation/components/buttons/download_curriculum_button.dart';
import '../../presentation/components/cards/semester_info_card.dart';
import '../../providers/subject_detail_provider.dart';

class SubjectsScreen extends StatelessWidget {
  const SubjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const data = kProgDetail;
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
                            'Subjects',
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
            )
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SemesterInfoCard(data: data),
            const SizedBox(height: 12),
            DownloadCurriculumButton(onTap: () {}),
            const SizedBox(height: 12),
            Subject1Button(onTap: () => context.push('/functions/subjects/1')),
            const SizedBox(height: 12),
            Subject2Button(onTap: () => context.push('/functions/subjects/2')),
            const SizedBox(height: 12),
            Subject3Button(onTap: () => context.push('/functions/subjects/3')),
            const SizedBox(height: 12),
            Subject4Button(onTap: () => context.push('/functions/subjects/4')),
            const SizedBox(height: 12),
            Subject5Button(onTap: () => context.push('/functions/subjects/5')),
            const SizedBox(height: 12),
            Subject6Button(onTap: () => context.push('/functions/subjects/6')),
          ],
        ),
      ),
    );
  }
}
