import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

class GetUsersParams extends Equatable {
  final int page;
  final int perPage;

  const GetUsersParams({
    required this.page,
    required this.perPage,
  });

  @override
  List<Object?> get props => [page, perPage];
}

class GetUsersUseCase implements UseCase<Tuple2<List<UserEntity>, int>, GetUsersParams> {
  final UserRepository repository;

  GetUsersUseCase(this.repository);

  @override
  Future<Either<Failure, Tuple2<List<UserEntity>, int>>> call(GetUsersParams params) async {
    return await repository.getUsers(
      page: params.page,
      perPage: params.perPage,
    );
  }
}
