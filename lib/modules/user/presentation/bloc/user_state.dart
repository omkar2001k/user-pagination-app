import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {
  const UserInitial();
}

class UserLoading extends UserState {
  const UserLoading();
}

class UserLoaded extends UserState {
  final List<UserEntity> users;
  final List<UserEntity> filteredUsers;
  final int currentPage;
  final int totalPages;
  final bool hasReachedMax;
  final bool isFetchingMore;
  final bool isRefreshing;
  final String searchQuery;
  final bool isOffline;
  final String? errorMessage;

  const UserLoaded({
    required this.users,
    required this.filteredUsers,
    required this.currentPage,
    required this.totalPages,
    required this.hasReachedMax,
    this.isFetchingMore = false,
    this.isRefreshing = false,
    this.searchQuery = '',
    this.isOffline = false,
    this.errorMessage,
  });

  UserLoaded copyWith({
    List<UserEntity>? users,
    List<UserEntity>? filteredUsers,
    int? currentPage,
    int? totalPages,
    bool? hasReachedMax,
    bool? isFetchingMore,
    bool? isRefreshing,
    String? searchQuery,
    bool? isOffline,
    String? errorMessage,
  }) {
    return UserLoaded(
      users: users ?? this.users,
      filteredUsers: filteredUsers ?? this.filteredUsers,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      searchQuery: searchQuery ?? this.searchQuery,
      isOffline: isOffline ?? this.isOffline,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        users,
        filteredUsers,
        currentPage,
        totalPages,
        hasReachedMax,
        isFetchingMore,
        isRefreshing,
        searchQuery,
        isOffline,
        errorMessage,
      ];
}

class UserError extends UserState {
  final String message;

  const UserError(this.message);

  @override
  List<Object?> get props => [message];
}
