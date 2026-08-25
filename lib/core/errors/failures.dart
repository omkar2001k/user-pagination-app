import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server Error Occurred. Please try again later.']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Cache Read/Write Failure.']);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No Internet Connection. Displaying cached data if available.']);
}

class TimeoutFailure extends Failure {
  const TimeoutFailure([super.message = 'Request timed out. Please check your connection and try again.']);
}
