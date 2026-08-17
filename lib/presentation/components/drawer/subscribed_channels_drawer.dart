import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unec_assistant/presentation/providers/theme_provider.dart';
import '../../../providers/subscriptions_provider.dart';

class SubscribedChannelsDrawer extends ConsumerWidget {
  const SubscribedChannelsDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final channels = ref.watch(subscriptionsProvider);
    final appColors = ref.watch(appColorsProvider);

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.75,
      backgroundColor: appColors.background,
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
                  color: appColors.textPrimary,
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
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: appColors.primaryContainer,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              channel.channelName.substring(0, 1).toUpperCase(),
                              style: GoogleFonts.redditSans(
                                  fontWeight: FontWeight.bold,
                                  color: appColors.primary),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              channel.channelName,
                              style: GoogleFonts.redditSans(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: appColors.textPrimary,
                              ),
                            ),
                          ),
                          Icon(Icons.chevron_right_rounded,
                              size: 18, color: appColors.textSecondary),
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
                behavior: HitTestBehavior.opaque,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: appColors.cardBackground,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: appColors.borderColor),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Manage Subscribed Channels',
                    style: GoogleFonts.redditSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: appColors.primary,
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

