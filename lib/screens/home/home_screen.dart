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
import 'package:unec_assistant/providers/dashboard_provider.dart';

import '../../presentation/components/lists/labels.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(feedPostsProvider);
    final recentFunction = ref.watch(recentFunctionProvider);

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 35),
        children: [

          const SectionLabel('Class & Attendance'),
          const SizedBox(height: 10),

          CurrentClassCard(
            onTap: () => context.go('/functions/${recentFunction.title}'),
          ),

          const AttendanceCard(),

          const ScheduleCard(),

          const RecentGradeCard(),

          const SizedBox(height: 10),
          const SectionLabel('News Feed'),
          const SizedBox(height: 10),

          if (posts.isNotEmpty)
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
          const SectionLabel('Personal'),

          const RecentNoteCard(),

        ],
      ),
    );
  }
}
