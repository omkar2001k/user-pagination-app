import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class FetchUsersEvent extends UserEvent {
  const FetchUsersEvent();
}

class FetchNextPageEvent extends UserEvent {
  const FetchNextPageEvent();
}

class RefreshUsersEvent extends UserEvent {
  const RefreshUsersEvent();
}

class SearchUsersEvent extends UserEvent {
  final String query;

  const SearchUsersEvent(this.query);

  @override
  List<Object?> get props => [query];
}
