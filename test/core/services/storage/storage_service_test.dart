import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rentease/core/services/storage/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Mock class for SharedPreferences
class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late StorageService storageService;
  late MockSharedPreferences mockPrefs;

  setUp(() {
    mockPrefs = MockSharedPreferences();
    storageService = StorageService(prefs: mockPrefs);
  });

  const tKey = 'test_key';

  group('StorageService', () {
    
    group('String operations', () {
      const tValue = 'hello_world';

      test('setString should call shared_preferences and return true', () async {
        // Arrange
        when(() => mockPrefs.setString(tKey, tValue)).thenAnswer((_) async => true);
        // Act
        final result = await storageService.setString(tKey, tValue);
        // Assert
        expect(result, true);
        verify(() => mockPrefs.setString(tKey, tValue)).called(1);
      });

      test('getString should return correct value from shared_preferences', () {
        when(() => mockPrefs.getString(tKey)).thenReturn(tValue);
        final result = storageService.getString(tKey);
        expect(result, tValue);
      });
    });

    group('Int operations', () {
      const tValue = 100;

      test('setInt should save correctly', () async {
        when(() => mockPrefs.setInt(tKey, tValue)).thenAnswer((_) async => true);
        final result = await storageService.setInt(tKey, tValue);
        expect(result, true);
      });

      test('getInt should return value or null', () {
        when(() => mockPrefs.getInt(tKey)).thenReturn(null);
        expect(storageService.getInt(tKey), isNull);
      });
    });

    group('Double operations', () {
      const tValue = 19.99;

      test('setDouble should save correctly', () async {
        when(() => mockPrefs.setDouble(tKey, tValue)).thenAnswer((_) async => true);
        final result = await storageService.setDouble(tKey, tValue);
        expect(result, true);
      });
    });

    group('Bool operations', () {
      const tValue = true;

      test('setBool should save correctly', () async {
        when(() => mockPrefs.setBool(tKey, tValue)).thenAnswer((_) async => true);
        final result = await storageService.setBool(tKey, tValue);
        expect(result, true);
      });
    });

    group('StringList operations', () {
      final tValue = ['apple', 'banana'];

      test('setStringList should save correctly', () async {
        when(() => mockPrefs.setStringList(tKey, tValue)).thenAnswer((_) async => true);
        final result = await storageService.setStringList(tKey, tValue);
        expect(result, true);
      });
    });

    group('Utility operations', () {
      test('containsKey should return boolean from prefs', () {
        when(() => mockPrefs.containsKey(tKey)).thenReturn(true);
        expect(storageService.containsKey(tKey), true);
      });

      test('remove should remove specific key', () async {
        when(() => mockPrefs.remove(tKey)).thenAnswer((_) async => true);
        final result = await storageService.remove(tKey);
        expect(result, true);
        verify(() => mockPrefs.remove(tKey)).called(1);
      });

      test('clear should wipe all data', () async {
        when(() => mockPrefs.clear()).thenAnswer((_) async => true);
        final result = await storageService.clear();
        expect(result, true);
        verify(() => mockPrefs.clear()).called(1);
      });
    });
  });
}