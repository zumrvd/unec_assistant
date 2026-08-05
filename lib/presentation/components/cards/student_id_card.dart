import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StudentIdCard extends StatelessWidget {
  const StudentIdCard({
    required this.studentName,
    required this.groupCode,
    required this.faculty,
    required this.sabahGroup,
    required this.years,
    required this.yearBadge,
    this.quote,
    this.profileImage,
    super.key,
  });

  final String studentName;
  final String groupCode;
  final String faculty;
  final String sabahGroup;
  final String years;
  final String yearBadge;
  final String? quote;
  final ImageProvider? profileImage;

  static const _textColor = Color(0xFFE0E4F0);
  static const _backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0569FF),
      Color(0xCC0569FF),
      Color(0xFF035CE1),
    ],
    stops: [0.0, 0.5, 1.0],
  );
  static const _bubbleColor = Color(0xFF2776F3);
  static const _badgeBackgroundColor = Color(0xB56B98DB);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17.0),
      child: SizedBox(
        width: double.infinity,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          clipBehavior: Clip.hardEdge,
          child: Stack(
            children: [
              Positioned.fill(
                child: const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: _backgroundGradient,
                  ),
                ),
              ),
              const Positioned(
                top: -50,
                right: 20,
                child: _Bubble(diameter: 150),
              ),
              const Positioned(
                top: 50,
                left: -60,
                child: _Bubble(diameter: 120),
              ),
              const Positioned(
                bottom: -15,
                left: 100,
                child: _Bubble(diameter: 60),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'UNEC · TƏLƏBƏ',
                          style: GoogleFonts.redditSans(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: _textColor,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: _badgeBackgroundColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          child: Text(
                            yearBadge,
                            style: GoogleFonts.redditSans(
                              fontWeight: FontWeight.w700,
                              fontSize: 10,
                              color: _textColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 80,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _ProfilePhoto(profileImage: profileImage),
                              if (quote != null) ...[
                                const SizedBox(height: 8),
                                Text(
                                  quote!,
                                  softWrap: true,
                                  style: GoogleFonts.redditSans(
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 8,
                                    color: _textColor,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                studentName,
                                style: GoogleFonts.redditSans(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15,
                                  color: Color(0xFFFFFFFF),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                groupCode,
                                style: GoogleFonts.redditSans(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15,
                                  color: Color(0xFFFFFFFF),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                faculty,
                                style: GoogleFonts.redditSans(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                  color: _textColor,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '· $sabahGroup',
                                style: GoogleFonts.redditSans(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                  color: _textColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                years,
                                style: GoogleFonts.redditSans(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 8,
                                  color: _textColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.diameter});

  final double diameter;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: StudentIdCard._bubbleColor,
      ),
    );
  }
}

class _ProfilePhoto extends StatelessWidget {
  const _ProfilePhoto({this.profileImage});

  final ImageProvider? profileImage;

  @override
  Widget build(BuildContext context) {
    if (profileImage != null) {
      return Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image: profileImage!,
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: StudentIdCard._bubbleColor,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
