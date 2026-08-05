import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/about_app_info.dart';
import '../dialogs/contact_redirect_dialog.dart';

class ContactTile extends StatefulWidget {
  final ContactMethod data;

  const ContactTile({
    required this.data,
    super.key,
  });

  @override
  State<ContactTile> createState() => _ContactTileState();
}

class _ContactTileState extends State<ContactTile> {
  bool _isActive = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isActive = true),
      onExit: (_) => setState(() => _isActive = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isActive = true),
        onTapCancel: () => setState(() => _isActive = false),
        onTapUp: (_) => setState(() => _isActive = false),
        onTap: () {
          setState(() => _isActive = false);
          showContactRedirectDialog(context, widget.data);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: 72,
          decoration: BoxDecoration(
            color: const Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _isActive ? widget.data.brandColor : const Color(0xFFE0E4F0),
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                widget.data.iconAsset,
                width: 20,
                height: 20,
                placeholderBuilder: (context) => Icon(
                  Icons.circle_outlined,
                  size: 20,
                  color: widget.data.brandColor,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                widget.data.label,
                style: GoogleFonts.redditSans(
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                  color: _isActive ? widget.data.brandColor : const Color(0xFF1F1F1F),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
