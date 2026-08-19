import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Data model representing student card personalization settings.
/// Structured for seamless JSON serialization, local storage, and future REST API / Database integration.
class StudentCardSettingsModel {
  final String themeId;
  final String avatarType; // 'initials', 'asset', 'custom'
  final String? avatarAssetPath;
  final String? customAvatarBase64;
  final String? quote;
  final DateTime updatedAt;

  const StudentCardSettingsModel({
    required this.themeId,
    required this.avatarType,
    this.avatarAssetPath,
    this.customAvatarBase64,
    this.quote,
    required this.updatedAt,
  });

  factory StudentCardSettingsModel.defaultSettings() {
    return StudentCardSettingsModel(
      themeId: 'blue',
      avatarType: 'asset',
      avatarAssetPath: 'assets/images/profile.jpg',
      quote: '"too pretty to worry about midterms"',
      updatedAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'themeId': themeId,
      'avatarType': avatarType,
      'avatarAssetPath': avatarAssetPath,
      'customAvatarBase64': customAvatarBase64,
      'quote': quote,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory StudentCardSettingsModel.fromJson(Map<String, dynamic> json) {
    return StudentCardSettingsModel(
      themeId: json['themeId'] as String? ?? 'blue',
      avatarType: json['avatarType'] as String? ?? 'asset',
      avatarAssetPath: json['avatarAssetPath'] as String?,
      customAvatarBase64: json['customAvatarBase64'] as String?,
      quote: json['quote'] as String?,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}

/// Service class managing persistence and server synchronization for Student ID Card.
/// Can be extended with `http` client or Firebase/Supabase/PostgreSQL backends.
class StudentCardService {
  static const String _storageKey = 'unec_student_card_customization_v1';

  /// Load settings from local storage or remote API
  Future<StudentCardSettingsModel> loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_storageKey);
      if (jsonStr != null && jsonStr.isNotEmpty) {
        final Map<String, dynamic> decoded = jsonDecode(jsonStr);
        return StudentCardSettingsModel.fromJson(decoded);
      }
    } catch (_) {
      // Fallback to default in case of corrupted storage or test environment
    }
    return StudentCardSettingsModel.defaultSettings();
  }

  /// Save settings locally and queue/send to remote database/API
  Future<bool> saveSettings(StudentCardSettingsModel settings) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = jsonEncode(settings.toJson());
      final success = await prefs.setString(_storageKey, jsonStr);

      // Future API integration hook:
      // await _syncWithRemoteApi(settings);

      return success;
    } catch (_) {
      return false;
    }
  }

  /// Future API sync helper
  Future<bool> syncWithRemoteApi(StudentCardSettingsModel settings) async {
    // Example future implementation:
    // final response = await http.post(
    //   Uri.parse('https://api.unec.edu.az/v1/student/card/preferences'),
    //   headers: {'Content-Type': 'application/json'},
    //   body: jsonEncode(settings.toJson()),
    // );
    // return response.statusCode == 200;
    return true;
  }
}
