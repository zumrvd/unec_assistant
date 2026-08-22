import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unec_assistant/providers/theme_provider.dart';
import 'package:unec_assistant/providers/locale_provider.dart';
import 'package:unec_assistant/l10n/translations.dart';
import '../../../models/subject_detail.dart';

class TeacherCard extends ConsumerWidget {
  final SubjectDetail data;

  const TeacherCard({required this.data, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColors = ref.watch(appColorsProvider);
    final tr = ref.watch(strProvider);
    final iconColor = appColors.primary;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: appColors.cardBackground,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: appColors.borderColor, width: 1),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            key: const Key('teacher_image_placeholder'),
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: appColors.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.person_outlined, size: 26, color: iconColor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tr.subjectTeacherTitle,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.redditSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                    color: appColors.textMuted,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  data.teacherName,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.redditSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: appColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _localizeRank(data.teacherRank, tr),
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.redditSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    color: appColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  data.teacherEmail,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.redditSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    color: iconColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _localizeRank(String rank, AppStrings tr) {
    String localized = rank;
    if (rank.contains('Associate Professor')) {
      localized = localized.replaceFirst('Associate Professor', tr.rankAssociateProfessor);
    }
    if (rank.contains('Head of Dept.')) {
      localized = localized.replaceFirst('Head of Dept.', tr.rankHeadOfDept);
    }
    if (rank.contains('CS Dept.')) {
      localized = localized.replaceFirst('CS Dept.', tr.deptCS);
    }
    if (rank.contains('Physics Dept.')) {
      localized = localized.replaceFirst('Physics Dept.', tr.deptPhysics);
    }
    return localized;
  }
}
