class ApiConfig {
  // Web (Chrome) di Windows:
  static const String baseUrlWeb = 'http://127.0.0.1:8000';

  // Android Emulator (localhost laptop):
  static const String baseUrlAndroidEmulator = 'http://10.0.2.2:8000';

  // Nanti untuk HP fisik (isi IP laptop):
  static const String baseUrlPhysicalDevice = 'http://192.168.1.10:8000';

  // Untuk sekarang (karena kamu bisa run di web):
  static const String baseUrl = baseUrlWeb;
}