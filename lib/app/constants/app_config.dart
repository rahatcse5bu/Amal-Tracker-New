class AppConfig {
  // Define your server URLs
  // For Android emulator: 10.0.2.2, for physical device: your machine IP
  static const String baseUrl = 'http://10.0.2.2:3000/api/';
  
  // Define app version
  static const String appVersion = '1.0.0';

  // Add any other configuration constants here
  static const int timeoutDuration = 300;  // seconds
  static const String apiVersion = 'v1';  // Optional API versioning
}
