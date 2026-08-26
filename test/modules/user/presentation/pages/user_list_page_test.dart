import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:user_pagination_app/core/widgets/common_empty_widget.dart';
import 'package:user_pagination_app/core/widgets/common_error_widget.dart';
import 'package:user_pagination_app/modules/user/domain/entities/user_entity.dart';
import 'package:user_pagination_app/modules/user/presentation/bloc/user_bloc.dart';
import 'package:user_pagination_app/modules/user/presentation/bloc/user_event.dart';
import 'package:user_pagination_app/modules/user/presentation/bloc/user_state.dart';
import 'package:user_pagination_app/modules/user/presentation/views/user_list_view.dart';
import 'package:user_pagination_app/modules/user/presentation/widgets/user_card_widget.dart';

class MockUserBloc extends MockBloc<UserEvent, UserState> implements UserBloc {}

void main() {
  late MockUserBloc mockUserBloc;

  setUp(() {
    mockUserBloc = MockUserBloc();
  });

  const tUser = UserEntity(
    id: 1,
    email: 'george.bluth@reqres.in',
    firstName: 'George',
    lastName: 'Bluth',
    avatar: 'https://reqres.in/img/faces/1-image.jpg',
  );

  Widget makeTestableWidget(Widget child) {
    return MaterialApp(
      home: BlocProvider<UserBloc>.value(
        value: mockUserBloc,
        child: child,
      ),
    );
  }

  group('UserListView Widget Tests', () {
    testWidgets('should render shimmer loading when state is UserLoadingState',
        (tester) async {
      when(() => mockUserBloc.state).thenReturn(const UserLoadingState());

      await tester
          .pumpWidget(makeTestableWidget(UserListView(onUserSelected: (_) {})));

      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets(
        'should render error widget when state is UserErrorState and handle retry',
        (tester) async {
      when(() => mockUserBloc.state)
          .thenReturn(const UserErrorState('Server Failure'));

      await tester
          .pumpWidget(makeTestableWidget(UserListView(onUserSelected: (_) {})));

      expect(find.byType(CommonErrorWidget), findsOneWidget);
      expect(find.text('Server Failure'), findsOneWidget);

      await tester.tap(find.text('Try Again'));
      await tester.pump();

      verify(() => mockUserBloc.add(const FetchUsersEvent())).called(1);
    });

    testWidgets('should render list of user cards when state is UserLoadedState',
        (tester) async {
      when(() => mockUserBloc.state).thenReturn(
        const UserLoadedState(
          users: [tUser],
          filteredUsers: [tUser],
          currentPage: 1,
          totalPages: 1,
          hasReachedMax: true,
        ),
      );

      UserEntity? selectedUser;
      await tester.pumpWidget(
        makeTestableWidget(
          UserListView(onUserSelected: (u) => selectedUser = u),
        ),
      );

      expect(find.byType(UserCardWidget), findsOneWidget);
      expect(find.text('George Bluth'), findsOneWidget);
      expect(find.text('george.bluth@reqres.in'), findsOneWidget);

      await tester.tap(find.byType(UserCardWidget));
      await tester.pump();

      expect(selectedUser, tUser);
    });

    testWidgets('should render empty widget when filtered users list is empty',
        (tester) async {
      when(() => mockUserBloc.state).thenReturn(
        const UserLoadedState(
          users: [tUser],
          filteredUsers: [],
          currentPage: 1,
          totalPages: 1,
          hasReachedMax: true,
          searchQuery: 'alex',
        ),
      );

      await tester
          .pumpWidget(makeTestableWidget(UserListView(onUserSelected: (_) {})));

      expect(find.byType(CommonEmptyWidget), findsOneWidget);
      expect(find.text('No Matching Users'), findsOneWidget);
    });

    testWidgets(
        'should render empty widget with no available users message when search is empty',
        (tester) async {
      when(() => mockUserBloc.state).thenReturn(
        const UserLoadedState(
          users: [],
          filteredUsers: [],
          currentPage: 1,
          totalPages: 1,
          hasReachedMax: true,
          searchQuery: '',
        ),
      );

      await tester
          .pumpWidget(makeTestableWidget(UserListView(onUserSelected: (_) {})));

      expect(find.byType(CommonEmptyWidget), findsOneWidget);
      expect(find.text('No Users Available'), findsOneWidget);
    });

    testWidgets(
        'should render loading indicator at bottom when isFetchingMore is true',
        (tester) async {
      when(() => mockUserBloc.state).thenReturn(
        const UserLoadedState(
          users: [tUser],
          filteredUsers: [tUser],
          currentPage: 1,
          totalPages: 2,
          hasReachedMax: false,
          isFetchingMore: true,
        ),
      );

      await tester
          .pumpWidget(makeTestableWidget(UserListView(onUserSelected: (_) {})));

      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });

    testWidgets(
        'should trigger RefreshUsersEvent when refresh action button in AppBar is tapped',
        (tester) async {
      when(() => mockUserBloc.state).thenReturn(
        const UserLoadedState(
          users: [tUser],
          filteredUsers: [tUser],
          currentPage: 1,
          totalPages: 1,
          hasReachedMax: true,
        ),
      );

      await tester
          .pumpWidget(makeTestableWidget(UserListView(onUserSelected: (_) {})));

      await tester.tap(find.byIcon(Icons.refresh_rounded));
      await tester.pump();

      verify(() => mockUserBloc.add(const RefreshUsersEvent())).called(1);
    });

    testWidgets('should trigger SearchUsersEvent when typing in search field',
        (tester) async {
      when(() => mockUserBloc.state).thenReturn(
        const UserLoadedState(
          users: [tUser],
          filteredUsers: [tUser],
          currentPage: 1,
          totalPages: 1,
          hasReachedMax: true,
        ),
      );

      await tester
          .pumpWidget(makeTestableWidget(UserListView(onUserSelected: (_) {})));

      await tester.enterText(
          find.byKey(const Key('search_bar_text_field')), 'John');
      await tester.pump();

      verify(() => mockUserBloc.add(const SearchUsersEvent('John'))).called(1);
    });

    testWidgets(
        'should display SnackBar when state is UserLoadedState and errorMessage is not null',
        (tester) async {
      const loadedState = UserLoadedState(
        users: [tUser],
        filteredUsers: [tUser],
        currentPage: 1,
        totalPages: 2,
        hasReachedMax: false,
        errorMessage: 'Offline error message',
      );

      whenListen(
        mockUserBloc,
        Stream.fromIterable([loadedState]),
        initialState: const UserLoadingState(),
      );

      await tester
          .pumpWidget(makeTestableWidget(UserListView(onUserSelected: (_) {})));
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Offline error message'), findsOneWidget);
    });
  });
}
