import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/post.dart';
import '../../../models/channel.dart';

class PostCard extends StatefulWidget {
  final Post data;
  final Channel channel;
  final VoidCallback onTap;
  final VoidCallback onLikeTap;
  final VoidCallback onShareTap;

  const PostCard({
    required this.data,
    required this.channel,
    required this.onTap,
    required this.onLikeTap,
    required this.onShareTap,
    super.key,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool _isExpanded = false;

  void _showCustomShareToast(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        behavior: SnackBarBehavior.floating,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE0E4F0), width: 1),
          ),
          child: Text(
            'Link copied to clipboard',
            textAlign: TextAlign.center,
            style: GoogleFonts.redditSans(
              color: const Color(0xFF1F1F1F),
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  String _timeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inDays > 0) return '${diff.inDays} hours ago';
    if (diff.inHours > 0) return '${diff.inHours} hours ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes} minutes ago';
    return 'Just now';
  }

  String _getCategoryLabel(ChannelCategory category) {
    switch (category) {
      case ChannelCategory.official: return 'Official';
      case ChannelCategory.clubs: return 'Clubs';
      case ChannelCategory.devTeam: return 'Dev Team';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE0E4F0), width: 1),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            GestureDetector(
              onTap: widget.onTap,
              behavior: HitTestBehavior.opaque,
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFE8F0FE),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      widget.channel.channelName.substring(0, 1).toUpperCase(),
                      style: GoogleFonts.redditSans(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        color: const Color(0xFF0569FF),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                widget.channel.channelName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.redditSans(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                  color: const Color(0xFF1F1F1F),
                                ),
                              ),
                            ),
                            if (widget.channel.isVerified) ...[
                              const SizedBox(width: 4),
                              const Icon(Icons.verified_rounded, size: 16, color: Color(0xFF0569FF)),
                            ],
                          ],
                        ),
                        Text(
                          '${_getCategoryLabel(widget.channel.category)} · ${_timeAgo(widget.data.postedAt)}',
                          style: GoogleFonts.redditSans(
                            fontWeight: FontWeight.w500,
                            fontSize: 11,
                            color: const Color(0xFF838A97),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Image Placeholder
            Container(
              width: double.infinity,
              height: 160,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F0FE),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Icon(
                  Icons.school_outlined,
                  size: 40,
                  color: Color(0xFF75A4FF),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Body Text
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.data.bodyText,
                  maxLines: _isExpanded ? null : 2,
                  softWrap: true,
                  overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                  style: GoogleFonts.redditSans(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                    color: const Color(0xFF1F1F1F),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: () => setState(() => _isExpanded = !_isExpanded),
                  behavior: HitTestBehavior.opaque,
                  child: Text(
                    _isExpanded ? 'Show less' : 'Read more',
                    style: GoogleFonts.redditSans(
                      color: const Color(0xFF0569FF),
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),

            // Action Row
            Row(
              children: [
                GestureDetector(
                  onTap: widget.onLikeTap,
                  behavior: HitTestBehavior.opaque,
                  child: Row(
                    children: [
                      Icon(
                        widget.data.isLikedByCurrentUser
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        size: 18,
                        color: widget.data.isLikedByCurrentUser
                            ? const Color(0xFFDA4979)
                            : const Color(0xFF838A97),
                      ),
                      const SizedBox(width: 6),
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
                const SizedBox(width: 15),
                GestureDetector(
                  onTap: widget.onTap,
                  behavior: HitTestBehavior.opaque,
                  child: Row(
                    children: [
                      const Icon(Icons.chat_bubble_outline_rounded, size: 16, color: Color(0xFF838A97)),
                      const SizedBox(width: 6),
                      Text(
                        '${widget.data.commentCount}',
                        style: GoogleFonts.redditSans(
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                          color: const Color(0xFF838A97),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    _showCustomShareToast(context);
                    widget.onShareTap();
                  },
                  behavior: HitTestBehavior.opaque,
                  child: const Icon(Icons.ios_share_rounded, size: 18, color: Color(0xFF838A97)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
