import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rentease/core/services/storage/token_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Mock the dependency
class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late TokenService tokenService;
  late MockSharedPreferences mockPrefs;

  setUp(() {
    mockPrefs = MockSharedPreferences();
    tokenService = TokenService(prefs: mockPrefs);
  });

  const tToken = 'test_auth_token_123';
  const tokenKey = 'auth_token'; // This must match the private _tokenKey in your class

  group('TokenService', () {
    
    group('saveToken', () {
      test('should save token to SharedPreferences using the correct key', () async {
        // Arrange
        when(() => mockPrefs.setString(tokenKey, tToken))
            .thenAnswer((_) async => true);

        // Act
        await tokenService.saveToken(tToken);

        // Assert
        verify(() => mockPrefs.setString(tokenKey, tToken)).called(1);
      });
    });

    group('getToken', () {
      test('should return token from SharedPreferences when it exists', () {
        // Arrange
        when(() => mockPrefs.getString(tokenKey)).thenReturn(tToken);

        // Act
        final result = tokenService.getToken();

        // Assert
        expect(result, tToken);
        verify(() => mockPrefs.getString(tokenKey)).called(1);
      });

      test('should return null when no token is stored', () {
        // Arrange
        when(() => mockPrefs.getString(tokenKey)).thenReturn(null);

        // Act
        final result = tokenService.getToken();

        // Assert
        expect(result, isNull);
      });
    });

    group('removeToken', () {
      test('should call remove with the correct key', () async {
        // Arrange
        when(() => mockPrefs.remove(tokenKey)).thenAnswer((_) async => true);

        // Act
        await tokenService.removeToken();

        // Assert
        verify(() => mockPrefs.remove(tokenKey)).called(1);
      });
    });

    group('token lifecycle', () {
      test('should successfully handle a full save/get/remove cycle', () async {
        // Arrange
        when(() => mockPrefs.setString(tokenKey, any())).thenAnswer((_) async => true);
        when(() => mockPrefs.getString(tokenKey)).thenReturn(tToken);
        when(() => mockPrefs.remove(tokenKey)).thenAnswer((_) async => true);

        // Act & Assert
        await tokenService.saveToken(tToken);
        final retrieved = tokenService.getToken();
        await tokenService.removeToken();

        expect(retrieved, tToken);
        verify(() => mockPrefs.setString(tokenKey, tToken)).called(1);
        verify(() => mockPrefs.remove(tokenKey)).called(1);
      });
    });
  });
}