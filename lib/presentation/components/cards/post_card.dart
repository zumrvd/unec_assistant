import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/post.dart';
import '../../../models/channel.dart';
import '../../../utils/app_toast.dart';

// Category label lookup — collapses the old switch to one line.
const _kCategoryLabels = {
  ChannelCategory.official: 'Official',
  ChannelCategory.clubs: 'Clubs',
  ChannelCategory.devTeam: 'Dev Team',
};

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

  /// Fixed: was returning "hours ago" for day-level diffs.
  String _timeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
    return 'Just now';
  }

  @override
  Widget build(BuildContext context) {
    final categoryLabel = _kCategoryLabels[widget.channel.category] ?? '';

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
            // Header — no redundant inner GestureDetector; outer card handles nav.
            Row(
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
                        '$categoryLabel · ${_timeAgo(widget.data.postedAt)}',
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
                child: Icon(Icons.school_outlined, size: 40, color: Color(0xFF75A4FF)),
              ),
            ),
            const SizedBox(height: 12),

            // Body Text + Read More
            // GestureDetector absorbs the tap so it does NOT bubble to the card nav.
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

            // Action Row — each inner GestureDetector stops propagation to the card.
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    widget.onLikeTap();
                  },
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
                    AppToast.show(context, 'Link copied to clipboard');
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
