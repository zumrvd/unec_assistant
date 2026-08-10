class ChannelSubscription {
  final String channelId;
  final bool isSubscribed;
  final bool notificationsEnabled;

  const ChannelSubscription({
    required this.channelId,
    required this.isSubscribed,
    required this.notificationsEnabled,
  });

  ChannelSubscription copyWith({
    bool? isSubscribed,
    bool? notificationsEnabled,
  }) {
    return ChannelSubscription(
      channelId: channelId,
      isSubscribed: isSubscribed ?? this.isSubscribed,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }
}
