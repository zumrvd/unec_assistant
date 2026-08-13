import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/comment.dart';
import '../../../models/user_account.dart';

class CommentTile extends StatefulWidget {
  final Comment data;
  final UserAccount author;
  final UserAccount currentUser;
  final void Function(String commentId) onLikeTap;
  final void Function(String replyText, String? parentCommentId, String? replyToUserId) onReplySubmit;
  final void Function(String commentId, String newText) onEditSubmit;
  final void Function(String commentId) onDeleteTap;
  final VoidCallback onLoadReplies;
  final List<Comment>? loadedReplies;
  final Map<String, UserAccount> users;

  const CommentTile({
    required this.data,
    required this.author,
    required this.currentUser,
    required this.onLikeTap,
    required this.onReplySubmit,
    required this.onEditSubmit,
    required this.onDeleteTap,
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
  bool _editInputVisible = false;
  final TextEditingController _replyController = TextEditingController();
  final TextEditingController _editController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _editController.text = widget.data.bodyText;
  }

  @override
  void dispose() {
    _replyController.dispose();
    _editController.dispose();
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
                decoration: BoxDecoration(shape: BoxShape.circle, color: avatarBg),
                alignment: Alignment.center,
                child: Text(
                  widget.author.initials,
                  style: GoogleFonts.redditSans(
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                    color: avatarText,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
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
                          '${_timeAgo(widget.data.postedAt)}${widget.data.isEdited ? ' · edited' : ''}',
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
              ),
              if (widget.author.userId == widget.currentUser.userId)
                PopupMenuButton<String>(
                  color: const Color(0xFFFFFFFF),
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.more_vert_rounded, size: 18, color: Color(0xFF838A97)),
                  onSelected: (value) {
                    if (value == 'edit') {
                      setState(() {
                        _editInputVisible = true;
                        _editController.text = widget.data.bodyText;
                      });
                    } else if (value == 'delete') {
                      widget.onDeleteTap(widget.data.commentId);
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Text('Edit', style: TextStyle(fontSize: 13)),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text('Delete', style: TextStyle(fontSize: 13, color: Colors.red)),
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
                if (_editInputVisible)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TextField(
                        controller: _editController,
                        autofocus: true,
                        style: GoogleFonts.redditSans(fontSize: 13, color: const Color(0xFF1F1F1F)),
                        maxLines: null,
                        decoration: const InputDecoration(
                          isDense: true,
                          border: UnderlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(vertical: 4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextButton(
                            onPressed: () => setState(() => _editInputVisible = false),
                            child: const Text('Cancel', style: TextStyle(fontSize: 12)),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (_editController.text.isNotEmpty && _editController.text != widget.data.bodyText) {
                                widget.onEditSubmit(widget.data.commentId, _editController.text);
                              }
                              setState(() => _editInputVisible = false);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0569FF),
                              foregroundColor: Colors.white,
                              minimumSize: const Size(60, 30),
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                            ),
                            child: const Text('Save', style: TextStyle(fontSize: 12)),
                          ),
                        ],
                      ),
                    ],
                  )
                else
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
                      onTap: () => widget.onLikeTap(widget.data.commentId),
                      behavior: HitTestBehavior.opaque,
                      child: Row(
                        children: [
                          Icon(
                            widget.data.isLikedByCurrentUser ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                            size: 16,
                            color: widget.data.isLikedByCurrentUser ? const Color(0xFFDA4979) : const Color(0xFF838A97),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${widget.data.likeCount}',
                            style: GoogleFonts.redditSans(
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                              color: widget.data.isLikedByCurrentUser ? const Color(0xFFDA4979) : const Color(0xFF838A97),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: () => setState(() => _replyInputVisible = !_replyInputVisible),
                      behavior: HitTestBehavior.opaque,
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
                      height: 36,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FC),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFFE0E4F0)),
                      ),
                      alignment: Alignment.centerLeft,
                      child: TextField(
                        controller: _replyController,
                        autofocus: true,
                        style: GoogleFonts.redditSans(fontSize: 12, color: const Color(0xFF1F1F1F)),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Write a reply...',
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      if (_replyController.text.isNotEmpty) {
                        widget.onReplySubmit(
                          _replyController.text,
                          widget.data.commentId,
                          widget.data.authorUserId,
                        );
                        _replyController.clear();
                        setState(() {
                          _replyInputVisible = false;
                          _repliesExpanded = true;
                        });
                        if (widget.loadedReplies == null) {
                          widget.onLoadReplies();
                        }
                      }
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF0569FF)),
                      alignment: Alignment.center,
                      child: const Icon(Icons.send_rounded, size: 16, color: Color(0xFFFFFFFF)),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (!isReply && (widget.data.replyCount > 0 || (widget.loadedReplies?.isNotEmpty ?? false))) ...[
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 46.0),
              child: GestureDetector(
                onTap: () {
                  if (!_repliesExpanded) widget.onLoadReplies();
                  setState(() => _repliesExpanded = !_repliesExpanded);
                },
                behavior: HitTestBehavior.opaque,
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
                  currentUser: widget.currentUser,
                  onLikeTap: widget.onLikeTap,
                  onReplySubmit: widget.onReplySubmit,
                  onEditSubmit: widget.onEditSubmit,
                  onDeleteTap: widget.onDeleteTap,
                  onLoadReplies: widget.onLoadReplies,
                  users: widget.users,
                );
              }),
          ],
        ],
      ),
    );
  }
}
