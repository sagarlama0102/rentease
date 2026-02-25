import 'package:flutter/material.dart';
import 'package:rentease/features/booking/domain/entities/booking_entity.dart';

class BookingCard extends StatelessWidget {
  final BookingEntity booking;
  final VoidCallback? onCancel;

  const BookingCard({super.key, required this.booking, this.onCancel});

  @override
  Widget build(BuildContext context) {
    // Make sure this matches your backend IP/URL
    const String imageServerUrl = "http://192.168.101.15:4000";

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Property Thumbnail Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                booking.propertyImages.isNotEmpty
                    ? "$imageServerUrl${booking.propertyImages[0]}"
                    : 'https://via.placeholder.com/150',
                width: 90,
                height: 90,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 90,
                  height: 90,
                  color: Colors.grey[200],
                  child: const Icon(Icons.image_not_supported),
                ),
              ),
            ),
            const SizedBox(width: 16),

            // 2. Info Column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    booking.propertyTitle ?? "Property Request",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  _buildStatusBadge(booking.status),
                  const SizedBox(height: 8),
                  if (booking.message != null)
                    Text(
                      "Note: ${booking.message}",
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),

            // 3. Action Button (Cancel)
            if (booking.status == BookingStatus.pending)
              Align(
                alignment: Alignment.center,
                child: IconButton(
                  icon: const Icon(Icons.cancel, color: Colors.redAccent),
                  onPressed: onCancel,
                  tooltip: "Cancel Booking",
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Icon(
                  booking.status == BookingStatus.confirmed 
                      ? Icons.check_circle 
                      : Icons.error_outline,
                  color: booking.status == BookingStatus.confirmed 
                      ? Colors.green 
                      : Colors.grey,
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Helper to build a colored status badge
  Widget _buildStatusBadge(BookingStatus status) {
    Color badgeColor;
    switch (status) {
      case BookingStatus.confirmed:
        badgeColor = Colors.green;
        break;
      case BookingStatus.cancelled:
        badgeColor = Colors.red;
        break;
      case BookingStatus.rejected:
        badgeColor = Colors.orange;
        break;
      default:
        badgeColor = Colors.blue;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status.name.toUpperCase(),
        style: TextStyle(
          color: badgeColor,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}