import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unec_assistant/presentation/components/cards/student_id_card.dart';
import 'package:unec_assistant/services/student_card_service.dart';

final studentCardServiceProvider = Provider<StudentCardService>((ref) {
  return StudentCardService();
});

String? formatStudentQuote(String? raw) {
  if (raw == null) return null;
  final trimmed = raw.trim();
  if (trimmed.isEmpty) return null;
  if (trimmed.startsWith('"') && trimmed.endsWith('"') && trimmed.length >= 2) {
    return trimmed;
  }
  return '"$trimmed"';
}

class StudentCardCustomizationState {
  final StudentCardTheme selectedTheme;
  final ImageProvider? selectedAvatar;
  final String avatarLabel;
  final String? selectedQuote;
  final List<({String label, ImageProvider image})> recentUploadedImages;

  const StudentCardCustomizationState({
    required this.selectedTheme,
    required this.selectedAvatar,
    required this.avatarLabel,
    required this.selectedQuote,
    required this.recentUploadedImages,
  });

  StudentCardCustomizationState copyWith({
    StudentCardTheme? selectedTheme,
    ImageProvider? Function()? selectedAvatar,
    String? avatarLabel,
    String? Function()? selectedQuote,
    List<({String label, ImageProvider image})>? recentUploadedImages,
  }) {
    return StudentCardCustomizationState(
      selectedTheme: selectedTheme ?? this.selectedTheme,
      selectedAvatar:
          selectedAvatar != null ? selectedAvatar() : this.selectedAvatar,
      avatarLabel: avatarLabel ?? this.avatarLabel,
      selectedQuote:
          selectedQuote != null ? selectedQuote() : this.selectedQuote,
      recentUploadedImages:
          recentUploadedImages ?? this.recentUploadedImages,
    );
  }
}

class StudentCardCustomizationNotifier
    extends Notifier<StudentCardCustomizationState> {
  @override
  StudentCardCustomizationState build() {
    return StudentCardCustomizationState(
      selectedTheme: StudentCardTheme.presets.first,
      selectedAvatar: const AssetImage('assets/images/profile.jpg'),
      avatarLabel: 'Student Photo',
      selectedQuote: '"too pretty to worry about midterms"',
      recentUploadedImages: const [
        (
          label: 'Student Photo',
          image: AssetImage('assets/images/profile.jpg'),
        ),
        (
          label: 'UNEC Profile',
          image: AssetImage('assets/images/unec_profile_picture.png'),
        ),
        (
          label: 'Mascot',
          image: AssetImage('assets/images/robot_mascot.PNG'),
        ),
      ],
    );
  }

  void setTheme(StudentCardTheme theme) {
    state = state.copyWith(selectedTheme: theme);
  }

  void setAvatar(ImageProvider? avatar, String label) {
    state = state.copyWith(
      selectedAvatar: () => avatar,
      avatarLabel: label,
    );
  }

  void setQuote(String? quote) {
    final cleanQuote = formatStudentQuote(quote);
    state = state.copyWith(
      selectedQuote: () => cleanQuote,
    );
  }

  Future<void> saveCustomization({
    required StudentCardTheme theme,
    required ImageProvider? avatar,
    required String avatarLabel,
    required String? quote,
  }) async {
    final cleanQuote = formatStudentQuote(quote);
    state = state.copyWith(
      selectedTheme: theme,
      selectedAvatar: () => avatar,
      avatarLabel: avatarLabel,
      selectedQuote: () => cleanQuote,
    );

    final service = ref.read(studentCardServiceProvider);
    String avatarType = 'initials';
    String? assetPath;
    if (avatar is AssetImage) {
      avatarType = 'asset';
      assetPath = avatar.assetName;
    }

    await service.saveSettings(
      StudentCardSettingsModel(
        themeId: theme.id,
        avatarType: avatarType,
        avatarAssetPath: assetPath,
        quote: cleanQuote,
        updatedAt: DateTime.now(),
      ),
    );
  }

  void addRecentImage(String label, ImageProvider image) {
    final existing = List<({String label, ImageProvider image})>.from(
      state.recentUploadedImages,
    );
    existing.removeWhere((item) => item.label == label);
    existing.insert(0, (label: label, image: image));
    final trimmed = existing.length > 3 ? existing.sublist(0, 3) : existing;
    state = state.copyWith(
      recentUploadedImages: trimmed,
      selectedAvatar: () => image,
      avatarLabel: label,
    );
  }

  void randomizeVibe() {
    final theme = (StudentCardTheme.presets.toList()..shuffle()).first;
    const quotes = [
      '"too pretty to worry about midterms"',
      '"powered by iced matcha & dreams"',
      '"in my academic comeback era"',
      '"99% loaded, 1% awake"',
      '"Future Software Engineer 💻"',
      '"Coffee, Code & Dreams ☕"',
      '"dean\'s list or bust ☕"',
      '"UNEC · SABAH 🎓"',
    ];
    final quote = (quotes.toList()..shuffle()).first;
    state = state.copyWith(
      selectedTheme: theme,
      selectedQuote: () => quote,
    );
  }
}

final studentCardCustomizationProvider = NotifierProvider<
    StudentCardCustomizationNotifier,
    StudentCardCustomizationState>(() {
  return StudentCardCustomizationNotifier();
});
