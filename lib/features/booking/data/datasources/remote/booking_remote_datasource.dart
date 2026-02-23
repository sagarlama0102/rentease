import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rentease/core/api/api_client.dart';
import 'package:rentease/core/api/api_endpoints.dart';
import 'package:rentease/core/services/storage/token_service.dart';
import 'package:rentease/features/booking/data/datasources/booking_datasource.dart';
import 'package:rentease/features/booking/data/models/booking_api_model.dart';

final bookingRemoteDatasourceProvider = Provider<IBookingRemoteDataSource>((
  ref,
) {
  return BookingRemoteDatasource(
    apiClient: ref.read(apiClientProvider),
    tokenService: ref.read(tokenServiceProvider),
  );
});

class BookingRemoteDatasource implements IBookingRemoteDataSource {
  final ApiClient _apiClient;
  final TokenService _tokenService;

  BookingRemoteDatasource({
    required ApiClient apiClient,
    required TokenService tokenService,
  })  : _apiClient = apiClient,
        _tokenService = tokenService;

  // Helper to get headers - reduces code duplication
  Future<Options> _getOptions() async {
    final token = await _tokenService.getToken();
    return Options(headers: {'Authorization': 'Bearer $token'});
  }

  @override
  Future<bool> createBooking(BookingApiModel booking) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.createBooking,
        data: booking.toJson(),
        options: await _getOptions(),
      );
      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<BookingApiModel>> getAllBookings(int page, int size) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.getMyBookings, // Path: bookings/my-bookings
        queryParameters: {'page': page, 'size': size},
        options: await _getOptions(),
      );

      // Access the 'booking' list from the {booking: [], total: X} response
      final List data = response.data['data'];
      return data.map((json) => BookingApiModel.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<bool> updateBookingStatus(String bookingId, String status) async {
    try {
      // Logic: If status is CANCELLED, use the specific PATCH /bookings/:id/cancel
      if (status.toUpperCase() == "CANCELLED") {
        final response = await _apiClient.patch(
          ApiEndpoints.cancelBooking(bookingId),
          options: await _getOptions(),
        );
        return response.statusCode == 200;
      }
      
      // If you ever add Admin functionality to CONFIRM/REJECT, 
      // you would add another 'else if' here for those endpoints.
      return false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<BookingApiModel?> getBookingById(String bookingId) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.getBookingById(bookingId),
        options: await _getOptions(),
      );
      return BookingApiModel.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<BookingApiModel?> findActiveBooking(String userId, String propertyId) async {
    try {
      // Usually, your backend handles 'current user' via token, 
      // so you might only need to send propertyId
      final response = await _apiClient.get(
        "bookings/active", 
        queryParameters: {'propertyId': propertyId},
        options: await _getOptions(),
      );
      if (response.data != null) {
        return BookingApiModel.fromJson(response.data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
