import '../models/post.dart';
import '../models/channel.dart';
import '../models/comment.dart';
import '../models/subscription.dart';
import 'feed_repository(old).dart';

class MockFeedRepository implements FeedRepository {
  final List<Channel> _channels = [
    const Channel(
      channelId: 'ch1',
      channelName: 'Rektorat Kanalı',
      category: ChannelCategory.official,
      isVerified: true,
    ),
    const Channel(
      channelId: 'ch2',
      channelName: 'IT Club',
      category: ChannelCategory.clubs,
    ),
    const Channel(
      channelId: 'ch3',
      channelName: 'Dev Team',
      category: ChannelCategory.devTeam,
      isVerified: true,
    ),
  ];

  late final List<Post> _posts = [
    Post(
      postId: 'p1',
      channelId: 'ch1',
      bodyText:
          '2025/2026-ci tədris ilinin YAZ semestri üçün ara imtahan cədvəli açıqlanmışdır. Cədvəl ilə aşağıdakı linkə daxil olmaqla tanış ola bilərsiz.\n\nLink : https://unec.edu.az/bakalavriatura-seviyyesi-uzre-2025-2026-ci-tedris-ilinin-yaz-semestrinin-ara-qiymetlendirme-imtahani-cedveli/',
      feedType: PostFeedType.official,
      postedAt: DateTime.now().subtract(const Duration(hours: 2)),
      likeCount: 122,
      commentCount: 3,
      shareCount: 14,
      isLikedByCurrentUser: false,
    ),
    Post(
      postId: 'p2',
      channelId: 'ch2',
      bodyText: 'Hey guys! We are having a meeting this Friday at 3 PM in Room 316. Don\'t forget to bring your laptops!',
      feedType: PostFeedType.clubs,
      postedAt: DateTime.now().subtract(const Duration(hours: 5)),
      likeCount: 45,
      commentCount: 3,
      shareCount: 5,
      isLikedByCurrentUser: true,
    ),
  ];

  final List<Comment> _comments = [
    Comment(
      commentId: 'c1',
      postId: 'p1',
      authorUserId: 'u2',
      bodyText: 'Cədvəl çox sıxdır, araları azdır ☹️',
      postedAt: DateTime.now().subtract(const Duration(minutes: 34)),
      likeCount: 14,
      isLikedByCurrentUser: true,
      replyCount: 1,
    ),
    Comment(
      commentId: 'c1-r1',
      postId: 'p1',
      parentCommentId: 'c1',
      authorUserId: 'u3',
      bodyText: 'Məncə normaldır, hazırlaşmaq olar.',
      postedAt: DateTime.now().subtract(const Duration(minutes: 10)),
      likeCount: 2,
      isLikedByCurrentUser: false,
      replyCount: 0,
    ),
    Comment(
      commentId: 'c2',
      postId: 'p1',
      authorUserId: 'u3',
      bodyText: 'Təşəkkürlər, vaxtında paylaşdınız 🙏',
      postedAt: DateTime.now().subtract(const Duration(hours: 1)),
      likeCount: 3,
      isLikedByCurrentUser: false,
      replyCount: 0,
    ),
    Comment(
      commentId: 'c3',
      postId: 'p2',
      authorUserId: 'u1',
      bodyText: 'i don\'t have laptops',
      postedAt: DateTime.now().subtract(const Duration(minutes: 2)),
      likeCount: 0,
      isLikedByCurrentUser: false,
      replyCount: 2,
    ),
    Comment(
      commentId: 'c3-r1',
      postId: 'p2',
      parentCommentId: 'c3',
      authorUserId: 'u2',
      bodyText: 'Mən gətirə bilərəm!',
      postedAt: DateTime.now().subtract(const Duration(minutes: 1)),
      likeCount: 0,
      isLikedByCurrentUser: false,
      replyCount: 0,
    ),
    Comment(
      commentId: 'c3-r2',
      postId: 'p2',
      parentCommentId: 'c3',
      authorUserId: 'u3',
      bodyText: 'Mənim də ehtiyat laptopum var.',
      postedAt: DateTime.now().subtract(const Duration(seconds: 30)),
      likeCount: 0,
      isLikedByCurrentUser: false,
      replyCount: 0,
    ),
  ];

  final Map<String, ChannelSubscription> _subscriptions = {
    'ch1': const ChannelSubscription(channelId: 'ch1', isSubscribed: true, notificationsEnabled: true),
    'ch2': const ChannelSubscription(channelId: 'ch2', isSubscribed: false, notificationsEnabled: false),
  };

  Future<void> _latency() => Future.delayed(const Duration(milliseconds: 300));

  @override
  Future<List<Post>> fetchFeed({
    Set<PostFeedType> filters = const {},
    String? searchQuery,
    int page = 0,
  }) async {
    await _latency();
    var filtered = _posts;

    if (filters.isNotEmpty) {
      filtered = filtered.where((p) {
        // Match if the post type is in the filters, 
        // OR if the 'subscribed' filter is active and the user is subscribed to the channel.
        final bool typeMatch = filters.contains(p.feedType);
        final bool subMatch = filters.contains(PostFeedType.subscribed) &&
            (_subscriptions[p.channelId]?.isSubscribed ?? false);
        return typeMatch || subMatch;
      }).toList();
    }

    if (searchQuery != null && searchQuery.isNotEmpty) {
      final q = searchQuery.toLowerCase();
      filtered =
          filtered.where((p) => p.bodyText.toLowerCase().contains(q)).toList();
    }
    return filtered;
  }

  @override
  Future<Post> fetchPostById(String postId) async {
    await _latency();
    return _posts.firstWhere((p) => p.postId == postId);
  }

