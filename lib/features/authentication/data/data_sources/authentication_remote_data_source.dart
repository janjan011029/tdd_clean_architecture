import 'package:dio/dio.dart';
import 'package:tdd_clean_architecture/core/api/dio_client.dart';
import 'package:tdd_clean_architecture/core/errors/exeptions.dart';
import 'package:tdd_clean_architecture/features/authentication/data/models/user_model.dart';

abstract interface class AuthenticationRemoteDataSource {
  Future<void> createUser({
    required String createdAt,
    required String name,
    required String avatar,
  });

  Future<List<UserModel>> getUsers();
}

class AuthRemoteDataSourceImpl implements AuthenticationRemoteDataSource {
  const AuthRemoteDataSourceImpl(this._dioClient);

  final DioClient _dioClient;

  @override
  Future<void> createUser({
    required String createdAt,
    required String name,
    required String avatar,
  }) async {
    //1. check to make sure that it returns the right data when the status code is 200 or the proper status code
    //2. check to make sure that is throws an CUSTOM EXCEPTION with the right message when status code is a bad one

    try {
      final response = await _dioClient.post('/users', data: {
        'createdAt': createdAt,
        'name': name,
        'avatar': avatar,
      });

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw APIException(
          message: response.statusMessage!,
          statusCode: response.statusCode!,
        );
      }
    } on APIException {
      rethrow;
    } on DioException catch (e) {
      throw APIException(
        message: 'Network error: ${e.message}',
        statusCode: 503,
      );
    }
  }

  @override
  Future<List<UserModel>> getUsers() async {
    try {
      final response = await _dioClient.get('/users');

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw APIException(
          message: response.statusMessage!,
          statusCode: response.statusCode!,
        );
      }

      final users = response.data as List<Map<String, dynamic>>;
      final fUsers = <UserModel>[];

      for (var user in users) {
        fUsers.add(UserModel.fromMap(user));
      }

      return fUsers;
    } on APIException {
      rethrow;
    } on DioException catch (e) {
      throw APIException(
        message: 'Network error: ${e.message}',
        statusCode: 503,
      );
    }
  }
}
