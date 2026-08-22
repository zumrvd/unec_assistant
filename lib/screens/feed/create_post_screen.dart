import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unec_assistant/providers/locale_provider.dart';
import 'package:unec_assistant/l10n/translations.dart';
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
import '../../providers/theme_provider.dart';
import '../../presentation/theme/app_colors.dart';

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

  AppStrings get _tr => ref.read(strProvider);

  void _submitRequest() {
    if (_bodyController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _nameController.text.isEmpty) {
      AppToast.show(context, _tr.createPostFillFields);
      return;
    }

    if (!_emailController.text.contains('@')) {
      AppToast.show(context, _tr.createPostInvalidEmail);
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
      builder: (context) {
        final appColors = ref.watch(appColorsProvider);
        return AlertDialog(
          backgroundColor: appColors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: Text(_tr.createPostRequestSentTitle,
              style: GoogleFonts.redditSans(fontWeight: FontWeight.bold, color: appColors.textPrimary)),
          content: Text(
            _tr.createPostSuccessDesc,
            style: GoogleFonts.redditSans(color: appColors.textSecondary),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                if (mounted) {
                  context.pop();
                }
              },
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Text(_tr.createPostOk,
                    style: GoogleFonts.redditSans(
                        fontWeight: FontWeight.w700,
                        color: appColors.primary)),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(signatureProvider, (previous, next) {
      if (next.isNotEmpty &&
          _nameController.text.isEmpty &&
          _emailController.text.isEmpty &&
          _selectedSignatureId == null) {
        _applySignature(next.last);
      }
    });

    final appColors = ref.watch(appColorsProvider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop || (_isSubmitted && _currentView == CreatePostView.editor)) {
          return;
        }
        await _onBack(context);
      },
      child: Scaffold(
        backgroundColor: appColors.background,
        appBar: CustomAppBar(
          title: _getAppBarTitle(),
          onBackTap: () => _onBack(context),
        ),
        body: Column(
          children: [
            _buildViewToggle(appColors),
            Expanded(child: _buildCurrentView(appColors)),
          ],
        ),
      ),
    );
  }

  String _getAppBarTitle() {
    switch (_currentView) {
      case CreatePostView.editor:
        return _tr.createPostTitle;
      case CreatePostView.pending:
        return _tr.createPostWaitingApproval;
      case CreatePostView.approved:
        return _tr.createPostSharedPosts;
    }
  }

  Widget _buildViewToggle(AppColors appColors) {
    final options = <(String, CreatePostView)>[
      (_tr.createPostEditorTab, CreatePostView.editor),
      (_tr.createPostWaitingTab, CreatePostView.pending),
      (_tr.createPostSharedTab, CreatePostView.approved),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: appColors.surface,
        border: Border(bottom: BorderSide(color: appColors.borderColor, width: 1)),
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
                      ? appColors.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  options[i].$1,
                  style: GoogleFonts.redditSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: _currentView == options[i].$2
                        ? appColors.textInverse
                        : appColors.textSecondary,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCurrentView(AppColors appColors) {
    switch (_currentView) {
      case CreatePostView.editor:
        return _buildEditorView(appColors);
      case CreatePostView.pending:
        return _buildPendingView(appColors);
      case CreatePostView.approved:
        return _buildApprovedView(appColors);
    }
  }

  Widget _buildEditorView(AppColors appColors) {
    final previewChannel = Channel(
      channelId: 'preview',
      channelName:
          _nameController.text.isEmpty ? _tr.createPostYourNamePlaceholder : _nameController.text,
      category: _selectedCategory,
      isVerified: false,
    );

    final previewPost = Post(
      postId: 'preview',
      channelId: 'preview',
      bodyText: _bodyController.text.isEmpty
          ? _tr.createPostPreviewBodyPlaceholder
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
          _buildAuditInfoCard(appColors),
          const SizedBox(height: 25),
          _buildSectionTitle(_tr.createPostSenderDetails, appColors),
          const SizedBox(height: 12),
          _buildSignatureDropdown(appColors),
          const SizedBox(height: 12),
          _buildTextField(
            appColors: appColors,
            controller: _nameController,
            hintText: _tr.createPostFullNameHint,
            icon: Icons.person_outline_rounded,
            onChanged: (val) {
              setState(() => _selectedSignatureId = null);
            },
          ),
          const SizedBox(height: 12),
          _buildTextField(
            appColors: appColors,
            controller: _emailController,
            hintText: _tr.createPostEmailHint,
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            onChanged: (val) {
              setState(() => _selectedSignatureId = null);
            },
          ),
          const SizedBox(height: 12),
          _buildSignatureToggle(appColors),
          const SizedBox(height: 25),
          _buildSectionTitle(_tr.createPostPostContent, appColors),
          const SizedBox(height: 12),
          _buildCategorySelector(appColors),
          const SizedBox(height: 12),
          _buildTextField(
            appColors: appColors,
            controller: _bodyController,
            hintText: _tr.createPostContentHint,
            maxLines: 5,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          _buildAttachmentButton(appColors),
          const SizedBox(height: 35),
          _buildSectionTitle(_tr.createPostLivePreview, appColors),
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
          _buildSubmitButton(appColors),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSignatureDropdown(AppColors appColors) {
    final signatures = ref.watch(signatureProvider);
    if (signatures.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: appColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: appColors.borderColor),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedSignatureId,
          dropdownColor: appColors.surface,
          hint: Text(_tr.createPostSelectSignatureHint, 
            style: GoogleFonts.redditSans(fontSize: 14, color: appColors.textSecondary)),
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: appColors.textSecondary),
          items: signatures.map((sig) {
            return DropdownMenuItem<String>(
              value: sig.id,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      sig.name,
                      style: GoogleFonts.redditSans(fontSize: 14, color: appColors.textPrimary),
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Icon(Icons.delete_outline_rounded, size: 18, color: appColors.danger),
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

  Widget _buildPendingView(AppColors appColors) {
    final pendingRequests = ref.watch(pendingRequestsProvider);

    if (pendingRequests.isEmpty) {
      return _buildEmptyState(_tr.createPostPendingEmptyTitle,
          _tr.createPostPendingEmptyDesc, appColors);
    }

    return ListView.separated(
      padding: const EdgeInsets.all(25),
      itemCount: pendingRequests.length,
      separatorBuilder: (context, index) => const SizedBox(height: 15),
      itemBuilder: (context, index) {
        final req = pendingRequests[index];
        return _buildRequestTile(req, Icons.access_time_rounded, appColors.warning, appColors);
      },
    );
  }

  Widget _buildApprovedView(AppColors appColors) {
    final approvedRequests = ref.watch(approvedRequestsProvider);

    if (approvedRequests.isEmpty) {
      return _buildEmptyState(_tr.createPostSharedEmptyTitle, _tr.createPostSharedEmptyDesc, appColors);
    }

    return ListView.separated(
      padding: const EdgeInsets.all(25),
      itemCount: approvedRequests.length,
      separatorBuilder: (context, index) => const SizedBox(height: 15),
      itemBuilder: (context, index) {
        final req = approvedRequests[index];
        return _buildRequestTile(req, Icons.check_circle_outline_rounded, appColors.success, appColors);
      },
    );
  }

  Widget _buildRequestTile(PostRequest req, IconData icon, Color color, AppColors appColors) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: appColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: appColors.borderColor),
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
                    color: appColors.textPrimary,
                  ),
                ),
              ),
              Text(
                _timeAgo(req.createdAt),
                style: GoogleFonts.redditSans(
                  fontSize: 11,
                  color: appColors.textSecondary,
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
              color: appColors.textPrimary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String title, String message, AppColors appColors) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.post_add_rounded, size: 64, color: appColors.textMuted),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.redditSans(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: appColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.redditSans(
                fontSize: 13,
                color: appColors.textSecondary,
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
                    color: appColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _tr.createPostGoToEditor,
                    style: GoogleFonts.redditSans(fontWeight: FontWeight.w600, color: appColors.textInverse),
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
    if (diff.inDays > 0) return _tr.createPostDaysAgo(diff.inDays);
    if (diff.inHours > 0) return _tr.createPostHoursAgo(diff.inHours);
    if (diff.inMinutes > 0) return _tr.createPostMinsAgo(diff.inMinutes);
    return _tr.createPostJustNow;
  }

  Widget _buildAuditInfoCard(AppColors appColors) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: appColors.primaryContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: appColors.primary.withValues(alpha: 0.1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded,
              color: appColors.primary, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _tr.createPostAuditInfoTitle,
                  style: GoogleFonts.redditSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: appColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _tr.createPostAuditInfoDesc,
                  style: GoogleFonts.redditSans(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: appColors.textPrimary,
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

  Widget _buildSectionTitle(String title, AppColors appColors) {
    return Text(
      title,
      style: GoogleFonts.redditSans(
        fontWeight: FontWeight.w800,
        fontSize: 11,
        color: appColors.textSecondary,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildTextField({
    required AppColors appColors,
    required TextEditingController controller,
    required String hintText,
    IconData? icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    ValueChanged<String>? onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: appColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: appColors.borderColor),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        onChanged: onChanged,
        style:
            GoogleFonts.redditSans(fontSize: 14, color: appColors.textPrimary),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.redditSans(
              color: appColors.textSecondary, fontSize: 14),
          prefixIcon: icon != null
              ? Icon(icon, color: appColors.textSecondary, size: 20)
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }

  Widget _buildCategorySelector(AppColors appColors) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: appColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: appColors.borderColor),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<ChannelCategory>(
          value: _selectedCategory,
          dropdownColor: appColors.surface,
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down_rounded,
              color: appColors.textSecondary),
          items: ChannelCategory.values.map((cat) {
            return DropdownMenuItem(
              value: cat,
              child: Text(
                _getCategoryLabel(cat),
                style: GoogleFonts.redditSans(
                    fontSize: 14, color: appColors.textPrimary),
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

  Widget _buildAttachmentButton(AppColors appColors) {
    return GestureDetector(
      onTap: () {
      AppToast.show(context, _tr.createPostAttachmentNotImpl);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: appColors.primaryContainer,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: appColors.primary.withValues(alpha: 0.2),
              style: BorderStyle.solid),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image_outlined, color: appColors.primary, size: 20),
            const SizedBox(width: 10),
            Text(
              _tr.createPostAddAttachment,
              style: GoogleFonts.redditSans(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: appColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton(AppColors appColors) {
    return GestureDetector(
      onTap: _submitRequest,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: appColors.primary,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: appColors.primary.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            _tr.createPostSubmitBtn,
            style: GoogleFonts.redditSans(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: appColors.textInverse,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignatureToggle(AppColors appColors) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: appColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: appColors.borderColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.history_edu_rounded,
                  color: appColors.textSecondary, size: 20),
              const SizedBox(width: 12),
              Text(
                _tr.createPostSaveSignature,
                style: GoogleFonts.redditSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: appColors.textPrimary,
                ),
              ),
            ],
          ),
          Switch(
            value: _saveAsSignature,
            activeThumbColor: appColors.primary,
            onChanged: (val) => setState(() => _saveAsSignature = val),
          ),
        ],
      ),
    );
  }

  String _getCategoryLabel(ChannelCategory category) {
    switch (category) {
      case ChannelCategory.official:
        return _tr.createPostCatOfficial;
      case ChannelCategory.clubs:
        return _tr.createPostCatClub;
      case ChannelCategory.devTeam:
        return _tr.createPostCatDev;
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
