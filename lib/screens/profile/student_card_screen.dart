import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unec_assistant/presentation/components/cards/student_id_card.dart';
import 'package:unec_assistant/presentation/components/lists/labels.dart';
import 'package:unec_assistant/presentation/theme/app_colors.dart';
import 'package:unec_assistant/providers/student_card_customization_provider.dart';
import 'package:unec_assistant/providers/theme_provider.dart';
import 'package:unec_assistant/providers/locale_provider.dart';

class StudentCardScreen extends ConsumerStatefulWidget {
  const StudentCardScreen({super.key});

  @override
  ConsumerState<StudentCardScreen> createState() => _StudentCardScreenState();
}

class _StudentCardScreenState extends ConsumerState<StudentCardScreen> {
  late TextEditingController _quoteController;
  final _cardController = StudentIdCardController();

  // Draft editing state
  late StudentCardTheme _draftTheme;
  late ImageProvider? _draftAvatar;
  late String _draftAvatarLabel;
  late String? _draftQuote;

  // Baseline initial state to detect unsaved changes
  late StudentCardTheme _initialTheme;
  late ImageProvider? _initialAvatar;
  late String? _initialQuote;

  static const List<String?> _quoteSuggestions = [
    '"too pretty to worry about midterms"',
    '"powered by iced matcha & dreams"',
    '"in my academic comeback era"',
    '"99% loaded, 1% awake"',
    '"future Software Engineer "',
    '"coffee, Code & Dreams "',
    '"git it girl "',
    '"silent grind, loud success"',
    null,
  ];

