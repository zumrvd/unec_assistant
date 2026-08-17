import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StudentIdCard extends StatefulWidget {
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

  static const textColor = Color(0xFFE0E4F0);
  static const backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0569FF),
      Color(0xCC0569FF),
      Color(0xFF035CE1),
    ],
    stops: [0.0, 0.5, 1.0],
  );
  static const bubbleColor = Color(0xFF2776F3);
  static const badgeBackgroundColor = Color(0xB56B98DB);

  @override
  State<StudentIdCard> createState() => _StudentIdCardState();
}

class _StudentIdCardState extends State<StudentIdCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;
  bool _isFront = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutCubic,
      ),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutQuart,
      ),
    );
  }

  void _toggleCard() {
    if (_isFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    setState(() {
      _isFront = !_isFront;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: _toggleCard,
        behavior: HitTestBehavior.opaque,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001) // perspective
                  ..rotateY(_rotationAnimation.value * 3.14159),
                alignment: Alignment.center,
                child: _rotationAnimation.value < 0.5
                    ? _buildFrontCard()
                    : Transform.scale(
                        scaleX: -1,
                        scaleY: 1,
                        child: _buildBackCard(),
                      ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFrontCard() {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 160),
      child: SizedBox(
        width: 280,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          clipBehavior: Clip.hardEdge,
          child: Stack(
            children: [
              Positioned.fill(
                child: const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: StudentIdCard.backgroundGradient,
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'UNEC · TƏLƏBƏ',
                          style: GoogleFonts.redditSans(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: StudentIdCard.textColor,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: StudentIdCard.badgeBackgroundColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          child: Text(
                            widget.yearBadge,
                            style: GoogleFonts.redditSans(
                              fontWeight: FontWeight.w700,
                              fontSize: 10,
                              color: StudentIdCard.textColor,
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
                              _ProfilePhoto(profileImage: widget.profileImage),
                              if (widget.quote != null) ...[
                                const SizedBox(height: 8),
                                Text(
                                  widget.quote!,
                                  softWrap: true,
                                  style: GoogleFonts.redditSans(
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 8,
                                    color: StudentIdCard.textColor,
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
                                widget.studentName,
                                style: GoogleFonts.redditSans(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15,
                                  color: const Color(0xFFFFFFFF),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                widget.groupCode,
                                style: GoogleFonts.redditSans(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15,
                                  color: const Color(0xFFFFFFFF),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                widget.faculty,
                                style: GoogleFonts.redditSans(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                  color: StudentIdCard.textColor,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '· ${widget.sabahGroup}',
                                style: GoogleFonts.redditSans(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                  color: StudentIdCard.textColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.years,
                                style: GoogleFonts.redditSans(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 8,
                                  color: StudentIdCard.textColor,
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

  Widget _buildBackCard() {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 220),
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
                    gradient: StudentIdCard.backgroundGradient,
                  ),
                ),
              ),
              const Positioned(
                top: -50,
                right: 20,
                child: _Bubble(diameter: 150),
              ),
              // Non-positioned child to give the Stack a finite height
              const SizedBox(height: 200, width: double.infinity),
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
        color: StudentIdCard.bubbleColor,
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
        color: StudentIdCard.bubbleColor,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
