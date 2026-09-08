import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/comment.dart';
import '../models/post.dart';
import '../models/channel.dart';
import 'feed_repository(abstract).dart';

class ApiFeedRepository implements FeedRepository {
  static const String _baseUrl = 'http://10.0.2.2:8000';

  @override
  Future<List<Post>> fetchFeed({
    Set<PostFeedType> filters = const {},
    String? searchQuery,
    int page = 0,
  }) async {
    final url = Uri.parse('$_baseUrl/feed');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> rawList = jsonDecode(response.body);
      return rawList
          .map((item) => Post.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to fetch feed');
    }
  }
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<Channel> fetchChannelById(String channelId) async {
    return const Channel(
      channelId: 'ch1',
      channelName: 'Rektorat Kanalı',
      avatarUrl: null,
      category: ChannelCategory.official,
      isVerified: true,
    );
  }

  @override
  Future<Post> fetchPostById(String postId) async {
    final posts = await fetchFeed();
    print('Looking for postId: "$postId" | Available IDs in server: ${posts.map((p) => p.postId).toList()}');
    return posts.firstWhere(
          (p) => p.postId == postId,
      orElse: () => throw Exception('Post $postId not found'),
    );
  }

  @override
  Future<List<Comment>> fetchComments(
      String postId, {
        CommentSort sort = CommentSort.mostRecent,
      }) async {
    final url = Uri.parse('$_baseUrl/feed/$postId/comments');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> rawList = jsonDecode(response.body);
      return rawList
          .map((item) => Comment.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load comments');
    }
  }


  @override
  Future<List<Channel>> fetchSubscribedChannels() async {
    return const [
      Channel(
        channelId: 'ch1',
        channelName: 'Rektorat Kanalı',
        avatarUrl: null,
        category: ChannelCategory.official,
        isVerified: true,
      ),
    ];
  }

  @override
  Future<Post> toggleLikePost(String postId) async {
    final url = Uri.parse('$_baseUrl/feed/$postId/like');
    final response = await http.post(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> rawJson = jsonDecode(response.body);
      return Post.fromJson(rawJson);
    } else {
      throw Exception('Failed to toggle like on post $postId');
    }
  }

  @
}