import 'package:flutter/material.dart';
import '../cards/subject_material_list_item.dart';
import '../../../models/subject_detail.dart';

class SubjectMaterialsList extends StatelessWidget {
  final List<SubjectDetail> items;
  final void Function(String subjectId)? onSubjectTap;

  const SubjectMaterialsList({
    required this.items,
    this.onSubjectTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        return SubjectMaterialListItem(
          data: items[index],
          onTap: () => onSubjectTap?.call(items[index].subjectId),
        );
      },
    );
  }
}
