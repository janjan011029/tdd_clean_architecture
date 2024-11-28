import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_clean_architecture/features/authentication/domain/entities/user.dart';
import 'package:tdd_clean_architecture/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:tdd_clean_architecture/features/authentication/domain/usecases/get_users.dart';

import 'authentication_repository.mock.dart';

void main() {
  late AuthenticationRepository repository;
  late GetUsers usecase;

  setUp(() {
    repository = MockAuthRepo();
    usecase = GetUsers(repository);
  });

  final testResponse = [User.empty()];

  test('should call [AuthRepo.getUsers] and return [List<User>]', () async {
    //Arrange
    when(() => repository.getUsers()).thenAnswer(
      (_) async => Right(testResponse),
    );

    //Act
    final result = await usecase();

    expect(result, equals(Right<dynamic,List<User>>(testResponse)));

    verify(() => repository.getUsers()).called(1);

    verifyNoMoreInteractions(repository);
  });
}
