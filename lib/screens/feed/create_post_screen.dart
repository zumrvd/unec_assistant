import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../models/post.dart';
import '../../models/channel.dart';
import '../../models/post_request.dart';
import '../../models/user_signature.dart';
import '../../presentation/components/cards/post_card.dart';
import '../../presentation/components/lists/labels.dart';
import '../../presentation/components/dialogs/discard_changes_dialog.dart';
import '../../providers/post_request_provider.dart';
import '../../providers/signature_provider.dart';
import '../../utils/app_toast.dart';

enum CreatePostView { editor, pending, approved }

class CreatePostScreen extends ConsumerStatefulWidget {
  const CreatePostScreen({super.key});

  @override
  ConsumerState<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _bodyController = TextEditingController();

  ChannelCategory _selectedCategory = ChannelCategory.official;
  bool _isLikedPreview = false;
  int _likeCountPreview = 0;
  bool _isSubmitted = false;
  bool _saveAsSignature = false;
  String? _selectedSignatureId;

  CreatePostView _currentView = CreatePostView.editor;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _onBack(BuildContext context) async {
    if (_isSubmitted) {
      context.pop();
      return;
    }

    if (_currentView == CreatePostView.editor) {
      if (_bodyController.text.isNotEmpty || _nameController.text.isNotEmpty) {
        final shouldPop = await showDiscardChangesDialog(context);
        if (shouldPop == true && context.mounted) {
          context.pop();
        }
        return;
      }
    }

    context.pop();
  }

  void _applySignature(UserSignature sig) {
    setState(() {
      _nameController.text = sig.name;
      _emailController.text = sig.email;
      _selectedCategory = sig.preferredCategory;
      _selectedSignatureId = sig.id;
    });
  }

