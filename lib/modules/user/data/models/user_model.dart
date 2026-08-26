import 'package:user_pagination_app/modules/user/data/mappers/user_mapper.dart';
import 'package:user_pagination_app/modules/user/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.firstName,
    required super.lastName,
    required super.avatar,
    super.phone,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final idVal = json['id'] is int ? json['id'] as int : int.parse(json['id'].toString());
    final synthPhone = '+1 (555) 019-${(1000 + idVal).toString()}';

    return UserModel(
      id: idVal,
      email: json['email']?.toString() ?? '',
      firstName: json['first_name']?.toString() ?? '',
      lastName: json['last_name']?.toString() ?? '',
      avatar: json['avatar']?.toString() ?? '',
      phone: json['phone']?.toString() ?? synthPhone,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'avatar': avatar,
      'phone': phone,
    };
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserMapper.toModel(entity);
  }

  UserEntity toEntity() {
    return UserMapper.toEntity(this);
  }
}
