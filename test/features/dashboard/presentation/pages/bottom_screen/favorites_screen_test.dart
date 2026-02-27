import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:rentease/core/services/storage/user_session_service.dart';
import 'package:rentease/features/dashboard/presentation/pages/bottom_screen/favorites_screen.dart';
import 'package:rentease/features/favourites/domain/entities/favourite_entity.dart';
import 'package:rentease/features/favourites/domain/usecases/get_all_favourite_usecase.dart';
import 'package:rentease/features/favourites/domain/usecases/toggle_favourite_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';


// Mock UseCases - Teacher Style
class MockGetAllFavouritesUsecase extends Mock implements GetAllFavouritesUsecase {}
class MockToggleFavouriteUsecase extends Mock implements ToggleFavouriteUsecase {}

void main() {
  late MockGetAllFavouritesUsecase mockGetAllFavouritesUsecase;
  late MockToggleFavouriteUsecase mockToggleFavouriteUsecase;
  late SharedPreferences sharedPreferences;

  const tFavourite = FavouriteEntity(
    favouriteId: '1',
    propertyId: 'prop123',
    propertyTitle: 'Luxury Villa',
    propertyImages: ['/villa.jpg'], 
    userId: '1',
  );

  setUpAll(() async {
    // 1. Initialize SharedPreferences with empty mock values
    SharedPreferences.setMockInitialValues({});
    sharedPreferences = await SharedPreferences.getInstance();
    
    // Fallback values for complex parameters if needed
    // registerFallbackValue(...);
  });

  setUp(() {
    mockGetAllFavouritesUsecase = MockGetAllFavouritesUsecase();
    mockToggleFavouriteUsecase = MockToggleFavouriteUsecase();

    // Setup default mock responses
    when(() => mockGetAllFavouritesUsecase.call())
        .thenAnswer((_) async => const Right([tFavourite]));
    
    when(() => mockToggleFavouriteUsecase.call(any()))
        .thenAnswer((_) async => const Right(true));
  });

  Widget createTestWidget() {
    return ProviderScope(
      overrides: [
        // Overriding the UseCase providers instead of the ViewModel
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        getAllFavouritesUsecaseProvider.overrideWithValue(mockGetAllFavouritesUsecase),
        toggleFavouriteUsecaseProvider.overrideWithValue(mockToggleFavouriteUsecase),
      ],
      child: const MaterialApp(
        home: FavouritesScreen(),
      ),
    );
  }

  group('FavouritesScreen - UI Elements', () {
    testWidgets('should display AppBar with title My Wishlist', (tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.text('My Wishlist'), findsOneWidget);
        expect(find.byType(AppBar), findsOneWidget);
      });
    });

    testWidgets('should display property title in the card', (tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.text('Luxury Villa'), findsOneWidget);
      });
    });

    testWidgets('should display View details button', (tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.text('View details'), findsOneWidget);
      });
    });
  });

  group('FavouritesScreen - Empty State', () {
    testWidgets('should show empty wishlist message when list is empty', (tester) async {
      // Return empty list for this specific test
      when(() => mockGetAllFavouritesUsecase.call())
          .thenAnswer((_) async => const Right([]));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Your wishlist is empty'), findsOneWidget);
      expect(find.byIcon(Icons.favorite_rounded), findsWidgets);
    });
  });

  group('FavouritesScreen - Actions', () {
    testWidgets('should call toggleFavourite usecase when heart icon is pressed', (tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Find and tap the favorite toggle icon
        final favoriteButton = find.byIcon(Icons.favorite_rounded).last;
        await tester.tap(favoriteButton);
        await tester.pump();

        // Verify the usecase was triggered
        verify(() => mockToggleFavouriteUsecase.call('prop123')).called(1);
      });
    });
  });

  group('FavouritesScreen - Layout', () {
    testWidgets('should use a ListView to display items', (tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.byType(ListView), findsOneWidget);
      });
    });

    testWidgets('should contain RefreshIndicator for pull-to-refresh', (tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.byType(RefreshIndicator), findsOneWidget);
      });
    });
  });
}