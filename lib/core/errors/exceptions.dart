class ServerException implements Exception {
  final String message;
  final int? statusCode;

  const ServerException({
    required this.message,
    this.statusCode,
  });

  @override
  String toString() => 'ServerException(message: $message, statusCode: $statusCode)';
}

class CacheException implements Exception {
  final String message;

  const CacheException({required this.message});

  @override
  String toString() => 'CacheException(message: $message)';
}

class NetworkException implements Exception {
  final String message;

  const NetworkException({this.message = 'No Internet Connection'});

  @override
  String toString() => 'NetworkException(message: $message)';
}

class TimeoutException implements Exception {
  final String message;

  const TimeoutException({this.message = 'Connection timed out. Please try again.'});

  @override
  String toString() => 'TimeoutException(message: $message)';
}
