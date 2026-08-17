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

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    // 1. Check block
    if (state.isBlocked) {
      return false;
    }

    // 2. Validate current password
    if (currentPassword != state.currentPassword) {
      final newFailedAttempts = state.failedAttempts + 1;
      DateTime? newBlock;
      if (newFailedAttempts >= 3) {
        newBlock = DateTime.now().add(const Duration(hours: 1));
      }
      
      state = state.copyWith(
        failedAttempts: newFailedAttempts,
        blockUntil: newBlock,
      );
      return false;
    }

    // 3. Validate new password
    final error = validateNewPassword(newPassword);
    if (error != null) return false;

    // 4. Update state
    final newHistory = [newPassword, ...state.passwordHistory];
    if (newHistory.length > 3) {
      newHistory.removeLast();
    }

    state = state.copyWith(
      currentPassword: newPassword,
      passwordHistory: newHistory,
      lastChangeTimestamp: DateTime.now(),
      failedAttempts: 0,
    );

    return true; // Success
  }
}


final userSecurityProvider = NotifierProvider<UserSecurityNotifier, UserSecurityState>(() {
  return UserSecurityNotifier();
});
