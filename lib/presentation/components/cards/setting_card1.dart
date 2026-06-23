import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsCard1 extends StatelessWidget {
  const SettingsCard1({
    required this.onProfileInfoTap,
    required this.onUnecCabinetTap,
    required this.onChangePassTap,
    super.key,
  });

  final VoidCallback onProfileInfoTap;
  final VoidCallback onUnecCabinetTap;
  final VoidCallback onChangePassTap;


  static const _borderColor = Color(0xFFE0E4F0);
  static const _labelGrey = Color(0x80838A97);
  static const _subtitleColor = Color(0x80838A97);


  Widget _iconBox(IconData icon, Color bgColor, Color iconColor) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        icon,
        size: 22,
        color: iconColor,
      ),
    );
  }

  TextStyle _labelStyle() {
    return GoogleFonts.redditSans(
      fontWeight: FontWeight.w700,
      fontSize: 13,
      color: const Color(0xFF000000),
    );
  }

  @override
  Widget build(BuildContext context) {
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
      padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _iconBox(
                    Icons.badge_outlined,
                    const Color(0x260F6E56),
                    const Color(0xFF0F6E56),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Profile İnformations', style: _labelStyle()),
                      const SizedBox(height: 2),
                      Text(
                        'Your full transcript',
                        style: GoogleFonts.redditSans(
                          fontWeight: FontWeight.w400,
                          fontSize: 11,
                          color: _subtitleColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              GestureDetector(
                onTap: onProfileInfoTap,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: const Color(0x26838A97),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.arrow_right_rounded,
                    size: 25,
                    color: _labelGrey,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          const Divider(
            color: _borderColor,
            thickness: 1,
            height: 1,
          ),

          const SizedBox(height: 15),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _iconBox(
                    Icons.add_box,
                    const Color(0x260569FF),
                    const Color(0xFF0569FF),
                  ),

                  const SizedBox(width: 12),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Unec Cabinet', style: _labelStyle()),
                      const SizedBox(height: 2),
                      Text(
                        'Direct link to your cabinet',
                        style: GoogleFonts.redditSans(
                          fontWeight: FontWeight.w400,
                          fontSize: 11,
                          color: _subtitleColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              GestureDetector(
                onTap: onUnecCabinetTap,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: const Color(0x26838A97),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.arrow_outward_rounded,
                    size: 15,
                    color: _labelGrey,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          const Divider(
            color: _borderColor,
            thickness: 1,
            height: 1,
          ),

          const SizedBox(height: 15),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _iconBox(
                    Icons.password_rounded,
                    const Color(0x26993C1D),
                    const Color(0xFF993C1D),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Change Password', style: _labelStyle()),
                      const SizedBox(height: 2),
                      Text(
                        'Resets your password',
                        style: GoogleFonts.redditSans(
                          fontWeight: FontWeight.w400,
                          fontSize: 11,
                          color: _subtitleColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              GestureDetector(
                onTap: onChangePassTap,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: const Color(0x26838A97),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.arrow_right_rounded,
                    size: 25,
                    color: _labelGrey,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
