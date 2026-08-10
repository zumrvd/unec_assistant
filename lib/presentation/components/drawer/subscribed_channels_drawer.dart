import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../providers/subscriptions_provider.dart';

class SubscribedChannelsDrawer extends ConsumerWidget {
  const SubscribedChannelsDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final channels = ref.watch(subscriptionsProvider);

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.75,
      backgroundColor: const Color(0xFFF8F9FC),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Subscribed',
                style: GoogleFonts.redditSans(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: const Color(0xFF1F1F1F),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemCount: channels.length,
                itemBuilder: (context, index) {
                  final channel = channels[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      context.push('/feed/manage-channels');
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFE8F0FE),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              channel.channelName.substring(0, 1).toUpperCase(),
                              style: GoogleFonts.redditSans(
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF0569FF)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              channel.channelName,
                              style: GoogleFonts.redditSans(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: const Color(0xFF1F1F1F),
                              ),
                            ),
                          ),
                          const Icon(Icons.chevron_right_rounded,
                              size: 18, color: Color(0xFF838A97)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  context.push('/feed/manage-channels');
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE0E4F0)),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Manage Subscribed Channels',
                    style: GoogleFonts.redditSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: const Color(0xFF0569FF),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
