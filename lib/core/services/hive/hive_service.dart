import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rentease/core/constants/hive_table_constants.dart';
import 'package:rentease/features/auth/data/models/auth_hive_model.dart';
import 'package:rentease/features/booking/data/models/booking_hive_model.dart';
import 'package:rentease/features/dashboard/data/models/property_hive_model.dart';
import 'package:rentease/features/favourites/data/models/favourite_hive_model.dart';

final hiveServiceProvider = Provider<HiveService>((ref) {
  return HiveService();
});

class HiveService {
  //database init
  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();

    final path = '${directory.path}/${HiveTableConstants.dbName}';
    Hive.init(path);

    _registerAdapter();
    await openBoxes();
  }

  void _registerAdapter() {
    if (!Hive.isAdapterRegistered(HiveTableConstants.authTypeId)) {
      Hive.registerAdapter(AuthHiveModelAdapter());
    }
    if (!Hive.isAdapterRegistered(HiveTableConstants.propertyTypeId)) {
      Hive.registerAdapter(PropertyHiveModelAdapter());
    }
    if (!Hive.isAdapterRegistered(HiveTableConstants.bookingTypeId)) {
      Hive.registerAdapter(BookingHiveModelAdapter());
    }
    if (!Hive.isAdapterRegistered(HiveTableConstants.favouriteTypeId)) {
      Hive.registerAdapter(FavouriteHiveModelAdapter());
    }
  }

  // open Boxes
  Future<void> openBoxes() async {
    await Hive.openBox<AuthHiveModel>(HiveTableConstants.authTable);
    await Hive.openBox<PropertyHiveModel>(HiveTableConstants.propertyTable);
    await Hive.openBox<BookingHiveModel>(HiveTableConstants.bookingTable);
    await Hive.openBox<FavouriteHiveModel>(HiveTableConstants.favouriteTable);
  }

  //close Boxes
  Future<void> close() async {
    await Hive.close();
  }

  //==============Auth Queries ================
  Box<AuthHiveModel> get _authBox =>
      Hive.box<AuthHiveModel>(HiveTableConstants.authTable);

  Future<AuthHiveModel> registerUser(AuthHiveModel model) async {
    await _authBox.put(model.authId, model);
    return model;
  }

  //login User
  Future<AuthHiveModel?> loginUser(String email, String password) async {
    final users = _authBox.values.where(
      (user) => user.email == email && user.password == password,
    );
    if (users.isNotEmpty) {
      return users.first;
    }
    return null;
  }

  // logout
  Future<void> logoutUser() async {}

  //get current user
  AuthHiveModel? getCurrentUser(String authId) {
    return _authBox.get(authId);
  }

  //is email exists
  bool isEmailExists(String email) {
    final users = _authBox.values.where((user) => user.email == email);
    return users.isNotEmpty;
  }

  // Get user by ID
  AuthHiveModel? getUserById(String authId) {
    return _authBox.get(authId);
  }

  // Get user by email
  AuthHiveModel? getUserByEmail(String email) {
    try {
      return _authBox.values.firstWhere((user) => user.email == email);
    } catch (e) {
      return null;
    }
  }

  // Update user
  Future<bool> updateUser(AuthHiveModel user) async {
    if (_authBox.containsKey(user.authId)) {
      await _authBox.put(user.authId, user);
      return true;
    }
    return false;
  }

  // Delete user
  Future<void> deleteUser(String authId) async {
    await _authBox.delete(authId);
  }

  // ================================ Property Queries =================================

  Box<PropertyHiveModel> get _propertyBox =>
      Hive.box<PropertyHiveModel>(HiveTableConstants.propertyTable);

  List<PropertyHiveModel> getAllProperty() {
    return _propertyBox.values.toList();
  }

  PropertyHiveModel? getPropertyById(String propertyId) {
    return _propertyBox.get(propertyId);
  }

  Future<void> cacheAllProperty(List<PropertyHiveModel> properties) async {
    await _propertyBox.clear();
    for (var property in properties) {
      await _propertyBox.put(property.propertyId, property);
    }
  }

  //====================Booking Queries==============================//

  Box<BookingHiveModel> get _bookingBox =>
      Hive.box<BookingHiveModel>(HiveTableConstants.bookingTable);

  Future<BookingHiveModel> createBooking(BookingHiveModel booking) async {
    final id =
        booking.bookingId ?? DateTime.now().millisecondsSinceEpoch.toString();
    await _bookingBox.put(id, booking);
    return booking;
  }

  List<BookingHiveModel> getAllBookings() {
    return _bookingBox.values.toList();
  }

  BookingHiveModel? getBookingById(String bookingId) {
    return _bookingBox.get(bookingId);
  }

  Future<bool> updateBookingStatus(BookingHiveModel booking) async {
    final id = booking.bookingId;
    if (id != null && _bookingBox.containsKey(id)) {
      await _bookingBox.put(id, booking);
      return true;
    }
    return false;
  }

  Future<BookingHiveModel?> findActiveBooking({
    required String userId,
    required String propertyId,
  }) async {
    try {
      return _bookingBox.values.firstWhere(
        (booking) =>
            booking.userId == userId &&
            booking.propertyId == propertyId &&
            (booking.status == "PENDING" || booking.status == "CONFIRMED"),
      );
    } catch (e) {
      return null;
    }
  }

  Future<void> cacheAllBooking(List<BookingHiveModel> bookings) async {
    await _bookingBox.clear();
    for (var booking in bookings) {
      if (booking.bookingId != null) {
        await _bookingBox.put(booking.bookingId, booking);
      }
    }
  }

  //=========================================favourite Queries ==============================
  Box<FavouriteHiveModel> get _favouriteBox =>
      Hive.box<FavouriteHiveModel>(HiveTableConstants.favouriteTable);

  // Get all favourites for a specific user
  List<FavouriteHiveModel> getAllFavourites(String userId) {
    return _favouriteBox.values
        .where((favourite) => favourite.userId == userId)
        .toList();
  }

  // Toggle Favourite logic (Add if missing, Delete if exists)
  Future<bool> toggleFavourite(FavouriteHiveModel favourite) async {
    // We check if the property is already favourited by this specific user
    final existingKey = _favouriteBox.keys.firstWhere(
      (key) {
        final item = _favouriteBox.get(key);
        return item?.propertyId == favourite.propertyId && item?.userId == favourite.userId;
      },
      orElse: () => null,
    );

    if (existingKey != null) {
      // If it exists, remove it (Unlike)
      await _favouriteBox.delete(existingKey);
      return false; // Returns false meaning "removed from favourites"
    } else {
      // If it doesn't exist, add it (Like)
      // Use propertyId as part of the key to keep it unique per user/property
      final uniqueKey = "${favourite.userId}_${favourite.propertyId}";
      await _favouriteBox.put(uniqueKey, favourite);
      return true; // Returns true meaning "added to favourites"
    }
  }

  // Check if a specific property is favourited by the user
  bool isFavourite(String userId, String propertyId) {
    return _favouriteBox.values.any(
      (favourite) => favourite.userId == userId && favourite.propertyId == propertyId,
    );
  }

  // Cache all favourites from the server (Useful when syncing)
  Future<void> cacheAllFavourites(List<FavouriteHiveModel> favourites, String userId) async {
    // 1. Find all keys belonging to the current user
    final userKeys = _favouriteBox.keys.where((key) {
      final item = _favouriteBox.get(key);
      return item?.userId == userId;
    }).toList();

    // 2. Clear only the current user's favourites to avoid deleting others' data
    await _favouriteBox.deleteAll(userKeys);

    // 3. Add the new list
    for (var fav in favourites) {
      final uniqueKey = "${fav.userId}_${fav.propertyId}";
      await _favouriteBox.put(uniqueKey, fav);
    }
  }
}
