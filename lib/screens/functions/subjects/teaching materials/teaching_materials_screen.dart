import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:unec_assistant/presentation/providers/theme_provider.dart';
import '../../../../providers/subject_detail_provider.dart';
import '../../../../presentation/components/lists/subject_materials_list.dart';
import '../../../../presentation/components/buttons/materials/smart_sync_button.dart';
import '../../../../presentation/components/lists/labels.dart';

class TeachingMaterialsScreen extends ConsumerWidget {
  const TeachingMaterialsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allSubjects = ref.watch(allSubjectsProvider);
    final appColors = ref.watch(appColorsProvider);

    return Scaffold(
      backgroundColor: appColors.background,
      appBar: const CustomAppBar(title: 'Teaching Materials'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            SmartSyncButton(onTap: () => context.push('/functions/teaching-materials/smart-sync')),
            SectionLabel('All subjects  ${allSubjects.length}'),
            SubjectMaterialsList(
              items: allSubjects,
              onSubjectTap: (id) => context.push('/functions/teaching-materials/subject/$id'),
            ),
          ],
        ),
      ),
    );
  }
}

