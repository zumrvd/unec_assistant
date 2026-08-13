import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/channel.dart';
import 'feed_provider.dart';

class SubscriptionsNotifier extends Notifier<List<Channel>> {
  @override
  List<Channel> build() {
    Future.microtask(() => _loadSubscriptions());
    return [];
  }

  Future<void> _loadSubscriptions() async {
    final repo = ref.read(feedRepositoryProvider);
    try {
      final channels = await repo.fetchSubscribedChannels();
      state = channels;
    } catch (e) {
      // Handle error
    }
  }

  Future<void> toggleSubscription(String channelId, bool isSubscribed) async {
    final repo = ref.read(feedRepositoryProvider);
    try {
      await repo.setSubscription(channelId, isSubscribed: isSubscribed);
      await _loadSubscriptions();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> toggleNotifications(String channelId, bool enabled) async {
    final repo = ref.read(feedRepositoryProvider);
    try {
      await repo.setNotifications(channelId, enabled: enabled);
      // In a real app we might update the local state of a subscription model
    } catch (e) {
      // Handle error
    }
  }
}

final subscriptionsProvider = NotifierProvider<SubscriptionsNotifier, List<Channel>>(SubscriptionsNotifier.new);
