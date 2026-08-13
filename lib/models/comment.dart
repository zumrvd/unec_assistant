enum CommentSort { mostRecent, mostLiked }

class Comment {
  final String commentId;
  final String postId;
  final String? parentCommentId; // null = top-level comment, non-null = reply
  final String authorUserId;
  final String bodyText;
  final DateTime postedAt;
  final int likeCount;
  final bool isLikedByCurrentUser;
  final int replyCount;
  final bool isEdited;

  const Comment({
    required this.commentId,
    required this.postId,
    this.parentCommentId,
    required this.authorUserId,
    required this.bodyText,
    required this.postedAt,
    required this.likeCount,
    required this.isLikedByCurrentUser,
    required this.replyCount,
    this.isEdited = false,
  });

  Comment copyWith({
    int? likeCount,
    bool? isLikedByCurrentUser,
    int? replyCount,
    String? bodyText,
    bool? isEdited,
  }) {
    return Comment(
      commentId: commentId,
      postId: postId,
      parentCommentId: parentCommentId,
      authorUserId: authorUserId,
      bodyText: bodyText ?? this.bodyText,
      postedAt: postedAt,
      likeCount: likeCount ?? this.likeCount,
      isLikedByCurrentUser: isLikedByCurrentUser ?? this.isLikedByCurrentUser,
      replyCount: replyCount ?? this.replyCount,
      isEdited: isEdited ?? this.isEdited,
    );
  }
}
