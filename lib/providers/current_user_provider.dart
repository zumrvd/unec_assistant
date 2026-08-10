import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_account.dart';

final currentUserProvider = Provider<UserAccount>((ref) {
  return const UserAccount(
    userId: 'u1',
    displayName: 'Zümrüd V.',
    initials: 'ZV',
  );
});
