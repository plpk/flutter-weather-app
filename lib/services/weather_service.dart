// lib/services/weather_service.dart
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import '../models/weather_model.dart';

class WeatherService {
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  Future<Weather> getWeatherByLocation() async {
    // Check location permissions
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions denied');
      }
    }

    // Get current location
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Get API key from .env file
    final apiKey = dotenv.env['OPENWEATHER_API_KEY'];
    
    // Fetch weather data
    final response = await http.get(
      Uri.parse('$baseUrl?lat=${position.latitude}&lon=${position.longitude}&units=metric&appid=$apiKey'),
    );

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<Weather> getWeatherByCity(String city) async {
    // Get API key from .env file
    final apiKey = dotenv.env['OPENWEATHER_API_KEY'];
    
    // Fetch weather data
    final response = await http.get(
      Uri.parse('$baseUrl?q=$city&units=metric&appid=$apiKey'),
    );

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}