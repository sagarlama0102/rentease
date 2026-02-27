import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:rentease/features/dashboard/domain/entities/property_entity.dart';
import 'package:rentease/widgets/best_offer_card.dart';

void main() {
  // 1. Create a mock PropertyEntity
  const tProperty = PropertyEntity(
    propertyId: '1',
    title: 'Luxury Penthouse',
    price: 50000,
    city: 'Kathmandu',
    description: 'A beautiful house',
    address: '123 street',
    bhk: '3 BHK',
    propertyType: 'Apartment',
    propertyImages: ['/test_image.jpg'],
    // Add other required fields from your PropertyEntity definition
  );

  // Helper to create the widget
  Widget createTestWidget(PropertyEntity property) {
    return MaterialApp(
      home: Scaffold(
        body: SizedBox(
          height: 300,
          width: 300,
          child: BestOfferCard(property: property),
        ),
      ),
    );
  }

  group('BestOfferCard Widget Tests', () {
    testWidgets('should display property title and price', (WidgetTester tester) async {
  await mockNetworkImagesFor(() async {
    await tester.pumpWidget(createTestWidget(tProperty));

    expect(find.text('Luxury Penthouse'), findsOneWidget);

    expect(find.textContaining('50000'), findsOneWidget);
    expect(find.textContaining('Rs.'), findsOneWidget);
    
    expect(find.text('Kathmandu'), findsOneWidget);
  });
});

    testWidgets('should display the correct IconBadges', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(createTestWidget(tProperty));

        expect(find.text('3 BHK'), findsOneWidget);
        expect(find.text('Apartment'), findsOneWidget);

        expect(find.byIcon(Icons.bed), findsOneWidget);
        expect(find.byIcon(Icons.home_work), findsOneWidget);
      });
    });

    testWidgets('should show placeholder/broken image icon when image fails', (WidgetTester tester) async {

      const propertyNoImage = PropertyEntity(
        propertyId: '2',
        title: 'No Image House',
        description: 'A beautiful house',
        address: '123 street',
        price: 20000,
        city: 'Pokhara',
        bhk: '1 BHK',
        propertyType: 'Flat',
        propertyImages: [],
      );

      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(createTestWidget(propertyNoImage));

        expect(find.byType(Image), findsOneWidget);
      });
    });

    testWidgets('should have a gradient overlay container', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(createTestWidget(tProperty));

        final containerFinder = find.byType(Container);
        
        bool hasGradient = false;
        for (var widget in tester.widgetList<Container>(containerFinder)) {
          if (widget.decoration is BoxDecoration) {
            final decoration = widget.decoration as BoxDecoration;
            if (decoration.gradient is LinearGradient) {
              hasGradient = true;
              break;
            }
          }
        }
        expect(hasGradient, true);
      });
    });
  });
}