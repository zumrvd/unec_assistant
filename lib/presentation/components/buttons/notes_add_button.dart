import 'package:flutter/material.dart';

class NotesAddButton extends StatelessWidget {
  final VoidCallback onTap;

  const NotesAddButton({
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: const BoxDecoration(
          color: Color(0xFF0569FF),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.add_rounded,
          size: 26,
          color: Color(0xFFFFFFFF),
        ),
      ),
    );
  }
}
