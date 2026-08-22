import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unec_assistant/providers/locale_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../models/channel.dart';
import '../../../models/comment.dart';
import '../../../models/user_account.dart';
import '../../../presentation/components/cards/comment_tile.dart';
import '../../../presentation/components/lists/labels.dart';
import '../../../providers/post_detail_provider.dart';
import '../../../providers/current_user_provider.dart';
import '../../../utils/app_toast.dart';

// Top-level constant — decoupled from widget state.
const _kMockUsers = {
  'u2': UserAccount(userId: 'u2', displayName: 'Elşad V.', initials: 'EM'),
  'u3': UserAccount(userId: 'u3', displayName: 'Vəfa B.', initials: 'VB'),
  'u1': UserAccount(userId: 'u1', displayName: 'Zümrüd V.', initials: 'ZV'),
};

const _kCategoryLabels = {
  ChannelCategory.official: 'Official Channel',
  ChannelCategory.clubs: 'Clubs Channel',
  ChannelCategory.devTeam: 'Dev Team Channel',
};

class PostDetailScreen extends ConsumerStatefulWidget {
  final String postId;

  const PostDetailScreen({
    required this.postId,
    super.key,
  });

  @override
  ConsumerState<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends ConsumerState<PostDetailScreen> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(postDetailProvider.notifier).loadPostData(widget.postId);
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _copyToClipboard() {
    Clipboard.setData(const ClipboardData(text: 'https://unec.edu.az/post'));
    AppToast.show(context, 'Link copied to clipboard');
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(postDetailProvider);
    final currentUser = ref.watch(currentUserProvider);

    if (state.isLoading && state.post == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF8F9FC),
        appBar: const CustomAppBar(title: 'Posts'),
        body: const Center(child: CircularProgressIndicator(color: Color(0xFF0569FF))),
      );
    }

    if (state.post == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF8F9FC),
        appBar: const CustomAppBar(title: 'Posts'),
        body: const Center(child: Text('Post not found')),
      );
    }

    final post = state.post!;
    final channel = state.channel!;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: const CustomAppBar(title: 'Posts'),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFE8F0FE)),
                        alignment: Alignment.center,
                        child: Text(
                          channel.channelName.substring(0, 1).toUpperCase(),
                          style: GoogleFonts.redditSans(
                              fontWeight: FontWeight.w800,
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
                                    style: GoogleFonts.redditSans(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                      color: const Color(0xFF1F1F1F),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (channel.isVerified) ...[
                                  const SizedBox(width: 4),
                                  const Icon(Icons.verified_rounded, size: 14, color: Color(0xFF0569FF)),
                                ],
                              ],
                            ),
                            Text(
                              _kCategoryLabels[channel.category] ?? 'Channel',
                              style: GoogleFonts.redditSans(
                                fontWeight: FontWeight.w500,
                                fontSize: 11,
                                color: const Color(0xFF838A97),
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => ref.read(postDetailProvider.notifier).toggleSubscription(),
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: state.isSubscribed ? const Color(0xFF0569FF) : const Color(0xFFFFFFFF),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFF0569FF), width: 1),
                          ),
                          child: Text(
                            state.isSubscribed ? 'Subscribed' : 'Subscribe',
                            style: GoogleFonts.redditSans(
                              fontWeight: FontWeight.w700,
                              fontSize: 11,
                              color: state.isSubscribed ? const Color(0xFFFFFFFF) : const Color(0xFF0569FF),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      PopupMenuButton<String>(
                        color: const Color(0xFFFFFFFF),
                        elevation: 0,
                        offset: const Offset(0, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: Color(0xFFE0E4F0), width: 1),
                        ),
                        icon: const Icon(Icons.more_horiz_rounded, color: Color(0xFF838A97)),
                        itemBuilder: (context) => [
                          PopupMenuItem<String>(
                            value: 'report',
                            padding: EdgeInsets.zero,
                            child: GestureDetector(
                              onTap: () => Navigator.pop(context),
                              behavior: HitTestBehavior.opaque,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                                child: Text(
                                  'Report Post',
                                  style: GoogleFonts.redditSans(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                    color: const Color(0xFF1F1F1F),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F0FE),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Center(
                      child: Icon(Icons.school_outlined, size: 40, color: Color(0xFF75A4FF)),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: post.bodyText.split('Link :')[0]),
                        if (post.bodyText.contains('Link :')) ...[
                          const TextSpan(text: '\n\nLink : ', style: TextStyle(fontWeight: FontWeight.bold)),
                          WidgetSpan(
                            child: GestureDetector(
                              onTap: () => _launchURL(post.bodyText.split('Link :')[1].trim()),
                              behavior: HitTestBehavior.opaque,
                              child: Text(
                                post.bodyText.split('Link :')[1].trim(),
                                style: GoogleFonts.redditSans(
                                  color: const Color(0xFF0569FF),
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    style: GoogleFonts.redditSans(
                      fontSize: 14,
                      color: const Color(0xFF1F1F1F),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),

                  Text(
                    '${post.likeCount} likes · ${post.commentCount} comments · ${post.shareCount} shares',
                    style: GoogleFonts.redditSans(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: const Color(0xFF838A97),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Divider(color: Color(0xFFE0E4F0), thickness: 1),
                  const SizedBox(height: 15),

                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => ref.read(postDetailProvider.notifier).toggleLike(),
                        behavior: HitTestBehavior.opaque,
                        child: Icon(
                          post.isLikedByCurrentUser ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                          color: post.isLikedByCurrentUser ? const Color(0xFFDA4979) : const Color(0xFF838A97),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 25),
                      const Icon(Icons.chat_bubble_outline_rounded, color: Color(0xFF838A97), size: 22),
                      const SizedBox(width: 25),
                      GestureDetector(
                        onTap: () {
                          _copyToClipboard();
                          ref.read(postDetailProvider.notifier).sharePost();
                        },
                        behavior: HitTestBehavior.opaque,
                        child: const Icon(Icons.ios_share_rounded, color: Color(0xFF838A97), size: 22),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  const Divider(color: Color(0xFFE0E4F0), thickness: 1),
                  const SizedBox(height: 25),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${post.commentCount} comments',
                        style: GoogleFonts.redditSans(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: const Color(0xFF1F1F1F),
                        ),
                      ),
                      PopupMenuButton<CommentSort>(
                        onSelected: (sort) => ref.read(postDetailProvider.notifier).setSort(sort),
                        offset: const Offset(0, 40),
                        color: const Color(0xFFFFFFFF),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: Color(0xFFE0E4F0)),
                        ),
                        child: Row(
                          children: [
                            Text(
                              state.sort == CommentSort.mostRecent ? 'Most recent' : 'Most liked',
                              style: GoogleFonts.redditSans(
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                                color: const Color(0xFF0569FF),
                              ),
                            ),
                            const Icon(Icons.arrow_drop_down_rounded, color: Color(0xFF0569FF)),
                          ],
                        ),
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: CommentSort.mostRecent,
                            child: Text('Most recent'),
                          ),
                          const PopupMenuItem(
                            value: CommentSort.mostLiked,
                            child: Text('Most liked'),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.comments.length,
                    itemBuilder: (context, index) {
                      final comment = state.comments[index];
                      final author = _kMockUsers[comment.authorUserId] ??
                          const UserAccount(userId: '?', displayName: 'Unknown', initials: '??');

                      return CommentTile(
                        data: comment,
                        author: author,
                        currentUser: currentUser,
                        onLikeTap: (id) => ref.read(postDetailProvider.notifier).toggleCommentLike(id),
                        onReplySubmit: (text, parentId, replyToId) =>
                            ref.read(postDetailProvider.notifier).submitComment(
                              text,
                              parentCommentId: parentId,
                              replyToUserId: replyToId,
                              users: _kMockUsers,
                            ),
                        onEditSubmit: (id, text) => ref.read(postDetailProvider.notifier).editComment(id, text),
                        onDeleteTap: (id) => ref.read(postDetailProvider.notifier).deleteComment(id),
                        onLoadReplies: () => ref.read(postDetailProvider.notifier).loadReplies(comment.commentId),
                        loadedReplies: state.replies[comment.commentId],
                        users: _kMockUsers,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // Sticky Composer
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFFFFFFFF),
              border: Border(top: BorderSide(color: Color(0xFFE0E4F0), width: 1)),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFE8F0FE),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      currentUser.initials,
                      style: GoogleFonts.redditSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF0569FF),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FC),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFE0E4F0)),
                      ),
                      alignment: Alignment.centerLeft,
                      child: TextField(
                        controller: _commentController,
                        style: GoogleFonts.redditSans(
                          fontSize: 13,
                          color: const Color(0xFF1F1F1F),
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Add a comment...',
                          hintStyle: GoogleFonts.redditSans(
                            color: const Color(0xFF838A97),
                            fontSize: 13,
                          ),
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () {
                      if (_commentController.text.isNotEmpty) {
                        ref.read(postDetailProvider.notifier).submitComment(_commentController.text);
                        _commentController.clear();
                        FocusScope.of(context).unfocus();
                      }
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF0569FF),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.send_rounded,
                        color: Color(0xFFFFFFFF),
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}