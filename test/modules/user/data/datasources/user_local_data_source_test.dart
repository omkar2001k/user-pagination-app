import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';
import 'package:user_pagination_app/core/constants/api_constants.dart';
import 'package:user_pagination_app/core/errors/exceptions.dart';
import 'package:user_pagination_app/modules/user/data/datasources/user_local_data_source.dart';
import 'package:user_pagination_app/modules/user/data/models/user_model.dart';

class MockBox extends Mock implements Box {}

void main() {
  late UserLocalDataSourceImpl dataSource;
  late MockBox mockBox;

  setUp(() {
    mockBox = MockBox();
    dataSource = UserLocalDataSourceImpl(box: mockBox);
  });

  const tUserModel = UserModel(
    id: 1,
    email: 'john@example.com',
    firstName: 'John',
    lastName: 'Doe',
    avatar: 'https://example.com/avatar.png',
    phone: '+1 (555) 019-1001',
  );

  group('getCachedUsers', () {
    test('should return empty list when cached data is null', () async {
      when(() => mockBox.get(ApiConstants.cachedUsersKey)).thenReturn(null);

      final result = await dataSource.getCachedUsers();

      expect(result, isEmpty);
      verify(() => mockBox.get(ApiConstants.cachedUsersKey)).called(1);
    });

    test('should parse list of Map objects successfully', () async {
      when(() => mockBox.get(ApiConstants.cachedUsersKey)).thenReturn([
        tUserModel.toJson(),
      ]);

      final result = await dataSource.getCachedUsers();

      expect(result, [tUserModel]);
    });

    test('should parse list of JSON string objects successfully', () async {
      when(() => mockBox.get(ApiConstants.cachedUsersKey)).thenReturn([
        jsonEncode(tUserModel.toJson()),
      ]);

      final result = await dataSource.getCachedUsers();

      expect(result, [tUserModel]);
    });

    test('should throw CacheException when list element is invalid type',
        () async {
      when(() => mockBox.get(ApiConstants.cachedUsersKey)).thenReturn([123]);

      expect(
        () => dataSource.getCachedUsers(),
        throwsA(isA<CacheException>()),
      );
    });

    test('should throw CacheException on box get error', () async {
      when(() => mockBox.get(ApiConstants.cachedUsersKey))
          .thenThrow(Exception('Hive error'));

      expect(
        () => dataSource.getCachedUsers(),
        throwsA(isA<CacheException>()),
      );
    });
  });

  group('cacheUsers', () {
    test('should save json list to box', () async {
      when(() => mockBox.put(ApiConstants.cachedUsersKey, any()))
          .thenAnswer((_) async {});

      await dataSource.cacheUsers([tUserModel]);

      verify(() =>
              mockBox.put(ApiConstants.cachedUsersKey, [tUserModel.toJson()]))
          .called(1);
    });

    test('should throw CacheException on box put error', () async {
      when(() => mockBox.put(any(), any())).thenThrow(Exception('Box error'));

      expect(
        () => dataSource.cacheUsers([tUserModel]),
        throwsA(isA<CacheException>()),
      );
    });
  });

  group('clearCache', () {
    test('should delete cached users key from box', () async {
      when(() => mockBox.delete(ApiConstants.cachedUsersKey))
          .thenAnswer((_) async {});

      await dataSource.clearCache();

      verify(() => mockBox.delete(ApiConstants.cachedUsersKey)).called(1);
    });

    test('should throw CacheException on box delete error', () async {
      when(() => mockBox.delete(any())).thenThrow(Exception('Delete error'));

      expect(
        () => dataSource.clearCache(),
        throwsA(isA<CacheException>()),
      );
    });
  });
}
