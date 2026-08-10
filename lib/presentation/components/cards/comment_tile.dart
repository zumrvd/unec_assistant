import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/comment.dart';
import '../../../models/user_account.dart';

class CommentTile extends StatefulWidget {
  final Comment data;
  final UserAccount author;
  final VoidCallback onLikeTap;
  final void Function(String replyText) onReplySubmit;
  final VoidCallback onLoadReplies;
  final List<Comment>? loadedReplies;
  final Map<String, UserAccount> users;

  const CommentTile({
    required this.data,
    required this.author,
    required this.onLikeTap,
    required this.onReplySubmit,
    required this.onLoadReplies,
    this.loadedReplies,
    required this.users,
    super.key,
  });

  @override
  State<CommentTile> createState() => _CommentTileState();
}

class _CommentTileState extends State<CommentTile> {
  bool _repliesExpanded = false;
  bool _replyInputVisible = false;
  final TextEditingController _replyController = TextEditingController();

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  String _timeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inDays > 0) return '${diff.inDays}d';
    if (diff.inHours > 0) return '${diff.inHours}h';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m';
    return 'now';
  }

  @override
  Widget build(BuildContext context) {
    final bool isReply = widget.data.parentCommentId != null;

    final Color avatarBg = isReply ? const Color(0xFFFFE5E5) : const Color(0xFFE8F0FE);
    final Color avatarText = isReply ? const Color(0xFFD54829) : const Color(0xFF0569FF);

    return Padding(
      padding: EdgeInsets.only(left: isReply ? 32.0 : 0.0, bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: avatarBg,
                ),
                alignment: Alignment.center,
                child: Text(
                  widget.author.initials,
                  style: GoogleFonts.redditSans(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: avatarText,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        widget.author.displayName,
                        style: GoogleFonts.redditSans(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          color: const Color(0xFF1F1F1F),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _timeAgo(widget.data.postedAt),
                        style: GoogleFonts.redditSans(
                          fontWeight: FontWeight.w500,
                          fontSize: 10,
                          color: const Color(0xFF838A97),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 46.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.data.bodyText,
                  style: GoogleFonts.redditSans(
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                    color: const Color(0xFF1F1F1F),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    GestureDetector(
                      onTap: widget.onLikeTap,
                      child: Row(
                        children: [
                          Icon(
                            widget.data.isLikedByCurrentUser
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            size: 16,
                            color: widget.data.isLikedByCurrentUser
                                ? const Color(0xFFDA4979)
                                : const Color(0xFF838A97),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${widget.data.likeCount}',
                            style: GoogleFonts.redditSans(
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                              color: widget.data.isLikedByCurrentUser
                                  ? const Color(0xFFDA4979)
                                  : const Color(0xFF838A97),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: () => setState(() => _replyInputVisible = !_replyInputVisible),
                      child: Text(
                        'Reply',
                        style: GoogleFonts.redditSans(
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                          color: const Color(0xFF838A97),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (_replyInputVisible) ...[
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(left: 46.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE0E4F0)),
                      ),
                      child: TextField(
                        controller: _replyController,
                        style: GoogleFonts.redditSans(fontSize: 12),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Write a reply...',
                          isDense: true,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      if (_replyController.text.isNotEmpty) {
                        widget.onReplySubmit(_replyController.text);
                        _replyController.clear();
                        setState(() => _replyInputVisible = false);
                      }
                    },
                    child: const CircleAvatar(
                      radius: 18,
                      backgroundColor: Color(0xFF0569FF),
                      child: Icon(Icons.send_rounded, size: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (!isReply && widget.data.replyCount > 0) ...[
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 46.0),
              child: GestureDetector(
                onTap: () {
                  if (!_repliesExpanded) {
                    widget.onLoadReplies();
                  }
                  setState(() => _repliesExpanded = !_repliesExpanded);
                },
                child: Text(
                  _repliesExpanded ? 'Hide replies' : 'View ${widget.data.replyCount} replies',
                  style: GoogleFonts.redditSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                    color: const Color(0xFF0569FF),
                  ),
                ),
              ),
            ),
            if (_repliesExpanded && widget.loadedReplies != null)
              ...widget.loadedReplies!.map((reply) {
                final author = widget.users[reply.authorUserId] ??
                    const UserAccount(userId: '?', displayName: 'Unknown', initials: '??');
                return CommentTile(
                  data: reply,
                  author: author,
                  onLikeTap: () {},
                  onReplySubmit: (_) {},
                  onLoadReplies: () {},
                  users: widget.users,
                );
              }),
          ],
        ],
      ),
    );
  }
}
