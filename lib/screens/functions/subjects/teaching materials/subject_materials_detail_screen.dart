import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../providers/materials_providers.dart';
import '../../../../models/lecture_material.dart';
import '../../../../presentation/components/cards/lecture_materials_card.dart';

import '../../../../presentation/components/lists/labels.dart';

class SubjectMaterialsDetailScreen extends StatelessWidget {
  final String subjectId;

  const SubjectMaterialsDetailScreen({
    required this.subjectId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final subject = kSubjectMaterials.firstWhere((s) => s.subjectId == subjectId);
    
    // Map subjectId to lecture list
    List<LectureMaterial> lectures;
    switch (subjectId) {
      case 'prog': lectures = kProgLectures; break;
      case 'fizika': lectures = kFizikaLectures; break;
      case 'az': lectures = kAzLectures; break;
      case 'xetti': lectures = kXettiLectures; break;
      case 'info': lectures = kInfoLectures; break;
      case 'xarici': lectures = kXariciLectures; break;
      default: lectures = kEmptyLectures;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: CustomAppBar(title: subject.subjectName),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (lectures.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Text(
                    "No materials available yet",
                    style: GoogleFonts.redditSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: const Color(0xFF838A97),
                    ),
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: lectures.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return LectureMaterialsCard(data: lectures[index]);
                },
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
