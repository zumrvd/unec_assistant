import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class StudentCardTheme {
  final String id;
  final String name;
  final LinearGradient gradient;
  final Color bubbleColor;
  final Color badgeBackgroundColor;

  const StudentCardTheme({
    required this.id,
    required this.name,
    required this.gradient,
    required this.bubbleColor,
    required this.badgeBackgroundColor,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudentCardTheme &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  static const List<StudentCardTheme> presets = [
    // 1. Blue (Classic UNEC Primary)
    StudentCardTheme(
      id: 'blue',
      name: 'Blue',
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF0569FF),
          Color(0xCC0569FF),
          Color(0xFF035CE1),
        ],
        stops: [0.0, 0.5, 1.0],
      ),
      bubbleColor: Color(0xFF2776F3),
      badgeBackgroundColor: Color(0xB56B98DB),
    ),
    // 2. Navy (Deep UNEC Dark Navy)
    StudentCardTheme(
      id: 'navy',
      name: 'Navy',
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF174280),
          Color(0xFF1C4B8E),
          Color(0xFF123466),
        ],
        stops: [0.0, 0.5, 1.0],
      ),
      bubbleColor: Color(0xFF2258A3),
      badgeBackgroundColor: Color(0xB55785C4),
    ),
    // 3. Purple
    StudentCardTheme(
      id: 'purple',
      name: 'Purple',
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF534AB7),
          Color(0xCC534AB7),
          Color(0xFF433B9B),
        ],
        stops: [0.0, 0.5, 1.0],
      ),
      bubbleColor: Color(0xFF6B62D4),
      badgeBackgroundColor: Color(0xB58E87E6),
    ),
    // 4. Pink
    StudentCardTheme(
      id: 'pink',
      name: 'Pink',
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFDA4979),
          Color(0xCCDA4979),
          Color(0xFFC03666),
        ],
        stops: [0.0, 0.5, 1.0],
      ),
      bubbleColor: Color(0xFFE8608E),
      badgeBackgroundColor: Color(0xB5EDA0BC),
    ),
    // 5. Deep Pink
    StudentCardTheme(
      id: 'deep_pink',
      name: 'Deep Pink',
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFE16890),
          Color(0xCCE16890),
          Color(0xFFC74C75),
        ],
        stops: [0.0, 0.5, 1.0],
      ),
      bubbleColor: Color(0xFFEB81A4),
      badgeBackgroundColor: Color(0xB5F2ACC2),
    ),
    // 6. Orange-Red
    StudentCardTheme(
      id: 'orange_red',
      name: 'Orange-Red',
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFD54829),
          Color(0xCCD54829),
          Color(0xFFB83518),
        ],
        stops: [0.0, 0.5, 1.0],
      ),
      bubbleColor: Color(0xFFE56245),
      badgeBackgroundColor: Color(0xB5F09B87),
    ),
    // 7. Yellow
    StudentCardTheme(
      id: 'yellow',
      name: 'Yellow',
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFE3993C),
          Color(0xCCE3993C),
          Color(0xFFC47B20),
        ],
        stops: [0.0, 0.5, 1.0],
      ),
      bubbleColor: Color(0xFFF0B05F),
      badgeBackgroundColor: Color(0xB5F7D09E),
    ),
    // 8. Dark Yellow / Ochre
    StudentCardTheme(
      id: 'yellow_dark',
      name: 'Dark Yellow',
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF985909),
          Color(0xFF854F0B),
          Color(0xFF734105),
        ],
        stops: [0.0, 0.5, 1.0],
      ),
      bubbleColor: Color(0xFFB06B12),
      badgeBackgroundColor: Color(0xB5CCA26E),
    ),
    // 9. Green
    StudentCardTheme(
      id: 'green',
      name: 'Green',
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF0F6E11),
          Color(0xCC0F6E11),
          Color(0xFF0B540D),
        ],
        stops: [0.0, 0.5, 1.0],
      ),
      bubbleColor: Color(0xFF1B8A1E),
      badgeBackgroundColor: Color(0xB571B873),
    ),
    // 10. Olive Green (Green2)
    StudentCardTheme(
      id: 'green2',
      name: 'Olive Green',
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF3B6D11),
          Color(0xCC3B6D11),
          Color(0xFF2C530B),
        ],
        stops: [0.0, 0.5, 1.0],
      ),
      bubbleColor: Color(0xFF4F8A1B),
      badgeBackgroundColor: Color(0xB58AB56B),
    ),
    // 11. Dark Red
    StudentCardTheme(
      id: 'red',
      name: 'Red',
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF993C1D),
          Color(0xCC993C1D),
          Color(0xFF7A2B11),
        ],
        stops: [0.0, 0.5, 1.0],
      ),
      bubbleColor: Color(0xFFB5502E),
      badgeBackgroundColor: Color(0xB5CF9582),
    ),
    // 12. Charcoal Obsidian
    StudentCardTheme(
      id: 'obsidian',
      name: 'Obsidian',
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF2D333F),
          Color(0xFF242A34),
          Color(0xFF1A1F27),
        ],
        stops: [0.0, 0.5, 1.0],
      ),
      bubbleColor: Color(0xFF3E4656),
      badgeBackgroundColor: Color(0xB5838A97),
    ),
  ];
}

