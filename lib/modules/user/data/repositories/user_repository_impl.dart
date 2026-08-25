import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_local_data_source.dart';
import '../datasources/user_remote_data_source.dart';

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
        final userEntities = response.users.map((model) => model.toEntity()).toList();

        // Cache page 1 results locally for offline availability
        if (page == 1) {
          try {
            await localDataSource.cacheUsers(response.users);
          } catch (_) {
            // Ignore cache save failures silently to not break online flow
          }
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
      final cachedEntities = cachedModels.map((m) => m.toEntity()).toList();
      return Right(cachedEntities);
    } catch (e) {
      return const Left(CacheFailure('Failed to load cached users.'));
    }
  }

  Future<Either<Failure, Tuple2<List<UserEntity>, int>>> _handleOfflineFallback(Failure originalFailure) async {
    try {
      final cachedModels = await localDataSource.getCachedUsers();
      if (cachedModels.isNotEmpty) {
        final cachedEntities = cachedModels.map((m) => m.toEntity()).toList();
        return Right(Tuple2(cachedEntities, 1));
      }
    } catch (_) {}
    return Left(originalFailure);
  }
}
