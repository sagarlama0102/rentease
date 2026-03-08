import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rentease/core/services/storage/user_session_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late UserSessionService userSessionService;
  late MockSharedPreferences mockPrefs;

  setUp(() {
    mockPrefs = MockSharedPreferences();
    userSessionService = UserSessionService(prefs: mockPrefs);
  });

  // Test data constants
  const tUserId = 'user_123';
  const tEmail = 'test@example.com';
  const tUsername = 'testuser';
  const tFirstName = 'John';
  const tLastName = 'Doe';
  const tPhoneNumber = '+1234567890';
  const tProfilePicture = 'https://example.com/profile.jpg';

  // Keys (matching your project's private static constants)
  const keyIsLoggedIn = 'is_logged_in';
  const keyUserId = 'user_id';
  const keyUserEmail = 'user_email';
  const keyUsername = 'username';
  const keyUserFirstName = 'user_first_name';
  const keyUserLastName = 'user_last_name';
  const keyUserPhoneNumber = 'user_phone_number';
  const keyUserProfilePicture = 'user_profile_picture';

  group('UserSessionService', () {
    group('saveUserSession', () {
      test('should save all required and provided optional user session data', () async {
        // Arrange
        when(() => mockPrefs.setBool(any(), any())).thenAnswer((_) async => true);
        when(() => mockPrefs.setString(any(), any())).thenAnswer((_) async => true);

        // Act
        await userSessionService.saveUserSession(
          userId: tUserId,
          email: tEmail,
          username: tUsername,
          firstName: tFirstName,
          lastName: tLastName,
          phoneNumber: tPhoneNumber,
          profilePicture: tProfilePicture,
        );

        // Assert
        verify(() => mockPrefs.setBool(keyIsLoggedIn, true)).called(1);
        verify(() => mockPrefs.setString(keyUserId, tUserId)).called(1);
        verify(() => mockPrefs.setString(keyUserEmail, tEmail)).called(1);
        verify(() => mockPrefs.setString(keyUserFirstName, tFirstName)).called(1);
        verify(() => mockPrefs.setString(keyUserPhoneNumber, tPhoneNumber)).called(1);
        verify(() => mockPrefs.setString(keyUserProfilePicture, tProfilePicture)).called(1);
      });

      test('should not save optional fields when they are null', () async {
        // Arrange
        when(() => mockPrefs.setBool(any(), any())).thenAnswer((_) async => true);
        when(() => mockPrefs.setString(any(), any())).thenAnswer((_) async => true);

        // Act
        await userSessionService.saveUserSession(
          userId: tUserId,
          email: tEmail,
          username: tUsername,
          firstName: tFirstName,
          lastName: tLastName,
          phoneNumber: null, // Null optional field
          profilePicture: null, // Null optional field
        );

        // Assert
        verifyNever(() => mockPrefs.setString(keyUserPhoneNumber, any()));
        verifyNever(() => mockPrefs.setString(keyUserProfilePicture, any()));
      });
    });

    group('Getters', () {
      test('isLoggedIn should return true when stored value is true', () {
        when(() => mockPrefs.getBool(keyIsLoggedIn)).thenReturn(true);
        expect(userSessionService.isLoggedIn(), true);
      });

      test('isLoggedIn should return false when key does not exist (null)', () {
        when(() => mockPrefs.getBool(keyIsLoggedIn)).thenReturn(null);
        expect(userSessionService.isLoggedIn(), false);
      });

      test('getUserId should return the correct string', () {
        when(() => mockPrefs.getString(keyUserId)).thenReturn(tUserId);
        expect(userSessionService.getUserId(), tUserId);
      });
    });

    group('clearUserSession', () {
      test('should remove every single session key from storage', () async {
        // Arrange
        when(() => mockPrefs.remove(any())).thenAnswer((_) async => true);

        // Act
        await userSessionService.clearUserSession();

        // Assert
        verify(() => mockPrefs.remove(keyIsLoggedIn)).called(1);
        verify(() => mockPrefs.remove(keyUserId)).called(1);
        verify(() => mockPrefs.remove(keyUserEmail)).called(1);
        verify(() => mockPrefs.remove(keyUserProfilePicture)).called(1);
        verify(() => mockPrefs.remove(keyUsername)).called(1);
      });
    });
  });
}