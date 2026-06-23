import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:unec_assistant/presentation/components/cards/current_class_card.dart';
import 'package:unec_assistant/presentation/components/cards/feed_post_card.dart';
import 'package:unec_assistant/providers/dashboard_providers.dart';

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
          const Text(
            'Class & Attendance',
            style: TextStyle(
              color: Color(0xFF838A97),
              fontSize: 15,
            ),
          ),

          const SizedBox(height: 5),

          CurrentClassCard(
            onTap: () => context.go('/functions/${recentFunction.title}'),
          ),

          const SizedBox(height: 5),

          const Text(
            'News Feed',
            style: TextStyle(
              color: Color(0xFF838A97),
              fontSize: 15,
            ),
          ),

          const SizedBox(height: 5),

          if (posts.isNotEmpty)
            FeedPostCard(
              key: ValueKey(posts.first.id),
              post: posts.first,
              isInteractive: false,
            ),
        ],
      ),
    );
  }
}
