class FeedPost {
  const FeedPost({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.dateString,
    this.channelName,
    this.likeCount = 0,
    this.commentCount = 0,
  });

  final String id;
  final String title;
  final String content;
  final String category;
  final String dateString;
  final String? channelName;
  final int likeCount;
  final int commentCount;

  String get displayChannelName => channelName ?? title;

  String get channelMeta => '$category · $dateString';
}
