import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/materials_providers.dart';
import '../../presentation/components/lists/subject_materials_list.dart';
import '../../presentation/components/buttons/smart_sync_button.dart';
import '../../presentation/components/buttons/show_in_files_button.dart';

class TeachingMaterialsScreen extends StatelessWidget {
  const TeachingMaterialsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                          'Teaching Materials',
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
            SmartSyncButton(
              onTap: () => context.push('/functions/teaching-materials/smart-sync'),
            ),
            const SizedBox(height: 12),
            const Padding(
              padding: EdgeInsets.only(bottom: 10.0),
              child: Text(
                'All subjects',
                style: TextStyle(
                  color: Color(0xFF838A97),
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(height: 12),
            SubjectMaterialsList(
              items: kSubjectMaterials,
              onSubjectTap: (id) => context.push('/functions/teaching-materials/subject/$id'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
