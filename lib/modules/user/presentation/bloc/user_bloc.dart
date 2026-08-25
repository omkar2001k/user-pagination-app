import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/api_constants.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/get_users_usecase.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUsersUseCase getUsersUseCase;

  UserBloc({required this.getUsersUseCase}) : super(const UserInitial()) {
    on<FetchUsersEvent>(_onFetchUsers);
    on<FetchNextPageEvent>(_onFetchNextPage);
    on<RefreshUsersEvent>(_onRefreshUsers);
    on<SearchUsersEvent>(_onSearchUsers);
  }

  Future<void> _onFetchUsers(
    FetchUsersEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(const UserLoading());

    final result = await getUsersUseCase(
      const GetUsersParams(page: 1, perPage: ApiConstants.defaultPerPage),
    );

    result.fold(
      (failure) {
        emit(UserError(failure.message));
      },
      (data) {
        final users = data.value1;
        final totalPages = data.value2;
        final hasReachedMax = 1 >= totalPages;

        emit(UserLoaded(
          users: users,
          filteredUsers: users,
          currentPage: 1,
          totalPages: totalPages,
          hasReachedMax: hasReachedMax,
        ));
      },
    );
  }

  Future<void> _onFetchNextPage(
    FetchNextPageEvent event,
    Emitter<UserState> emit,
  ) async {
    final currentState = state;
    if (currentState is! UserLoaded || currentState.hasReachedMax || currentState.isFetchingMore) {
      return;
    }

    emit(currentState.copyWith(isFetchingMore: true));

    final nextPage = currentState.currentPage + 1;
    final result = await getUsersUseCase(
      GetUsersParams(page: nextPage, perPage: ApiConstants.defaultPerPage),
    );

    result.fold(
      (failure) {
        // If next page fetch fails, keep current loaded users but turn off fetching indicator and show message
        emit(currentState.copyWith(
          isFetchingMore: false,
          errorMessage: failure.message,
        ));
      },
      (data) {
        final newUsers = data.value1;
        final totalPages = data.value2;
        
        // Append new users avoiding duplicate IDs if any
        final existingIds = currentState.users.map((u) => u.id).toSet();
        final filteredNewUsers = newUsers.where((u) => !existingIds.contains(u.id)).toList();
        final updatedUsers = List<UserEntity>.from(currentState.users)..addAll(filteredNewUsers);

        final updatedFiltered = _applySearchFilter(updatedUsers, currentState.searchQuery);
        final hasReachedMax = nextPage >= totalPages;

        emit(currentState.copyWith(
          users: updatedUsers,
          filteredUsers: updatedFiltered,
          currentPage: nextPage,
          totalPages: totalPages,
          hasReachedMax: hasReachedMax,
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
    if (currentState is UserLoaded) {
      emit(currentState.copyWith(isRefreshing: true));
    }

    final result = await getUsersUseCase(
      const GetUsersParams(page: 1, perPage: ApiConstants.defaultPerPage),
    );

    result.fold(
      (failure) {
        if (currentState is UserLoaded) {
          emit(currentState.copyWith(
            isRefreshing: false,
            errorMessage: failure.message,
          ));
        } else {
          emit(UserError(failure.message));
        }
      },
      (data) {
        final users = data.value1;
        final totalPages = data.value2;
        final hasReachedMax = 1 >= totalPages;
        final searchQuery = currentState is UserLoaded ? currentState.searchQuery : '';
        final filtered = _applySearchFilter(users, searchQuery);

        emit(UserLoaded(
          users: users,
          filteredUsers: filtered,
          currentPage: 1,
          totalPages: totalPages,
          hasReachedMax: hasReachedMax,
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
    if (currentState is UserLoaded) {
      final query = event.query;
      final filtered = _applySearchFilter(currentState.users, query);
      emit(currentState.copyWith(
        searchQuery: query,
        filteredUsers: filtered,
      ));
    }
  }

  List<UserEntity> _applySearchFilter(List<UserEntity> users, String query) {
    final sanitizedQuery = query.replaceAll(RegExp(r'[^\w\s]'), '').trim().toLowerCase();
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
