import 'package:user_pagination_app/modules/user/data/models/user_model.dart';
import 'package:user_pagination_app/modules/user/domain/entities/user_entity.dart';

class UserMapper {
  /// Maps a [UserModel] data transfer object to a [UserEntity] domain model.
  static UserEntity toEntity(UserModel model) {
    return UserEntity(
      id: model.id,
      email: model.email,
      firstName: model.firstName,
      lastName: model.lastName,
      avatar: model.avatar,
      phone: model.phone,
    );
  }

  /// Maps a [UserEntity] domain model back to a [UserModel] data transfer object.
  static UserModel toModel(UserEntity entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      firstName: entity.firstName,
      lastName: entity.lastName,
      avatar: entity.avatar,
      phone: entity.phone,
    );
  }

  /// Maps a list of [UserModel]s to a list of [UserEntity] domain entities.
  static List<UserEntity> toEntityList(List<UserModel> models) {
    return models.map(toEntity).toList();
  }

  /// Maps a list of [UserEntity] domain entities to a list of [UserModel]s.
  static List<UserModel> toModelList(List<UserEntity> entities) {
    return entities.map(toModel).toList();
  }
}
