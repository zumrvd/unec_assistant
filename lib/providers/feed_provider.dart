import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/post.dart';
import '../data/feed_repository.dart';
import '../data/api_feed_provider.dart';

final feedRepositoryProvider = Provider<FeedRepository>((ref) {
  return ApiFeedRepository();
});

class FeedState {
  final List<Post> posts;
  final bool isLoading;
  final String? error;
  final Set<PostFeedType> filters;
  final String searchQuery;

  const FeedState({
    this.posts = const [],
    this.isLoading = false,
    this.error,
    this.filters = const {},
    this.searchQuery = '',
  });

  FeedState copyWith({
    List<Post>? posts,
    bool? isLoading,
    String? error,
    Set<PostFeedType>? filters,
    String? searchQuery,
  }) {
    return FeedState(
      posts: posts ?? this.posts,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      filters: filters ?? this.filters,
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
        filters: state.filters,
        searchQuery: state.searchQuery,
      );
      state = state.copyWith(posts: posts, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void toggleFilter(PostFeedType? filter) {
    if (filter == null) {
      state = state.copyWith(filters: const {});
    } else {
      final newFilters = Set<PostFeedType>.from(state.filters);
      if (newFilters.contains(filter)) {
        newFilters.remove(filter);
      } else {
        newFilters.add(filter);
      }
      state = state.copyWith(filters: newFilters);
    }
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

  Future<void> sharePost(String postId) async {
    final oldPosts = state.posts;
    final index = oldPosts.indexWhere((p) => p.postId == postId);
    if (index == -1) return;

    final post = oldPosts[index];
    final updatedPost = post.copyWith(shareCount: post.shareCount + 1);

    // Optimistic update
    state = state.copyWith(
      posts: [
        for (var i = 0; i < oldPosts.length; i++)
          if (i == index) updatedPost else oldPosts[i]
      ],
    );

    try {
      await ref.read(feedRepositoryProvider).sharePost(postId);
    } catch (e) {
      // Rollback
      state = state.copyWith(posts: oldPosts);
    }
  }
}

final feedProvider = NotifierProvider<FeedNotifier, FeedState>(FeedNotifier.new);