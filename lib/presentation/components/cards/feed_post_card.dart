import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unec_assistant/models/feed_post.dart';

class FeedPostCard extends StatefulWidget {
  const FeedPostCard({
    required this.post,
    this.isInteractive = true,
    super.key,
  });

  final FeedPost post;
  final bool isInteractive;

  @override
  State<FeedPostCard> createState() => _FeedPostCardState();
}

class _FeedPostCardState extends State<FeedPostCard> with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late int _likeCount;
  bool _isLiked = false;

  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  static const _channelMetaColor = Color(0x80838A97);
  static const _borderColor = Color(0xFFE0E4F0);
  static const _readMoreColor = Color(0xFF0569FF);
  static const _likedColor = Color(0xFFDA4979);
  static const _imageIconColor = Color(0x800569FF);
  static const _pillBackground = Color(0x260569FF);
  static const _pillTextColor = Color(0xFF0569FF);

  FeedPost get post => widget.post;

  @override
  void initState() {
    super.initState();
    _likeCount = post.likeCount;

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _pulseAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.2).chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.2, end: 1.0).chain(CurveTween(curve: Curves.easeIn)),
        weight: 50,
      ),
    ]).animate(_pulseController);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant FeedPostCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.post.id != post.id) {
      _isExpanded = false;
      _isLiked = false;
      _likeCount = post.likeCount;
    }
  }

  String _truncated(String text) {
    if (text.length > 100) {
      return '${text.substring(0, 100)}...';
    }
    return text;
  }

  void _openPost() {
    context.go('/feed/post${post.id}');
  }

  void _handleLike() {
    setState(() {
      _isLiked = !_isLiked;
      _likeCount += _isLiked ? 1 : -1;
    });
    if (_isLiked) {
      _pulseController.forward(from: 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final showReadMoreToggle = post.content.length > 100;

    final cardContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.asset(
                'assets/images/unec_profile_picture.png',
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    post.displayChannelName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.redditSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: const Color(0xFF000000),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    post.channelMeta,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.redditSans(
                      fontWeight: FontWeight.w400,
                      fontSize: 10,
                      color: _channelMetaColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    decoration: BoxDecoration(
                      color: _pillBackground,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    child: Text(
                      post.category,
                      style: GoogleFonts.redditSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 8,
                        color: _pillTextColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (widget.isInteractive)
              IconButton(
                onPressed: _openPost,
                icon: const Icon(
                  Icons.open_in_new_rounded,
                  size: 20,
                  color: _channelMetaColor,
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          height: 80,
          decoration: BoxDecoration(
            color: const Color(0xFFE8F0FE),
            borderRadius: BorderRadius.circular(7),
          ),
          child: const Center(
            child: Icon(
              Icons.school_rounded,
              size: 32,
              color: _imageIconColor,
            ),
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: widget.isInteractive ? () => setState(() => _isExpanded = !_isExpanded) : null,
          child: AnimatedCrossFade(
            duration: const Duration(milliseconds: 250),
            firstChild: Text(
              _truncated(post.content),
              softWrap: true,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.redditSans(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: const Color(0xFF000000),
              ),
            ),
            secondChild: Text(
              post.content,
              softWrap: true,
              style: GoogleFonts.redditSans(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: const Color(0xFF000000),
              ),
            ),
            crossFadeState: _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          ),
        ),
        if (showReadMoreToggle && (!widget.isInteractive || !_isExpanded)) ...[
          const SizedBox(height: 12),
          GestureDetector(
            onTap: widget.isInteractive ? () => setState(() => _isExpanded = !_isExpanded) : _openPost,
            child: Text(
              _isExpanded ? 'Read less' : 'Read more',
              style: GoogleFonts.redditSans(
                fontWeight: FontWeight.w400,
                fontSize: 12,
                color: _readMoreColor,
              ),
            ),
          ),
        ],
        const SizedBox(height: 12),
        const Divider(
          color: _borderColor,
          thickness: 1,
          indent: 0,
          endIndent: 0,
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: widget.isInteractive ? _handleLike : null,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ScaleTransition(
                        scale: _pulseAnimation,
                        child: Icon(
                          _isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                          size: 20,
                          color: _isLiked ? _likedColor : _channelMetaColor,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$_likeCount',
                        style: GoogleFonts.redditSans(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: _channelMetaColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: widget.isInteractive ? _openPost : null,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.mode_comment_outlined,
                        size: 20,
                        color: _channelMetaColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${post.commentCount}',
                        style: GoogleFonts.redditSans(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: _channelMetaColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Icon(
              Icons.ios_share_rounded,
              size: 20,
              color: _channelMetaColor,
            ),
          ],
        ),
      ],
    );

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: _borderColor,
          width: 1,
        ),
      ),
      padding: const EdgeInsets.only(
        top: 20,
        right: 31,
        bottom: 20,
        left: 31,
      ),
      child: widget.isInteractive 
          ? cardContent 
          : GestureDetector(
              onTap: _openPost,
              behavior: HitTestBehavior.opaque,
              child: cardContent,
            ),
    );
  }
}
