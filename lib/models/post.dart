enum PostFeedType { subscribed, official, clubs, devTeam }

class Post {
  final String postId;
  final String channelId; // links to Channel
  final String bodyText;
  final String? imageUrl; // null or failed load → show placeholder graphic
  final PostFeedType feedType;
  final DateTime postedAt;
  final int likeCount;
  final int commentCount;
  final int shareCount;
  final bool isLikedByCurrentUser;

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      postId: json['postId'] as String,
      channelId: json['channelId'] as String,
      bodyText: json['bodyText'] as String,
      imageUrl: json['imageUrl'] as String?,
      feedType: PostFeedType.values.byName(json['feedType'] as String),
      postedAt: DateTime.parse(json['postedAt'] as String),
      likeCount: json['likeCount'] as int,
      commentCount: json['commentCount'] as int,
      shareCount: json['shareCount'] as int,
      isLikedByCurrentUser: json['isLikedByCurrentUser'] as bool,
    );
  }

  const Post({
    required this.postId,
    required this.channelId,
    required this.bodyText,
    this.imageUrl,
    required this.feedType,
    required this.postedAt,
    required this.likeCount,
    required this.commentCount,
    required this.shareCount,
    required this.isLikedByCurrentUser,
  });

  Post copyWith({
    int? likeCount,
    bool? isLikedByCurrentUser,
    int? commentCount,
    int? shareCount,
  }) {
    return Post(
      postId: postId,
      channelId: channelId,
      bodyText: bodyText,
      imageUrl: imageUrl,
      feedType: feedType,
      postedAt: postedAt,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      shareCount: shareCount ?? this.shareCount,
      isLikedByCurrentUser: isLikedByCurrentUser ?? this.isLikedByCurrentUser,
    );
  }
}