import 'dart:convert';
import 'package:hive/hive.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';

abstract class UserLocalDataSource {
  Future<List<UserModel>> getCachedUsers();
  Future<void> cacheUsers(List<UserModel> users);
  Future<void> clearCache();
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final Box box;

  UserLocalDataSourceImpl({required this.box});

  @override
  Future<List<UserModel>> getCachedUsers() async {
    try {
      final rawData = box.get(ApiConstants.cachedUsersKey);
      if (rawData != null && rawData is List) {
        return rawData.map((item) {
          if (item is Map) {
            return UserModel.fromJson(Map<String, dynamic>.from(item));
          } else if (item is String) {
            return UserModel.fromJson(jsonDecode(item) as Map<String, dynamic>);
          }
          throw const CacheException(message: 'Invalid cache element type');
        }).toList();
      }
      return [];
    } catch (e) {
      throw CacheException(message: 'Failed to retrieve cached users: $e');
    }
  }

  @override
  Future<void> cacheUsers(List<UserModel> users) async {
    try {
      final jsonList = users.map((u) => u.toJson()).toList();
      await box.put(ApiConstants.cachedUsersKey, jsonList);
    } catch (e) {
      throw CacheException(message: 'Failed to cache users: $e');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await box.delete(ApiConstants.cachedUsersKey);
    } catch (e) {
      throw CacheException(message: 'Failed to clear cache: $e');
    }
  }
}
