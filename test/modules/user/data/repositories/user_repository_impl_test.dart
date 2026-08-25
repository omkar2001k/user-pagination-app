import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:user_pagination_app/core/errors/exceptions.dart';
import 'package:user_pagination_app/core/errors/failures.dart';
import 'package:user_pagination_app/core/network/network_info.dart';
import 'package:user_pagination_app/modules/user/data/datasources/user_local_data_source.dart';
import 'package:user_pagination_app/modules/user/data/datasources/user_remote_data_source.dart';
import 'package:user_pagination_app/modules/user/data/models/user_model.dart';
import 'package:user_pagination_app/modules/user/data/models/user_paginated_response_model.dart';
import 'package:user_pagination_app/modules/user/data/repositories/user_repository_impl.dart';

class MockUserRemoteDataSource extends Mock implements UserRemoteDataSource {}

class MockUserLocalDataSource extends Mock implements UserLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late UserRepositoryImpl repository;
  late MockUserRemoteDataSource mockRemoteDataSource;
  late MockUserLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockUserRemoteDataSource();
    mockLocalDataSource = MockUserLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = UserRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  const tUserModel = UserModel(
    id: 1,
    email: 'george.bluth@reqres.in',
    firstName: 'George',
    lastName: 'Bluth',
    avatar: 'https://reqres.in/img/faces/1-image.jpg',
  );

  const tPaginatedResponse = UserPaginatedResponseModel(
    page: 1,
    perPage: 10,
    total: 12,
    totalPages: 2,
    users: [tUserModel],
  );

  group('UserRepositoryImpl Tests', () {
    test('should fetch remote users and cache page 1 when device is online',
        () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getUsers(page: 1, perPage: 10))
          .thenAnswer((_) async => tPaginatedResponse);
      when(() => mockLocalDataSource.cacheUsers(any()))
          .thenAnswer((_) async {});

      final result = await repository.getUsers(page: 1, perPage: 10);

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should be right'),
        (r) {
          expect(r.value1.length, 1);
          expect(r.value1.first.firstName, 'George');
          expect(r.value2, 2);
        },
      );
      verify(() => mockLocalDataSource.cacheUsers([tUserModel])).called(1);
    });

    test('should not cache users when page > 1', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getUsers(page: 2, perPage: 10))
          .thenAnswer((_) async => tPaginatedResponse);

      final result = await repository.getUsers(page: 2, perPage: 10);

      expect(result.isRight(), true);
      verifyNever(() => mockLocalDataSource.cacheUsers(any()));
    });

    test('should ignore cache write error silently when page 1 caching fails',
        () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getUsers(page: 1, perPage: 10))
          .thenAnswer((_) async => tPaginatedResponse);
      when(() => mockLocalDataSource.cacheUsers(any()))
          .thenThrow(const CacheException(message: 'Write fail'));

      final result = await repository.getUsers(page: 1, perPage: 10);

      expect(result.isRight(), true);
    });

    test('should return cached users when device is offline', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(() => mockLocalDataSource.getCachedUsers())
          .thenAnswer((_) async => [tUserModel]);

      final result = await repository.getUsers(page: 1, perPage: 10);

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should be right'),
        (r) {
          expect(r.value1.length, 1);
          expect(r.value1.first.firstName, 'George');
        },
      );
      verify(() => mockLocalDataSource.getCachedUsers()).called(1);
      verifyZeroInteractions(mockRemoteDataSource);
    });

    test('should return NetworkFailure when offline and cache is empty',
        () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(() => mockLocalDataSource.getCachedUsers())
          .thenAnswer((_) async => []);

      final result = await repository.getUsers(page: 1, perPage: 10);

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<NetworkFailure>()),
        (r) => fail('Should be left'),
      );
    });

    test('should return cached users when remote call throws TimeoutException',
        () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getUsers(page: 1, perPage: 10))
          .thenThrow(const TimeoutException(message: 'Timed out'));
      when(() => mockLocalDataSource.getCachedUsers())
          .thenAnswer((_) async => [tUserModel]);

      final result = await repository.getUsers(page: 1, perPage: 10);

      expect(result.isRight(), true);
    });

    test('should return cached users when remote call throws NetworkException',
        () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getUsers(page: 1, perPage: 10))
          .thenThrow(const NetworkException(message: 'Network error'));
      when(() => mockLocalDataSource.getCachedUsers())
          .thenAnswer((_) async => [tUserModel]);

      final result = await repository.getUsers(page: 1, perPage: 10);

      expect(result.isRight(), true);
    });

    test('should return ServerFailure when remote call throws ServerException',
        () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getUsers(page: 1, perPage: 10))
          .thenThrow(const ServerException(message: 'Internal Server Error'));

      final result = await repository.getUsers(page: 1, perPage: 10);

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (r) => fail('Should be left'),
      );
    });

    test('should return ServerFailure when unexpected error occurs', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getUsers(page: 1, perPage: 10))
          .thenThrow(const FormatException('Bad format'));

      final result = await repository.getUsers(page: 1, perPage: 10);

      expect(result.isLeft(), true);
      result.fold(
        (failure) =>
            expect(failure.message, contains('An unexpected error occurred')),
        (r) => fail('Should be left'),
      );
    });

    test('getCachedUsers should return Right(entities) on success', () async {
      when(() => mockLocalDataSource.getCachedUsers())
          .thenAnswer((_) async => [tUserModel]);

      final result = await repository.getCachedUsers();

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should be right'),
        (r) => expect(r.length, 1),
      );
    });

    test('getCachedUsers should return Left(CacheFailure) on exception',
        () async {
      when(() => mockLocalDataSource.getCachedUsers())
          .thenThrow(Exception('Cache read fail'));

      final result = await repository.getCachedUsers();

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<CacheFailure>()),
        (r) => fail('Should be left'),
      );
    });
  });
}
