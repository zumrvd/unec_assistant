import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/student_profile.dart';
import '../models/channel.dart';
import 'subscriptions_provider.dart';

final studentProfileProvider = Provider<StudentProfile>((ref) {
  final subscribedChannels = ref.watch(subscriptionsProvider);
  final clubs = subscribedChannels
      .where((c) => c.category == ChannelCategory.clubs)
      .map((c) => c.channelName.replaceAll(' Club', ''))
      .toList();

  return StudentProfile(
    studentName: 'Zümrüd Verdiyeva',
    studentId: '230101042',
    initials: 'ZV',
    isActive: true,
    faculty: 'Rəqəmsal Iqtisadiyyat',
    major: 'Informasiya Texnologiyaları',
    gpa: 92.3,
    clubMemberships: clubs.isEmpty ? ['Tech', 'Debat'] : clubs,
    groupCode: 'BİT-1102',
    year: 'Year 1',
    enrollmentDate: 'September 2024',
    earnedCredits: 30,
    totalCredits: 120,
  );
});
