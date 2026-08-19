import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:unec_assistant/models/channel.dart';
import 'package:unec_assistant/models/post.dart';
import 'package:unec_assistant/presentation/components/cards/current_class_card.dart';
import 'package:unec_assistant/presentation/components/cards/attendance_card.dart';
import 'package:unec_assistant/presentation/components/cards/schedule_card.dart';
import 'package:unec_assistant/presentation/components/cards/recent_note_card.dart';
import 'package:unec_assistant/presentation/components/cards/recent_grade_card.dart';
import 'package:unec_assistant/presentation/components/cards/post_card.dart';
import 'package:unec_assistant/providers/theme_provider.dart';
import 'package:unec_assistant/providers/calendar_provider.dart';
import 'package:unec_assistant/providers/current_class_provider.dart';
import 'package:unec_assistant/providers/dashboard_provider.dart';
import 'package:unec_assistant/providers/notes_provider.dart';
import 'package:unec_assistant/providers/subject_detail_provider.dart';
import 'package:unec_assistant/models/calendar_event.dart';
import '../../presentation/components/lists/labels.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColors = ref.watch(appColorsProvider);
    final posts = ref.watch(feedPostsProvider);
    final recentFunction = ref.watch(recentFunctionProvider);

    // Section Visibility Logic
    final now = DateTime.now();

    // 1. Class & Attendance
    final currentClassState = ref.watch(currentClassProvider);
    final attentionSubjects = ref.watch(attentionSubjectsProvider);
    final calendarEvents = ref.watch(calendarEventsProvider);
    final hasUpcomingSchedule = calendarEvents.any(
      (e) =>
          (e.type == EventType.personalEvent || e.type == EventType.exam) &&
          e.endTime.isAfter(now),
    );
    final isClassAttendanceVisible =
        !currentClassState.isEmpty ||
        attentionSubjects.isNotEmpty ||
        hasUpcomingSchedule;

    // 2. Academic
    final subjects = ref.watch(allSubjectsProvider);
    final hasRecentGrade = subjects.any(
      (s) =>
          s.seminarEntries.isNotEmpty || s.midtermScore > 0 || s.finalScore > 0,
    );

    // 3. News Feed
    final isNewsFeedVisible = posts.isNotEmpty;

    // 4. Personal
    final notes = ref.watch(notesProvider);
    final isPersonalVisible = notes.isNotEmpty;

    return Scaffold(
      backgroundColor: appColors.background,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 35),
        children: [
          if (isClassAttendanceVisible) ...[
            const SectionLabel('Class & Attendance'),
            const SizedBox(height: 10),
            CurrentClassCard(
              onTap: () => context.go('/functions/${recentFunction.title}'),
            ),
            const AttendanceCard(),
            const ScheduleCard(),
            const SizedBox(height: 10),
          ],

          if (hasRecentGrade) ...[
            const SectionLabel('Academic'),
            const RecentGradeCard(),
            const SizedBox(height: 10),
          ],

          if (isNewsFeedVisible) ...[
            const SectionLabel('News Feed'),
            const SizedBox(height: 10),
            PostCard(
              key: ValueKey(posts.first.id),
              data: Post(
                postId: posts.first.id,
                channelId: 'ch1', // Fallback for old model compatibility
                bodyText: posts.first.content,
                feedType: PostFeedType.official,
                postedAt: DateTime.now(),
                likeCount: posts.first.likeCount,
                commentCount: posts.first.commentCount,
                shareCount: 0,
                isLikedByCurrentUser: false,
              ),
              channel: const Channel(
                channelId: 'ch1',
                channelName: 'Rektorat Kanalı',
                category: ChannelCategory.official,
                isVerified: true,
              ),
              onTap: () => context.go('/feed/post/${posts.first.id}'),
              onLikeTap: () {},
              onShareTap: () {},
            ),
            const SizedBox(height: 10),
          ],

          if (isPersonalVisible) ...[
            const SectionLabel('Personal'),
            const RecentNoteCard(),
          ],
        ],
      ),
    );
  }
}
