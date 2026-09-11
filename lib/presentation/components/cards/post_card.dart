import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:unec_assistant/providers/theme_provider.dart';
import 'package:unec_assistant/providers/locale_provider.dart';
import 'package:unec_assistant/l10n/translations.dart';
import '../../../models/post.dart';
import '../../../models/channel.dart';
import '../../../providers/feed_provider.dart';


class PostCard extends ConsumerStatefulWidget {
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
  ConsumerState<PostCard> createState() => _PostCardState();
}

class _PostCardState extends ConsumerState<PostCard> {
  bool _isExpanded = false;

  String _timeAgo(DateTime dateTime, AppStrings tr) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inDays > 0) return tr.feedTimeAgoDay(diff.inDays);
    if (diff.inHours > 0) return tr.feedTimeAgoHour(diff.inHours);
    if (diff.inMinutes > 0) return tr.feedTimeAgoMin(diff.inMinutes);
    return tr.feedJustNow;
  }

  @override
  Widget build(BuildContext context) {
    final appColors = ref.watch(appColorsProvider);
    final tr = ref.watch(strProvider);
    final categoryLabel = switch (widget.channel.category) {
      ChannelCategory.official => tr.feedFilterOfficial,
      ChannelCategory.clubs => tr.feedFilterClubs,
      ChannelCategory.devTeam => tr.feedFilterDevTeam,
    };

    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: appColors.cardBackground,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: appColors.borderColor, width: 1),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: appColors.primaryContainer,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    widget.channel.channelName.substring(0, 1).toUpperCase(),
                    style: GoogleFonts.redditSans(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      color: appColors.primaryOnContainer,
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
                                color: appColors.textPrimary,
                              ),
                            ),
                          ),
                          if (widget.channel.isVerified) ...[
                            const SizedBox(width: 4),
                            Icon(
                              Icons.verified_rounded,
                              size: 16,
                              color: appColors.primary,
                            ),
                          ],
                        ],
                      ),
                      Text(
                        '$categoryLabel · ${_timeAgo(widget.data.postedAt, tr)}',
                        style: GoogleFonts.redditSans(
                          fontWeight: FontWeight.w500,
                          fontSize: 11,
                          color: appColors.textSecondary,
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
                color: appColors.placeholderImageBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Icon(
                  Icons.school_outlined,
                  size: 40,
                  color: appColors.placeholderImageIcon,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Body Text + Read More
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.data.bodyText,
                  maxLines: _isExpanded ? null : 2,
                  softWrap: true,
                  overflow: _isExpanded
                      ? TextOverflow.visible
                      : TextOverflow.ellipsis,
                  style: GoogleFonts.redditSans(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                    color: appColors.textPrimary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: () => setState(() => _isExpanded = !_isExpanded),
                  behavior: HitTestBehavior.opaque,
                  child: Text(
                    _isExpanded ? tr.feedShowLess : tr.feedReadMore,
                    style: GoogleFonts.redditSans(
                      color: appColors.primary,
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
                            ? appColors.heartColor
                            : appColors.textSecondary,
                      ),
                      const SizedBox(width: 6),
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
                const SizedBox(width: 15),
                GestureDetector(
                  onTap: widget.onTap,
                  behavior: HitTestBehavior.opaque,
                  child: Row(
                    children: [
                      Icon(
                        Icons.chat_bubble_outline_rounded,
                        size: 16,
                        color: appColors.textSecondary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${widget.data.commentCount}',
                        style: GoogleFonts.redditSans(
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                          color: appColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () async {
                    ref.read(feedProvider.notifier).sharePost(widget.data.postId);
                    await Share.share(
                      'https://unec-assistant.app/feed/post/${widget.data.postId}',
                    );
                  },
                  child: Icon(
                    Icons.ios_share_rounded,
                    size: 18,
                    color: appColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
