import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Map<String, dynamic>> getWeather(double latitude, double longitude) async {
    final String apiEndpoint = 'http://api.openweathermap.org/data/2.5/weather';

    final Map<String, String> parameters = {
      'lat': latitude.toString(),
      'lon': longitude.toString(),
      'appid': 'fdeeed8f12d6bdf41fcf5457285cb6c0',
      'units': 'metric', // You can change the units to 'imperial' for Fahrenheit
    };

    final Uri uri = Uri.parse(apiEndpoint).replace(queryParameters: parameters);

    final http.Response response = await http.get(uri);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}

