import 'package:user_pagination_app/modules/user/data/models/user_model.dart';

class UserPaginatedResponseModel {
  final int page;
  final int perPage;
  final int total;
  final int totalPages;
  final List<UserModel> users;

  const UserPaginatedResponseModel({
    required this.page,
    required this.perPage,
    required this.total,
    required this.totalPages,
    required this.users,
  });

  factory UserPaginatedResponseModel.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'] as List<dynamic>? ?? [];
    final usersList = rawData
        .map((item) => UserModel.fromJson(item as Map<String, dynamic>))
        .toList();

    return UserPaginatedResponseModel(
      page: json['page'] is int ? json['page'] as int : 1,
      perPage: json['per_page'] is int ? json['per_page'] as int : 10,
      total: json['total'] is int ? json['total'] as int : usersList.length,
      totalPages: json['total_pages'] is int ? json['total_pages'] as int : 1,
      users: usersList,
    );
  }
}
