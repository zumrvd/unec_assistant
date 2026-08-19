import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unec_assistant/providers/theme_provider.dart';

class NotesAddButton extends ConsumerWidget {
  final VoidCallback onTap;

  const NotesAddButton({required this.onTap, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColors = ref.watch(appColorsProvider);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: appColors.primary,
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
