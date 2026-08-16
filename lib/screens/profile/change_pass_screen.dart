import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
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
    final password = _newPasswordController.text;
    final securityState = ref.read(userSecurityProvider);

    switch (requirement) {
      case '8-32 characters long':
        return password.length >= 8 && password.length <= 32;
      case 'One uppercase letter (A-Z)':
        return RegExp(r'[A-Z]').hasMatch(password);
      case 'One lowercase letter (a-z)':
        return RegExp(r'[a-z]').hasMatch(password);
      case 'One number':
        return RegExp(r'[0-9]').hasMatch(password);
      case 'One special character (!@#\$...)':
        return RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(password);
      case 'Different from last 3 passwords':
        return !securityState.passwordHistory.contains(password);
      default:
        return false;
    }
  }

  void _handleUpdate() async {
    setState(() => _isLoading = true);

    if (_newPasswordController.text != _confirmPasswordController.text) {
      AppToast.show(
        context,
        'Passwords do not match',
        textColor: const Color(0xFF993C1D),
      );
    }

    final error = await ref
        .read(userSecurityProvider.notifier)
        .changePassword(
          _currentPasswordController.text,
          _newPasswordController.text,
        );

    if (mounted) {
      setState(() => _isLoading = false);
      if (error != null) {
        AppToast.show(context, error, textColor: const Color(0xFF993C1D));
        if (error.contains('cooldown') || error.contains('blocked')) {
          _startCooldownTimer();
        }
      } else {
        AppToast.show(
          context,
          'Password updated successfully',
          textColor: const Color(0xFF0F6E56),
        );
        _startCooldownTimer();
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) context.pop();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
      backgroundColor: const Color(0xFFF8F9FC),
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
                  color: const Color(0x260569FF),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.shield_moon,
                  color: Color(0xFF0569FF),
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
                color: const Color(0xFF1E1E1E),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'This password does not affect your\nUnec Kabinet Password',
              textAlign: TextAlign.center,
              style: GoogleFonts.redditSans(
                fontWeight: FontWeight.w500,
                fontSize: 13,
                color: const Color(0xFFB0B3B8),
              ),
            ),
            const SizedBox(height: 30),

            // Input Fields Card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE0E4F0)),
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
                  ),
                  const Divider(height: 1, color: Color(0xFFE0E4F0)),
                  _buildPasswordField(
                    label: 'New password',
                    controller: _newPasswordController,
                    isObscured: _isNewObscured,
                    icon: Icons.shield_moon_outlined,
                    onToggle: () =>
                        setState(() => _isNewObscured = !_isNewObscured),
                    onChanged: (_) => setState(() {}),
                  ),
                  const Divider(height: 1, color: Color(0xFFE0E4F0)),
                  _buildPasswordField(
                    label: 'Confirm password',
                    controller: _confirmPasswordController,
                    isObscured: _isConfirmObscured,
                    icon: Icons.sync_rounded,
                    onToggle: () => setState(
                      () => _isConfirmObscured = !_isConfirmObscured,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Requirements Card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE0E4F0)),
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
                        color: const Color(0xFF1E1E1E),
                      ),
                    ),
                  ),
                  const Divider(height: 1, color: Color(0xFFE0E4F0)),
                  _buildRequirementItem('8-32 characters long'),
                  _buildRequirementItem('One uppercase letter (A-Z)'),
                  _buildRequirementItem('One lowercase letter (a-z)'),
                  _buildRequirementItem('One number'),
                  _buildRequirementItem('One special character (!@#\$...)'),
                  _buildRequirementItem('Different from last 3 passwords'),
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
                    color: const Color(0xFF993C1D).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color(0xFF993C1D).withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.timer_outlined,
                        color: Color(0xFF993C1D),
                        size: 18,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _cooldownText,
                          style: GoogleFonts.redditSans(
                            color: const Color(0xFF993C1D),
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
                        ? const Color(0xFF0569FF)
                        : const Color(0xFFB0B3B8).withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  alignment: Alignment.center,
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.history_rounded,
                              size: 20,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Update password',
                              style: GoogleFonts.redditSans(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: Colors.white,
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
                    color: const Color(0xFF0569FF),
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
                    color: const Color(0xFF0569FF),
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
              color: const Color(0xFF838A97),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0x1A0569FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: const Color(0xFF0569FF), size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: controller,
                  obscureText: isObscured,
                  onChanged: onChanged,
                  decoration: InputDecoration(
                    hintText: 'Enter password',
                    hintStyle: GoogleFonts.redditSans(
                      color: const Color(0xFFB0B3B8),
                      fontSize: 15,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE0E4F0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE0E4F0)),
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
                          color: const Color(0xFF838A97),
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

  Widget _buildRequirementItem(String text) {
    final isMet = _meetsRequirement(text);
    final hasText = _newPasswordController.text.isNotEmpty;

    Color iconColor;
    IconData iconData;

    if (!hasText) {
      iconColor = const Color(0xFFB0B3B8);
      iconData = Icons.radio_button_unchecked;
    } else if (isMet) {
      iconColor = const Color(0xFF0F6E56);
      iconData = Icons.check_circle_rounded;
    } else {
      iconColor = const Color(0xFF993C1D);
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
                  ? (isMet ? const Color(0xFF1E1E1E) : const Color(0xFF993C1D))
                  : const Color(0xFF838A97),
            ),
          ),
        ],
      ),
    );
  }
}
