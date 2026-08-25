import 'package:flutter_test/flutter_test.dart';
import 'package:user_pagination_app/modules/user/data/models/user_model.dart';
import 'package:user_pagination_app/modules/user/domain/entities/user_entity.dart';

void main() {
  const tUserModel = UserModel(
    id: 1,
    email: 'george.bluth@reqres.in',
    firstName: 'George',
    lastName: 'Bluth',
    avatar: 'https://reqres.in/img/faces/1-image.jpg',
    phone: '+1 (555) 019-1001',
  );

  group('UserModel Tests', () {
    test('should be a subclass of UserEntity', () {
      expect(tUserModel, isA<UserEntity>());
    });

    test('should return a valid model from JSON', () {
      final Map<String, dynamic> jsonMap = {
        'id': 1,
        'email': 'george.bluth@reqres.in',
        'first_name': 'George',
        'last_name': 'Bluth',
        'avatar': 'https://reqres.in/img/faces/1-image.jpg',
      };

      final result = UserModel.fromJson(jsonMap);

      expect(result.id, 1);
      expect(result.email, 'george.bluth@reqres.in');
      expect(result.firstName, 'George');
      expect(result.lastName, 'Bluth');
      expect(result.fullName, 'George Bluth');
      expect(result.initials, 'GB');
      expect(result.avatar, 'https://reqres.in/img/faces/1-image.jpg');
    });

    test('should return a JSON map containing proper data from model', () {
      final jsonMap = tUserModel.toJson();

      final expectedMap = {
        'id': 1,
        'email': 'george.bluth@reqres.in',
        'first_name': 'George',
        'last_name': 'Bluth',
        'avatar': 'https://reqres.in/img/faces/1-image.jpg',
        'phone': '+1 (555) 019-1001',
      };

      expect(jsonMap, expectedMap);
    });

    test('should convert to and from UserEntity cleanly', () {
      const entity = UserEntity(
        id: 2,
        email: 'janet.weaver@reqres.in',
        firstName: 'Janet',
        lastName: 'Weaver',
        avatar: 'https://reqres.in/img/faces/2-image.jpg',
        phone: '+1 (555) 019-1002',
      );

      final modelFromEntity = UserModel.fromEntity(entity);
      expect(modelFromEntity.id, 2);
      expect(modelFromEntity.toEntity(), entity);
    });
  });
}
