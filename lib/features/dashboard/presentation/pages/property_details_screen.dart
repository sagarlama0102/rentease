import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rentease/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:rentease/features/booking/presentation/state/booking_state.dart';
import 'package:rentease/features/booking/presentation/view_model/booking_view_model.dart';
import 'package:rentease/features/dashboard/presentation/view_model/property_viewmodel.dart';
import 'package:rentease/features/dashboard/presentation/state/property_state.dart';

class PropertyDetailScreen extends ConsumerStatefulWidget {
  final String propertyId;
  const PropertyDetailScreen({super.key, required this.propertyId});

  @override
  ConsumerState<PropertyDetailScreen> createState() =>
      _PropertyDetailScreenState();
}

class _PropertyDetailScreenState extends ConsumerState<PropertyDetailScreen> {
  // Use a consistent server URL (Update this if your IP changes)
  final String imageServerUrl = "http://172.26.0.73:4000";

  @override
  void initState() {
    super.initState();
    // Fetch fresh data for this specific property when screen opens
    Future.microtask(
      () => ref
          .read(propertyViewModelProvider.notifier)
          .getPropertyById(widget.propertyId),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 1. Listen for Booking State changes (Success/Error)
    ref.listen<BookingState>(bookingViewModelProvider, (previous, next) {
      if (next.status == BookingStatusState.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              next.errorMessage ?? "Failed to send booking request",
            ),
            backgroundColor: Colors.red,
          ),
        );
      } else if (next.status == BookingStatusState.created) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Booking request sent successfully!"),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      }
    });

    final propertyState = ref.watch(propertyViewModelProvider);
    final bookingState = ref.watch(bookingViewModelProvider);
    final property = propertyState.selectedProperty;

    return Scaffold(
      backgroundColor: Colors.white,
      body: propertyState.status == PropertyStatus.loading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xff99DAB3)),
            )
          : property == null
          ? const Center(child: Text("Property not found"))
          : Stack(
              children: [
                // 1️⃣ Background Image with Gradient Overlay
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        property.propertyImages.isNotEmpty
                            ? "$imageServerUrl${property.propertyImages[0]}"
                            : 'https://via.placeholder.com/400',
                        fit: BoxFit.cover,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.3),
                              Colors.black.withOpacity(0.6),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // 2️⃣ Modern Back Button
                Positioned(
                  top: 45,
                  left: 20,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () {
                        ref
                            .read(propertyViewModelProvider.notifier)
                            .clearSelectedProperty();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),

                // 3️⃣ Draggable Content Sheet
                DraggableScrollableSheet(
                  initialChildSize: 0.65,
                  minChildSize: 0.65,
                  maxChildSize: 0.92,
                  builder: (context, scrollController) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 2,
                      ),
                      decoration: const BoxDecoration(
                        color: Color(0xff142725),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(35),
                        ),
                      ),
                      child: ListView(
                        controller: scrollController,
                        children: [
                          // Handle Bar
                          Center(
                            child: Container(
                              width: 60,
                              height: 6,
                              margin: const EdgeInsets.only(top: 10),
                              decoration: BoxDecoration(
                                color: Colors.white24,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          const SizedBox(height: 25),

                          // Title & Price
                          Text(
                            property.title,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Rs. ${property.price}",
                            style: const TextStyle(
                              fontSize: 22,
                              color: Color(0xff99DAB3),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Location
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: Color(0xff99DAB3),
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  "${property.address}, ${property.city}",
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 30),

                          // Specifications Section
                          const Text(
                            "Specifications",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 20),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildModernSpecItem(Icons.bed, property.bhk),
                              _buildModernSpecItem(
                                Icons.home,
                                property.propertyType,
                              ),
                              _buildModernSpecItem(
                                Icons.check_circle,
                                property.isRented ? "Rented" : "Available",
                              ),
                            ],
                          ),

                          const SizedBox(height: 35),

                          // Description
                          const Text(
                            "Description",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            property.description,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.white70,
                              height: 1.6,
                            ),
                          ),
                          const SizedBox(height: 120), // Padding for button
                        ],
                      ),
                    );
                  },
                ),

                // 4️⃣ Premium Bottom Button
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(color: Color(0xff142725)),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: property.isRented ? 0 : 8,
                        backgroundColor: property.isRented
                            ? Colors.grey.withOpacity(0.5)
                            : const Color(0xff99DAB3),
                        minimumSize: const Size(double.infinity, 60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed:
                          (property.isRented ||
                              bookingState.status == BookingStatusState.loading)
                          ? null
                          : () => _showBookingDialog(
                              context,
                              ref,
                              property.propertyId!,
                            ),
                      child: bookingState.status == BookingStatusState.loading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              property.isRented
                                  ? "Already Rented"
                                  : "Book This Property",
                              style: TextStyle(
                                color: property.isRented
                                    ? Colors.white60
                                    : Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildModernSpecItem(IconData icon, String label) {
    return Container(
      width: 95,
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: const Color(0xff1F3A37),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xff99DAB3), size: 28),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showBookingDialog(
    BuildContext context,
    WidgetRef ref,
    String propertyId,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xff142725),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          "Confirm Booking",
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          "Are you sure you want to book this property? This action will notify the administrator.",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff99DAB3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              // 1. Get the current user from your Auth Provider
              final authState = ref.read(authViewModelProvider);
              final userId = authState
                  .authEntity
                  ?.authId; // Or authState.userEntity?.userId

              if (userId != null) {
                // 2. Pass both propertyId AND userId to the method
                ref
                    .read(bookingViewModelProvider.notifier)
                    .createBooking(
                      propertyId: propertyId,
                      userId: userId, // This is the missing piece!
                      message: "Interested in this property.",
                    );
              } else {
                // 3. Handle the case where the user isn't logged in
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Please login to book a property"),
                  ),
                );
              }
            },
            child: const Text(
              "Confirm",
              style: TextStyle(color: Color(0xff142725)),
            ),
          ),
        ],
      ),
    );
  }
}
