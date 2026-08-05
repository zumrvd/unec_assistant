import 'package:flutter/material.dart';
import '../buttons/contact_tile.dart';
import '../../../models/about_app_info.dart';

class ContactUsRow extends StatelessWidget {
  final List<ContactMethod> items;

  const ContactUsRow({
    required this.items,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (int i = 0; i < items.length; i++) ...[
          Expanded(child: ContactTile(data: items[i])),
          if (i < items.length - 1) const SizedBox(width: 10),
        ],
      ],
    );
  }
}
