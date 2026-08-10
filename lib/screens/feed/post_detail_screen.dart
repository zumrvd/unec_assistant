import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../models/comment.dart';
import '../../../models/user_account.dart';
import '../../../presentation/components/cards/comment_tile.dart';
import '../../../presentation/components/lists/labels.dart';
import '../../../providers/post_detail_provider.dart';
import '../../../providers/current_user_provider.dart';

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

  final Map<String, UserAccount> _mockUsers = {
    'u2':
        const UserAccount(userId: 'u2', displayName: 'Elşad V.', initials: 'EM'),
    'u3':
        const UserAccount(userId: 'u3', displayName: 'Vəfa B.', initials: 'VB'),
    'u1':
        const UserAccount(userId: 'u1', displayName: 'Zümrüd V.', initials: 'ZV'),
  };

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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Link copied to clipboard')),
    );
  }

  void _showReportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report Post'),
        content: const Text('Are you sure you want to report this post?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Report')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(postDetailProvider);
    final currentUser = ref.watch(currentUserProvider);

    if (state.isLoading && state.post == null) {
      return const Scaffold(
        backgroundColor: Color(0xFFF8F9FC),
        appBar: CustomAppBar(title: 'Posts'),
        body:
            Center(child: CircularProgressIndicator(color: Color(0xFF0569FF))),
      );
    }

    if (state.post == null) {
      return const Scaffold(
        backgroundColor: Color(0xFFF8F9FC),
        appBar: CustomAppBar(title: 'Posts'),
        body: Center(child: Text('Post not found')),
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Channel Header
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
                                Text(
                                  channel.channelName,
                                  style: GoogleFonts.redditSans(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                    color: const Color(0xFF1F1F1F),
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
                              'Official Channel',
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
                        onTap: () => ref
                            .read(postDetailProvider.notifier)
                            .toggleSubscription(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: state.isSubscribed
                                ? const Color(0xFF0569FF)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFF0569FF)),
                          ),
                          child: Text(
                            state.isSubscribed ? 'Subscribed' : 'Subscribe',
                            style: GoogleFonts.redditSans(
                              fontWeight: FontWeight.w700,
                              fontSize: 11,
                              color: state.isSubscribed
                                  ? Colors.white
                                  : const Color(0xFF0569FF),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: _showReportDialog,
                        child: const Icon(Icons.more_horiz_rounded,
                            color: Color(0xFF838A97)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Content Image
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F0FE),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Center(
                      child: Icon(Icons.school_outlined,
                          size: 40, color: Color(0x800569FF)),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Body Text with Link
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: post.bodyText.split('Link :')[0]),
                        if (post.bodyText.contains('Link :')) ...[
                          const TextSpan(
                              text: '\n\nLink : ',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          WidgetSpan(
                            child: GestureDetector(
                              onTap: () => _launchURL(
                                  post.bodyText.split('Link :')[1].trim()),
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

                  // Stats
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

                  // Interaction Icons
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () =>
                            ref.read(postDetailProvider.notifier).toggleLike(),
                        child: Icon(
                          post.isLikedByCurrentUser
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          color: post.isLikedByCurrentUser
                              ? const Color(0xFFDA4979)
                              : const Color(0xFF838A97),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 25),
                      const Icon(Icons.chat_bubble_outline_rounded,
                          color: Color(0xFF838A97), size: 22),
                      const SizedBox(width: 25),
                      GestureDetector(
                        onTap: _copyToClipboard,
                        child: const Icon(Icons.ios_share_rounded,
                            color: Color(0xFF838A97), size: 22),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  const Divider(color: Color(0xFFE0E4F0), thickness: 1),
                  const SizedBox(height: 25),

                  // Comment Sort Header
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
                        onSelected: (sort) => ref
                            .read(postDetailProvider.notifier)
                            .setSort(sort),
                        offset: const Offset(0, 40),
                        child: Row(
                          children: [
                            Text(
                              state.sort == CommentSort.mostRecent
                                  ? 'Most recent'
                                  : 'Most liked',
                              style: GoogleFonts.redditSans(
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                                color: const Color(0xFF0569FF),
                              ),
                            ),
                            const Icon(Icons.arrow_drop_down_rounded,
                                color: Color(0xFF0569FF)),
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

                  // Comments List
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.comments.length,
                    itemBuilder: (context, index) {
                      final comment = state.comments[index];
                      final author = _mockUsers[comment.authorUserId] ??
                          const UserAccount(
                              userId: '?',
                              displayName: 'Unknown',
                              initials: '??');

                      return CommentTile(
                        data: comment,
                        author: author,
                        onLikeTap: () => ref
                            .read(postDetailProvider.notifier)
                            .toggleCommentLike(comment.commentId),
                        onReplySubmit: (text) => ref
                            .read(postDetailProvider.notifier)
                            .submitComment(text,
                                parentCommentId: comment.commentId),
                        onLoadReplies: () => ref
                            .read(postDetailProvider.notifier)
                            .loadReplies(comment.commentId),
                        loadedReplies: state.replies[comment.commentId],
                        users: _mockUsers,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // Sticky Composer
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: const BoxDecoration(
              color: Colors.white,
              border:
                  Border(top: BorderSide(color: Color(0xFFE0E4F0), width: 1)),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: const Color(0xFFE8F0FE),
                    child: Text(currentUser.initials,
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0569FF))),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FC),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFE0E4F0)),
                      ),
                      child: TextField(
                        controller: _commentController,
                        style: GoogleFonts.redditSans(fontSize: 13),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Add a comment...',
                          isDense: true,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () {
                      if (_commentController.text.isNotEmpty) {
                        ref
                            .read(postDetailProvider.notifier)
                            .submitComment(_commentController.text);
                        _commentController.clear();
                        FocusScope.of(context).unfocus();
                      }
                    },
                    child: const CircleAvatar(
                      radius: 20,
                      backgroundColor: Color(0xFF0569FF),
                      child: Icon(Icons.send_rounded,
                          color: Colors.white, size: 18),
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
