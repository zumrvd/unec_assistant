enum ChannelCategory { official, clubs, devTeam }

class Channel {
  final String channelId;
  final String channelName;
  final String? avatarUrl;
  final ChannelCategory category;
  final bool isVerified;

  const Channel({
    required this.channelId,
    required this.channelName,
    this.avatarUrl,
    required this.category,
    this.isVerified = false,
  });
}
