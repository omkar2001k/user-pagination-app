import 'package:user_pagination_app/modules/user/data/models/user_model.dart';
import 'package:user_pagination_app/modules/user/domain/entities/user_entity.dart';

class UserMapper {
  /// Maps a [UserModel] DTO to a non-nullable [UserEntity] domain model with explicit null fallback handling.
  static UserEntity toEntity(UserModel? model) {
    final idVal = model?.id ?? 0;
    final synthPhone = '+1 (555) 019-${(1000 + idVal).toString()}';

    return UserEntity(
      id: idVal,
      email: model?.email ?? '',
      firstName: model?.firstName ?? '',
      lastName: model?.lastName ?? '',
      avatar: model?.avatar ?? '',
      phone: model?.phone ?? synthPhone,
    );
  }

  /// Maps a [UserEntity] domain model back to a [UserModel] data transfer object.
  static UserModel toModel(UserEntity? entity) {
    return UserModel(
      id: entity?.id ?? 0,
      email: entity?.email ?? '',
      firstName: entity?.firstName ?? '',
      lastName: entity?.lastName ?? '',
      avatar: entity?.avatar ?? '',
      phone: entity?.phone ?? '',
    );
  }

  /// Maps a list of [UserModel]s to a list of [UserEntity] domain entities with null safety.
  static List<UserEntity> toEntityList(List<UserModel>? models) {
    if (models == null || models.isEmpty) {
      return [];
    }
    return models.map(toEntity).toList();
  }

  /// Maps a list of [UserEntity] domain entities to a list of [UserModel]s.
  static List<UserModel> toModelList(List<UserEntity>? entities) {
    if (entities == null || entities.isEmpty) {
      return [];
    }
    return entities.map(toModel).toList();
  }
}
