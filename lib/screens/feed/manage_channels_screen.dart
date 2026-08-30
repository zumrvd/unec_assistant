import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../presentation/components/lists/labels.dart';
import 'package:unec_assistant/providers/locale_provider.dart';
import 'package:unec_assistant/providers/theme_provider.dart';
import '../../../providers/subscriptions_provider.dart';

class ManageChannelsScreen extends ConsumerWidget {
  const ManageChannelsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final channels = ref.watch(subscriptionsProvider);
    final appColors = ref.watch(appColorsProvider);
    final tr = ref.watch(strProvider);

    if (channels.isEmpty) {
      return Scaffold(
        backgroundColor: appColors.background,
        appBar: CustomAppBar(title: tr.channelsTitle),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: appColors.primaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.notifications_off_outlined,
                  size: 36,
                  color: appColors.primary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                tr.channelsNoSubs,
                style: GoogleFonts.redditSans(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: appColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                tr.channelsSubscribeHint,
                textAlign: TextAlign.center,
                style: GoogleFonts.redditSans(
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                  color: appColors.textMuted,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: appColors.background,
      appBar: CustomAppBar(title: tr.channelsTitle),
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
                color: appColors.cardBackground,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: appColors.borderColor),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: appColors.primaryContainer,
                    child: Text(
                      channel.channelName.substring(0, 1),
                      style: GoogleFonts.redditSans(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        color: appColors.primary,
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
                            color: appColors.textPrimary,
                          ),
                        ),
                        Text(
                          channel.category.name.toUpperCase(),
                          style: GoogleFonts.redditSans(
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                            color: appColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.notifications_rounded,
                    color: appColors.primary,
                    size: 22,
                  ),
                  const SizedBox(width: 15),
                  GestureDetector(
                    onTap: () => ref
                        .read(subscriptionsProvider.notifier)
                        .toggleSubscription(channel.channelId, false),
                    behavior: HitTestBehavior.opaque,
                    child: Text(
                      tr.channelsUnsubscribe,
                      style: GoogleFonts.redditSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                        color: appColors.danger,
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
