import 'package:http/http.dart' as http;

class EmailService {
  final String baseUrl =
      'https://us-central1-weather-web-b1e1e.cloudfunctions.net';

  Future<http.Response> subscribe(
    String email,
    double lat,
    double lng,
    String city,
  ) {
    return http.post(
      Uri.parse('$baseUrl/subscribe'),
      body: {
        'email': email,
        'lat': lat.toString(),
        'lng': lng.toString(),
        'city': city,
      },
    );
  }

  Future<http.Response> unsubscribe(String email) {
    return http.post(Uri.parse('$baseUrl/unsubscribe'), body: {'email': email});
  }
}
