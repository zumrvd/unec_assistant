import 'channel.dart';

class UserSignature {
  final String id;
  final String name;
  final String email;
  final ChannelCategory preferredCategory;

  const UserSignature({
    required this.id,
    required this.name,
    required this.email,
    required this.preferredCategory,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'preferredCategory': preferredCategory.index,
    };
  }

  factory UserSignature.fromJson(Map<String, dynamic> json) {
    return UserSignature(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      preferredCategory: ChannelCategory.values[json['preferredCategory'] as int],
    );
  }

  UserSignature copyWith({
    String? id,
    String? name,
    String? email,
    ChannelCategory? preferredCategory,
  }) {
    return UserSignature(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      preferredCategory: preferredCategory ?? this.preferredCategory,
    );
  }
}