  @override
  Future<Channel> fetchChannelById(String channelId) async {
    await _latency();
    return _channels.firstWhere((c) => c.channelId == channelId);
  }

  @override
  Future<List<Channel>> fetchSubscribedChannels() async {
    await _latency();
    return _channels.where((c) => _subscriptions[c.channelId]?.isSubscribed ?? false).toList();
  }

  @override
  Future<List<Comment>> fetchComments(String postId, {CommentSort sort = CommentSort.mostRecent}) async {
    await _latency();
    final results = _comments.where((c) => c.postId == postId && c.parentCommentId == null).toList();
    if (sort == CommentSort.mostLiked) {
      results.sort((a, b) => b.likeCount.compareTo(a.likeCount));
    } else {
      results.sort((a, b) => b.postedAt.compareTo(a.postedAt));
    }
    return results;
  }

  @override
  Future<List<Comment>> fetchReplies(String commentId) async {
    await _latency();
    return _comments.where((c) => c.parentCommentId == commentId).toList();
  }

  @override
  Future<Comment> postComment({required String postId, String? parentCommentId, required String bodyText}) async {
    await _latency();
    final newComment = Comment(
      commentId: 'c${_comments.length + 1}',
      postId: postId,
      parentCommentId: parentCommentId,
      authorUserId: 'u1',
      bodyText: bodyText,
      postedAt: DateTime.now(),
      likeCount: 0,
      isLikedByCurrentUser: false,
      replyCount: 0,
    );
    _comments.add(newComment);

    // Increment post comment count
    final pIdx = _posts.indexWhere((p) => p.postId == postId);
    if (pIdx != -1) {
      _posts[pIdx] = _posts[pIdx].copyWith(commentCount: _posts[pIdx].commentCount + 1);
    }

    // Increment parent comment reply count
    if (parentCommentId != null) {
      final cIdx = _comments.indexWhere((c) => c.commentId == parentCommentId);
      if (cIdx != -1) {
        _comments[cIdx] = _comments[cIdx].copyWith(replyCount: _comments[cIdx].replyCount + 1);
      }
    }

    return newComment;
  }

  @override
  Future<Post> toggleLikePost(String postId) async {
    await _latency();
    final index = _posts.indexWhere((p) => p.postId == postId);
    final post = _posts[index];
    final updated = post.copyWith(
      isLikedByCurrentUser: !post.isLikedByCurrentUser,
      likeCount: post.isLikedByCurrentUser ? post.likeCount - 1 : post.likeCount + 1,
    );
    _posts[index] = updated;
    return updated;
  }

  @override
  Future<Comment> toggleLikeComment(String commentId) async {
    await _latency();
    final index = _comments.indexWhere((c) => c.commentId == commentId);
    final comment = _comments[index];
    final updated = comment.copyWith(
      isLikedByCurrentUser: !comment.isLikedByCurrentUser,
      likeCount: comment.isLikedByCurrentUser ? comment.likeCount - 1 : comment.likeCount + 1,
    );
    _comments[index] = updated;
    return updated;
  }

  @override
  Future<Comment> editComment(String commentId, String newBodyText) async {
    await _latency();
    final index = _comments.indexWhere((c) => c.commentId == commentId);
    if (index == -1) throw Exception('Comment not found');
    final updated = _comments[index].copyWith(
      bodyText: newBodyText,
      isEdited: true,
    );
    _comments[index] = updated;
    return updated;
  }

  @override
  Future<void> deleteComment(String commentId) async {
    await _latency();
    final index = _comments.indexWhere((c) => c.commentId == commentId);
    if (index == -1) return;

    final comment = _comments[index];
    final postId = comment.postId;
    final parentId = comment.parentCommentId;

    // Find all replies if it's a top-level comment
    final List<String> idsToDelete = [commentId];
    if (parentId == null) {
      final replies = _comments.where((c) => c.parentCommentId == commentId).map((c) => c.commentId);
      idsToDelete.addAll(replies);
    }

    // Update counts
    final pIdx = _posts.indexWhere((p) => p.postId == postId);
    if (pIdx != -1) {
      _posts[pIdx] = _posts[pIdx].copyWith(commentCount: _posts[pIdx].commentCount - idsToDelete.length);
    }

    if (parentId != null) {
      final cIdx = _comments.indexWhere((c) => c.commentId == parentId);
      if (cIdx != -1) {
        _comments[cIdx] = _comments[cIdx].copyWith(replyCount: _comments[cIdx].replyCount - 1);
      }
    }

    _comments.removeWhere((c) => idsToDelete.contains(c.commentId));
  }

  @override
  Future<Post> sharePost(String postId) async {
    await _latency();
    final index = _posts.indexWhere((p) => p.postId == postId);
    if (index == -1) throw Exception('Post not found');
    final post = _posts[index];
    final updated = post.copyWith(shareCount: post.shareCount + 1);
    _posts[index] = updated;
    return updated;
  }

  @override
  Future<void> setSubscription(String channelId, {required bool isSubscribed}) async {
    await _latency();
    final sub = _subscriptions[channelId] ?? ChannelSubscription(channelId: channelId, isSubscribed: false, notificationsEnabled: false);
    _subscriptions[channelId] = sub.copyWith(isSubscribed: isSubscribed);
  }

  @override
  Future<void> setNotifications(String channelId, {required bool enabled}) async {
    await _latency();
    final sub = _subscriptions[channelId] ?? ChannelSubscription(channelId: channelId, isSubscribed: false, notificationsEnabled: false);
    _subscriptions[channelId] = sub.copyWith(notificationsEnabled: enabled);
  }
}
