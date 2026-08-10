import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/post.dart';
import '../models/channel.dart';
import '../models/comment.dart';
import 'feed_provider.dart';

class PostDetailState {
  final Post? post;
  final Channel? channel;
  final List<Comment> comments;
  final CommentSort sort;
  final bool isLoading;
  final Map<String, List<Comment>> replies;
  final bool isSubscribed;

  const PostDetailState({
    this.post,
    this.channel,
    this.comments = const [],
    this.sort = CommentSort.mostRecent,
    this.isLoading = false,
    this.replies = const {},
    this.isSubscribed = false,
  });

  PostDetailState copyWith({
    Post? post,
    Channel? channel,
    List<Comment>? comments,
    CommentSort? sort,
    bool? isLoading,
    Map<String, List<Comment>>? replies,
    bool? isSubscribed,
  }) {
    return PostDetailState(
      post: post ?? this.post,
      channel: channel ?? this.channel,
      comments: comments ?? this.comments,
      sort: sort ?? this.sort,
      isLoading: isLoading ?? this.isLoading,
      replies: replies ?? this.replies,
      isSubscribed: isSubscribed ?? this.isSubscribed,
    );
  }
}

class PostDetailNotifier extends Notifier<PostDetailState> {
  @override
  PostDetailState build() {
    return const PostDetailState(isLoading: true);
  }

  Future<void> loadPostData(String postId) async {
    state = state.copyWith(isLoading: true);
    final repo = ref.read(feedRepositoryProvider);
    try {
      final post = await repo.fetchPostById(postId);
      final channel = await repo.fetchChannelById(post.channelId);
      final comments = await repo.fetchComments(postId, sort: state.sort);
      final subscribedChannels = await repo.fetchSubscribedChannels();
      final isSubscribed = subscribedChannels.any((c) => c.channelId == channel.channelId);

      state = state.copyWith(
        post: post,
        channel: channel,
        comments: comments,
        isSubscribed: isSubscribed,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> toggleSubscription() async {
    if (state.channel == null) return;
    final repo = ref.read(feedRepositoryProvider);
    final newSub = !state.isSubscribed;
    
    state = state.copyWith(isSubscribed: newSub);
    try {
      await repo.setSubscription(state.channel!.channelId, isSubscribed: newSub);
    } catch (e) {
      state = state.copyWith(isSubscribed: !newSub);
    }
  }

  Future<void> toggleLike() async {
    if (state.post == null) return;
    final repo = ref.read(feedRepositoryProvider);
    final oldPost = state.post!;
    final newPost = oldPost.copyWith(
      isLikedByCurrentUser: !oldPost.isLikedByCurrentUser,
      likeCount: oldPost.isLikedByCurrentUser ? oldPost.likeCount - 1 : oldPost.likeCount + 1,
    );

    state = state.copyWith(post: newPost);
    try {
      await repo.toggleLikePost(oldPost.postId);
    } catch (e) {
      state = state.copyWith(post: oldPost);
    }
  }

  void setSort(CommentSort sort) {
    if (state.sort == sort) return;
    state = state.copyWith(sort: sort);
    if (state.post != null) {
      loadPostData(state.post!.postId);
    }
  }

  Future<void> loadReplies(String commentId) async {
    final repo = ref.read(feedRepositoryProvider);
    try {
      final replies = await repo.fetchReplies(commentId);
      final newReplies = Map<String, List<Comment>>.from(state.replies);
      newReplies[commentId] = replies;
      state = state.copyWith(replies: newReplies);
    } catch (e) {
      // Handle error
    }
  }

  Future<void> submitComment(String bodyText, {String? parentCommentId}) async {
    if (state.post == null) return;
    final repo = ref.read(feedRepositoryProvider);
    try {
      final comment = await repo.postComment(
        postId: state.post!.postId,
        parentCommentId: parentCommentId,
        bodyText: bodyText,
      );
      
      if (parentCommentId == null) {
        state = state.copyWith(comments: [comment, ...state.comments]);
      } else {
        final newReplies = Map<String, List<Comment>>.from(state.replies);
        newReplies[parentCommentId] = [...(newReplies[parentCommentId] ?? []), comment];
        state = state.copyWith(replies: newReplies);
      }
    } catch (e) {
      // Handle error
    }
  }

  Future<void> toggleCommentLike(String commentId) async {
    final repo = ref.read(feedRepositoryProvider);
    
    // Find comment in top level
    int topIndex = state.comments.indexWhere((c) => c.commentId == commentId);
    if (topIndex != -1) {
      final comment = state.comments[topIndex];
      final updated = comment.copyWith(
        isLikedByCurrentUser: !comment.isLikedByCurrentUser,
        likeCount: comment.isLikedByCurrentUser ? comment.likeCount - 1 : comment.likeCount + 1,
      );
      state = state.copyWith(
        comments: [
          for (int i = 0; i < state.comments.length; i++)
            if (i == topIndex) updated else state.comments[i]
        ],
      );
    } else {
      // Find in replies
      String? parentId;
      Comment? reply;
      for (final entry in state.replies.entries) {
        final idx = entry.value.indexWhere((r) => r.commentId == commentId);
        if (idx != -1) {
          parentId = entry.key;
          reply = entry.value[idx];
          break;
        }
      }

      if (parentId != null && reply != null) {
        final updated = reply.copyWith(
          isLikedByCurrentUser: !reply.isLikedByCurrentUser,
          likeCount: reply.isLikedByCurrentUser ? reply.likeCount - 1 : reply.likeCount + 1,
        );
        final newReplies = Map<String, List<Comment>>.from(state.replies);
        newReplies[parentId] = [
          for (final r in state.replies[parentId]!)
            if (r.commentId == commentId) updated else r
        ];
        state = state.copyWith(replies: newReplies);
      }
    }

    try {
      await repo.toggleLikeComment(commentId);
    } catch (e) {
      // Rollback
    }
  }
}

final postDetailProvider = NotifierProvider<PostDetailNotifier, PostDetailState>(PostDetailNotifier.new);
