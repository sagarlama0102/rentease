import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:rentease/features/booking/domain/entities/booking_entity.dart';
import 'package:rentease/features/booking/presentation/widgets/booking_card.dart';

void main() {
  // Create a helper method to generate a mock booking
  BookingEntity createMockBooking({
    required BookingStatus status,
    String? message,
  }) {
    return BookingEntity(
      bookingId: '1',
      propertyId: 'prop123',
      propertyTitle: 'Luxury Apartment',
      propertyImages: ['/image1.jpg'],
      status: status,
      message: message,
      // Add other required fields based on your BookingEntity definition
      userId: 'user1',
      createdAt: DateTime.now(),
    );
  }

  group('BookingCard Widget Tests', () {
    testWidgets('should display property title and status badge', (WidgetTester tester) async {
      final booking = createMockBooking(status: BookingStatus.pending);

      // We use mockNetworkImagesFor to avoid 404/Network errors during tests
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BookingCard(booking: booking),
            ),
          ),
        );

        // Assert: Check for title
        expect(find.text('Luxury Apartment'), findsOneWidget);
        
        // Assert: Check for status badge (transformed to uppercase in your code)
        expect(find.text('PENDING'), findsOneWidget);
      });
    });

    testWidgets('should show cancel button only when status is pending', (WidgetTester tester) async {
      final pendingBooking = createMockBooking(status: BookingStatus.pending);
      final confirmedBooking = createMockBooking(status: BookingStatus.confirmed);

      await mockNetworkImagesFor(() async {
        // 1. Test Pending state
        await tester.pumpWidget(MaterialApp(home: Scaffold(body: BookingCard(booking: pendingBooking))));
        expect(find.byIcon(Icons.cancel), findsOneWidget);

        // 2. Test Confirmed state
        await tester.pumpWidget(MaterialApp(home: Scaffold(body: BookingCard(booking: confirmedBooking))));
        expect(find.byIcon(Icons.cancel), findsNothing);
        expect(find.byIcon(Icons.check_circle), findsOneWidget);
      });
    });

    testWidgets('should call onCancel when cancel button is pressed', (WidgetTester tester) async {
      bool wasCancelled = false;
      final booking = createMockBooking(status: BookingStatus.pending);

      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BookingCard(
                booking: booking,
                onCancel: () => wasCancelled = true,
              ),
            ),
          ),
        );

        // Act: Tap the cancel button
        await tester.tap(find.byType(IconButton));
        await tester.pump();

        // Assert: verify the callback was triggered
        expect(wasCancelled, isTrue);
      });
    });

    testWidgets('should display placeholder message if present', (WidgetTester tester) async {
      const note = "Please call me before arriving";
      final booking = createMockBooking(status: BookingStatus.pending, message: note);

      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(MaterialApp(home: Scaffold(body: BookingCard(booking: booking))));
        
        expect(find.text("Note: $note"), findsOneWidget);
      });
    });
  });
}