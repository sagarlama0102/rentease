class ApiEndpoints {
  ApiEndpoints._();

  // Base URL - change this for production
  static const String baseUrl = 'http://192.168.101.11:4000/api/';
  //static const String baseUrl = 'http://localhost:3000/api/v1';
  // For Android Emulator use: 'http://10.0.2.2:3000/api/v1'
  // For iOS Simulator use: 'http://localhost:5000/api/v1'
  // For Physical Device use your computer's IP: 'http://192.168.x.x:5000/api/v1'

  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  static const String register = '/auth/register';
  static const String login = '/auth/login';
  //  static const String userUploadPhoto = '/auth/update-profile';
  static const String userUploadPhoto = '/auth/update-profile';

  //properties

  static const String getAllProperty = '/properties';
  static String getPropertyById(String id) => '/properties/$id';
}
