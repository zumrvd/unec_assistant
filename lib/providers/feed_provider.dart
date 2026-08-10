import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/post.dart';
import '../data/feed_repository.dart';
import '../data/mock_feed_repository.dart';

/// Provider for the repository implementation.
final feedRepositoryProvider = Provider<FeedRepository>((ref) {
  return MockFeedRepository();
});

class FeedState {
  final List<Post> posts;
  final bool isLoading;
  final String? error;
  final PostFeedType? filter;
  final String searchQuery;

  const FeedState({
    this.posts = const [],
    this.isLoading = false,
    this.error,
    this.filter,
    this.searchQuery = '',
  });

  FeedState copyWith({
    List<Post>? posts,
    bool? isLoading,
    String? error,
    PostFeedType? filter,
    String? searchQuery,
  }) {
    return FeedState(
      posts: posts ?? this.posts,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      filter: filter ?? this.filter,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class FeedNotifier extends Notifier<FeedState> {
  @override
  FeedState build() {
    // Initial fetch
    Future.microtask(() => _fetchFeed());
    return const FeedState(isLoading: true);
  }

  Future<void> _fetchFeed() async {
    state = state.copyWith(isLoading: true);
    try {
      final repo = ref.read(feedRepositoryProvider);
      final posts = await repo.fetchFeed(
        filter: state.filter,
        searchQuery: state.searchQuery,
      );
      state = state.copyWith(posts: posts, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void setFilter(PostFeedType? filter) {
    state = state.copyWith(filter: filter);
    _fetchFeed();
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    _fetchFeed();
  }

  Future<void> refresh() => _fetchFeed();

  Future<void> toggleLike(String postId) async {
    final oldPosts = state.posts;
    final index = oldPosts.indexWhere((p) => p.postId == postId);
    if (index == -1) return;

    final post = oldPosts[index];
    final updatedPost = post.copyWith(
      isLikedByCurrentUser: !post.isLikedByCurrentUser,
      likeCount: post.isLikedByCurrentUser ? post.likeCount - 1 : post.likeCount + 1,
    );

    // Optimistic update
    state = state.copyWith(
      posts: [
        for (var i = 0; i < oldPosts.length; i++)
          if (i == index) updatedPost else oldPosts[i]
      ],
    );

    try {
      await ref.read(feedRepositoryProvider).toggleLikePost(postId);
    } catch (e) {
      // Rollback
      state = state.copyWith(posts: oldPosts);
    }
  }
}

final feedProvider = NotifierProvider<FeedNotifier, FeedState>(FeedNotifier.new);
