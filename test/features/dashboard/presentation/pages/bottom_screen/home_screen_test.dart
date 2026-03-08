// import 'package:dartz/dartz.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:rentease/features/auth/presentation/state/auth_state.dart';
// import 'package:rentease/features/auth/presentation/view_model/auth_view_model.dart';
// import 'package:rentease/features/dashboard/domain/entities/property_entity.dart';
// import 'package:rentease/features/dashboard/domain/usecases/get_all_property_usecase.dart';
// import 'package:rentease/features/dashboard/domain/usecases/get_property_byid_usecase.dart';
// import 'package:rentease/features/dashboard/presentation/pages/bottom_screen/home_screen.dart';
// import 'package:rentease/widgets/best_offer_card.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class MockGetAllPropertyUsecase extends Mock implements GetAllPropertyUsecase {}

// class MockGetPropertyByidUsecase extends Mock implements GetPropertyByidUsecase {}

// // Mock AuthViewModel for HomeHeader
// class MockAuthViewModel extends Mock implements AuthViewModel {
//   @override
//   AuthState get state => const AuthState(); // return empty/default user
// }

// void main() {
//   late MockGetAllPropertyUsecase mockGetAllPropertyUsecase;
//   late MockGetPropertyByidUsecase mockGetPropertyByidUsecase;

//   setUpAll(() async {
//     registerFallbackValue(const GetPropertyByIdParams(propertyId: 'fallback'));
//     SharedPreferences.setMockInitialValues({}); // mock prefs
//   });

//   setUp(() {
//     mockGetAllPropertyUsecase = MockGetAllPropertyUsecase();
//     mockGetPropertyByidUsecase = MockGetPropertyByidUsecase();
//   });

//   final tProperties = [
//     const PropertyEntity(
//       propertyId: '1',
//       title: 'Luxury Villa',
//       city: 'Kathmandu',
//       address: 'Kalanki',
//       propertyType: 'HOUSE',
//       bhk: '2BHK',
//       price: 5000,
//       propertyImages: ["/test.jpg"],
//       description: 'Test Description',
//     ),
//     const PropertyEntity(
//       propertyId: '2',
//       title: 'Modern Apartment',
//       city: 'Pokhara',
//       address: 'Lakeside',
//       propertyType: 'APARTMENT',
//       bhk: '1BHK',
//       price: 2000,
//       propertyImages: ["/test2.jpg"],
//       description: 'Test Description 2',
//     ),
//   ];

//   testWidgets('HomeScreen displays property cards when loaded', (tester) async {
//     // Arrange: stub the usecase
//     when(() => mockGetAllPropertyUsecase()).thenAnswer((_) async => Right(tProperties));

//     // Build the widget with provider overrides
//     await tester.pumpWidget(
//       ProviderScope(
//         overrides: [
//           getAllPropertyUsecaseProvider.overrideWithValue(mockGetAllPropertyUsecase),
//           getPropertyByidUsecaseProvider.overrideWithValue(mockGetPropertyByidUsecase),
//           authViewModelProvider.overrideWith(() => MockAuthViewModel())
//         ],
//         child: const MaterialApp(home: HomeScreen()),
//       ),
//     );

//     // Allow all async microtasks and rebuilds
//     await tester.pump();
//     await tester.pumpAndSettle();

//     // Assert: property titles should appear
//     expect(find.text('Luxury Villa'), findsOneWidget);
//     expect(find.text('Modern Apartment'), findsOneWidget);

//     // Optionally, check that GridView and BestOfferCards exist
//     expect(find.byType(GridView), findsOneWidget);
//     expect(find.byType(BestOfferCard), findsNWidgets(2));
//   });
// }