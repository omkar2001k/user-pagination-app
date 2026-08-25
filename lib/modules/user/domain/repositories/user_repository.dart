import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';

abstract class UserRepository {
  Future<Either<Failure, Tuple2<List<UserEntity>, int>>> getUsers({
    required int page,
    required int perPage,
  });

  Future<Either<Failure, List<UserEntity>>> getCachedUsers();
}
