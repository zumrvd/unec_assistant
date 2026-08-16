import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePopUp extends StatelessWidget {
  const ProfilePopUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: Alignment.topRight,
      insetPadding: const EdgeInsets.only(top: 80, right: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      backgroundColor: const Color(0xFFF0F4F8),
      // Elevation 0 — no shadow per design rules. Uses border for depth.
      elevation: 0,
      child: Container(
        width: 330,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE0E4F0), width: 1),
          borderRadius: BorderRadius.circular(28),
        ),
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Close and Email Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    'zverdiyevaa9@gmail.com',
                    style: GoogleFonts.redditSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1F1F1F),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: const Color(0x10000000),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: const Icon(Icons.close, size: 18, color: Color(0xFF838A97)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Profile Icon Large
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF0569FF),
              ),
              alignment: Alignment.center,
              child: Text(
                'Z.V',
                style: GoogleFonts.redditSans(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Greeting
            Text(
              'Merhaba Zümrüd!',
              style: GoogleFonts.redditSans(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF1F1F1F),
              ),
            ),
            const SizedBox(height: 16),

            // Manage Account Button (GestureDetector + styled Container)
            GestureDetector(
              onTap: () {},
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFE0E4F0)),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  'Manage your Account',
                  style: GoogleFonts.redditSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF0569FF),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Action List — GestureDetector rows instead of ListTile
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE0E4F0), width: 1),
                ),
                child: Column(
                  children: [
                    _ActionTile(
                      icon: Icons.person_add_alt_1_outlined,
                      label: 'Add another account',
                      onTap: () {},
                    ),
                    const Divider(height: 1, indent: 56),
                    _ActionTile(
                      icon: Icons.logout_rounded,
                      label: 'Sign out',
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _FooterLink(label: 'Privacy Policy'),
                Text(' • ', style: GoogleFonts.redditSans(color: const Color(0xFF838A97))),
                _FooterLink(label: 'Terms of Service'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF1F1F1F), size: 22),
            const SizedBox(width: 18),
            Text(
              label,
              style: GoogleFonts.redditSans(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1F1F1F),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  final String label;
  const _FooterLink({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: GoogleFonts.redditSans(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: const Color(0xFF838A97),
      ),
    );
  }
}
