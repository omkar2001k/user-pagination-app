import 'package:flutter_test/flutter_test.dart';
import 'package:user_pagination_app/core/errors/exceptions.dart';
import 'package:user_pagination_app/core/errors/failures.dart';

void main() {
  group('Exceptions Tests', () {
    test('ServerException toString and fields', () {
      const exception = ServerException(message: 'Server error', statusCode: 500);
      expect(exception.message, 'Server error');
      expect(exception.statusCode, 500);
      expect(exception.toString(), 'ServerException(message: Server error, statusCode: 500)');
    });

    test('CacheException toString and fields', () {
      const exception = CacheException(message: 'Cache failure');
      expect(exception.message, 'Cache failure');
      expect(exception.toString(), 'CacheException(message: Cache failure)');
    });

    test('NetworkException toString and fields', () {
      const exception = NetworkException(message: 'No net');
      const defaultException = NetworkException();
      expect(exception.message, 'No net');
      expect(defaultException.message, 'No Internet Connection');
      expect(exception.toString(), 'NetworkException(message: No net)');
    });

    test('TimeoutException toString and fields', () {
      const exception = TimeoutException(message: 'Timed out');
      const defaultException = TimeoutException();
      expect(exception.message, 'Timed out');
      expect(defaultException.message, 'Connection timed out. Please try again.');
      expect(exception.toString(), 'TimeoutException(message: Timed out)');
    });
  });

  group('Failures Tests', () {
    test('ServerFailure props and default message', () {
      const failure = ServerFailure('Custom error');
      const defaultFailure = ServerFailure();
      expect(failure.props, ['Custom error']);
      expect(defaultFailure.message, 'Server Error Occurred. Please try again later.');
      expect(failure, isA<Failure>());
    });

    test('CacheFailure props and default message', () {
      const failure = CacheFailure('Cache failed');
      const defaultFailure = CacheFailure();
      expect(failure.props, ['Cache failed']);
      expect(defaultFailure.message, 'Cache Read/Write Failure.');
    });

    test('NetworkFailure props and default message', () {
      const failure = NetworkFailure('No network');
      const defaultFailure = NetworkFailure();
      expect(failure.props, ['No network']);
      expect(defaultFailure.message, 'No Internet Connection. Displaying cached data if available.');
    });

    test('TimeoutFailure props and default message', () {
      const failure = TimeoutFailure('Request timeout');
      const defaultFailure = TimeoutFailure();
      expect(failure.props, ['Request timeout']);
      expect(defaultFailure.message, 'Request timed out. Please check your connection and try again.');
    });
  });
}