  void _submitRequest() {
    if (_bodyController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _nameController.text.isEmpty) {
      AppToast.show(context, 'Please fill all required fields');
      return;
    }

    if (!_emailController.text.contains('@')) {
      AppToast.show(context, 'Please enter a valid email');
      return;
    }

    if (_saveAsSignature) {
      final id = _selectedSignatureId ?? DateTime.now().millisecondsSinceEpoch.toString();
      ref.read(signatureProvider.notifier).saveSignature(UserSignature(
            id: id,
            name: _nameController.text,
            email: _emailController.text,
            preferredCategory: _selectedCategory,
          ));
    }

    final request = PostRequest(
      requestId: DateTime.now().millisecondsSinceEpoch.toString(),
      senderName: _nameController.text,
      senderEmail: _emailController.text,
      bodyText: _bodyController.text,
      categoryLabel: _getCategoryLabel(_selectedCategory),
      status: PostRequestStatus.pending,
      createdAt: DateTime.now(),
    );

    ref.read(postRequestProvider.notifier).addRequest(request);

    setState(() => _isSubmitted = true);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text('Request Sent',
            style: GoogleFonts.redditSans(fontWeight: FontWeight.bold)),
        content: Text(
          'Your post has been sent to audits (zverdiyevaa9@gmail.com). You will be notified once it is approved.',
          style: GoogleFonts.redditSans(),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context); // Close dialog
              if (mounted) {
                context.pop(); // Return to feed using go_router
              }
            },
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text('OK',
                  style: GoogleFonts.redditSans(
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0569FF))),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Initial auto-fill from most recent signature if empty
    ref.listen(signatureProvider, (previous, next) {
      if (next.isNotEmpty &&
          _nameController.text.isEmpty &&
          _emailController.text.isEmpty &&
          _selectedSignatureId == null) {
        _applySignature(next.last);
      }
    });

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop || (_isSubmitted && _currentView == CreatePostView.editor)) {
          return;
        }
        await _onBack(context);
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FC),
        appBar: CustomAppBar(
          title: _getAppBarTitle(),
          onBackTap: () => _onBack(context),
        ),
        body: Column(
          children: [
            _buildViewToggle(),
            Expanded(child: _buildCurrentView()),
          ],
        ),
      ),
    );
  }

  String _getAppBarTitle() {
    switch (_currentView) {
      case CreatePostView.editor:
        return 'Create Post';
      case CreatePostView.pending:
        return 'Waiting Approval';
      case CreatePostView.approved:
        return 'Shared Posts';
    }
  }

  Widget _buildViewToggle() {
    final options = <(String, CreatePostView)>[
      ('Editor', CreatePostView.editor),
      ('Waiting', CreatePostView.pending),
      ('Shared', CreatePostView.approved),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE0E4F0), width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var i = 0; i < options.length; i++) ...[
            if (i > 0) const SizedBox(width: 20),
            GestureDetector(
              onTap: () => setState(() => _currentView = options[i].$2),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: _currentView == options[i].$2
                      ? const Color(0xFF0569FF)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  options[i].$1,
                  style: GoogleFonts.redditSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: _currentView == options[i].$2
                        ? Colors.white
                        : const Color(0xFF838A97),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCurrentView() {
    switch (_currentView) {
      case CreatePostView.editor:
        return _buildEditorView();
      case CreatePostView.pending:
        return _buildPendingView();
      case CreatePostView.approved:
        return _buildApprovedView();
    }
  }

  Widget _buildEditorView() {
    final previewChannel = Channel(
      channelId: 'preview',
      channelName:
          _nameController.text.isEmpty ? 'Your Name' : _nameController.text,
      category: _selectedCategory,
      isVerified: false,
    );

    final previewPost = Post(
      postId: 'preview',
      channelId: 'preview',
      bodyText: _bodyController.text.isEmpty
          ? 'Your post content will appear here...'
          : _bodyController.text,
      feedType: _getFeedTypeFromCategory(_selectedCategory),
      postedAt: DateTime.now(),
      likeCount: _likeCountPreview,
      commentCount: 0,
      shareCount: 0,
      isLikedByCurrentUser: _isLikedPreview,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAuditInfoCard(),
          const SizedBox(height: 25),
          _buildSectionTitle('SENDER DETAILS'),
          const SizedBox(height: 12),
          _buildSignatureDropdown(),
          const SizedBox(height: 12),
          _buildTextField(
            controller: _nameController,
            hintText: 'Full Name',
            icon: Icons.person_outline_rounded,
            onChanged: (val) {
              setState(() => _selectedSignatureId = null);
            },
          ),
          const SizedBox(height: 12),
          _buildTextField(
            controller: _emailController,
            hintText: 'Your Email (Sender)',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            onChanged: (val) {
              setState(() => _selectedSignatureId = null);
            },
          ),
          const SizedBox(height: 12),
          _buildSignatureToggle(),
          const SizedBox(height: 25),
          _buildSectionTitle('POST CONTENT'),
          const SizedBox(height: 12),
          _buildCategorySelector(),
          const SizedBox(height: 12),
          _buildTextField(
            controller: _bodyController,
            hintText: 'What\'s on your mind?',
            maxLines: 5,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          _buildAttachmentButton(),
          const SizedBox(height: 35),
          _buildSectionTitle('LIVE PREVIEW'),
          const SizedBox(height: 15),
          PostCard(
            data: previewPost,
            channel: previewChannel,
            onTap: () {},
            onLikeTap: () {
              setState(() {
                _isLikedPreview = !_isLikedPreview;
                _likeCountPreview = _isLikedPreview ? 1 : 0;
              });
            },
            onShareTap: () {},
          ),
          const SizedBox(height: 40),
          _buildSubmitButton(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSignatureDropdown() {
    final signatures = ref.watch(signatureProvider);
    if (signatures.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE0E4F0)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedSignatureId,
          hint: Text('Select saved signature', 
            style: GoogleFonts.redditSans(fontSize: 14, color: const Color(0xFF838A97))),
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF838A97)),
          items: signatures.map((sig) {
            return DropdownMenuItem<String>(
              value: sig.id,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      sig.name,
                      style: GoogleFonts.redditSans(fontSize: 14, color: const Color(0xFF1F1F1F)),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      ref.read(signatureProvider.notifier).deleteSignature(sig.id);
                      if (_selectedSignatureId == sig.id) {
                        setState(() => _selectedSignatureId = null);
                      }
                    },
                    behavior: HitTestBehavior.opaque,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Icon(Icons.delete_outline_rounded, size: 18, color: Color(0xFFFF4D4D)),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (id) {
            if (id != null) {
              final sig = signatures.firstWhere((s) => s.id == id);
              _applySignature(sig);
            }
          },
        ),
      ),
    );
  }

  Widget _buildPendingView() {
    final pendingRequests = ref.watch(pendingRequestsProvider);

    if (pendingRequests.isEmpty) {
      return _buildEmptyState('Waiting for your first approval?',
          'Send a post for review and it will appear here!');
    }

    return ListView.separated(
      padding: const EdgeInsets.all(25),
      itemCount: pendingRequests.length,
      separatorBuilder: (context, index) => const SizedBox(height: 15),
      itemBuilder: (context, index) {
        final req = pendingRequests[index];
        return _buildRequestTile(req, Icons.access_time_rounded, Colors.amber);
      },
    );
  }

  Widget _buildApprovedView() {
    final approvedRequests = ref.watch(approvedRequestsProvider);

    if (approvedRequests.isEmpty) {
      return _buildEmptyState('No shared posts yet.', 'Create your first post now!');
    }

    return ListView.separated(
      padding: const EdgeInsets.all(25),
      itemCount: approvedRequests.length,
      separatorBuilder: (context, index) => const SizedBox(height: 15),
      itemBuilder: (context, index) {
        final req = approvedRequests[index];
        return _buildRequestTile(req, Icons.check_circle_outline_rounded, Colors.green);
      },
    );
  }

  Widget _buildRequestTile(PostRequest req, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE0E4F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  req.categoryLabel,
                  style: GoogleFonts.redditSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: const Color(0xFF1F1F1F),
                  ),
                ),
              ),
              Text(
                _timeAgo(req.createdAt),
                style: GoogleFonts.redditSans(
                  fontSize: 11,
                  color: const Color(0xFF838A97),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            req.bodyText,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.redditSans(
              fontSize: 13,
              color: const Color(0xFF1F1F1F),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String title, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.post_add_rounded, size: 64, color: Color(0xFFE0E4F0)),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.redditSans(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: const Color(0xFF1F1F1F),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.redditSans(
                fontSize: 13,
                color: const Color(0xFF838A97),
              ),
            ),
            const SizedBox(height: 24),
            if (_currentView != CreatePostView.editor)
              GestureDetector(
                onTap: () => setState(() => _currentView = CreatePostView.editor),
                behavior: HitTestBehavior.opaque,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0569FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Go to Editor',
                    style: GoogleFonts.redditSans(fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _timeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
    return 'Just now';
  }

  Widget _buildAuditInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F0FE),
        borderRadius: BorderRadius.circular(16),
        border:
            Border.all(color: const Color(0xFF0569FF).withValues(alpha: 0.1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded,
              color: Color(0xFF0569FF), size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Audit Approval Process',
                  style: GoogleFonts.redditSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: const Color(0xFF0569FF),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'All posts are sent to our team for verification. Once approved, your post will be visible in the Discover feed.',
                  style: GoogleFonts.redditSans(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: const Color(0xFF4285F4),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.redditSans(
        fontWeight: FontWeight.w800,
        fontSize: 11,
        color: const Color(0xFF838A97),
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    IconData? icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    ValueChanged<String>? onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE0E4F0)),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        onChanged: onChanged,
        style:
            GoogleFonts.redditSans(fontSize: 14, color: const Color(0xFF1F1F1F)),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.redditSans(
              color: const Color(0xFF838A97), fontSize: 14),
          prefixIcon: icon != null
              ? Icon(icon, color: const Color(0xFF838A97), size: 20)
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }

  Widget _buildCategorySelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE0E4F0)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<ChannelCategory>(
          value: _selectedCategory,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              color: Color(0xFF838A97)),
          items: ChannelCategory.values.map((cat) {
            return DropdownMenuItem(
              value: cat,
              child: Text(
                _getCategoryLabel(cat),
                style: GoogleFonts.redditSans(
                    fontSize: 14, color: const Color(0xFF1F1F1F)),
              ),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) {
              setState(() {
                _selectedCategory = val;
                _selectedSignatureId = null;
              });
            }
          },
        ),
      ),
    );
  }

  Widget _buildAttachmentButton() {
    return GestureDetector(
      onTap: () {
      AppToast.show(context, 'Image selection will be implemented soon');
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF0F4FF),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: const Color(0xFF0569FF).withValues(alpha: 0.2),
              style: BorderStyle.solid),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.image_outlined, color: Color(0xFF0569FF), size: 20),
            const SizedBox(width: 10),
            Text(
              'Add Attachment',
              style: GoogleFonts.redditSans(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: const Color(0xFF0569FF),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return GestureDetector(
      onTap: _submitRequest,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF0569FF),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0569FF).withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            'Send for Approval',
            style: GoogleFonts.redditSans(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignatureToggle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE0E4F0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.history_edu_rounded,
                  color: Color(0xFF838A97), size: 20),
              const SizedBox(width: 12),
              Text(
                'Save as signature',
                style: GoogleFonts.redditSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1F1F1F),
                ),
              ),
            ],
          ),
          Switch(
            value: _saveAsSignature,
            activeThumbColor: const Color(0xFF0569FF),
            onChanged: (val) => setState(() => _saveAsSignature = val),
          ),
        ],
      ),
    );
  }

  String _getCategoryLabel(ChannelCategory category) {
    switch (category) {
      case ChannelCategory.official:
        return 'Official Announcement';
      case ChannelCategory.clubs:
        return 'Club Update';
      case ChannelCategory.devTeam:
        return 'Dev Team Log';
    }
  }

  PostFeedType _getFeedTypeFromCategory(ChannelCategory cat) {
    switch (cat) {
      case ChannelCategory.official:
        return PostFeedType.official;
      case ChannelCategory.clubs:
        return PostFeedType.clubs;
      case ChannelCategory.devTeam:
        return PostFeedType.devTeam;
    }
  }
}
