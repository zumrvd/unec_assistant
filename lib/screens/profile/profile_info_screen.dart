import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:unec_assistant/presentation/components/lists/labels.dart';
import 'package:unec_assistant/providers/current_user_provider.dart';
import 'package:unec_assistant/providers/user_security_provider.dart';
import 'package:intl/intl.dart';

class ProfileInfoScreen extends ConsumerWidget {
  const ProfileInfoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final security = ref.watch(userSecurityProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: CustomAppBar(
        title: 'Profile Information',
        onBackTap: () => context.pop(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionLabel('PERSONAL DETAILS'),
            const SizedBox(height: 12),
            _buildInfoCard([
              _buildInfoRow('Full Name', user.displayName),
              _buildInfoRow('User ID', user.userId),
              _buildInfoRow('Initials', user.initials),
            ]),
            
            const SizedBox(height: 25),
            
            const SectionLabel('SECURITY'),
            const SizedBox(height: 12),
            _buildInfoCard([
              _buildInfoRow('Password', '••••••••'),
              _buildInfoRow(
                'Last Updated', 
                security.lastChangeTimestamp != null 
                    ? DateFormat('dd MMM yyyy, HH:mm').format(security.lastChangeTimestamp!)
                    : 'Never'
              ),
              _buildInfoRow('Status', 'Secure', isSuccess: true),
            ]),
            
            const SizedBox(height: 30),
            
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: () => context.push('/profile/change_pass'),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF0569FF)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  'Change Password',
                  style: GoogleFonts.redditSans(
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0569FF),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE0E4F0)),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isSuccess = false}) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.redditSans(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: const Color(0xFF838A97),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.redditSans(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: isSuccess ? const Color(0xFF0F6E56) : const Color(0xFF1E1E1E),
            ),
          ),
        ],
      ),
    );
  }
}
