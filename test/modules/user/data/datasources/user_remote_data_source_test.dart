import 'dart:async' as async;
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:user_pagination_app/core/errors/exceptions.dart' as app_exceptions;
import 'package:user_pagination_app/modules/user/data/datasources/user_remote_data_source.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late UserRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUpAll(() {
    registerFallbackValue(Uri());
  });

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = UserRemoteDataSourceImpl(client: mockHttpClient);
  });

  const tPage = 1;
  const tPerPage = 10;
  const tJsonResponse = '''
  {
    "page": 1,
    "per_page": 10,
    "total": 12,
    "total_pages": 2,
    "data": [
      {
        "id": 1,
        "email": "george.bluth@reqres.in",
        "first_name": "George",
        "last_name": "Bluth",
        "avatar": "https://reqres.in/img/faces/1-image.jpg"
      }
    ]
  }
  ''';

  group('UserRemoteDataSource Tests', () {
    test('should perform GET request on specified URL with correct parameters', () async {
      when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response(tJsonResponse, 200));

      final result = await dataSource.getUsers(page: tPage, perPage: tPerPage);

      expect(result.page, 1);
      expect(result.users.length, 1);
      expect(result.users.first.firstName, 'George');
      verify(() => mockHttpClient.get(
            Uri.parse('https://reqres.in/api/users?page=1&per_page=10'),
            headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
          )).called(1);
    });

    test('should throw ServerException when response code is non-200', () async {
      when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response('Server Error', 500));

      final call = dataSource.getUsers(page: tPage, perPage: tPerPage);

      expect(() => call, throwsA(isA<app_exceptions.ServerException>()));
    });

    test('should throw TimeoutException when request times out', () async {
      when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
          .thenThrow(async.TimeoutException('Connection timed out', const Duration(seconds: 1)));

      final call = dataSource.getUsers(page: tPage, perPage: tPerPage);

      expect(() => call, throwsA(isA<app_exceptions.TimeoutException>()));
    });

    test('should throw NetworkException on SocketException', () async {
      when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
          .thenThrow(const SocketException('No internet'));

      final call = dataSource.getUsers(page: tPage, perPage: tPerPage);

      expect(() => call, throwsA(isA<app_exceptions.NetworkException>()));
    });

    test('should throw ServerException on FormatException', () async {
      when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response('Invalid JSON format', 200));

      final call = dataSource.getUsers(page: tPage, perPage: tPerPage);

      expect(() => call, throwsA(isA<app_exceptions.ServerException>()));
    });

    test('should throw ServerException on generic error', () async {
      when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
          .thenThrow(Exception('Unknown error'));

      final call = dataSource.getUsers(page: tPage, perPage: tPerPage);

      expect(() => call, throwsA(isA<app_exceptions.ServerException>()));
    });
  });
}
