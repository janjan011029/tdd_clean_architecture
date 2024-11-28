import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_clean_architecture/core/api/dio_client.dart';
import 'package:tdd_clean_architecture/core/errors/exeptions.dart';
import 'package:tdd_clean_architecture/features/authentication/data/data_sources/authentication_remote_data_source.dart';
import 'package:tdd_clean_architecture/features/authentication/data/models/user_model.dart';

class MockClient extends Mock implements DioClient {}

void main() {
  late DioClient dioClient;
  late AuthenticationRemoteDataSource remoteDataSource;

  setUp(() {
    dioClient = MockClient();
    remoteDataSource = AuthRemoteDataSourceImpl(dioClient);
  });

  const url = '/users';
  group('createUser', () {
    test(
        '[createUser] should complete successfully when the status code is 201',
        () async {
      // Arrange
      const url = '/users';
      const testData = {
        "name": 'name',
        "avatar": 'avatar',
        "createdAt": 'createdAt',
      };

      when(() => dioClient.post(
            url,
            data: testData,
          )).thenAnswer((_) async {
        return Response(
          requestOptions: RequestOptions(path: url),
          data: {
            "message": "User created successfully",
            "status_code": 201,
          },
          statusCode: 201,
        );
      });

      // Act
      final result = remoteDataSource.createUser(
        createdAt: 'createdAt',
        name: 'name',
        avatar: 'avatar',
      );

      // Assert
      await expectLater(result, completes);

      verify(() => dioClient.post(
            url,
            data: testData,
          )).called(1);

      verifyNoMoreInteractions(dioClient);
    });

    test(
        '[createUser] should throw an APIException when the status code is not 201',
        () async {
      // Arrange
      const url = '/users';
      const testData = {
        "name": 'name',
        "avatar": 'avatar',
        "createdAt": 'createdAt',
      };

      when(() => dioClient.post(
            url,
            data: testData,
          )).thenAnswer((_) async {
        return Response(
          requestOptions: RequestOptions(path: url),
          data: {
            "message": "User creation failed",
            "status_code": 400,
          },
          statusCode: 400,
          statusMessage: "User creation failed",
        );
      });

      // Act & Assert
      expect(
        () => remoteDataSource.createUser(
          createdAt: 'createdAt',
          name: 'name',
          avatar: 'avatar',
        ),
        throwsA(isA<APIException>()),
      );

      verify(() => dioClient.post(
            url,
            data: testData,
          )).called(1);

      verifyNoMoreInteractions(dioClient);
    });

    test(
        '[createUser] should throw APIException on Dio error',
        () async {
      // Arrange
      const url = '/users';
      const testData = {
        "name": 'name',
        "avatar": 'avatar',
        "createdAt": 'createdAt',
      };

      when(() => dioClient.post(
            url,
            data: testData,
          )).thenThrow(DioException(
        requestOptions: RequestOptions(path: url),
        error: "Network error",
        type: DioExceptionType.connectionError,
      ));

      // Act & Assert
      expect(
        () => remoteDataSource.createUser(
          createdAt: 'createdAt',
          name: 'name',
          avatar: 'avatar',
        ),
        throwsA(isA<APIException>()),
      );

      verify(() => dioClient.post(
            url,
            data: testData,
          )).called(1);

      verifyNoMoreInteractions(dioClient);
    });
  });

  group('getUsers', () {
    test(
        '[getUsers] should return a list of UserModel when the status code is 200',
        () async {
      // Arrange
      final mockResponseData = [
        {
          "id": "1",
          "name": "John Doe",
          "avatar": "https://example.com/avatar.jpg",
          "createdAt": "2024-11-18"
        },
        {
          "id": "2",
          "name": "Jane Doe",
          "avatar": "https://example.com/avatar2.jpg",
          "createdAt": "2024-11-18"
        },
      ];

      when(() => dioClient.get(url)).thenAnswer((_) async {
        return Response(
          requestOptions: RequestOptions(path: url),
          data: mockResponseData,
          statusCode: 200,
        );
      });

      // Act
      final result = await remoteDataSource.getUsers();

      // Assert
      expect(result, isA<List<UserModel>>());
      expect(result.length, 2);
      expect(result[0].name, "John Doe");
      expect(result[1].name, "Jane Doe");

      verify(() => dioClient.get(url)).called(1);
      verifyNoMoreInteractions(dioClient);
    });

    test(
        '[getUsers] should throw APIException when the status code is not 200 or 201',
        () async {
      // Arrange
      when(() => dioClient.get(url)).thenAnswer((_) async {
        return Response(
          requestOptions: RequestOptions(path: url),
          data: {"message": "Error occurred"},
          statusCode: 400,
          statusMessage: "Bad Request",
        );
      });

      // Act & Assert
      expect(() => remoteDataSource.getUsers(), throwsA(isA<APIException>()));

      verify(() => dioClient.get(url)).called(1);
      verifyNoMoreInteractions(dioClient);
    });

    test('[getUsers] should throw APIException on Dio error', () async {
      // Arrange
      when(() => dioClient.get(url)).thenThrow(DioException(
        requestOptions: RequestOptions(path: url),
        error: "Network error",
        type: DioExceptionType.connectionError,
      ));

      // Act & Assert
      expect(() => remoteDataSource.getUsers(), throwsA(isA<APIException>()));

      verify(() => dioClient.get(url)).called(1);
      verifyNoMoreInteractions(dioClient);
    });
  });
}
