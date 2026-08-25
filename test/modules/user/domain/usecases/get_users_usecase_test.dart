import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:user_pagination_app/modules/user/domain/entities/user_entity.dart';
import 'package:user_pagination_app/modules/user/domain/repositories/user_repository.dart';
import 'package:user_pagination_app/modules/user/domain/usecases/get_users_usecase.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late GetUsersUseCase useCase;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    useCase = GetUsersUseCase(mockUserRepository);
  });

  const tUserEntity = UserEntity(
    id: 1,
    email: 'george.bluth@reqres.in',
    firstName: 'George',
    lastName: 'Bluth',
    avatar: 'https://reqres.in/img/faces/1-image.jpg',
  );

  group('GetUsersUseCase Tests', () {
    test('should get paginated users from repository', () async {
      when(() => mockUserRepository.getUsers(page: 1, perPage: 10))
          .thenAnswer((_) async => const Right(Tuple2([tUserEntity], 2)));

      final result = await useCase(const GetUsersParams(page: 1, perPage: 10));

      expect(result, const Right(Tuple2([tUserEntity], 2)));
      verify(() => mockUserRepository.getUsers(page: 1, perPage: 10)).called(1);
    });
  });
}
