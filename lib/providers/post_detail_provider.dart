import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/post.dart';
import '../models/channel.dart';
import '../models/comment.dart';
import '../models/user_account.dart';
import 'feed_provider.dart';
import 'subscriptions_provider.dart';

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

  // parent/reply grouping
  (List<Comment>, Map<String, List<Comment>>) _groupComments(List<Comment> allComments) {
    final rootComments = allComments.where((c) => c.parentCommentId == null).toList();
    final Map<String, List<Comment>> repliesMap = {};

    for (final comment in allComments.where((c) => c.parentCommentId != null)) {
      repliesMap.putIfAbsent(comment.parentCommentId!, () => []).add(comment);
    }

    return (rootComments, repliesMap);
  }

  @override
  PostDetailState build() {
    return const PostDetailState(isLoading: true);
  }

  Future<void> loadComments(String postId) async {
    final repo = ref.read(feedRepositoryProvider);
    try {
      final allComments = await repo.fetchComments(postId, sort: state.sort);
      final (roots, replies) = _groupComments(allComments);
      state = state.copyWith(comments: roots, replies: replies);
    } catch (e, stackTrace) {
      print('POST DETAIL PROVIDER ERROR: $e');
      print(stackTrace);
    }
  }


  Future<void> loadPostData(String postId) async {
    state = state.copyWith(isLoading: true, post: null, channel: null, comments: [], replies: {});
    final repo = ref.read(feedRepositoryProvider);
    try {
      final post = await repo.fetchPostById(postId);
      final channel = await repo.fetchChannelById(post.channelId);
      final allComments = await repo.fetchComments(postId, sort: state.sort);
      final subscribedChannels = await repo.fetchSubscribedChannels();
      final isSubscribed = subscribedChannels.any((c) => c.channelId == channel.channelId);
      final (roots, replies) = _groupComments(allComments);

      state = state.copyWith(
        post: post,
        channel: channel,
        comments: roots,
        replies: replies,
        isSubscribed: isSubscribed,
        isLoading: false,
      );
    } catch (e, stackTrace) {
      print('POST DETAIL PROVIDER ERROR: $e');
      print(stackTrace);
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> toggleSubscription() async {
    if (state.channel == null) return;
    final subNotifier = ref.read(subscriptionsProvider.notifier);
    final newSub = !state.isSubscribed;

    state = state.copyWith(isSubscribed: newSub);
    try {
      await subNotifier.toggleSubscription(state.channel!.channelId, newSub);
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

  Future<void> sharePost() async {
    if (state.post == null) return;
    final repo = ref.read(feedRepositoryProvider);
    final oldPost = state.post!;
    final newPost = oldPost.copyWith(shareCount: oldPost.shareCount + 1);

    state = state.copyWith(post: newPost);
    try {
      await repo.sharePost(oldPost.postId);
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

  Future<void> submitComment(String bodyText, {String? parentCommentId, String? replyToUserId, Map<String, UserAccount>? users}) async {
    if (state.post == null) return;
    final repo = ref.read(feedRepositoryProvider);
    
    // Check if we are replying to a reply (nested reply)
    String? actualParentId = parentCommentId;
    String finalBodyText = bodyText;

    if (parentCommentId != null) {
      // Find the parent comment in the flat list of top-level comments
      final isTopLevel = state.comments.any((c) => c.commentId == parentCommentId);
      if (!isTopLevel) {
        // If it's not top-level, it must be a reply. 
        // We need to find its parent to keep everything under one level.
        for (final entry in state.replies.entries) {
          if (entry.value.any((r) => r.commentId == parentCommentId)) {
            actualParentId = entry.key; // Set parent to the top-level comment
            break;
          }
        }
      }

      // Prepend @user tag if it's a specific reply
      if (replyToUserId != null && users != null) {
        final user = users[replyToUserId];
        if (user != null) {
          final tag = '@${user.displayName.replaceAll(' ', '').toLowerCase()} ';
          if (!finalBodyText.toLowerCase().startsWith(tag.toLowerCase())) {
            finalBodyText = '$tag$finalBodyText';
          }
        }
      }
    }

    try {
      final comment = await repo.postComment(
        postId: state.post!.postId,
        parentCommentId: actualParentId,
        bodyText: finalBodyText,
      );

      // Update post comment count in state
      final updatedPost = state.post!.copyWith(commentCount: state.post!.commentCount + 1);

      if (actualParentId == null) {
        state = state.copyWith(
          post: updatedPost,
          comments: [comment, ...state.comments],
        );
      } else {
        final newReplies = Map<String, List<Comment>>.from(state.replies);
        newReplies[actualParentId] = [...(newReplies[actualParentId] ?? []), comment];
        
        // Update the top-level comment's reply count in the list
        final updatedComments = state.comments.map((c) {
          if (c.commentId == actualParentId) {
            return c.copyWith(replyCount: c.replyCount + 1);
          }
          return c;
        }).toList();

        state = state.copyWith(
          post: updatedPost,
          comments: updatedComments,
          replies: newReplies,
        );
      }
    } catch (e) {
      // Handle error
    }
  }

  Future<void> toggleCommentLike(String commentId) async {
    final repo = ref.read(feedRepositoryProvider);

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
      // Silence error
    }
  }

  Future<void> editComment(String commentId, String newBodyText) async {
    final repo = ref.read(feedRepositoryProvider);
    try {
      final updated = await repo.editComment(commentId, newBodyText);
      _updateCommentInState(updated);
    } catch (e) {
      // Handle error
    }
  }

  Future<void> deleteComment(String commentId) async {
    final repo = ref.read(feedRepositoryProvider);
    try {
      // Find comment to calculate count decrement
      Comment? target;
      int deletedCount = 1;
      target = state.comments.where((c) => c.commentId == commentId).firstOrNull;
      if (target == null) {
        for (final rList in state.replies.values) {
          target = rList.where((c) => c.commentId == commentId).firstOrNull;
          if (target != null) break;
        }
      } else {
        // If top-level, we also delete its replies in state
        deletedCount += target.replyCount;
      }

      if (target == null) return;

      await repo.deleteComment(commentId);

      final updatedPost = state.post!.copyWith(commentCount: state.post!.commentCount - deletedCount);
      
      if (target.parentCommentId == null) {
        state = state.copyWith(
          post: updatedPost,
          comments: state.comments.where((c) => c.commentId != commentId).toList(),
          replies: Map.from(state.replies)..remove(commentId),
        );
      } else {
        final parentId = target.parentCommentId!;
        final newReplies = Map<String, List<Comment>>.from(state.replies);
        newReplies[parentId] = newReplies[parentId]!.where((r) => r.commentId != commentId).toList();
        
        final updatedComments = state.comments.map((c) {
          if (c.commentId == parentId) return c.copyWith(replyCount: c.replyCount - 1);
          return c;
        }).toList();

        state = state.copyWith(
          post: updatedPost,
          comments: updatedComments,
          replies: newReplies,
        );
      }
    } catch (e) {
      print('DELETE COMMENT ERROR: $e');
    }
  }

  void _updateCommentInState(Comment updated) {
    if (updated.parentCommentId == null) {
      state = state.copyWith(
        comments: state.comments.map((c) => c.commentId == updated.commentId ? updated : c).toList(),
      );
    } else {
      final parentId = updated.parentCommentId!;
      final newReplies = Map<String, List<Comment>>.from(state.replies);
      if (newReplies.containsKey(parentId)) {
        newReplies[parentId] = newReplies[parentId]!.map((r) => r.commentId == updated.commentId ? updated : r).toList();
        state = state.copyWith(replies: newReplies);
      }
    }
  }
}

final postDetailProvider = NotifierProvider<PostDetailNotifier, PostDetailState>(PostDetailNotifier.new);