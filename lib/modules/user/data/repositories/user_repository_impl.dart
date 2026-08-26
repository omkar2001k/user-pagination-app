import 'package:dartz/dartz.dart';
import 'package:user_pagination_app/core/errors/exceptions.dart';
import 'package:user_pagination_app/core/errors/failures.dart';
import 'package:user_pagination_app/core/network/network_info.dart';
import 'package:user_pagination_app/modules/user/data/datasources/user_local_data_source.dart';
import 'package:user_pagination_app/modules/user/data/datasources/user_remote_data_source.dart';
import 'package:user_pagination_app/modules/user/data/mappers/user_mapper.dart';
import 'package:user_pagination_app/modules/user/domain/entities/user_entity.dart';
import 'package:user_pagination_app/modules/user/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final UserLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  UserRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Tuple2<List<UserEntity>, int>>> getUsers({
    required int page,
    required int perPage,
  }) async {
    final isConnected = await networkInfo.isConnected;

    if (isConnected) {
      try {
        final response = await remoteDataSource.getUsers(page: page, perPage: perPage);
        final userEntities = UserMapper.toEntityList(response.users);

        if (page == 1) {
          try {
            await localDataSource.cacheUsers(response.users);
          } catch (_) {}
        }

        return Right(Tuple2(userEntities, response.totalPages));
      } on TimeoutException catch (e) {
        return _handleOfflineFallback(TimeoutFailure(e.message));
      } on NetworkException catch (e) {
        return _handleOfflineFallback(NetworkFailure(e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('An unexpected error occurred: $e'));
      }
    } else {
      return _handleOfflineFallback(const NetworkFailure('No Internet Connection. Loaded cached data.'));
    }
  }

  @override
  Future<Either<Failure, List<UserEntity>>> getCachedUsers() async {
    try {
      final cachedModels = await localDataSource.getCachedUsers();
      final cachedEntities = UserMapper.toEntityList(cachedModels);
      return Right(cachedEntities);
    } catch (e) {
      return const Left(CacheFailure('Failed to load cached users.'));
    }
  }

  Future<Either<Failure, Tuple2<List<UserEntity>, int>>> _handleOfflineFallback(Failure originalFailure) async {
    try {
      final cachedModels = await localDataSource.getCachedUsers();
      if (cachedModels.isNotEmpty) {
        final cachedEntities = UserMapper.toEntityList(cachedModels);
        return Right(Tuple2(cachedEntities, 1));
      }
    } catch (_) {}
    return Left(originalFailure);
  }
}
