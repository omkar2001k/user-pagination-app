import 'package:flutter_test/flutter_test.dart';
import 'package:user_pagination_app/modules/user/data/mappers/user_mapper.dart';
import 'package:user_pagination_app/modules/user/data/models/user_model.dart';
import 'package:user_pagination_app/modules/user/domain/entities/user_entity.dart';

void main() {
  const tModel = UserModel(
    id: 1,
    email: 'george.bluth@reqres.in',
    firstName: 'George',
    lastName: 'Bluth',
    avatar: 'https://reqres.in/img/faces/1-image.jpg',
    phone: '+1 (555) 019-1001',
  );

  const tEntity = UserEntity(
    id: 1,
    email: 'george.bluth@reqres.in',
    firstName: 'George',
    lastName: 'Bluth',
    avatar: 'https://reqres.in/img/faces/1-image.jpg',
    phone: '+1 (555) 019-1001',
  );

  group('UserMapper', () {
    test('toEntity should map UserModel to UserEntity accurately', () {
      final result = UserMapper.toEntity(tModel);
      expect(result, equals(tEntity));
      expect(result.id, equals(1));
      expect(result.email, equals('george.bluth@reqres.in'));
      expect(result.firstName, equals('George'));
      expect(result.lastName, equals('Bluth'));
      expect(result.avatar, equals('https://reqres.in/img/faces/1-image.jpg'));
      expect(result.phone, equals('+1 (555) 019-1001'));
    });

    test('toModel should map UserEntity to UserModel accurately', () {
      final result = UserMapper.toModel(tEntity);
      expect(result.id, equals(tModel.id));
      expect(result.email, equals(tModel.email));
      expect(result.firstName, equals(tModel.firstName));
      expect(result.lastName, equals(tModel.lastName));
      expect(result.avatar, equals(tModel.avatar));
      expect(result.phone, equals(tModel.phone));
    });

    test('toEntityList should map list of UserModel to list of UserEntity', () {
      final result = UserMapper.toEntityList([tModel]);
      expect(result, isA<List<UserEntity>>());
      expect(result.length, equals(1));
      expect(result.first, equals(tEntity));
    });

    test('toModelList should map list of UserEntity to list of UserModel', () {
      final result = UserMapper.toModelList([tEntity]);
      expect(result, isA<List<UserModel>>());
      expect(result.length, equals(1));
      expect(result.first.id, equals(tEntity.id));
    });
  });
}
