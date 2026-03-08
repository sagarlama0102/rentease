import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rentease/features/booking/domain/entities/booking_entity.dart';
import 'package:rentease/features/booking/presentation/view_model/booking_view_model.dart';
import 'package:rentease/features/booking/presentation/state/booking_state.dart';
import 'package:rentease/features/booking/presentation/widgets/booking_card.dart';

class MyBookingsScreen extends ConsumerStatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  ConsumerState<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends ConsumerState<MyBookingsScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() =>
        ref.read(bookingViewModelProvider.notifier).getAllBookings());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bookingViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Bookings')),
      body: _buildBody(state),
    );
  }

  Widget _buildBody(BookingState state) {
    if (state.status == BookingStatusState.loading && state.bookings.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.bookings.isEmpty) {
      return const Center(child: Text('You have no bookings yet.'));
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(bookingViewModelProvider.notifier).getAllBookings(),
      child: ListView.builder(
        itemCount: state.bookings.length,
        itemBuilder: (context, index) {
          final booking = state.bookings[index];
          return BookingCard(
            booking: booking,
            onCancel: () {
              _showCancelDialog(booking.bookingId!);
            },
          );
        },
      ),
    );
  }

  void _showCancelDialog(String bookingId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Booking'),
        content: const Text('Are you sure you want to cancel this request?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('No')),
          TextButton(
            onPressed: () {
              ref.read(bookingViewModelProvider.notifier).updateBookingStatus(
                    bookingId: bookingId,
                    status: BookingStatus.cancelled,
                  );
              Navigator.pop(context);
            },
            child: const Text('Yes, Cancel', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}