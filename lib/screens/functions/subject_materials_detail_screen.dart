import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/materials_providers.dart';
import '../../models/lecture_material.dart';
import '../../presentation/components/cards/lecture_materials_card.dart';

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
                          subject.subjectName,
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
