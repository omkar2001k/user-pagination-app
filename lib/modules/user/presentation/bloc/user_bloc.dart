import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_pagination_app/core/constants/api_constants.dart';
import 'package:user_pagination_app/modules/user/domain/entities/user_entity.dart';
import 'package:user_pagination_app/modules/user/domain/usecases/get_users_usecase.dart';
import 'package:user_pagination_app/modules/user/presentation/bloc/user_event.dart';
import 'package:user_pagination_app/modules/user/presentation/bloc/user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUsersUseCase getUsersUseCase;

  UserBloc({required this.getUsersUseCase}) : super(const UserInitialState()) {
    on<FetchUsersEvent>(_onFetchUsers);
    on<FetchNextPageEvent>(_onFetchNextPage);
    on<RefreshUsersEvent>(_onRefreshUsers);
    on<SearchUsersEvent>(_onSearchUsers);
  }

  Future<void> _onFetchUsers(
    FetchUsersEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(const UserLoadingState());

    final result = await getUsersUseCase(
      const GetUsersParams(page: 1, perPage: ApiConstants.defaultPerPage),
    );

    result.fold(
      (failure) => emit(UserErrorState(failure.message)),
      (data) {
        final users = data.value1;
        final totalPages = data.value2;

        emit(UserLoadedState(
          users: users,
          filteredUsers: users,
          currentPage: 1,
          totalPages: totalPages,
          hasReachedMax: 1 >= totalPages,
        ));
      },
    );
  }

  Future<void> _onFetchNextPage(
    FetchNextPageEvent event,
    Emitter<UserState> emit,
  ) async {
    final currentState = state;
    if (currentState is! UserLoadedState ||
        currentState.hasReachedMax ||
        currentState.isFetchingMore) {
      return;
    }

    emit(currentState.copyWith(isFetchingMore: true));

    final nextPage = currentState.currentPage + 1;
    final result = await getUsersUseCase(
      GetUsersParams(page: nextPage, perPage: ApiConstants.defaultPerPage),
    );

    result.fold(
      (failure) {
        emit(currentState.copyWith(
          isFetchingMore: false,
          errorMessage: failure.message,
        ));
      },
      (data) {
        final newUsers = data.value1;
        final totalPages = data.value2;

        final existingIds = currentState.users.map((u) => u.id).toSet();
        final dedupedNewUsers =
            newUsers.where((u) => !existingIds.contains(u.id)).toList();
        final updatedUsers = List<UserEntity>.from(currentState.users)
          ..addAll(dedupedNewUsers);

        final updatedFiltered =
            _applySearchFilter(updatedUsers, currentState.searchQuery);

        emit(currentState.copyWith(
          users: updatedUsers,
          filteredUsers: updatedFiltered,
          currentPage: nextPage,
          totalPages: totalPages,
          hasReachedMax: nextPage >= totalPages,
          isFetchingMore: false,
        ));
      },
    );
  }

  Future<void> _onRefreshUsers(
    RefreshUsersEvent event,
    Emitter<UserState> emit,
  ) async {
    final currentState = state;
    if (currentState is UserLoadedState) {
      emit(currentState.copyWith(isRefreshing: true));
    }

    final result = await getUsersUseCase(
      const GetUsersParams(page: 1, perPage: ApiConstants.defaultPerPage),
    );

    result.fold(
      (failure) {
        if (currentState is UserLoadedState) {
          emit(currentState.copyWith(
            isRefreshing: false,
            errorMessage: failure.message,
          ));
        } else {
          emit(UserErrorState(failure.message));
        }
      },
      (data) {
        final users = data.value1;
        final totalPages = data.value2;
        final searchQuery =
            currentState is UserLoadedState ? currentState.searchQuery : '';
        final filtered = _applySearchFilter(users, searchQuery);

        emit(UserLoadedState(
          users: users,
          filteredUsers: filtered,
          currentPage: 1,
          totalPages: totalPages,
          hasReachedMax: 1 >= totalPages,
          isRefreshing: false,
          searchQuery: searchQuery,
        ));
      },
    );
  }

  void _onSearchUsers(
    SearchUsersEvent event,
    Emitter<UserState> emit,
  ) {
    final currentState = state;
    if (currentState is UserLoadedState) {
      final query = event.query;
      final filtered = _applySearchFilter(currentState.users, query);
      emit(currentState.copyWith(
        searchQuery: query,
        filteredUsers: filtered,
      ));
    }
  }

  List<UserEntity> _applySearchFilter(List<UserEntity> users, String query) {
    final sanitizedQuery =
        query.replaceAll(RegExp(r'[^\w\s]'), '').trim().toLowerCase();
    if (sanitizedQuery.isEmpty) {
      return users;
    }
    return users.where((user) {
      final nameMatch = user.fullName.toLowerCase().contains(sanitizedQuery);
      final emailMatch = user.email.toLowerCase().contains(sanitizedQuery);
      return nameMatch || emailMatch;
    }).toList();
  }
}
