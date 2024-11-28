import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tdd_clean_architecture/core/utils/typedef.dart';
import 'package:tdd_clean_architecture/features/authentication/data/models/user_model.dart';
import 'package:tdd_clean_architecture/features/authentication/domain/entities/user.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tModel = UserModel.empty();
  test('should be a subclass of [User] entity', () {
    expect(tModel, isA<User>());
  });

  final tJson = fixture('user.json');
  final tMap = jsonDecode(tJson) as DataMap;

  group('fromMap', () {
    test(
        'Testing the [fromMap] method should return a [UserModel] with the right data',
        () {
      //Act
      final results = UserModel.fromMap(tMap);

      //Assert
      expect(results, equals(tModel));
    });
  });

  group('fromJson', () {
    test(
        'Testing the [fromJson] method and should return a [UserModel] with the right data',
        () {
      //Act
      final results = UserModel.fromJson(tJson);

      //Assert
      expect(results, equals(tModel));
    });
  });

  group('toMap', () {
    test(
        'Testing the [toMap] method and should return a Map<String, dynamic> result',
        () {
      //Act
      final result = tModel.toMap();

      //Assert
      expect(result, equals(tMap));
    });
  });

  group('toJson', () {
    test('Testing the [toMap] method and should return a String result', () {
      //Act
      final result = tModel.toJson();

      final tJson = jsonEncode({
        "id": "1",
        "avatar": "_empty.avatar",
        "createdAt": "_empty.createdAt",
        "name": "_empty.name"
      });

      //Assert
      expect(result, equals(tJson));
    });
  });

  group('copyWith', () {
    test('Testing the [copyWith] method and should return a String result', () {
      //Act
      final result = tModel.copyWith(name: 'Janjan');

      //Assert
      expect(result!.name, equals('Janjan'));
    });
  });
}
