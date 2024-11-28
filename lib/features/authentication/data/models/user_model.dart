import 'dart:convert';

import 'package:tdd_clean_architecture/core/utils/typedef.dart';
import 'package:tdd_clean_architecture/features/authentication/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.avatar,
    required super.createdAt,
    required super.name,
  });

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(jsonDecode(source) as DataMap);

  UserModel.fromMap(DataMap map)
      : this(
          id: map['id'] as String,
          avatar: map['avatar'] as String,
          createdAt: map['createdAt'] as String,
          name: map['name'] as String,
        );

  UserModel? copyWith({
    String? id,
    String? avatar,
    String? createdAt,
    String? name,
  }) {
    return UserModel(
      id: id ?? this.id,
      avatar: avatar ?? this.avatar,
      createdAt: createdAt ?? this.createdAt,
      name: name ?? this.name,
    );
  }

  DataMap toMap() => {
        'id': id,
        'avatar': avatar,
        'createdAt': createdAt,
        'name': name,
      };

  String toJson() => jsonEncode(toMap());

  factory UserModel.empty() {
    return const UserModel(
      id: '1',
      createdAt: '_empty.createdAt',
      name: '_empty.name',
      avatar: '_empty.avatar',
    );
  }
}
