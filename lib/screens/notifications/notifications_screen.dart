import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:unec_assistant/providers/theme_provider.dart';
import 'package:unec_assistant/providers/locale_provider.dart';
import 'package:unec_assistant/l10n/translations.dart';
import 'package:unec_assistant/presentation/theme/app_colors.dart';
import '../../models/app_notification.dart';
import '../../providers/notification_provider.dart';
import '../../presentation/components/lists/labels.dart';
import 'package:unec_assistant/providers/time_provider.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationListProvider);
    final isEnabled = ref.watch(notificationsEnabledProvider);
    final appColors = ref.watch(appColorsProvider);
    final tr = ref.watch(strProvider);
    final now = ref.watch(nowProvider);

    // Grouping logic
    final Map<String, List<AppNotification>> grouped = {};
    for (var n in notifications) {
      String groupKey = _getGroupKey(n.timestamp, tr, now);
      grouped.putIfAbsent(groupKey, () => []).add(n);
    }

    final sortedKeys = grouped.keys.toList();

    return Scaffold(
      backgroundColor: appColors.background,
      appBar: CustomAppBar(
        title: tr.notifTitle,
        trailing: notifications.any((n) => !n.isRead)
            ? GestureDetector(
                onTap: () =>
                    ref.read(notificationListProvider.notifier).markAllAsRead(),
                behavior: HitTestBehavior.opaque,
                child: SizedBox(
                  width: 75,
                  child: Text(
                    tr.notifMarkAllRead,
                    textAlign: TextAlign.end,
                    maxLines: 2,
                    style: GoogleFonts.redditSans(
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                      color: appColors.primary,
                      height: 1.1,
                    ),
                  ),
                ),
              )
            : null,
      ),
      body: !isEnabled
          ? _buildDisabledState(appColors, tr)
          : notifications.isEmpty
          ? _buildEmptyState(appColors, tr)
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: sortedKeys.length,
              itemBuilder: (context, index) {
                final key = sortedKeys[index];
                final groupNotifications = grouped[key]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 5,
                      ),
                      child: Text(
                        key.toUpperCase(),
                        style: GoogleFonts.redditSans(
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          color: appColors.textSecondary,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),
                    ...groupNotifications.map(
                      (n) => _NotificationTile(notification: n),
                    ),
                  ],
                );
              },
            ),
    );
  }

  String _getGroupKey(DateTime date, AppStrings tr, DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final notificationDate = DateTime(date.year, date.month, date.day);

    if (notificationDate == today) return tr.notifGroupToday;
    if (notificationDate == yesterday) return tr.notifGroupYesterday;
    return tr.localizeDateString(DateFormat('MMM dd').format(date));
  }

  Widget _buildEmptyState(AppColors appColors, AppStrings tr) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none_rounded,
            size: 80,
            color: appColors.borderColor,
          ),
          const SizedBox(height: 16),
          Text(
            tr.notifNoneYet,
            style: GoogleFonts.redditSans(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: appColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisabledState(AppColors appColors, AppStrings tr) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_off_outlined,
              size: 80,
              color: appColors.borderColor,
            ),
            const SizedBox(height: 16),
            Text(
              tr.notifDisabledTitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.redditSans(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: appColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              tr.notifDisabledSub,
              textAlign: TextAlign.center,
              style: GoogleFonts.redditSans(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: appColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationTile extends ConsumerWidget {
  final AppNotification notification;

  const _NotificationTile({required this.notification});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColors = ref.watch(appColorsProvider);
    final tr = ref.watch(strProvider);

    String displayTitle = notification.title;
    String displayMessage = notification.message;

    // Content mapping for mock keys
    switch (notification.title) {
      case 'ACADEMIC_MIDTERM_SCHEDULE':
        displayTitle = tr.notifAcademicTitle;
        displayMessage = tr.notifAcademicBody;
        break;
      case 'FEED_NEW_POST_RECTORATE':
        displayTitle = tr.notifFeedTitle;
        displayMessage = tr.notifFeedBody;
        break;
      case 'ALERT_ATTENDANCE_WARNING':
        displayTitle = tr.notifAttendanceTitle;
        displayMessage = tr.notifAttendanceBody(2, "Programming I");
        break;
      case 'INFO_APP_UPDATE':
        displayTitle = tr.notifUpdateTitle;
        displayMessage = tr.notifUpdateBody("1.1.2");
        break;
    }

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => ref
          .read(notificationListProvider.notifier)
          .deleteNotification(notification.id),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: appColors.error,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white),
      ),
      child: GestureDetector(
        onTap: () => ref
            .read(notificationListProvider.notifier)
            .markAsRead(notification.id),
        behavior: HitTestBehavior.opaque,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: appColors.cardBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: notification.isRead
                  ? appColors.borderColor
                  : appColors.primary.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildIcon(appColors),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            displayTitle,
                            style: GoogleFonts.redditSans(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: appColors.textPrimary,
                            ),
                          ),
                        ),
                        if (!notification.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: appColors.error,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      displayMessage,
                      style: GoogleFonts.redditSans(
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                        color: appColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      DateFormat('HH:mm').format(notification.timestamp),
                      style: GoogleFonts.redditSans(
                        fontWeight: FontWeight.w500,
                        fontSize: 11,
                        color: appColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(AppColors appColors) {
    IconData iconData;
    Color color;

    switch (notification.type) {
      case NotificationType.academic:
        iconData = Icons.school_rounded;
        color = appColors.primary;
        break;
      case NotificationType.feed:
        iconData = Icons.newspaper_rounded;
        color = appColors.success;
        break;
      case NotificationType.alert:
        iconData = Icons.warning_amber_rounded;
        color = appColors.warning;
        break;
      case NotificationType.info:
        iconData = Icons.info_outline_rounded;
        color = appColors.notificationPurple;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        shape: BoxShape.circle,
      ),
      child: Icon(iconData, color: color, size: 18),
    );
  }
}
