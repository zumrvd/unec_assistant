import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unec_assistant/presentation/providers/theme_provider.dart';
import '../../../models/comment.dart';
import '../../../models/user_account.dart';

class CommentTile extends ConsumerStatefulWidget {
  final Comment data;
  final UserAccount author;
  final UserAccount currentUser;
  final void Function(String commentId) onLikeTap;
  final void Function(
          String replyText, String? parentCommentId, String? replyToUserId)
      onReplySubmit;
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
  ConsumerState<CommentTile> createState() => _CommentTileState();
}

class _CommentTileState extends ConsumerState<CommentTile> {
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
    final appColors = ref.watch(appColorsProvider);
    final bool isReply = widget.data.parentCommentId != null;
    final Color avatarBg =
        isReply ? appColors.dangerContainer : appColors.primaryContainer;
    final Color avatarText =
        isReply ? appColors.dangerOnContainer : appColors.primaryOnContainer;

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
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: avatarBg),
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
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        widget.author.displayName,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: GoogleFonts.redditSans(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          color: appColors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${_timeAgo(widget.data.postedAt)}${widget.data.isEdited ? ' · edited' : ''}',
                      style: GoogleFonts.redditSans(
                        fontWeight: FontWeight.w500,
                        fontSize: 10,
                        color: appColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.author.userId == widget.currentUser.userId)
                PopupMenuButton<String>(
                  color: appColors.surface,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: appColors.borderColor, width: 1),
                  ),
                  padding: EdgeInsets.zero,
                  icon: Icon(Icons.more_vert_rounded,
                      size: 18, color: appColors.textSecondary),
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
                    PopupMenuItem(
                      value: 'edit',
                      child: Text(
                        'Edit',
                        style: GoogleFonts.redditSans(
                          fontSize: 13,
                          color: appColors.textPrimary,
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Text(
                        'Delete',
                        style: GoogleFonts.redditSans(
                          fontSize: 13,
                          color: appColors.danger,
                        ),
                      ),
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
                        style: GoogleFonts.redditSans(
                          fontSize: 13,
                          color: appColors.textPrimary,
                        ),
                        maxLines: null,
                        decoration: InputDecoration(
                          isDense: true,
                          border: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: appColors.borderColor),
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () =>
                                setState(() => _editInputVisible = false),
                            behavior: HitTestBehavior.opaque,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 7),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: appColors.borderColor),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Cancel',
                                style: GoogleFonts.redditSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: appColors.textSecondary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              if (_editController.text.isNotEmpty &&
                                  _editController.text !=
                                      widget.data.bodyText) {
                                widget.onEditSubmit(widget.data.commentId,
                                    _editController.text);
                              }
                              setState(() => _editInputVisible = false);
                            },
                            behavior: HitTestBehavior.opaque,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 7),
                              decoration: BoxDecoration(
                                color: appColors.primary,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Save',
                                style: GoogleFonts.redditSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: appColors.pillSelectedText,
                                ),
                              ),
                            ),
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
                      color: appColors.textPrimary,
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
                            widget.data.isLikedByCurrentUser
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            size: 16,
                            color: widget.data.isLikedByCurrentUser
                                ? appColors.heartColor
                                : appColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${widget.data.likeCount}',
                            style: GoogleFonts.redditSans(
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                              color: widget.data.isLikedByCurrentUser
                                  ? appColors.heartColor
                                  : appColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: () => setState(
                          () => _replyInputVisible = !_replyInputVisible),
                      behavior: HitTestBehavior.opaque,
                      child: Text(
                        'Reply',
                        style: GoogleFonts.redditSans(
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                          color: appColors.textSecondary,
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
                        color: appColors.inputBackground,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: appColors.borderColor),
                      ),
                      alignment: Alignment.centerLeft,
                      child: TextField(
                        controller: _replyController,
                        autofocus: true,
                        style: GoogleFonts.redditSans(
                            fontSize: 12, color: appColors.textPrimary),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Write a reply...',
                          hintStyle: GoogleFonts.redditSans(
                              color: appColors.textMuted, fontSize: 12),
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
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: appColors.primary),
                      alignment: Alignment.center,
                      child: Icon(Icons.send_rounded,
                          size: 16, color: appColors.pillSelectedText),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (!isReply &&
              (widget.data.replyCount > 0 ||
                  (widget.loadedReplies?.isNotEmpty ?? false))) ...[
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
                  _repliesExpanded
                      ? 'Hide replies'
                      : 'View ${widget.data.replyCount} replies',
                  style: GoogleFonts.redditSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                    color: appColors.primary,
                  ),
                ),
              ),
            ),
            if (_repliesExpanded && widget.loadedReplies != null)
              ...widget.loadedReplies!.map((reply) {
                final author = widget.users[reply.authorUserId] ??
                    const UserAccount(
                        userId: '?', displayName: 'Unknown', initials: '??');
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
