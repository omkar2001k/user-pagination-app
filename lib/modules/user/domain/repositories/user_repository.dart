import 'package:dartz/dartz.dart';
import 'package:user_pagination_app/core/errors/failures.dart';
import 'package:user_pagination_app/modules/user/domain/entities/user_entity.dart';

abstract class UserRepository {
  Future<Either<Failure, Tuple2<List<UserEntity>, int>>> getUsers({
    required int page,
    required int perPage,
  });

  Future<Either<Failure, List<UserEntity>>> getCachedUsers();
}
