import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:user_pagination_app/modules/user/domain/entities/user_entity.dart';
import 'package:user_pagination_app/modules/user/presentation/pages/user_detail_page.dart';
import 'package:user_pagination_app/modules/user/presentation/pages/user_list_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'user_list',
        builder: (context, state) => const UserListPage(),
      ),
      GoRoute(
        path: '/details',
        name: 'user_detail',
        builder: (context, state) {
          final user = state.extra as UserEntity;
          return UserDetailPage(user: user);
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.error}'),
      ),
    ),
  );
}
