import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SubjectsButton extends StatefulWidget {
  const SubjectsButton({
    required this.onTapSubjects,
    required this.onTapTeachingMaterials,
    required this.onTapGrades,
    required this.onTapOpen,
    super.key,
  });

  final VoidCallback onTapSubjects;
  final VoidCallback onTapTeachingMaterials;
  final VoidCallback onTapGrades;
  final VoidCallback onTapOpen;

  @override
  State<SubjectsButton> createState() => _SubjectsButtonState();
}

class _SubjectsButtonState extends State<SubjectsButton> with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _expandController;
  late Animation<double> _expandAnimation;

  static const _titleColor = Color(0xFF1F1F1F);
  static const _subtitleColor = Color(0x80838A97);
  static const _borderColor = Color(0xFFE0E4F0);
  static const _subjectsIconColor = Color(0xFF854F0B);
  static const _subjectsIconBackground = Color(0x24E3993C);
  static const _pillBackground = Color(0x260569FF);
  static const _pillTextColor = Color(0xFF0569FF);
  static const _teachingIconColor = Color(0xFF534AB7);
  static const _teachingIconBackground = Color(0x26534AB7);
  static const _gradesIconColor = Color(0xFF3B6D11);
  static const _gradesIconBackground = Color(0x263B6D11);

  @override
  void initState() {
    super.initState();
    _expandController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _expandAnimation = CurvedAnimation(
      parent: _expandController,
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void dispose() {
    _expandController.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _expandController.forward();
      } else {
        _expandController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: _borderColor,
              width: 1,
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: widget.onTapSubjects,
                  behavior: HitTestBehavior.opaque,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: _subjectsIconBackground,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.book_outlined,
                          size: 28,
                          color: _subjectsIconColor,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Subjects',
                            style: GoogleFonts.redditSans(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              color: _titleColor,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'For the full academic semester',
                            style: GoogleFonts.redditSans(
                              fontWeight: FontWeight.w700,
                              fontSize: 10,
                              color: _subtitleColor,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            decoration: BoxDecoration(
                              color: _pillBackground,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            child: Text(
                              'Grades · Materials',
                              style: GoogleFonts.redditSans(
                                fontWeight: FontWeight.w700,
                                fontSize: 8,
                                color: _pillTextColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  widget.onTapOpen();
                  _toggleExpand();
                },
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0x10838A97),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: RotationTransition(
                    turns: Tween<double>(begin: 0, end: 0.25).animate(_expandAnimation),
                    child: const Icon(
                      Icons.arrow_right_rounded,
                      size: 30,
                      color: Color(0x80838A97),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizeTransition(
          sizeFactor: _expandAnimation,
          child: Column(
            children: [
              const SizedBox(height: 14),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.subdirectory_arrow_right,
                    size: 18,
                    color: _subtitleColor,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: GestureDetector(
                      onTap: widget.onTapTeachingMaterials,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFFFF),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: _borderColor,
                            width: 1,
                          ),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: _teachingIconBackground,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.article_outlined,
                                size: 22,
                                color: _teachingIconColor,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Teaching Materials',
                                  style: GoogleFonts.redditSans(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                    color: _titleColor,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Lectures, seminars & tests',
                                  style: GoogleFonts.redditSans(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 10,
                                    color: _subtitleColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.subdirectory_arrow_right,
                    size: 18,
                    color: _subtitleColor,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: GestureDetector(
                      onTap: widget.onTapGrades,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFFFF),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: _borderColor,
                            width: 1,
                          ),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: _gradesIconBackground,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.grade_outlined,
                                size: 22,
                                color: _gradesIconColor,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Grades',
                                  style: GoogleFonts.redditSans(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                    color: _titleColor,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Seminars & exam results',
                                  style: GoogleFonts.redditSans(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 10,
                                    color: _subtitleColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
