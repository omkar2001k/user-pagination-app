import 'package:flutter/material.dart';
import 'package:user_pagination_app/modules/user/domain/entities/user_entity.dart';
import 'package:user_pagination_app/modules/user/presentation/views/user_detail_view.dart';

class UserDetailPage extends StatelessWidget {
  final UserEntity user;

  const UserDetailPage({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return UserDetailView(
      user: user,
      onBack: () => Navigator.of(context).pop(),
    );
  }
}
