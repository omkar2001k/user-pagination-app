import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:user_pagination_app/core/network/network_info.dart';

class MockConnectivity extends Mock implements Connectivity {}

void main() {
  late NetworkInfoImpl networkInfo;
  late MockConnectivity mockConnectivity;

  setUp(() {
    mockConnectivity = MockConnectivity();
    networkInfo = NetworkInfoImpl(mockConnectivity);
  });

  group('isConnected', () {
    test('should return true when connectivity is wifi or mobile', () async {
      when(() => mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => [ConnectivityResult.wifi]);

      final result = await networkInfo.isConnected;

      verify(() => mockConnectivity.checkConnectivity()).called(1);
      expect(result, isTrue);
    });

    test('should return false when connectivity result contains none', () async {
      when(() => mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => [ConnectivityResult.none]);

      final result = await networkInfo.isConnected;

      verify(() => mockConnectivity.checkConnectivity()).called(1);
      expect(result, isFalse);
    });
  });
}
