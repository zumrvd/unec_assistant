import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../presentation/components/buttons/feed_filter_tabs.dart';
import '../../../presentation/components/cards/post_card.dart';
import '../../../presentation/components/inputs/app_search_bar.dart';
import '../../../providers/feed_provider.dart';

class FeedMainScreen extends ConsumerStatefulWidget {
  const FeedMainScreen({super.key});

  @override
  ConsumerState<FeedMainScreen> createState() => _FeedMainScreenState();
}

class _FeedMainScreenState extends ConsumerState<FeedMainScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final feedState = ref.watch(feedProvider);
    final repo = ref.read(feedRepositoryProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
            child: Text(
              'News Feed',
              style: GoogleFonts.redditSans(
                color: const Color(0xFF838A97),
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35),
            child: FeedFilterTabs(
              selectedFilters: feedState.filters,
              onSelect: (type) => ref.read(feedProvider.notifier).toggleFilter(type),
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35),
            child: AppSearchBar(
              controller: _searchController,
              hintText: 'Search posts...',
              onChanged: (q) => ref.read(feedProvider.notifier).setSearchQuery(q),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: feedState.isLoading && feedState.posts.isEmpty
                ? const Center(child: CircularProgressIndicator(color: Color(0xFF0569FF)))
                : feedState.posts.isEmpty
                ? Center(
              child: Text(
                'No posts found',
                style: GoogleFonts.redditSans(color: const Color(0xFF838A97)),
              ),
            )
                : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 0),
              itemCount: feedState.posts.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final post = feedState.posts[index];
                return FutureBuilder(
                  future: repo.fetchChannelById(post.channelId),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const SizedBox(height: 150);
                    return PostCard(
                      data: post,
                      channel: snapshot.data!,
                      onTap: () async {
                        await context.push('/feed/post/${post.postId}');
                        ref.read(feedProvider.notifier).refresh();
                      },
                      onLikeTap: () => ref.read(feedProvider.notifier).toggleLike(post.postId),
                      onShareTap: () => ref.read(feedProvider.notifier).sharePost(post.postId),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/feed/create-post'),
        backgroundColor: const Color(0xFF0569FF),
        shape: const CircleBorder(),
        elevation: 4,
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
      ),
    );
  }
}
