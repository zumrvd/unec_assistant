import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unec_assistant/providers/theme_provider.dart';
import '../../../../providers/materials_provider.dart';
import '../../../../providers/subject_detail_provider.dart';
import '../../../../presentation/components/cards/lecture_materials_card.dart';
import '../../../../presentation/components/lists/labels.dart';
import 'package:unec_assistant/providers/locale_provider.dart';

class SubjectMaterialsDetailScreen extends ConsumerWidget {
  final String subjectId;

  const SubjectMaterialsDetailScreen({required this.subjectId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allSubjects = ref.watch(allSubjectsProvider);
    final subject = allSubjects.firstWhere((s) => s.subjectId == subjectId);
    final appColors = ref.watch(appColorsProvider);
    final tr = ref.watch(strProvider);

    // Materials come from the repository via subjectMaterialsProvider.
    // Replaces the previous switch statement over named lecture list constants.
    final lectures = ref.watch(subjectMaterialsProvider(subjectId));

    return Scaffold(
      backgroundColor: appColors.background,
      appBar: CustomAppBar(title: subject.subjectName),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (lectures.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Text(
                    tr.subjectMaterialsNoMaterials,
                    style: GoogleFonts.redditSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: appColors.textSecondary,
                    ),
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: lectures.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
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
