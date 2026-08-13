import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_security_state.dart';

class UserSecurityNotifier extends Notifier<UserSecurityState> {
  @override
  UserSecurityState build() {
    // Initial state with a default password for demo purposes
    return const UserSecurityState(
      currentPassword: '098123wasD<2',
      passwordHistory: ['Password123!'],
    );
  }

  String? validateNewPassword(String password) {
    if (password.length < 8 || password.length > 32) return '8-32 characters long';
    if (!RegExp(r'[A-Z]').hasMatch(password)) return 'One uppercase letter (A-Z)';
    if (!RegExp(r'[a-z]').hasMatch(password)) return 'One lowercase letter (a-z)';
    if (!RegExp(r'[0-9]').hasMatch(password)) return 'One number';
    if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(password)) return 'One special character';
    
    // History check
    if (state.passwordHistory.contains(password)) {
      return 'Different from last 3 passwords';
    }
    
    return null;
  }

  Future<String?> changePassword(String oldPass, String newPass) async {
    // 1. Check block
    if (state.isBlocked) {
      final remaining = state.blockUntil!.difference(DateTime.now());
      return 'Too many attempts. Try again in ${remaining.inMinutes} minutes.';
    }

    // 2. Validate current password
    if (oldPass != state.currentPassword) {
      final newFailedAttempts = state.failedAttempts + 1;
      DateTime? newBlock;
      if (newFailedAttempts >= 3) {
        newBlock = DateTime.now().add(const Duration(hours: 1));
      }
      
      state = state.copyWith(
        failedAttempts: newFailedAttempts,
        blockUntil: newBlock,
      );
      
      if (newBlock != null) {
        return 'Too many failed attempts. You are blocked for 1 hour.';
      }
      return 'Current password is incorrect.';
    }

    // 3. Validate new password
    final error = validateNewPassword(newPass);
    if (error != null) return error;

    // 4. Update state
    final newHistory = [newPass, ...state.passwordHistory];
    if (newHistory.length > 3) {
      newHistory.removeLast();
    }

    state = state.copyWith(
      currentPassword: newPass,
      passwordHistory: newHistory,
      lastChangeTimestamp: DateTime.now(),
      failedAttempts: 0,
      blockUntil: DateTime.now().add(const Duration(minutes: 5)), // Optional: block for 5 mins after success
    );

    return null; // Success
  }
}

final userSecurityProvider = NotifierProvider<UserSecurityNotifier, UserSecurityState>(() {
  return UserSecurityNotifier();
});
