import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:unec_assistant/providers/theme_provider.dart';
import 'package:unec_assistant/presentation/theme/app_colors.dart';
import 'package:unec_assistant/providers/user_security_provider.dart';
import 'package:unec_assistant/presentation/components/lists/labels.dart';
import 'package:unec_assistant/utils/app_toast.dart';

class ChangePassScreen extends ConsumerStatefulWidget {
  const ChangePassScreen({super.key});

  @override
  ConsumerState<ChangePassScreen> createState() => _ChangePassScreenState();
}

class _ChangePassScreenState extends ConsumerState<ChangePassScreen> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isCurrentObscured = true;
  bool _isNewObscured = true;
  bool _isConfirmObscured = true;
  bool _isLoading = false;
  Timer? _cooldownTimer;
  String _cooldownText = '';

  @override
  void initState() {
    super.initState();
    _startCooldownTimer();
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _cooldownTimer?.cancel();
    super.dispose();
  }

  void _startCooldownTimer() {
    _cooldownTimer?.cancel();
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final securityState = ref.read(userSecurityProvider);
      if (securityState.isBlocked) {
        final remaining = securityState.blockUntil!.difference(DateTime.now());
        if (remaining.isNegative) {
          setState(() => _cooldownText = '');
          timer.cancel();
        } else {
          final minutes = remaining.inMinutes;
          final seconds = remaining.inSeconds % 60;
          setState(() {
            _cooldownText =
                'Security cooldown: $minutes:${seconds.toString().padLeft(2, '0')} remaining';
          });
        }
      } else {
        if (_cooldownText.isNotEmpty) {
          setState(() => _cooldownText = '');
        }
        timer.cancel();
      }
    });
  }

  bool _meetsRequirement(String requirement) {
    final text = _newPasswordController.text;
    switch (requirement) {
      case '8-32 characters long':
        return text.length >= 8 && text.length <= 32;
      case 'One uppercase letter (A-Z)':
        return text.contains(RegExp(r'[A-Z]'));
      case 'One lowercase letter (a-z)':
        return text.contains(RegExp(r'[a-z]'));
      case 'One number':
        return text.contains(RegExp(r'[0-9]'));
      case 'One special character (!@#\$...)':
        return text.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'));
      case 'Different from last 3 passwords':
        final security = ref.read(userSecurityProvider);
        return !security.isPasswordInHistory(text);
      default:
        return false;
    }
  }

  Future<void> _handleUpdate() async {
    if (_newPasswordController.text != _confirmPasswordController.text) {
      AppToast.show(context, 'Passwords do not match');
      return;
    }

    setState(() => _isLoading = true);

    final success = await ref
        .read(userSecurityProvider.notifier)
        .changePassword(
          currentPassword: _currentPasswordController.text,
          newPassword: _newPasswordController.text,
        );

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (success) {
      AppToast.show(context, 'Password changed successfully!');
      context.pop();
    } else {
      final security = ref.read(userSecurityProvider);
      if (security.isBlocked) {
        AppToast.show(context, 'Account temporarily locked. Try again later.');
        _startCooldownTimer();
      } else {
        AppToast.show(
          context,
          'Incorrect current password. ${security.remainingAttempts} attempts remaining.',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appColors = ref.watch(appColorsProvider);
    final securityState = ref.watch(userSecurityProvider);
    final allRequirementsMet = [
      '8-32 characters long',
      'One uppercase letter (A-Z)',
      'One lowercase letter (a-z)',
      'One number',
      'One special character (!@#\$...)',
      'Different from last 3 passwords',
    ].every(_meetsRequirement);

    return Scaffold(
      backgroundColor: appColors.background,
      appBar: CustomAppBar(
        title: 'Change Password',
        onBackTap: () => context.pop(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
        child: Column(
          children: [
            Center(
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: appColors.primaryContainer,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  Icons.shield_moon,
                  color: appColors.primary,
                  size: 30,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Set a new password',
              style: GoogleFonts.redditSans(
                fontWeight: FontWeight.w800,
                fontSize: 20,
                color: appColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'This password does not affect your\nUnec Kabinet Password',
              textAlign: TextAlign.center,
              style: GoogleFonts.redditSans(
                fontWeight: FontWeight.w500,
                fontSize: 13,
                color: appColors.textSecondary,
              ),
            ),
            const SizedBox(height: 30),

            // Input Fields Card
            Container(
              decoration: BoxDecoration(
                color: appColors.cardBackground,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: appColors.borderColor),
              ),
              child: Column(
                children: [
                  _buildPasswordField(
                    label: 'Current password',
                    controller: _currentPasswordController,
                    isObscured: _isCurrentObscured,
                    icon: Icons.lock_outline_rounded,
                    onToggle: () => setState(
                      () => _isCurrentObscured = !_isCurrentObscured,
                    ),
                    appColors: appColors,
                  ),
                  Divider(height: 1, color: appColors.divider),
                  _buildPasswordField(
                    label: 'New password',
                    controller: _newPasswordController,
                    isObscured: _isNewObscured,
                    icon: Icons.shield_moon_outlined,
                    onToggle: () =>
                        setState(() => _isNewObscured = !_isNewObscured),
                    onChanged: (_) => setState(() {}),
                    appColors: appColors,
                  ),
                  Divider(height: 1, color: appColors.divider),
                  _buildPasswordField(
                    label: 'Confirm password',
                    controller: _confirmPasswordController,
                    isObscured: _isConfirmObscured,
                    icon: Icons.sync_rounded,
                    onToggle: () => setState(
                      () => _isConfirmObscured = !_isConfirmObscured,
                    ),
                    appColors: appColors,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Requirements Card
            Container(
              decoration: BoxDecoration(
                color: appColors.cardBackground,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: appColors.borderColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Password requirements',
                      style: GoogleFonts.redditSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: appColors.textPrimary,
                      ),
                    ),
                  ),
                  Divider(height: 1, color: appColors.divider),
                  _buildRequirementItem('8-32 characters long', appColors),
                  _buildRequirementItem(
                    'One uppercase letter (A-Z)',
                    appColors,
                  ),
                  _buildRequirementItem(
                    'One lowercase letter (a-z)',
                    appColors,
                  ),
                  _buildRequirementItem('One number', appColors),
                  _buildRequirementItem(
                    'One special character (!@#\$...)',
                    appColors,
                  ),
                  _buildRequirementItem(
                    'Different from last 3 passwords',
                    appColors,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            if (_cooldownText.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: appColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: appColors.error.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.timer_outlined,
                        color: appColors.error,
                        size: 18,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _cooldownText,
                          style: GoogleFonts.redditSans(
                            color: appColors.error,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: GestureDetector(
                onTap:
                    (allRequirementsMet &&
                        !_isLoading &&
                        !securityState.isBlocked)
                    ? _handleUpdate
                    : null,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  decoration: BoxDecoration(
                    color:
                        (allRequirementsMet &&
                            !_isLoading &&
                            !securityState.isBlocked)
                        ? appColors.primary
                        : appColors.buttonDisabledBg,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  alignment: Alignment.center,
                  child: _isLoading
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: appColors.pillSelectedText,
                            strokeWidth: 2,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.history_rounded,
                              size: 20,
                              color: appColors.pillSelectedText,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Update password',
                              style: GoogleFonts.redditSans(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: appColors.pillSelectedText,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            GestureDetector(
              onTap: () {},
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Forgot current password?',
                  style: GoogleFonts.redditSans(
                    color: appColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {},
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Having troubles with your Unec Kabinet password?',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.redditSans(
                    color: appColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool isObscured,
    required IconData icon,
    required VoidCallback onToggle,
    required AppColors appColors,
    ValueChanged<String>? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.redditSans(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: appColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: appColors.primaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: appColors.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: controller,
                  obscureText: isObscured,
                  onChanged: onChanged,
                  style: GoogleFonts.redditSans(
                    color: appColors.textPrimary,
                    fontSize: 15,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter password',
                    hintStyle: GoogleFonts.redditSans(
                      color: appColors.textMuted,
                      fontSize: 15,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: appColors.borderColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: appColors.borderColor),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    isDense: true,
                    suffixIcon: GestureDetector(
                      onTap: onToggle,
                      behavior: HitTestBehavior.opaque,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Icon(
                          isObscured
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 20,
                          color: appColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRequirementItem(String text, AppColors appColors) {
    final isMet = _meetsRequirement(text);
    final hasText = _newPasswordController.text.isNotEmpty;

    Color iconColor;
    IconData iconData;

    if (!hasText) {
      iconColor = appColors.textMuted;
      iconData = Icons.radio_button_unchecked;
    } else if (isMet) {
      iconColor = appColors.success;
      iconData = Icons.check_circle_rounded;
    } else {
      iconColor = appColors.error;
      iconData = Icons.cancel_rounded;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Icon(iconData, color: iconColor, size: 20),
          const SizedBox(width: 12),
          Text(
            text,
            style: GoogleFonts.redditSans(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: hasText
                  ? (isMet ? appColors.textPrimary : appColors.error)
                  : appColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