  List<({String label, ImageProvider image})> get _presetAvatars {
    final str = ref.read(strProvider);
    return [
      (
        label: str.studentCardPhotoLabel,
        image: const AssetImage('assets/images/profile.jpg'),
      ),
      (
        label: str.studentCardMascotLabel,
        image: const AssetImage('assets/images/robot_mascot.PNG'),
      ),
      (
        label: str.studentCardUnecProfileLabel,
        image: const AssetImage('assets/images/unec_profile_picture.png'),
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    final savedState = ref.read(studentCardCustomizationProvider);
    _draftTheme = savedState.selectedTheme;
    _draftAvatar = savedState.selectedAvatar;
    _draftAvatarLabel = savedState.avatarLabel;
    _draftQuote = savedState.selectedQuote;

    _initialTheme = savedState.selectedTheme;
    _initialAvatar = savedState.selectedAvatar;
    _initialQuote = savedState.selectedQuote;

    _quoteController = TextEditingController(
      text: _extractRawQuote(_draftQuote),
    );
  }

  @override
  void dispose() {
    _quoteController.dispose();
    super.dispose();
  }

  String _extractRawQuote(String? quote) {
    if (quote == null) return '';
    var trimmed = quote.trim();
    if (trimmed.startsWith('"') &&
        trimmed.endsWith('"') &&
        trimmed.length >= 2) {
      trimmed = trimmed.substring(1, trimmed.length - 1);
    }
    return trimmed;
  }

  bool get _hasUnsavedChanges {
    final currentQuote = formatStudentQuote(_draftQuote);
    final initialQuote = formatStudentQuote(_initialQuote);
    final avatarChanged = _draftAvatar != _initialAvatar;
    final themeChanged = _draftTheme.id != _initialTheme.id;
    final quoteChanged = currentQuote != initialQuote;
    return avatarChanged || themeChanged || quoteChanged;
  }

  void _onSettingInteracted() {
    if (!_cardController.isFront) {
      _cardController.flipToFront();
    }
  }

  Future<void> _handleBackNavigation() async {
    if (!_hasUnsavedChanges) {
      context.pop();
      return;
    }
    await _showDiscardWarningDialog();
  }

  Future<void> _showDiscardWarningDialog() async {
    final appColors = ref.read(appColorsProvider);
    final str = ref.read(strProvider);
    final choice = await showDialog<String>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: appColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0x26E3993C),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.warning_amber_rounded,
                      color: Color(0xFFE3993C),
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      str.studentCardUnsavedTitle,
                      style: GoogleFonts.redditSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                        color: appColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                str.studentCardUnsavedDesc,
                style: GoogleFonts.redditSans(
                  fontSize: 13.5,
                  height: 1.45,
                  color: appColors.textSecondary,
                ),
              ),
              const SizedBox(height: 20),
              // Action 1: Primary "Save & Return" full width
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(ctx).pop('save'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.check_circle_rounded, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        str.studentCardSaveBtn,
                        style: GoogleFonts.redditSans(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Action 2 & 3: Side-by-side balanced actions
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(ctx).pop('discard'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFD54829),
                          side: BorderSide(
                            color: const Color(0xFFD54829).withValues(alpha: 0.35),
                            width: 1.2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          str.studentCardDiscardBtn,
                          style: GoogleFonts.redditSans(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: TextButton(
                        onPressed: () => Navigator.of(ctx).pop('stay'),
                        style: TextButton.styleFrom(
                          backgroundColor: appColors.inputBackground,
                          foregroundColor: appColors.textSecondary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: appColors.borderColor,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Text(
                          str.studentCardKeepEditingBtn,
                          style: GoogleFonts.redditSans(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (choice == 'discard') {
      if (mounted) context.pop();
    } else if (choice == 'save') {
      await _saveAndReturn();
    }
  }

  Future<void> _saveAndReturn() async {
    await ref.read(studentCardCustomizationProvider.notifier).saveCustomization(
          theme: _draftTheme,
          avatar: _draftAvatar,
          avatarLabel: _draftAvatarLabel,
          quote: _draftQuote,
        );
    if (mounted) {
      context.pop();
    }
  }

  void _showImagePickerSheet() {
    final appColors = ref.read(appColorsProvider);
    final str = ref.read(strProvider);
    showModalBottomSheet(
      context: context,
      backgroundColor: appColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      str.studentCardChooseAvatar,
                      style: GoogleFonts.redditSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: appColors.textPrimary,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: _presetAvatars.map((avatarPreset) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _draftAvatar = avatarPreset.image;
                          _draftAvatarLabel = avatarPreset.label;
                        });
                        _onSettingInteracted();
                        Navigator.of(context).pop();
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: appColors.borderColor,
                                width: 2,
                              ),
                              image: DecorationImage(
                                image: avatarPreset.image,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            avatarPreset.label,
                            style: GoogleFonts.redditSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: appColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appColors = ref.watch(appColorsProvider);
    final str = ref.watch(strProvider);

    return PopScope(
      canPop: !_hasUnsavedChanges,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleBackNavigation();
      },
      child: Scaffold(
        backgroundColor: appColors.background,
        appBar: CustomAppBar(
          title: str.studentCardTitle,
          onBackTap: _handleBackNavigation,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top: Live Interactive Student ID Card Preview (starts on back face)
              Center(
                child: StudentIdCard(
                  studentName: 'Zümrüd Verdiyeva',
                  groupCode: '575-1',
                  faculty: 'İnformasiya Texnologiyaları',
                  sabahGroup: 'SABAH grupları',
                  years: '2025-2029',
                  yearBadge: '1-ci kurs',
                  quote: _draftQuote,
                  profileImage: _draftAvatar,
                  theme: _draftTheme,
                  initialIsFront: false,
                  cardController: _cardController,
                ),
              ),
              const SizedBox(height: 8),

              // Flip Card Micro Hint & Random Vibe Action
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 1),
                          child: Icon(
                            Icons.touch_app_rounded,
                            size: 13,
                            color: appColors.textSecondary,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            str.studentCardTapToFlip,
                            softWrap: true,
                            style: GoogleFonts.redditSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: appColors.textSecondary,
                              height: 1.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () {
                      final randomTheme =
                          (StudentCardTheme.presets.toList()..shuffle()).first;
                      final validQuotes = _quoteSuggestions
                          .where((q) => q != null && q.isNotEmpty)
                          .toList();
                      final randomQuote = (validQuotes..shuffle()).first;

                      _quoteController.text = _extractRawQuote(randomQuote);
                      setState(() {
                        _draftTheme = randomTheme;
                        _draftQuote = randomQuote;
                      });
                      _onSettingInteracted();
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: appColors.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: appColors.primary.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.casino_rounded,
                            size: 13,
                            color: appColors.primaryOnContainer,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            str.studentCardSurpriseVibe,
                            style: GoogleFonts.redditSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: appColors.primaryOnContainer,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // DEDICATED ROW 1: Gradient Theme Palette (Pure Visual Swatches)
              _buildCustomizationCard(
                appColors: appColors,
                icon: Icons.palette_rounded,
                title: str.studentCardThemeTitle,
                subtitle: str.studentCardThemeSubtitle,
                child: SizedBox(
                  height: 46,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: StudentCardTheme.presets.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final themePreset = StudentCardTheme.presets[index];
                      final isSelected = _draftTheme.id == themePreset.id;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _draftTheme = themePreset;
                          });
                          _onSettingInteracted();
                        },
                        behavior: HitTestBehavior.opaque,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 44,
                          height: 44,
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? appColors.primary
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: themePreset.gradient,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(
                                    alpha: appColors.isDark ? 0.35 : 0.15,
                                  ),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: isSelected
                                ? const Center(
                                    child: Icon(
                                      Icons.check_rounded,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                  )
                                : null,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // DEDICATED ROW 2: Profile Avatar & Identity
              _buildCustomizationCard(
                appColors: appColors,
                icon: Icons.face_retouching_natural_rounded,
                title: str.studentCardAvatarTitle,
                subtitle: str.studentCardAvatarSubtitle,
                child: Row(
                  children: [
                    // Option 1: Initials
                    _buildAvatarOption(
                      appColors: appColors,
                      label: str.studentCardInitials,
                      isSelected: _draftAvatar == null,
                      avatarWidget: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: _draftTheme.bubbleColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            'ZV',
                            style: GoogleFonts.redditSans(
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _draftAvatar = null;
                          _draftAvatarLabel = str.studentCardInitials;
                        });
                        _onSettingInteracted();
                      },
                    ),
                    const SizedBox(width: 10),

                    // Option 2: Student Photo
                    _buildAvatarOption(
                      appColors: appColors,
                      label: str.studentCardPhoto,
                      isSelected: _draftAvatar ==
                          const AssetImage('assets/images/profile.jpg'),
                      avatarWidget: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: const Image(
                          image: AssetImage('assets/images/profile.jpg'),
                          width: 44,
                          height: 44,
                          fit: BoxFit.cover,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _draftAvatar =
                              const AssetImage('assets/images/profile.jpg');
                          _draftAvatarLabel = str.studentCardPhoto;
                        });
                        _onSettingInteracted();
                      },
                    ),
                    const SizedBox(width: 10),

                    // Option 3: Mascot
                    _buildAvatarOption(
                      appColors: appColors,
                      label: str.studentCardMascot,
                      isSelected: _draftAvatar ==
                          const AssetImage('assets/images/robot_mascot.PNG'),
                      avatarWidget: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: const Image(
                          image: AssetImage('assets/images/robot_mascot.PNG'),
                          width: 44,
                          height: 44,
                          fit: BoxFit.cover,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _draftAvatar =
                              const AssetImage('assets/images/robot_mascot.PNG');
                          _draftAvatarLabel = str.studentCardMascot;
                        });
                        _onSettingInteracted();
                      },
                    ),
                    const SizedBox(width: 10),

                    // Option 4: Custom / Picker
                    _buildAvatarOption(
                      appColors: appColors,
                      label: str.studentCardMore,
                      isSelected: false,
                      avatarWidget: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: appColors.inputBackground,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: appColors.borderColor,
                            style: BorderStyle.solid,
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.add_photo_alternate_outlined,
                            size: 20,
                            color: appColors.primary,
                          ),
                        ),
                      ),
                      onTap: _showImagePickerSheet,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // DEDICATED ROW 3: Campus Motto & Quote
              _buildCustomizationCard(
                appColors: appColors,
                icon: Icons.format_quote_rounded,
                title: str.studentCardMottoTitle,
                subtitle: str.studentCardMottoSubtitle,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text Input
                    Container(
                      decoration: BoxDecoration(
                        color: appColors.inputBackground,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: appColors.borderColor,
                          width: 1,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          Icon(
                            Icons.edit_note_rounded,
                            size: 18,
                            color: appColors.textSecondary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _quoteController,
                              onChanged: (val) {
                                final text = val.trim();
                                setState(() {
                                  _draftQuote = text.isEmpty ? null : text;
                                });
                                _onSettingInteracted();
                              },
                              style: GoogleFonts.redditSans(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                color: appColors.textPrimary,
                              ),
                              cursorColor: appColors.primary,
                              maxLength: 45,
                              decoration: InputDecoration(
                                hintText: str.studentCardMottoHint,
                                hintStyle: GoogleFonts.redditSans(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  color: appColors.textMuted,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                counterText: '',
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ),
                          if (_quoteController.text.isNotEmpty)
                            GestureDetector(
                              onTap: () {
                                _quoteController.clear();
                                setState(() {
                                  _draftQuote = null;
                                });
                                _onSettingInteracted();
                              },
                              behavior: HitTestBehavior.opaque,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Icon(
                                  Icons.cancel_rounded,
                                  size: 16,
                                  color: appColors.textSecondary,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Quick Inspiration Quotes
                    Text(
                      str.studentCardQuickVibes,
                      style: GoogleFonts.redditSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.6,
                        color: appColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    SizedBox(
                      height: 32,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: _quoteSuggestions.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final quoteOption = _quoteSuggestions[index];
                          final isSelected = formatStudentQuote(_draftQuote) ==
                              formatStudentQuote(quoteOption);
                          final displayLabel = quoteOption ?? str.studentCardClearQuote;

                          return GestureDetector(
                            onTap: () {
                              _quoteController.text =
                                  _extractRawQuote(quoteOption);
                              setState(() {
                                _draftQuote = quoteOption;
                              });
                              _onSettingInteracted();
                            },
                            behavior: HitTestBehavior.opaque,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? appColors.primaryContainer
                                    : appColors.inputBackground,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isSelected
                                      ? appColors.primary
                                      : appColors.borderColor,
                                  width: isSelected ? 1.5 : 1,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  displayLabel,
                                  style: GoogleFonts.redditSans(
                                    fontWeight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                    fontSize: 11,
                                    fontStyle: quoteOption != null
                                        ? FontStyle.italic
                                        : FontStyle.normal,
                                    color: isSelected
                                        ? appColors.primaryOnContainer
                                        : appColors.textPrimary,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Bottom Save & Return Button
              GestureDetector(
                onTap: _saveAndReturn,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: appColors.primary,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: appColors.primary.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.check_circle_rounded,
                        size: 18,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        str.studentCardSaveBtn,
                        style: GoogleFonts.redditSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomizationCard({
    required AppColors appColors,
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: appColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: appColors.borderColor,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: appColors.isDark ? 0.2 : 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: appColors.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 16,
                  color: appColors.primaryOnContainer,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.redditSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: appColors.textPrimary,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: GoogleFonts.redditSans(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w500,
                        color: appColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildAvatarOption({
    required AppColors appColors,
    required String label,
    required bool isSelected,
    required Widget avatarWidget,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? appColors.primaryContainer
                : appColors.inputBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? appColors.primary : appColors.borderColor,
              width: isSelected ? 1.8 : 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              avatarWidget,
              const SizedBox(height: 6),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.redditSans(
                  fontSize: 10.5,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                  color: isSelected
                      ? appColors.primaryOnContainer
                      : appColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
