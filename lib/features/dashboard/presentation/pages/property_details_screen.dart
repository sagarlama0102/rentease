import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rentease/app/theme/theme_extensions.dart';
import 'package:rentease/core/api/api_endpoints.dart';
import 'package:rentease/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:rentease/features/booking/presentation/state/booking_state.dart';
import 'package:rentease/features/booking/presentation/view_model/booking_view_model.dart';
import 'package:rentease/features/dashboard/presentation/view_model/property_viewmodel.dart';
import 'package:rentease/features/dashboard/presentation/state/property_state.dart';
import 'package:rentease/features/favourites/presentation/state/favourite_state.dart';
import 'package:rentease/features/favourites/presentation/view_model/favourite_view_model.dart';

class PropertyDetailScreen extends ConsumerStatefulWidget {
  final String propertyId;
  const PropertyDetailScreen({super.key, required this.propertyId});

  @override
  ConsumerState<PropertyDetailScreen> createState() =>
      _PropertyDetailScreenState();
}

class _PropertyDetailScreenState extends ConsumerState<PropertyDetailScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref
          .read(propertyViewModelProvider.notifier)
          .getPropertyById(widget.propertyId);
      ref
          .read(favouriteViewModelProvider.notifier)
          .isFavourite(widget.propertyId);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Listeners for Snackbars
    ref.listen<BookingState>(bookingViewModelProvider, (previous, next) {
      if (next.status == BookingStatusState.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage ?? "Failed to send booking request"),
            backgroundColor: Colors.red,
          ),
        );
      } else if (next.status == BookingStatusState.created) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Booking request sent successfully!"),
            backgroundColor: Colors.green,
          ),
        );
      }
    });

    ref.listen<FavouriteState>(favouriteViewModelProvider, (previous, next) {
      if (next.status == FavouriteStatusState.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage ?? "Error updating wishlist")),
        );
      } else if (next.status == FavouriteStatusState.updated) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.isFavourite ? "Added to Wishlist" : "Removed from Wishlist"),
            duration: const Duration(seconds: 1),
          ),
        );
      }
    });

    final propertyState = ref.watch(propertyViewModelProvider);
    final bookingState = ref.watch(bookingViewModelProvider);
    final property = propertyState.selectedProperty;

    // Loading State
    if (propertyState.status == PropertyStatus.loading) {
      return Scaffold(
        backgroundColor: context.backgroundColor,
        body: const Center(child: CircularProgressIndicator(color: Color(0xff99DAB3))),
      );
    }

    // Error State
    if (property == null) {
      return Scaffold(
        backgroundColor: context.backgroundColor,
        body: const Center(child: Text("Property not found")),
      );
    }

    return Scaffold(
      backgroundColor: context.backgroundColor,
      // Fixed: The Button is now in the bottomNavigationBar for a professional look
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: context.surfaceColor,
          border: Border(top: BorderSide(color: context.borderColor.withOpacity(0.1))),
        ),
        child: SafeArea(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: property.isRented
                  ? Colors.grey.withOpacity(0.5)
                  : const Color(0xff99DAB3),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              minimumSize: const Size(double.infinity, 60),
              elevation: 0,
            ),
            onPressed: (property.isRented || bookingState.status == BookingStatusState.loading)
                ? null
                : () => _showBookingDialog(context, ref, property.propertyId!),
            child: bookingState.status == BookingStatusState.loading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(
                    property.isRented ? "Already Rented" : "Reserve Now",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
          ),
        ),
      ),
      body: Stack(
        children: [
          // 1. Property Image Header
          Positioned(
            top: 0, left: 0, right: 0,
            height: MediaQuery.of(context).size.height * 0.5,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  property.propertyImages.isNotEmpty
                      ? "${ApiEndpoints.baseUrlOnly}${property.propertyImages[0]}"
                      : 'https://via.placeholder.com/400',
                  fit: BoxFit.cover,
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.black26, Colors.black.withOpacity(0.5)],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 2. Custom Top Navigation (Back & Fav)
          Positioned(
            top: 45, left: 20, right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCircleIcon(
                  icon: Icons.arrow_back,
                  onTap: () {
                    ref.read(propertyViewModelProvider.notifier).clearSelectedProperty();
                    Navigator.pop(context);
                  },
                ),
                Consumer(
                  builder: (context, ref, _) {
                    final isFav = ref.watch(favouriteViewModelProvider).isFavourite;
                    return _buildCircleIcon(
                      icon: isFav ? Icons.favorite : Icons.favorite_border,
                      iconColor: isFav ? Colors.red : Colors.black,
                      onTap: () => ref.read(favouriteViewModelProvider.notifier).toggleFavourite(widget.propertyId),
                    );
                  },
                ),
              ],
            ),
          ),

          // 3. Modern Surface Sheet
          DraggableScrollableSheet(
            initialChildSize: 0.60,
            minChildSize: 0.60,
            maxChildSize: 0.92,
            builder: (context, scrollController) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  color: context.surfaceColor,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(35)),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
                ),
                child: ListView(
                  controller: scrollController,
                  children: [
                    Center(
                      child: Container(
                        width: 40, height: 4,
                        margin: const EdgeInsets.only(top: 12, bottom: 24),
                        decoration: BoxDecoration(
                          color: context.textTertiary.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            property.title,
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: context.textPrimary),
                          ),
                        ),
                        Text(
                          "Rs. ${property.price}",
                          style: const TextStyle(fontSize: 20, color: Color(0xff99DAB3), fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 16, color: context.textSecondary),
                        const SizedBox(width: 4),
                        Text("${property.address}, ${property.city}", style: TextStyle(color: context.textSecondary)),
                      ],
                    ),
                    const SizedBox(height: 30),
                    const Text("Specifications", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildModernSpecItem(context, Icons.bed, "${property.bhk} BHK"),
                        _buildModernSpecItem(context, Icons.home, property.propertyType),
                        _buildModernSpecItem(context, Icons.check_circle, property.isRented ? "Rented" : "Available"),
                      ],
                    ),
                    const SizedBox(height: 30),
                    const Text("Description", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Text(
                      property.description,
                      style: TextStyle(fontSize: 15, color: context.textSecondary, height: 1.6),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Helper for Navigation Buttons
  Widget _buildCircleIcon({required IconData icon, required VoidCallback onTap, Color iconColor = Colors.black}) {
    return Container(
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), shape: BoxShape.circle),
      child: IconButton(icon: Icon(icon, color: iconColor), onPressed: onTap),
    );
  }

  // Modern Spec Item
  Widget _buildModernSpecItem(BuildContext context, IconData icon, String label) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.27,
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: context.inputFillColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: context.borderColor.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xff99DAB3), size: 26),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textPrimary)),
        ],
      ),
    );
  }

  void _showBookingDialog(BuildContext context, WidgetRef ref, String propertyId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.surfaceColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text("Confirm Booking", style: TextStyle(color: context.textPrimary)),
        content: Text("Do you want to send a booking request for this property?", style: TextStyle(color: context.textSecondary)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff99DAB3)),
            onPressed: () {
              final userId = ref.read(authViewModelProvider).authEntity?.authId;
              if (userId != null) {
                ref.read(bookingViewModelProvider.notifier).createBooking(
                      propertyId: propertyId,
                      userId: userId,
                      message: "Interested in this property.",
                    );
                Navigator.pop(context);
              }
            },
            child: const Text("Confirm", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}