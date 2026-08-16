import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../presentation/components/lists/labels.dart';
import '../../../providers/subscriptions_provider.dart';

class ManageChannelsScreen extends ConsumerWidget {
  const ManageChannelsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final channels = ref.watch(subscriptionsProvider);

    if (channels.isEmpty) {
      return Scaffold(
        backgroundColor: const Color(0xFFF8F9FC),
        appBar: const CustomAppBar(title: 'Manage Subscribed Channels'),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF4FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.notifications_off_outlined, size: 36, color: Color(0xFF0569FF)),
              ),
              const SizedBox(height: 16),
              Text(
                'No subscriptions yet',
                style: GoogleFonts.redditSans(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: const Color(0xFF1F1F1F),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Subscribe to channels from the Feed\nto see them here.',
                textAlign: TextAlign.center,
                style: GoogleFonts.redditSans(
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                  color: const Color(0xFF838A97),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: const CustomAppBar(title: 'Manage Subscribed Channels'),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        itemCount: channels.length,
        itemBuilder: (context, index) {
          final channel = channels[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE0E4F0)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: const Color(0xFFE8F0FE),
                    child: Text(
                      channel.channelName.substring(0, 1),
                      style: GoogleFonts.redditSans(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        color: const Color(0xFF0569FF),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          channel.channelName,
                          style: GoogleFonts.redditSans(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: const Color(0xFF1F1F1F),
                          ),
                        ),
                        Text(
                          channel.category.name.toUpperCase(),
                          style: GoogleFonts.redditSans(
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                            color: const Color(0xFF838A97),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.notifications_rounded, color: Color(0xFF0569FF), size: 22),
                  const SizedBox(width: 15),
                  GestureDetector(
                    onTap: () => ref.read(subscriptionsProvider.notifier).toggleSubscription(channel.channelId, false),
                    child: Text(
                      'Unsubscribe',
                      style: GoogleFonts.redditSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                        color: const Color(0xFFD54829),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
