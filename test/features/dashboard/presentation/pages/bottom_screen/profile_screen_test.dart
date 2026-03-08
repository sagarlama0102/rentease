// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:network_image_mock/network_image_mock.dart';
// import 'package:rentease/features/auth/domain/entities/auth_entity.dart';
// import 'package:rentease/features/auth/presentation/state/auth_state.dart';
// import 'package:rentease/features/auth/presentation/view_model/auth_view_model.dart';
// import 'package:rentease/features/dashboard/presentation/pages/bottom_screen/profile_screen.dart';

// // Mock AuthViewModel
// class MockAuthViewModel extends Mock implements AuthViewModel {}

// void main() {
//   late MockAuthViewModel mockAuthViewModel;

//   const tAuthEntity = AuthEntity(
//     authId: '123',
//     firstName: 'John',
//     lastName: 'Doe',
//     username: 'John Doe',
//     email: 'john@example.com',
//     profilePicture: '/uploads/profile.jpg',
//   );

//   setUpAll(() {
//     registerFallbackValue(File(''));
//   });

//   setUp(() {
//     mockAuthViewModel = MockAuthViewModel();

//     // Stub state
//     when(() => mockAuthViewModel.state).thenReturn(
//       const AuthState(authEntity: tAuthEntity, status: AuthStatus.initial),
//     );

//     // Stub methods
//     when(() => mockAuthViewModel.logout()).thenAnswer((_) async {});
//     when(() => mockAuthViewModel.uploadPhoto(any())).thenAnswer((_) async {});
//   });

//   Widget createTestWidget() {
//     return ProviderScope(
//       overrides: [
//         // Wrap the mock in a Provider and override
//         authViewModelProvider.overrideWith(() => mockAuthViewModel),
//       ],
//       child: const MaterialApp(
//         home: ProfileScreen(),
//       ),
//     );
//   }

//   group('ProfileScreen Widget Tests', () {
//     testWidgets('renders user info correctly', (tester) async {
//       await mockNetworkImagesFor(() async {
//         await tester.pumpWidget(createTestWidget());
//         await tester.pumpAndSettle();

//         expect(find.text('John Doe'), findsOneWidget);
//         expect(find.text('john@example.com'), findsOneWidget);
//         expect(find.text('Profile Settings'), findsOneWidget);
//       });
//     });

//     testWidgets('shows logout dialog when Logout is tapped', (tester) async {
//       await mockNetworkImagesFor(() async {
//         await tester.pumpWidget(createTestWidget());
//         await tester.pumpAndSettle();

//         await tester.tap(find.text('Logout'));
//         await tester.pumpAndSettle();

//         expect(find.byType(AlertDialog), findsOneWidget);
//         expect(
//           find.text('Are you sure you want to end your session?'),
//           findsOneWidget,
//         );
//       });
//     });

//     testWidgets('shows image source selection when avatar is tapped', (tester) async {
//       await mockNetworkImagesFor(() async {
//         await tester.pumpWidget(createTestWidget());
//         await tester.pumpAndSettle();

//         final avatar = find.byType(GestureDetector).first;
//         await tester.tap(avatar);
//         await tester.pumpAndSettle();

//         expect(find.text('Take a Photo'), findsOneWidget);
//         expect(find.text('Choose from Gallery'), findsOneWidget);
//       });
//     });

//     testWidgets('calls logout method when confirming logout', (tester) async {
//       await mockNetworkImagesFor(() async {
//         await tester.pumpWidget(createTestWidget());
//         await tester.pumpAndSettle();

//         await tester.tap(find.text('Logout'));
//         await tester.pumpAndSettle();

//         final confirmLogoutBtn = find.widgetWithText(ElevatedButton, 'Logout');
//         await tester.tap(confirmLogoutBtn);
//         await tester.pumpAndSettle();

//         verify(() => mockAuthViewModel.logout()).called(1);
//       });
//     });
//   });
// }