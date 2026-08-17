import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unec_assistant/presentation/providers/theme_provider.dart';

class AttendanceButton extends ConsumerWidget {
  const AttendanceButton({
    required this.onTap,
    super.key,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColors = ref.watch(appColorsProvider);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: appColors.cardBackground,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: appColors.borderColor,
            width: 1,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '4',
                  style: GoogleFonts.redditSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 55,
                    color: appColors.textPrimary,
                    height: 1,
                  ),
                ),
                Text(
                  'used',
                  style: GoogleFonts.redditSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: appColors.textSecondary,
                    height: 1,
                  ),
                ),
              ],
            ),

            const SizedBox(width: 20),

            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Limit : 7 · 3 absence remains ',
                      style: GoogleFonts.redditSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: appColors.textSecondary,
                        height: 2,
                      ),
                    ),

                    const SizedBox(height: 8),

                    LayoutBuilder(
                      builder: (context, constraints) {
                        final width = constraints.maxWidth;
                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: width,
                              height: 12,
                              decoration: BoxDecoration(
                                color: appColors.divider,
                                borderRadius: BorderRadius.circular(7),
                              ),
                            ),
                            SizedBox(
                              width: width * 0.6,
                              child: FractionallySizedBox(
                                widthFactor: 1.0,
                                child: Container(
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: appColors.attendanceOrange,
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Icon(
                          Icons.warning_rounded,
                          size: 20,
                          color: appColors.danger,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text.rich(
                            TextSpan(
                              children: [
                                const TextSpan(text: 'Warning : '),
                                TextSpan(
                                  text: 'You are in danger zone. More than 50%',
                                  style: TextStyle(color: appColors.textPrimary),
                                ),
                                const TextSpan(
                                  text: ' of your absence allowance is used. Use the rest wisely.',
                                ),
                              ],
                            ),
                            style: GoogleFonts.redditSans(
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                              color: appColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ]
              ),
            ),
          ],
        ),
      ),
    );
  }
}

