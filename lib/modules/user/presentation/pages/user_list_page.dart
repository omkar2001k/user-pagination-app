import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/services/service_locator.dart';
import '../bloc/user_bloc.dart';
import '../bloc/user_event.dart';
import '../views/user_list_view.dart';

class UserListPage extends StatelessWidget {
  const UserListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserBloc>(
      create: (context) =>
          serviceLocator<UserBloc>()..add(const FetchUsersEvent()),
      child: UserListView(
        onUserSelected: (user) {
          context.push('/details', extra: user);
        },
      ),
    );
  }
}
