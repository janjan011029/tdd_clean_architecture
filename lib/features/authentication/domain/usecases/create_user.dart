// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:tdd_clean_architecture/core/usecase/usecase.dart';
import 'package:tdd_clean_architecture/core/utils/typedef.dart';
import 'package:tdd_clean_architecture/features/authentication/domain/repositories/authentication_repository.dart';

class CreateUser extends UsecaseWithParams<void, CreateUserParams> {
  const CreateUser(this._repository);

  final AuthenticationRepository _repository;

  @override
  ResultVoid call(CreateUserParams params) async {
    return _repository.createUser(
      createdAt: params.createdAt,
      name: params.name,
      avatar: params.avatar,
    );
  }
}

class CreateUserParams extends Equatable {
  const CreateUserParams({
    required this.createdAt,
    required this.name,
    required this.avatar,
  });

  final String createdAt;
  final String name;
  final String avatar;

  factory CreateUserParams.empty() => const CreateUserParams(
        createdAt: '_empty.createdAt',
        name: '_empty.name',
        avatar: '_empty.avatar',
      );

  @override
  List<Object?> get props => [createdAt, name, avatar];
}
