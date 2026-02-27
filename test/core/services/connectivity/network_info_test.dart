import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rentease/core/services/connectivity/network_info.dart';

// Mock class for the Connectivity plugin
class MockConnectivity extends Mock implements Connectivity {}

void main() {
  late NetworkInfo networkInfo;
  late MockConnectivity mockConnectivity;

  setUp(() {
    mockConnectivity = MockConnectivity();
    networkInfo = NetworkInfo(mockConnectivity);
  });

  group('NetworkInfo', () {
    group('isConnected', () {
      test('should return true when WiFi is connected', () async {
        // Arrange
        when(() => mockConnectivity.checkConnectivity())
            .thenAnswer((_) async => [ConnectivityResult.wifi]);

        // Act
        final result = await networkInfo.isConnected;

        // Assert
        expect(result, true);
        verify(() => mockConnectivity.checkConnectivity()).called(1);
      });

      test('should return true when Mobile Data is connected', () async {
        // Arrange
        when(() => mockConnectivity.checkConnectivity())
            .thenAnswer((_) async => [ConnectivityResult.mobile]);

        // Act
        final result = await networkInfo.isConnected;

        // Assert
        expect(result, true);
      });

      test('should return false when connectivity result is none', () async {
        // Arrange
        when(() => mockConnectivity.checkConnectivity())
            .thenAnswer((_) async => [ConnectivityResult.none]);

        // Act
        final result = await networkInfo.isConnected;

        // Assert
        expect(result, false);
      });

      test('should return true when multiple connections are available (WiFi + VPN)', () async {
        // Arrange
        // New versions of connectivity_plus return a list
        when(() => mockConnectivity.checkConnectivity())
            .thenAnswer((_) async => [ConnectivityResult.wifi, ConnectivityResult.vpn]);

        // Act
        final result = await networkInfo.isConnected;

        // Assert
        expect(result, true);
      });
    });

    group('Interface check', () {
      test('should be an instance of INetworkInfo', () {
        expect(networkInfo, isA<INetworkInfo>());
      });
    });
  });
}