class UserAccount {
  final String userId;
  final String displayName;
  final String? avatarUrl;
  final String initials; // fallback when avatarUrl is null/fails, e.g. "ZV"

  const UserAccount({
    required this.userId,
    required this.displayName,
    this.avatarUrl,
    required this.initials,
  });
}
