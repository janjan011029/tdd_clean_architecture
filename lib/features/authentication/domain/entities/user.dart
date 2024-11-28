import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    required this.id,
    required this.createdAt,
    required this.name,
    required this.avatar,
  });

  final String id;
  final String createdAt;
  final String name;
  final String avatar;

  factory User.empty() => const User(
        id: '-1',
        createdAt: '_empty.createdAt',
        name: '_empty.name',
        avatar: '_empty.avatar',
      );

  @override
  List<Object?> get props => [id,name,avatar];
}
