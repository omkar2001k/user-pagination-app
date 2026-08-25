import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:user_pagination_app/core/errors/failures.dart';
import 'package:user_pagination_app/modules/user/domain/entities/user_entity.dart';
import 'package:user_pagination_app/modules/user/domain/usecases/get_users_usecase.dart';
import 'package:user_pagination_app/modules/user/presentation/bloc/user_bloc.dart';
import 'package:user_pagination_app/modules/user/presentation/bloc/user_event.dart';
import 'package:user_pagination_app/modules/user/presentation/bloc/user_state.dart';

class MockGetUsersUseCase extends Mock implements GetUsersUseCase {}

void main() {
  late UserBloc userBloc;
  late MockGetUsersUseCase mockGetUsersUseCase;

  setUpAll(() {
    registerFallbackValue(const GetUsersParams(page: 1, perPage: 10));
  });

  setUp(() {
    mockGetUsersUseCase = MockGetUsersUseCase();
    userBloc = UserBloc(getUsersUseCase: mockGetUsersUseCase);
  });

  tearDown(() {
    userBloc.close();
  });

  const tUser1 = UserEntity(
    id: 1,
    email: 'george.bluth@reqres.in',
    firstName: 'George',
    lastName: 'Bluth',
    avatar: 'https://reqres.in/img/faces/1-image.jpg',
  );

  const tUser2 = UserEntity(
    id: 2,
    email: 'janet.weaver@reqres.in',
    firstName: 'Janet',
    lastName: 'Weaver',
    avatar: 'https://reqres.in/img/faces/2-image.jpg',
  );

  group('UserEvents Props', () {
    test('UserEvents equality and props', () {
      expect(const FetchUsersEvent().props, isEmpty);
      expect(const FetchNextPageEvent().props, isEmpty);
      expect(const RefreshUsersEvent().props, isEmpty);
      expect(const SearchUsersEvent('query').props, ['query']);
    });
  });

  group('UserBloc Tests', () {
    test('initial state should be UserInitial', () {
      expect(userBloc.state, const UserInitial());
    });

    blocTest<UserBloc, UserState>(
      'should emit [UserLoading, UserLoaded] when FetchUsersEvent succeeds',
      build: () {
        when(() => mockGetUsersUseCase(any()))
            .thenAnswer((_) async => const Right(Tuple2([tUser1], 2)));
        return userBloc;
      },
      act: (bloc) => bloc.add(const FetchUsersEvent()),
      expect: () => [
        const UserLoading(),
        const UserLoaded(
          users: [tUser1],
          filteredUsers: [tUser1],
          currentPage: 1,
          totalPages: 2,
          hasReachedMax: false,
        ),
      ],
    );

    blocTest<UserBloc, UserState>(
      'should emit [UserLoading, UserError] when FetchUsersEvent fails',
      build: () {
        when(() => mockGetUsersUseCase(any()))
            .thenAnswer((_) async => const Left(ServerFailure('Server Error')));
        return userBloc;
      },
      act: (bloc) => bloc.add(const FetchUsersEvent()),
      expect: () => [
        const UserLoading(),
        const UserError('Server Error'),
      ],
    );

    blocTest<UserBloc, UserState>(
      'should append users when FetchNextPageEvent succeeds',
      build: () {
        when(() => mockGetUsersUseCase(const GetUsersParams(page: 2, perPage: 10)))
            .thenAnswer((_) async => const Right(Tuple2([tUser2], 2)));
        return userBloc;
      },
      seed: () => const UserLoaded(
        users: [tUser1],
        filteredUsers: [tUser1],
        currentPage: 1,
        totalPages: 2,
        hasReachedMax: false,
      ),
      act: (bloc) => bloc.add(const FetchNextPageEvent()),
      expect: () => [
        const UserLoaded(
          users: [tUser1],
          filteredUsers: [tUser1],
          currentPage: 1,
          totalPages: 2,
          hasReachedMax: false,
          isFetchingMore: true,
        ),
        const UserLoaded(
          users: [tUser1, tUser2],
          filteredUsers: [tUser1, tUser2],
          currentPage: 2,
          totalPages: 2,
          hasReachedMax: true,
          isFetchingMore: false,
        ),
      ],
    );

    blocTest<UserBloc, UserState>(
      'should not fetch next page if hasReachedMax is true',
      build: () => userBloc,
      seed: () => const UserLoaded(
        users: [tUser1],
        filteredUsers: [tUser1],
        currentPage: 1,
        totalPages: 1,
        hasReachedMax: true,
      ),
      act: (bloc) => bloc.add(const FetchNextPageEvent()),
      expect: () => [],
    );

    blocTest<UserBloc, UserState>(
      'should set errorMessage when FetchNextPageEvent fails',
      build: () {
        when(() => mockGetUsersUseCase(const GetUsersParams(page: 2, perPage: 10)))
            .thenAnswer((_) async => const Left(ServerFailure('Next page fail')));
        return userBloc;
      },
      seed: () => const UserLoaded(
        users: [tUser1],
        filteredUsers: [tUser1],
        currentPage: 1,
        totalPages: 2,
        hasReachedMax: false,
      ),
      act: (bloc) => bloc.add(const FetchNextPageEvent()),
      expect: () => [
        const UserLoaded(
          users: [tUser1],
          filteredUsers: [tUser1],
          currentPage: 1,
          totalPages: 2,
          hasReachedMax: false,
          isFetchingMore: true,
        ),
        const UserLoaded(
          users: [tUser1],
          filteredUsers: [tUser1],
          currentPage: 1,
          totalPages: 2,
          hasReachedMax: false,
          isFetchingMore: false,
          errorMessage: 'Next page fail',
        ),
      ],
    );

    blocTest<UserBloc, UserState>(
      'should refresh users when RefreshUsersEvent is added',
      build: () {
        when(() => mockGetUsersUseCase(const GetUsersParams(page: 1, perPage: 10)))
            .thenAnswer((_) async => const Right(Tuple2([tUser1, tUser2], 2)));
        return userBloc;
      },
      seed: () => const UserLoaded(
        users: [tUser1],
        filteredUsers: [tUser1],
        currentPage: 1,
        totalPages: 2,
        hasReachedMax: false,
      ),
      act: (bloc) => bloc.add(const RefreshUsersEvent()),
      expect: () => [
        const UserLoaded(
          users: [tUser1],
          filteredUsers: [tUser1],
          currentPage: 1,
          totalPages: 2,
          hasReachedMax: false,
          isRefreshing: true,
        ),
        const UserLoaded(
          users: [tUser1, tUser2],
          filteredUsers: [tUser1, tUser2],
          currentPage: 1,
          totalPages: 2,
          hasReachedMax: false,
          isRefreshing: false,
        ),
      ],
    );

    blocTest<UserBloc, UserState>(
      'should set errorMessage when RefreshUsersEvent fails on UserLoaded',
      build: () {
        when(() => mockGetUsersUseCase(const GetUsersParams(page: 1, perPage: 10)))
            .thenAnswer((_) async => const Left(ServerFailure('Refresh error')));
        return userBloc;
      },
      seed: () => const UserLoaded(
        users: [tUser1],
        filteredUsers: [tUser1],
        currentPage: 1,
        totalPages: 2,
        hasReachedMax: false,
      ),
      act: (bloc) => bloc.add(const RefreshUsersEvent()),
      expect: () => [
        const UserLoaded(
          users: [tUser1],
          filteredUsers: [tUser1],
          currentPage: 1,
          totalPages: 2,
          hasReachedMax: false,
          isRefreshing: true,
        ),
        const UserLoaded(
          users: [tUser1],
          filteredUsers: [tUser1],
          currentPage: 1,
          totalPages: 2,
          hasReachedMax: false,
          isRefreshing: false,
          errorMessage: 'Refresh error',
        ),
      ],
    );

    blocTest<UserBloc, UserState>(
      'should emit UserError when RefreshUsersEvent fails on non-UserLoaded state',
      build: () {
        when(() => mockGetUsersUseCase(const GetUsersParams(page: 1, perPage: 10)))
            .thenAnswer((_) async => const Left(ServerFailure('Fatal Refresh error')));
        return userBloc;
      },
      act: (bloc) => bloc.add(const RefreshUsersEvent()),
      expect: () => [
        const UserError('Fatal Refresh error'),
      ],
    );

    blocTest<UserBloc, UserState>(
      'should filter users correctly by name and email (handling whitespace and special chars)',
      build: () => userBloc,
      seed: () => const UserLoaded(
        users: [tUser1, tUser2],
        filteredUsers: [tUser1, tUser2],
        currentPage: 1,
        totalPages: 1,
        hasReachedMax: true,
      ),
      act: (bloc) => bloc.add(const SearchUsersEvent('  george! ')),
      expect: () => [
        const UserLoaded(
          users: [tUser1, tUser2],
          filteredUsers: [tUser1],
          currentPage: 1,
          totalPages: 1,
          hasReachedMax: true,
          searchQuery: '  george! ',
        ),
      ],
    );

    blocTest<UserBloc, UserState>(
      'should restore all users when search query is empty',
      build: () => userBloc,
      seed: () => const UserLoaded(
        users: [tUser1, tUser2],
        filteredUsers: [tUser1],
        currentPage: 1,
        totalPages: 1,
        hasReachedMax: true,
        searchQuery: 'george',
      ),
      act: (bloc) => bloc.add(const SearchUsersEvent('')),
      expect: () => [
        const UserLoaded(
          users: [tUser1, tUser2],
          filteredUsers: [tUser1, tUser2],
          currentPage: 1,
          totalPages: 1,
          hasReachedMax: true,
          searchQuery: '',
        ),
      ],
    );
  });
}
