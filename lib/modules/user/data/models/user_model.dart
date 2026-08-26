import 'package:equatable/equatable.dart';
import 'package:user_pagination_app/modules/user/data/mappers/user_mapper.dart';
import 'package:user_pagination_app/modules/user/domain/entities/user_entity.dart';

class UserModel extends Equatable {
  final int? id;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? avatar;
  final String? phone;

  const UserModel({
    this.id,
    this.email,
    this.firstName,
    this.lastName,
    this.avatar,
    this.phone,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final idRaw = json['id'];
    final idVal = idRaw is int
        ? idRaw
        : int.tryParse(idRaw?.toString() ?? '');

    return UserModel(
      id: idVal,
      email: json['email']?.toString(),
      firstName: json['first_name']?.toString(),
      lastName: json['last_name']?.toString(),
      avatar: json['avatar']?.toString(),
      phone: json['phone']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (email != null) 'email': email,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (avatar != null) 'avatar': avatar,
      if (phone != null) 'phone': phone,
    };
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserMapper.toModel(entity);
  }

  UserEntity toEntity() {
    return UserMapper.toEntity(this);
  }

  @override
  List<Object?> get props => [id, email, firstName, lastName, avatar, phone];
}
