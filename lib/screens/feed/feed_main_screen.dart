import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unec_assistant/presentation/components/buttons/feed_filter_buttons.dart';
import 'package:unec_assistant/presentation/components/cards/feed_post_card.dart';
import 'package:unec_assistant/providers/dashboard_provider.dart';

class FeedMainScreen extends ConsumerWidget {
  const FeedMainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(feedPostsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 35),
        itemCount: posts.length + 2,
        itemBuilder: (context, index) {
          if (index == 0) {
            return const Padding(
              padding: EdgeInsets.only(bottom: 10, top: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'News Feed',
                    style: TextStyle(
                      color: Color(0xFF838A97),
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(height: 10),
                  FeedFilterButtons(),
                ],
              ),
            );
          }

          if (index == 1) {
            return const SizedBox(height: 15);
          }

          final post = posts[index - 2];
          return Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: FeedPostCard(
              key: ValueKey(post.id),
              post: post,
              isInteractive: true,
            ),
          );
        },
      ),
    );
  }
}
