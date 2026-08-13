enum PostRequestStatus { pending, approved, rejected }

class PostRequest {
  final String requestId;
  final String senderName;
  final String senderEmail;
  final String bodyText;
  final String categoryLabel;
  final PostRequestStatus status;
  final DateTime createdAt;
  final String? imageUrl;

  const PostRequest({
    required this.requestId,
    required this.senderName,
    required this.senderEmail,
    required this.bodyText,
    required this.categoryLabel,
    required this.status,
    required this.createdAt,
    this.imageUrl,
  });
}
