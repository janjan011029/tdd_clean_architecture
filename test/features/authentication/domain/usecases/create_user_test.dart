import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_clean_architecture/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:tdd_clean_architecture/features/authentication/domain/usecases/create_user.dart';

import 'authentication_repository.mock.dart';

void main() {
  late CreateUser usecase;
  late AuthenticationRepository repository;

  setUp(() {
    repository = MockAuthRepo();
    usecase = CreateUser(repository);
  });

  final params = CreateUserParams.empty();

  test(
    'should call [AuthRepo.createUser] with correct parameters and no other interactions',
    () async {
      // Arrange
      // Mock the repository's createUser method to return a Right(null) response when called
      when(() => repository.createUser(
            createdAt: any(named: 'createdAt'),
            name: any(named: 'name'),
            avatar: any(named: 'avatar'),
          )).thenAnswer((_) async => const Right(null));

      // Act
      // Call the usecase with the parameters to trigger the createUser function
      final result = await usecase(params);

      // Assert
      // Check that the result is a Right(null), indicating a successful creation
      expect(result, equals(const Right<dynamic, void>(null)));

      // Verify that repository.createUser was called exactly once with the correct parameters
      verify(() => repository.createUser(
            createdAt: params.createdAt,
            name: params.name,
            avatar: params.avatar,
          )).called(1);

      // Ensure there are no other interactions with the repository after calling createUser
      verifyNoMoreInteractions(repository);
    },
  );
}
