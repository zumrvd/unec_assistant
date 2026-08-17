class UserSecurityState {
  final String currentPassword;
  final List<String> passwordHistory;
  final DateTime? lastChangeTimestamp;
  final int failedAttempts;
  final DateTime? blockUntil;

  const UserSecurityState({
    required this.currentPassword,
    required this.passwordHistory,
    this.lastChangeTimestamp,
    this.failedAttempts = 0,
    this.blockUntil,
  });

  UserSecurityState copyWith({
    String? currentPassword,
    List<String>? passwordHistory,
    DateTime? lastChangeTimestamp,
    int? failedAttempts,
    DateTime? blockUntil,
  }) {
    return UserSecurityState(
      currentPassword: currentPassword ?? this.currentPassword,
      passwordHistory: passwordHistory ?? this.passwordHistory,
      lastChangeTimestamp: lastChangeTimestamp ?? this.lastChangeTimestamp,
      failedAttempts: failedAttempts ?? this.failedAttempts,
      blockUntil: blockUntil ?? this.blockUntil,
    );
  }

  bool get isBlocked {
    if (blockUntil == null) return false;
    return DateTime.now().isBefore(blockUntil!);
  }

  bool isPasswordInHistory(String pwd) => passwordHistory.contains(pwd);

  int get remainingAttempts => (3 - failedAttempts).clamp(0, 3);
}

