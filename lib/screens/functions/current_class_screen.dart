import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unec_assistant/presentation/components/cards/current_class_detailed_card.dart';
import 'package:unec_assistant/presentation/components/cards/teaching_materials_card.dart';
import 'package:unec_assistant/presentation/components/buttons/attendance_detailed_button.dart';

class CurrentClassScreen extends StatelessWidget {
  const CurrentClassScreen({super.key});

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
                Row(
                  mainAxisSize: MainAxisSize.min,
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
                    Text(
                      'Current Class',
                      style: GoogleFonts.redditSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: const Color(0xFF838A97),
                      ),
                    ),
                  ],
                ),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE5E5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Active',
                        style: GoogleFonts.redditSans(
                          color: const Color(0xFFFF4D4D),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Image.asset(
                        'assets/images/red_dot.gif',
                        width: 12,
                        height: 12,
                        errorBuilder: (context, error, stackTrace) {

                          return Container(
                            width: 12,
                            height: 12,
                            decoration: const BoxDecoration(
                              color: Color(0xFFFF4D4D),
                              shape: BoxShape.circle,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 35.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const CurrentClassDetailedCard(),

            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.only(bottom: 10.0),
              child: Text(
                'Class & Attendance',
                style: TextStyle(
                  color: Color(0xFF838A97),
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(height: 10),

            AttendanceButton(
              onTap: () => context.push('/functions/attendance_function'),
            ),

            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.only(bottom: 10.0),
              child: Text(
                'Academic',
                style: TextStyle(
                  color: Color(0xFF838A97),
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(height: 10),

            const TeachingMaterialsCard(),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
