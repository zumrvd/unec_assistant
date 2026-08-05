import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutUsCard extends StatelessWidget {
  const AboutUsCard({super.key});

  Widget _aboutSection({
    required String emoji,
    required String heading,
    required InlineSpan body,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(width: 8),
            Text(
              heading,
              style: GoogleFonts.redditSans(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: const Color(0xFF1F1F1F),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text.rich(
          body,
          softWrap: true,
          style: GoogleFonts.redditSans(
            fontWeight: FontWeight.w500,
            fontSize: 12,
            color: const Color(0xFF838A97),
            height: 1.5,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE0E4F0),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _aboutSection(
            emoji: '👋',
            heading: 'Hello World,',
            body: TextSpan(
              children: [
                const TextSpan(text: 'I am a first-year '),
                TextSpan(
                  text: 'IT student at UNEC',
                  style: GoogleFonts.redditSans(
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1F1F1F),
                  ),
                ),
                const TextSpan(
                  text: ' with a passion for building software that solves real-world challenges.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _aboutSection(
            emoji: '🚀',
            heading: 'How it started?',
            body: TextSpan(
              children: [
                const TextSpan(
                  text: 'My development journey began out of a simple desire to make everyday tasks — looking up classrooms, downloading lectures, tracking schedules, and digging around for student IDs — easier. These are the small, daily hassles we all deal with, but by simplifying them, our entire university experience becomes smoother. What started as an idea in front of a blank screen has evolved into the fully functional application you are using today. It was intentionally engineered to serve your core needs and bridge the gap between students and faculty administration. ',
                ),
                TextSpan(
                  text: "Let's redefine our university experience together.",
                  style: GoogleFonts.redditSans(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1F1F1F),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
