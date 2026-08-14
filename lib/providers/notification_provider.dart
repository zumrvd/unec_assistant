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
      title: 'YAZ semestri ara imtahan cədvəli',
      message: '2025/2026-ci tədris ilinin YAZ semestri üçün ara imtahan cədvəli açıqlanmışdır.',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: false,
      type: NotificationType.academic,
    ),
    AppNotification(
      id: '2',
      title: 'New Post in Rektorat Kanalı',
      message: 'Professor Məmmədov yeni bir elan paylaşdı.',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      isRead: true,
      type: NotificationType.feed,
    ),
    AppNotification(
      id: '3',
      title: 'Attendance Warning',
      message: 'You have missed 2 classes of "Programming I".',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isRead: false,
      type: NotificationType.alert,
    ),
    AppNotification(
      id: '4',
      title: 'App Update Available',
      message: 'Version 1.1.2 is now available with new features.',
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
