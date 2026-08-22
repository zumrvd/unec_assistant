import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/app_notification.dart';

class NotificationsEnabledNotifier extends Notifier<bool> {
  @override
  bool build() => true;

  void toggle(bool value) {
    state = value;
  }
}

final notificationsEnabledProvider = NotifierProvider<NotificationsEnabledNotifier, bool>(
  NotificationsEnabledNotifier.new,
);

class NotificationListNotifier extends Notifier<List<AppNotification>> {
  @override
  List<AppNotification> build() => _initialMockData;

  static final List<AppNotification> _initialMockData = [
    AppNotification(
      id: '1',
      title: 'ACADEMIC_MIDTERM_SCHEDULE',
      message: 'ACADEMIC_MIDTERM_BODY',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: false,
      type: NotificationType.academic,
    ),
    AppNotification(
      id: '2',
      title: 'FEED_NEW_POST_RECTORATE',
      message: 'FEED_NEW_POST_BODY',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      isRead: true,
      type: NotificationType.feed,
    ),
    AppNotification(
      id: '3',
      title: 'ALERT_ATTENDANCE_WARNING',
      message: 'ALERT_ATTENDANCE_BODY',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isRead: false,
      type: NotificationType.alert,
    ),
    AppNotification(
      id: '4',
      title: 'INFO_APP_UPDATE',
      message: 'INFO_APP_UPDATE_BODY',
      timestamp: DateTime.now().subtract(const Duration(days: 3)),
      isRead: true,
      type: NotificationType.info,
    ),
  ];

  void markAsRead(String id) {
    state = [
      for (final n in state)
        if (n.id == id) n.copyWith(isRead: true) else n
    ];
  }

  void markAllAsRead() {
    state = [for (final n in state) n.copyWith(isRead: true)];
  }

  void deleteNotification(String id) {
    state = state.where((n) => n.id != id).toList();
  }
}

final notificationListProvider = NotifierProvider<NotificationListNotifier, List<AppNotification>>(
  NotificationListNotifier.new,
);

final unreadNotificationsCountProvider = Provider<int>((ref) {
  final notifications = ref.watch(notificationListProvider);
  return notifications.where((n) => !n.isRead).length;
});
