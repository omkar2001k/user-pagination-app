import 'dart:async' as async;
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:user_pagination_app/core/constants/api_constants.dart';
import 'package:user_pagination_app/core/errors/exceptions.dart';
import 'package:user_pagination_app/modules/user/data/models/user_paginated_response_model.dart';

abstract class UserRemoteDataSource {
  Future<UserPaginatedResponseModel> getUsers({
    required int page,
    required int perPage,
  });
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final http.Client client;

  UserRemoteDataSourceImpl({required this.client});

  @override
  Future<UserPaginatedResponseModel> getUsers({
    required int page,
    required int perPage,
  }) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.usersEndpoint}?page=$page&per_page=$perPage');

    try {
      final response = await client
          .get(uri, headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          })
          .timeout(ApiConstants.timeoutDuration);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonMap = jsonDecode(response.body);
        return UserPaginatedResponseModel.fromJson(jsonMap);
      } else {
        throw ServerException(
          message: 'Server returned error status: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on async.TimeoutException {
      throw const TimeoutException(message: 'Connection timed out while fetching users.');
    } on SocketException {
      throw const NetworkException(message: 'No Internet Connection.');
    } on FormatException {
      throw const ServerException(message: 'Invalid response format from server.');
    } catch (e) {
      if (e is ServerException || e is TimeoutException || e is NetworkException) {
        rethrow;
      }
      throw ServerException(message: 'Unexpected network error: $e');
    }
  }
}
