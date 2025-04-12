// lib/models/weather_model.dart
class Weather {
  final double temperature;
  final String description;
  final String icon;
  final String cityName;
  final double feelsLike;
  final double humidity;
  final double windSpeed;

  Weather({
    required this.temperature,
    required this.description,
    required this.icon,
    required this.cityName,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      temperature: json['main']['temp'].toDouble(),
      description: json['weather'][0]['description'],
      icon: json['weather'][0]['icon'],
      cityName: json['name'],
      feelsLike: json['main']['feels_like'].toDouble(),
      humidity: json['main']['humidity'].toDouble(),
      windSpeed: json['wind']['speed'].toDouble(),
    );
  }
}