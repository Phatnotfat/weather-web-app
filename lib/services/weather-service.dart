import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather-model.dart';

final String baseFunctionUrl =
    'https://us-central1-weather-web-b1e1e.cloudfunctions.net';

class WeatherService {
  Future<Map<String, dynamic>> getWeather(String city, bool isLoadMore) async {
    final url = Uri.parse(
      '$baseFunctionUrl/getWeatherForecast?city=$city&isLoadMore=$isLoadMore',
    );
    final response = await http.get(url);
    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['success'] == true) {
      Weather current = Weather.fromJson(data['current'], {
        'name': data['current']['city'],
        'country': data['current']['country'],
      });
      List<Weather> forecast =
          (data['forecast'] as List)
              .map((item) => Weather.fromForecastJson(item))
              .toList();

      return {'current': current, 'forecast': forecast};
    } else {
      throw Exception(data['message'] ?? 'Failed to fetch weather data');
    }
  }

  Future<Map<String, dynamic>> getWeatherByCoords(
    double lat,
    double lon,
  ) async {
    final url = Uri.parse(
      '$baseFunctionUrl/getWeatherForecast?lat=$lat&lng=$lon',
    );
    final response = await http.get(url);
    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['success'] == true) {
      Weather current = Weather.fromJson(data['current'], {
        'name': data['current']['city'],
        'country': data['current']['country'],
      });
      List<Weather> forecast =
          (data['forecast'] as List)
              .map((item) => Weather.fromForecastJson(item))
              .toList();

      return {'current': current, 'forecast': forecast};
    } else {
      throw Exception(data['message'] ?? 'Failed to fetch weather data');
    }
  }
}
