class ApiEndpoints {
  ApiEndpoints._();

  // Base URL - change this for production

  static const String baseUrlOnly = 'http://10.125.255.80:4000';

  static const String baseUrl = '$baseUrlOnly/api/';

  // static const String baseUrl = 'http://192.168.101.15:4000/api/';


  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  static const String register = '/auth/register';
  static const String login = '/auth/login';
  //  static const String userUploadPhoto = '/auth/update-profile';
  static const String userUploadPhoto = '/auth/update-profile';

  //properties

  static const String getAllProperty = '/properties'; 
  static String getPropertyById(String id) => '/properties/$id';

  //bookings
  static const String createBooking = "bookings"; // app.use("/api/bookings", ...)
  static const String getMyBookings = "bookings/my-bookings";
  
  // Logic for dynamic routes
  static String cancelBooking(String id) => "bookings/$id/cancel";
  static String getBookingById(String id) => "bookings/$id";

  //favourites
  static const String toggleFavourite = "favourites/toggle";
  static const String getMyFavourites = "favourites/my-wishlist";
  
  // Logic for dynamic status check
  static String checkFavouriteStatus(String propertyId) => "favourites/status/$propertyId";
}