class StudentIdCardController {
  _StudentIdCardState? _state;

  void _attach(_StudentIdCardState state) {
    _state = state;
  }

  void _detach() {
    _state = null;
  }

  bool get isFront => _state?._isFront ?? true;

  void flipToFront() {
    _state?.flipToFront();
  }

  void flipToBack() {
    _state?.flipToBack();
  }

  void toggle() {
    _state?._toggleCard();
  }
}

class StudentIdCard extends ConsumerStatefulWidget {
  const StudentIdCard({
    required this.studentName,
    required this.groupCode,
    required this.faculty,
    required this.sabahGroup,
    required this.years,
    required this.yearBadge,
    this.quote,
    this.profileImage,
    this.theme,
    this.onTap,
    this.heroTag = 'student_id_card',
    this.initialIsFront = true,
    this.onDoneTap,
    this.cardController,
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
  final StudentCardTheme? theme;
  final VoidCallback? onTap;
  final Object? heroTag;
  final bool initialIsFront;
  final VoidCallback? onDoneTap;
  final StudentIdCardController? cardController;

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
  ConsumerState<StudentIdCard> createState() => _StudentIdCardState();
}

class _StudentIdCardState extends ConsumerState<StudentIdCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;
  bool _isFront = true;

  late ImageProvider? _selectedAvatar;
  late String? _selectedQuote;
  late StudentCardTheme _selectedTheme;

  @override
  void initState() {
    super.initState();
    _isFront = widget.initialIsFront;
    _selectedAvatar = widget.profileImage;
    _selectedQuote =
        widget.quote ?? '"too pretty to worry about midterms"';
    _selectedTheme = widget.theme ?? StudentCardTheme.presets.first;

    widget.cardController?._attach(this);

    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      value: widget.initialIsFront ? 0.0 : 1.0,
      vsync: this,
    );

    _rotationAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutCubic,
      ),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.04).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutQuart,
      ),
    );
  }

  @override
  void didUpdateWidget(covariant StudentIdCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.cardController != oldWidget.cardController) {
      oldWidget.cardController?._detach();
      widget.cardController?._attach(this);
    }
    if (widget.theme != null && widget.theme != oldWidget.theme) {
      setState(() {
        _selectedTheme = widget.theme!;
      });
    }
    if (widget.quote != oldWidget.quote) {
      setState(() {
        _selectedQuote = widget.quote;
      });
    }
    if (widget.profileImage != oldWidget.profileImage) {
      setState(() {
        _selectedAvatar = widget.profileImage;
      });
    }
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

  void flipToFront() {
    if (!_isFront) {
      _controller.reverse();
      setState(() {
        _isFront = true;
      });
    }
  }

  void flipToBack() {
    if (_isFront) {
      _controller.forward();
      setState(() {
        _isFront = false;
      });
    }
  }

  @override
  void dispose() {
    widget.cardController?._detach();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cardWidget = Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: widget.onTap ?? _toggleCard,
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

    if (widget.heroTag != null) {
      return Hero(
        tag: widget.heroTag!,
        flightShuttleBuilder: _flightShuttleBuilder,
        child: Material(
          type: MaterialType.transparency,
          child: cardWidget,
        ),
      );
    }

    return cardWidget;
  }

  Widget _flightShuttleBuilder(
    BuildContext flightContext,
    Animation<double> animation,
    HeroFlightDirection flightDirection,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
  ) {
    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeInOutCubic,
    );

    // Determine if the card we are navigating away from is currently front-facing
    final fromCardState =
        fromHeroContext.findAncestorStateOfType<_StudentIdCardState>();
    final bool isLeavingFromFront = fromCardState?._isFront ?? _isFront;

    final frontCard = RepaintBoundary(
      child: OverflowBox(
        alignment: Alignment.center,
        minWidth: 300,
        maxWidth: 300,
        minHeight: 0,
        maxHeight: double.infinity,
        child: _buildFrontCard(),
      ),
    );
    final backCard = RepaintBoundary(
      child: OverflowBox(
        alignment: Alignment.center,
        minWidth: 300,
        maxWidth: 300,
        minHeight: 0,
        maxHeight: double.infinity,
        child: Transform.scale(
          scaleX: -1,
          scaleY: 1,
          child: _buildBackCard(),
        ),
      ),
    );

    return AnimatedBuilder(
      animation: curvedAnimation,
      builder: (context, child) {
        final double progress = curvedAnimation.value;

        // When returning to profile and already on the front face, smoothly return without flipping
        if (flightDirection == HeroFlightDirection.pop && isLeavingFromFront) {
          return Material(
            type: MaterialType.transparency,
            child: Center(
              child: frontCard,
            ),
          );
        }

        final double rotation = progress;
        final double scale = 1.0 + 0.05 * math.sin(progress * math.pi);
        final bool showFront = rotation < 0.5;

        return Material(
          type: MaterialType.transparency,
          child: Center(
            child: Transform.scale(
              scale: scale,
              child: Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001) // perspective
                  ..rotateY(rotation * math.pi),
                alignment: Alignment.center,
                child: showFront ? frontCard : backCard,
              ),
            ),
          ),
        );
      },
    );
  }

  String? get _formattedQuote {
    final raw = _selectedQuote?.trim();
    if (raw == null || raw.isEmpty) return null;
    if (raw.startsWith('"') && raw.endsWith('"') && raw.length >= 2) {
      return raw;
    }
    return '"$raw"';
  }

  Widget _buildFrontCard() {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 160),
      child: SizedBox(
        width: 300,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          clipBehavior: Clip.hardEdge,
          child: Stack(
            children: [
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: _selectedTheme.gradient,
                  ),
                ),
              ),
              Positioned(
                top: -50,
                right: 20,
                child: _Bubble(
                  diameter: 150,
                  color: _selectedTheme.bubbleColor,
                ),
              ),
              Positioned(
                top: 50,
                left: -60,
                child: _Bubble(
                  diameter: 120,
                  color: _selectedTheme.bubbleColor,
                ),
              ),
              Positioned(
                bottom: -15,
                left: 100,
                child: _Bubble(
                  diameter: 60,
                  color: _selectedTheme.bubbleColor,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            'UNEC · TƏLƏBƏ',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.redditSans(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: StudentIdCard.textColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: _selectedTheme.badgeBackgroundColor,
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
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.touch_app_rounded,
                                size: 14,
                                color: StudentIdCard.textColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 72,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _ProfilePhoto(
                                profileImage: _selectedAvatar,
                                bubbleColor: _selectedTheme.bubbleColor,
                              ),
                              if (_formattedQuote != null)
                                Container(
                                  width: 72,
                                  margin: const EdgeInsets.only(top: 6),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 5,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.18),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color:
                                          Colors.white.withValues(alpha: 0.22),
                                      width: 0.8,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black
                                            .withValues(alpha: 0.12),
                                        blurRadius: 3,
                                        offset: const Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    _formattedQuote!,
                                    maxLines: 4,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.redditSans(
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 8.5,
                                      color: const Color(0xFFFFFFFF),
                                      height: 1.2,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black
                                              .withValues(alpha: 0.4),
                                          blurRadius: 2,
                                          offset: const Offset(0, 0.5),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.studentName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.redditSans(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15,
                                  color: const Color(0xFFFFFFFF),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                widget.groupCode,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.redditSans(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15,
                                  color: const Color(0xFFFFFFFF),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                widget.faculty,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.redditSans(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                  color: StudentIdCard.textColor,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '· ${widget.sabahGroup}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.redditSans(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                  color: StudentIdCard.textColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.years,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
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
      constraints: const BoxConstraints(minHeight: 160),
      child: SizedBox(
        width: 300,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          clipBehavior: Clip.hardEdge,
          child: Stack(
            children: [
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: _selectedTheme.gradient,
                  ),
                ),
              ),
              Positioned(
                top: -50,
                right: 20,
                child: _Bubble(
                  diameter: 150,
                  color: _selectedTheme.bubbleColor,
                ),
              ),
              Positioned(
                top: 50,
                left: -60,
                child: _Bubble(
                  diameter: 120,
                  color: _selectedTheme.bubbleColor,
                ),
              ),
              Positioned(
                bottom: -15,
                left: 100,
                child: _Bubble(
                  diameter: 60,
                  color: _selectedTheme.bubbleColor,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with UNEC Digital Badge & Tap to Flip
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.18),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.25),
                                    width: 1,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.verified_user_rounded,
                                  size: 13,
                                  color: Color(0xFFFFFFFF),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  'UNEC DIGITAL ID',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.redditSans(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 12,
                                    letterSpacing: 0.6,
                                    color: const Color(0xFFFFFFFF),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.2),
                              width: 0.8,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.flip_rounded,
                                size: 10,
                                color: Color(0xFFFFFFFF),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Tap to flip',
                                style: GoogleFonts.redditSans(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 8.5,
                                  color: const Color(0xFFFFFFFF),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Chip & Contactless Emblems
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Smart Chip Mockup
                        Container(
                          width: 34,
                          height: 25,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFFDF7A), Color(0xFFD4A017)],
                            ),
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.4),
                              width: 0.8,
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.memory_rounded,
                              size: 16,
                              color: Colors.brown.shade800,
                            ),
                          ),
                        ),
                        // NFC Contactless Symbol
                        Icon(
                          Icons.contactless_rounded,
                          size: 20,
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Barcode & Student ID Number Footer
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Digital Barcode Mockup
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(
                                26,
                                (index) => Container(
                                  width: index % 3 == 0
                                      ? 2.5
                                      : (index % 2 == 0 ? 1.5 : 1.0),
                                  height: 20,
                                  margin: const EdgeInsets.only(right: 2),
                                  color: Colors.white.withValues(
                                    alpha: index % 5 == 0 ? 0.35 : 0.85,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'ID: 230101042 · SABAH',
                              style: GoogleFonts.redditSans(
                                fontWeight: FontWeight.w600,
                                fontSize: 8,
                                letterSpacing: 0.8,
                                color: StudentIdCard.textColor.withValues(
                                  alpha: 0.8,
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Official Stamp Icon
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.35),
                              width: 1,
                            ),
                          ),
                          child: Icon(
                            Icons.school_rounded,
                            size: 14,
                            color: Colors.white.withValues(alpha: 0.7),
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
  const _Bubble({
    required this.diameter,
    required this.color,
  });

  final double diameter;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}

class _ProfilePhoto extends StatelessWidget {
  const _ProfilePhoto({
    this.profileImage,
    required this.bubbleColor,
  });

  final ImageProvider? profileImage;
  final Color bubbleColor;

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
        color: bubbleColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          'ZV',
          style: GoogleFonts.redditSans(
            fontWeight: FontWeight.w800,
            fontSize: 22,
            color: const Color(0xFFFFFFFF),
          ),
        ),
      ),
    );
  }
}

