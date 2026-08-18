import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class StudentCardTheme {
  final String name;
  final LinearGradient gradient;
  final Color bubbleColor;
  final Color badgeBackgroundColor;

  const StudentCardTheme({
    required this.name,
    required this.gradient,
    required this.bubbleColor,
    required this.badgeBackgroundColor,
  });

  static const List<StudentCardTheme> presets = [
    StudentCardTheme(
      name: 'Ocean Blue',
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
    StudentCardTheme(
      name: 'Emerald Mint',
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF059669),
          Color(0xCC059669),
          Color(0xFF047857),
        ],
        stops: [0.0, 0.5, 1.0],
      ),
      bubbleColor: Color(0xFF10B981),
      badgeBackgroundColor: Color(0xB534D399),
    ),
    StudentCardTheme(
      name: 'Sunset Violet',
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF7C3AED),
          Color(0xCC7C3AED),
          Color(0xFF6D28D9),
        ],
        stops: [0.0, 0.5, 1.0],
      ),
      bubbleColor: Color(0xFF8B5CF6),
      badgeBackgroundColor: Color(0xB5A78BFA),
    ),
    StudentCardTheme(
      name: 'Rose Berry',
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFE11D48),
          Color(0xCCE11D48),
          Color(0xFFBE123C),
        ],
        stops: [0.0, 0.5, 1.0],
      ),
      bubbleColor: Color(0xFFF43F5E),
      badgeBackgroundColor: Color(0xB5FB7185),
    ),
    StudentCardTheme(
      name: 'Midnight Onyx',
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF334155),
          Color(0xCC334155),
          Color(0xFF1E293B),
        ],
        stops: [0.0, 0.5, 1.0],
      ),
      bubbleColor: Color(0xFF475569),
      badgeBackgroundColor: Color(0xB564748B),
    ),
    StudentCardTheme(
      name: 'Golden Amber',
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFD97706),
          Color(0xCCD97706),
          Color(0xFFB45309),
        ],
        stops: [0.0, 0.5, 1.0],
      ),
      bubbleColor: Color(0xFFF59E0B),
      badgeBackgroundColor: Color(0xB5FBBF24),
    ),
  ];
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
  late TextEditingController _quoteController;

  // Up to 3 saved recent uploaded pictures
  late List<({String label, ImageProvider image})> _recentUploadedImages;

  static const List<String?> _quoteSuggestions = [
    '"too pretty to worry about midterms"',
    '"Future Software Engineer 💻"',
    '"Coffee, Code & Dreams ☕"',
    '"UNEC · SABAH 🎓"',
    null,
  ];

  static const List<({String label, ImageProvider image})> _availableUploadPresets = [
    (
      label: 'Cat (Midterms)',
      image: AssetImage('assets/images/profile.jpg'),
    ),
    (
      label: 'Student Photo',
      image: AssetImage('assets/images/unec_profile_picture.png'),
    ),
    (
      label: 'Robot Mascot',
      image: AssetImage('assets/images/robot_mascot.PNG'),
    ),
    (
      label: 'Alternate Cat',
      image: AssetImage('assets/images/profile.png'),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selectedAvatar =
        widget.profileImage ?? const AssetImage('assets/images/profile.jpg');
    _selectedQuote =
        widget.quote ?? '"too pretty to worry about midterms"';
    _selectedTheme = StudentCardTheme.presets.first;

    _quoteController = TextEditingController(text: _selectedQuote ?? '');
    _quoteController.addListener(() {
      final text = _quoteController.text.trim();
      if (_selectedQuote != (text.isEmpty ? null : text)) {
        setState(() {
          _selectedQuote = text.isEmpty ? null : text;
        });
      }
    });

    _recentUploadedImages = [
      (
        label: 'Cat',
        image: const AssetImage('assets/images/profile.jpg'),
      ),
      (
        label: 'Photo',
        image: const AssetImage('assets/images/unec_profile_picture.png'),
      ),
      (
        label: 'Mascot',
        image: const AssetImage('assets/images/robot_mascot.PNG'),
      ),
    ];

    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
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

  void _toggleCard() {
    if (_isFront) {
      _controller.forward();
    } else {
      FocusScope.of(context).unfocus();
      _controller.reverse();
    }
    setState(() {
      _isFront = !_isFront;
    });
  }

  void _handleUploadNewPhoto() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border.all(color: const Color(0xFF334155), width: 1),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Upload Profile Picture',
                    style: GoogleFonts.redditSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: const Color(0xFFFFFFFF),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    behavior: HitTestBehavior.opaque,
                    child: const Icon(
                      Icons.close_rounded,
                      color: Color(0xFF94A3B8),
                      size: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Select a photo to upload to your student ID card',
                style: GoogleFonts.redditSans(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: const Color(0xFF94A3B8),
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _availableUploadPresets.map((preset) {
                  return GestureDetector(
                    onTap: () {
                      _onNewPhotoUploaded(preset);
                      Navigator.pop(context);
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      width: 140,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF334155),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image(
                              image: preset.image,
                              width: 38,
                              height: 38,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              preset.label,
                              style: GoogleFonts.redditSans(
                                fontWeight: FontWeight.w600,
                                fontSize: 11,
                                color: const Color(0xFFFFFFFF),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  void _onNewPhotoUploaded(({String label, ImageProvider image}) newPhoto) {
    setState(() {
      _selectedAvatar = newPhoto.image;

      // Update recent uploaded list (max 3 items)
      _recentUploadedImages.removeWhere((item) => item.image == newPhoto.image);
      _recentUploadedImages.insert(0, newPhoto);
      if (_recentUploadedImages.length > 3) {
        _recentUploadedImages = _recentUploadedImages.sublist(0, 3);
      }
    });
  }

  @override
  void dispose() {
    _quoteController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: _isFront ? _toggleCard : null,
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
                        Text(
                          'UNEC · TƏLƏBƏ',
                          style: GoogleFonts.redditSans(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: StudentIdCard.textColor,
                          ),
                        ),
                        Row(
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
                          width: 80,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _ProfilePhoto(
                                profileImage: _selectedAvatar,
                                bubbleColor: _selectedTheme.bubbleColor,
                              ),
                              if (_selectedQuote != null &&
                                  _selectedQuote!.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Text(
                                  _selectedQuote!,
                                  softWrap: true,
                                  style: GoogleFonts.redditSans(
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 8.5,
                                    color: StudentIdCard.textColor,
                                    height: 1.15,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
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
      constraints: const BoxConstraints(minHeight: 250),
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
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with flip back button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.auto_fix_high_rounded,
                              size: 16,
                              color: StudentIdCard.textColor,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Personalize Card',
                              style: GoogleFonts.redditSans(
                                fontWeight: FontWeight.w800,
                                fontSize: 13,
                                color: const Color(0xFFFFFFFF),
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: _toggleCard,
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.3),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Done',
                                  style: GoogleFonts.redditSans(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 11,
                                    color: const Color(0xFFFFFFFF),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.check_rounded,
                                  size: 13,
                                  color: Color(0xFFFFFFFF),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Avatar Selector: Initials + Upload + up to 3 saved recent slots (max 5 options)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'AVATAR (MAX 5 SLOTS)',
                          style: GoogleFonts.redditSans(
                            fontWeight: FontWeight.w700,
                            fontSize: 8.5,
                            letterSpacing: 0.5,
                            color: StudentIdCard.textColor,
                          ),
                        ),
                        Text(
                          '${1 + 1 + _recentUploadedImages.length}/5 options',
                          style: GoogleFonts.redditSans(
                            fontWeight: FontWeight.w600,
                            fontSize: 8,
                            color: StudentIdCard.textColor.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Slot 1: Initials
                        _buildInitialsSlot(),

                        // Slot 2: Upload Action
                        _buildUploadSlot(),

                        // Slots 3, 4, 5: Up to 3 saved recent uploaded pictures
                        ..._recentUploadedImages.map((savedPhoto) {
                          final isSelected = _selectedAvatar == savedPhoto.image;
                          return _buildPhotoSlot(
                            image: savedPhoto.image,
                            label: savedPhoto.label,
                            isSelected: isSelected,
                            onTap: () {
                              setState(() {
                                _selectedAvatar = savedPhoto.image;
                              });
                            },
                          );
                        }),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Card Background Color Theme Selector
                    Text(
                      'GRADIENT THEME',
                      style: GoogleFonts.redditSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 8.5,
                        letterSpacing: 0.5,
                        color: StudentIdCard.textColor,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: StudentCardTheme.presets.map((themePreset) {
                        final isSelected =
                            _selectedTheme.name == themePreset.name;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedTheme = themePreset;
                            });
                          },
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              gradient: themePreset.gradient,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFFFFFFFF)
                                    : Colors.white.withValues(alpha: 0.3),
                                width: isSelected ? 2.5 : 1,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.3),
                                        blurRadius: 4,
                                        spreadRadius: 1,
                                      ),
                                    ]
                                  : null,
                            ),
                            child: isSelected
                                ? const Center(
                                    child: Icon(
                                      Icons.check_rounded,
                                      size: 15,
                                      color: Color(0xFFFFFFFF),
                                    ),
                                  )
                                : null,
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 8),

                    // Quote Input Box & Presets
                    Text(
                      'CARD QUOTE',
                      style: GoogleFonts.redditSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 8.5,
                        letterSpacing: 0.5,
                        color: StudentIdCard.textColor,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // User Input Box
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.25),
                          width: 1,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.format_quote_rounded,
                            size: 14,
                            color: StudentIdCard.textColor,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: TextField(
                              controller: _quoteController,
                              style: GoogleFonts.redditSans(
                                fontWeight: FontWeight.w600,
                                fontSize: 10.5,
                                color: const Color(0xFFFFFFFF),
                              ),
                              cursorColor: const Color(0xFFFFFFFF),
                              maxLength: 45,
                              decoration: InputDecoration(
                                hintText: 'Enter your custom quote...',
                                hintStyle: GoogleFonts.redditSans(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10,
                                  color: StudentIdCard.textColor.withValues(alpha: 0.6),
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                counterText: '',
                                contentPadding: const EdgeInsets.symmetric(vertical: 6),
                              ),
                            ),
                          ),
                          if (_quoteController.text.isNotEmpty)
                            GestureDetector(
                              onTap: () {
                                _quoteController.clear();
                              },
                              behavior: HitTestBehavior.opaque,
                              child: const Icon(
                                Icons.cancel_rounded,
                                size: 14,
                                color: StudentIdCard.textColor,
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),

                    // Quick Quote Suggestions
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        children: _quoteSuggestions.map((quoteOption) {
                          final isSelected = _selectedQuote == quoteOption;
                          final displayLabel = quoteOption ?? 'Clear quote';
                          return Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: GestureDetector(
                              onTap: () {
                                _quoteController.text = quoteOption ?? '';
                              },
                              behavior: HitTestBehavior.opaque,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 7,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.white.withValues(alpha: 0.25)
                                      : Colors.white.withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: isSelected
                                        ? const Color(0xFFFFFFFF)
                                        : Colors.transparent,
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  displayLabel,
                                  style: GoogleFonts.redditSans(
                                    fontWeight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                    fontSize: 8,
                                    fontStyle: quoteOption != null
                                        ? FontStyle.italic
                                        : FontStyle.normal,
                                    color: isSelected
                                        ? const Color(0xFFFFFFFF)
                                        : StudentIdCard.textColor,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
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

  Widget _buildInitialsSlot() {
    final isSelected = _selectedAvatar == null;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedAvatar = null;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 48,
        padding: const EdgeInsets.symmetric(vertical: 3),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white.withValues(alpha: 0.25)
              : Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(9),
          border: Border.all(
            color: isSelected ? const Color(0xFFFFFFFF) : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: _selectedTheme.bubbleColor,
              ),
              child: Center(
                child: Text(
                  'ZV',
                  style: GoogleFonts.redditSans(
                    fontWeight: FontWeight.w800,
                    fontSize: 10,
                    color: const Color(0xFFFFFFFF),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Initials',
              style: GoogleFonts.redditSans(
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                fontSize: 8,
                color: isSelected
                    ? const Color(0xFFFFFFFF)
                    : StudentIdCard.textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadSlot() {
    return GestureDetector(
      onTap: _handleUploadNewPhoto,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 48,
        padding: const EdgeInsets.symmetric(vertical: 3),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(9),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.white.withValues(alpha: 0.15),
              ),
              child: const Center(
                child: Icon(
                  Icons.add_photo_alternate_rounded,
                  size: 14,
                  color: Color(0xFFFFFFFF),
                ),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Upload',
              style: GoogleFonts.redditSans(
                fontWeight: FontWeight.w600,
                fontSize: 8,
                color: StudentIdCard.textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoSlot({
    required ImageProvider image,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 48,
        padding: const EdgeInsets.symmetric(vertical: 3),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white.withValues(alpha: 0.25)
              : Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(9),
          border: Border.all(
            color: isSelected ? const Color(0xFFFFFFFF) : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image(
                image: image,
                width: 26,
                height: 26,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.redditSans(
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                fontSize: 8,
                color: isSelected
                    ? const Color(0xFFFFFFFF)
                    : StudentIdCard.textColor,
              ),
            ),
          ],
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

