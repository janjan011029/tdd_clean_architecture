import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_clean_architecture/core/errors/exeptions.dart';
import 'package:tdd_clean_architecture/core/errors/failure.dart';
import 'package:tdd_clean_architecture/features/authentication/data/data_sources/authentication_remote_data_source.dart';
import 'package:tdd_clean_architecture/features/authentication/data/models/user_model.dart';
import 'package:tdd_clean_architecture/features/authentication/data/repositories/authentication_repository_impl.dart';
import 'package:tdd_clean_architecture/features/authentication/domain/entities/user.dart';

class MockAuthRemoteDataSrc extends Mock
    implements AuthenticationRemoteDataSource {}

void main() {
  late AuthenticationRemoteDataSource remoteDatasource;
  late AuthenticationRepositoryImpl repositoryImpl;
  setUp(() {
    remoteDatasource = MockAuthRemoteDataSrc();
    repositoryImpl = AuthenticationRepositoryImpl(remoteDatasource);
  });

  const tException = APIException(
    message: 'Unknown Error Occured',
    statusCode: 500,
  );

  final tUserList = <User>[
    User.empty(),
  ];

  group('createUser', () {
    //Params
    const createdAt = 'whatever._createdAt';
    const name = 'whatever._name';
    const avatar = 'whatever._avatar';

    test(
        'should call the [RemoteDataSource.createUser] and complete successfully '
        'when the call the remote source is successful.', () async {
      //Arrange
      when(() => remoteDatasource.createUser(
            createdAt: any(named: 'createdAt'),
            name: any(named: 'name'),
            avatar: any(named: 'avatar'),
          )).thenAnswer((_) async => Future.value());

      //Act
      final result = await repositoryImpl.createUser(
        createdAt: createdAt,
        name: name,
        avatar: avatar,
      );

      //Assert
      expect(result, equals(const Right(null)));
      //check that remote source createUser gets called and returns the right data
      verify(() => remoteDatasource.createUser(
            createdAt: createdAt,
            name: name,
            avatar: avatar,
          )).called(1);

      verifyNoMoreInteractions(remoteDatasource);
    });

    test(
        'should return a [ServerFailure] when the call to remote datasource is unsuccessful',
        () async {
      //Arrange
      when(() => remoteDatasource.createUser(
          createdAt: any(named: 'createdAt'),
          name: any(named: 'name'),
          avatar: any(named: 'avatar'))).thenThrow(tException);

      //Act
      final result = await repositoryImpl.createUser(
        createdAt: createdAt,
        name: name,
        avatar: avatar,
      );

      //Assert
      expect(
        result,
        equals(
          Left(
            APIFailure(
              message: tException.message,
              statusCode: tException.statusCode,
            ),
          ),
        ),
      );

      //Verify
      verify(() => remoteDatasource.createUser(
          createdAt: createdAt, name: name, avatar: avatar)).called(1);

      verifyNoMoreInteractions(remoteDatasource);
    });
  });

  group('getUsers', () {
    test(
        'should call the [RemoteDataSource.createUser] and complete successfully '
        'when the call the remote source is successful.', () async {
      final expectedUsers = [UserModel.empty()];
      //Arrange
      when(() => remoteDatasource.getUsers()).thenAnswer(
        (_) async => expectedUsers,
      );

      //Act
      final result = await repositoryImpl.getUsers();

      //Assert
      expect(result, isA<Right<dynamic, List<User>>>());

      //check that remote source getUsers gets called and returns the right data
      verify(() => remoteDatasource.getUsers()).called(1);

      verifyNoMoreInteractions(remoteDatasource);
    });

    test(
        'should return a [API Failure] when the call to remote datasource is unsuccessful',
        () async {
      //Arrange
      when(() => remoteDatasource.getUsers()).thenThrow(tException);

      //Act
      final result = await repositoryImpl.getUsers();

      //Assert
      expect(
        result,
        equals(
          Left(
            APIFailure(
              message: tException.message,
              statusCode: tException.statusCode,
            ),
          ),
        ),
      );

      //check that remote source getUsers gets called and returns the right data
      verify(() => remoteDatasource.getUsers()).called(1);

      verifyNoMoreInteractions(remoteDatasource);
    });
  });
}
