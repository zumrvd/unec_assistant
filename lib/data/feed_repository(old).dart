import '../models/post.dart';
import '../models/channel.dart';
import '../models/comment.dart';

abstract class FeedRepository {
  Future<List<Post>> fetchFeed({
    Set<PostFeedType> filters = const {},
    String? searchQuery,
    int page = 0,
  });
  Future<Post> fetchPostById(String postId);
  Future<Channel> fetchChannelById(String channelId);
  Future<List<Channel>> fetchSubscribedChannels();
  Future<List<Comment>> fetchComments(
    String postId, {
    CommentSort sort = CommentSort.mostRecent,
  });
  Future<List<Comment>> fetchReplies(String commentId);
  Future<Comment> postComment({
    required String postId,
    String? parentCommentId,
    required String bodyText,
  });
  Future<Post> toggleLikePost(String postId);
  Future<Comment> toggleLikeComment(String commentId);
  Future<Comment> editComment(String commentId, String newBodyText);
  Future<void> deleteComment(String commentId);
  Future<Post> sharePost(String postId);
  Future<void> setSubscription(String channelId, {required bool isSubscribed});
  Future<void> setNotifications(String channelId, {required bool enabled});
}
