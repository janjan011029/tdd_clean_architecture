import 'package:fpdart/fpdart.dart';
import 'package:tdd_clean_architecture/core/errors/exeptions.dart';
import 'package:tdd_clean_architecture/core/errors/failure.dart';
import 'package:tdd_clean_architecture/core/utils/typedef.dart';
import 'package:tdd_clean_architecture/features/authentication/data/data_sources/authentication_remote_data_source.dart';
import 'package:tdd_clean_architecture/features/authentication/domain/entities/user.dart';
import 'package:tdd_clean_architecture/features/authentication/domain/repositories/authentication_repository.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  const AuthenticationRepositoryImpl(this._remoteDataSource);

  final AuthenticationRemoteDataSource _remoteDataSource;
  @override
  ResultVoid createUser({
    required String createdAt,
    required String name,
    required String avatar,
  }) async {
    //Test-Driven Development
    //Call the remote data source
    //make sure that it returns the proper data if there is no exception
    //check if the methods returns the proper data
    /* check if when the remoteDataSource throws and exception, we return a failure 
    and if doesn't we return the expected data
    */

    try {
      await _remoteDataSource.createUser(
        createdAt: createdAt,
        name: name,
        avatar: avatar,
      );
      return const Right(null);
    } on APIException catch (e) {
      return Left(APIFailure.fromException(e));
    }
  }

  @override
  ResultFuture<List<User>> getUsers() async {
    try {
      final result = await _remoteDataSource.getUsers();
      return Right(result);
    } on APIException catch (e) {
      return Left(APIFailure.fromException(e));
    }
  }
}
