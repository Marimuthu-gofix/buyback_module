class ApiConfig {
  static const String baseUrl = "http://155.117.46.151:9010/api/v1";
  static String endpoint(String path) => "$baseUrl$path";
}
class dotsmartApiConfig {
  static const String baseUrl = "https://dotsmart-002-site1.gtempurl.com";
  static String endpoint(String path) => "$baseUrl$path";
}
