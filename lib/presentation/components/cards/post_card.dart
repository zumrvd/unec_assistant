import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/post.dart';
import '../../../models/channel.dart';

class PostCard extends StatelessWidget {
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

  String _timeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inDays > 0) return '${diff.inDays} hours ago'; // Simplification for mock
    if (diff.inHours > 0) return '${diff.inHours} hours ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes} minutes ago';
    return 'Just now';
  }

  String _getCategoryLabel(ChannelCategory category) {
    switch (category) {
      case ChannelCategory.official:
        return 'Official';
      case ChannelCategory.clubs:
        return 'Clubs';
      case ChannelCategory.devTeam:
        return 'Dev Team';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFE8F0FE),
                ),
                alignment: Alignment.center,
                child: Text(
                  channel.channelName.substring(0, 1).toUpperCase(),
                  style: GoogleFonts.redditSans(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: const Color(0xFF0569FF)),
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
                            channel.channelName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.redditSans(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: const Color(0xFF1F1F1F),
                            ),
                          ),
                        ),
                        if (channel.isVerified) ...[
                          const SizedBox(width: 4),
                          const Icon(Icons.verified_rounded,
                              size: 14, color: Color(0xFF0569FF)),
                        ],
                      ],
                    ),
                    Text(
                      '${_getCategoryLabel(channel.category)} · ${_timeAgo(data.postedAt)}',
                      style: GoogleFonts.redditSans(
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                        color: const Color(0xFF838A97),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Image Placeholder
          Container(
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F0FE),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Icon(
                Icons.school_outlined,
                size: 28,
                color: Color(0x800569FF),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Body Text
          GestureDetector(
            onTap: onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.bodyText,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.redditSans(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                    color: const Color(0xFF1F1F1F),
                    height: 1.4,
                  ),
                ),
                Text(
                  'Read more',
                  style: GoogleFonts.redditSans(
                    color: const Color(0xFF0569FF),
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),

          // Action Row
          Row(
            children: [
              GestureDetector(
                onTap: onLikeTap,
                child: Row(
                  children: [
                    Icon(
                      data.isLikedByCurrentUser
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      size: 18,
                      color: data.isLikedByCurrentUser
                          ? const Color(0xFFDA4979)
                          : const Color(0xFF838A97),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${data.likeCount}',
                      style: GoogleFonts.redditSans(
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                        color: data.isLikedByCurrentUser
                            ? const Color(0xFFDA4979)
                            : const Color(0xFF838A97),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 15),
              GestureDetector(
                onTap: onTap,
                child: Row(
                  children: [
                    const Icon(Icons.chat_bubble_outline_rounded,
                        size: 16, color: Color(0xFF838A97)),
                    const SizedBox(width: 6),
                    Text(
                      '${data.commentCount}',
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
                onTap: onShareTap,
                child: const Icon(Icons.ios_share_rounded,
                    size: 18, color: Color(0xFF838A97)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
