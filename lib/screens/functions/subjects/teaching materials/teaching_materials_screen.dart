import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../providers/materials_providers.dart';
import '../../../../presentation/components/lists/subject_materials_list.dart';
import '../../../../presentation/components/buttons/smart_sync_button.dart';
import '../../../../presentation/components/buttons/show_in_files_button.dart';

import '../../../../presentation/components/lists/labels.dart';

class TeachingMaterialsScreen extends StatelessWidget {
  const TeachingMaterialsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: const CustomAppBar(title: 'Teaching Materials'),
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
