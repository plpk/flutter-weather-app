import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';

enum TemperatureUnit { celsius, fahrenheit }

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherService _weatherService = WeatherService();
  Weather? _weather;
  String? _errorMessage;
  bool _isLoading = false;
  final TextEditingController _cityController = TextEditingController();
  TemperatureUnit _temperatureUnit = TemperatureUnit.celsius;

  @override
  void initState() {
    super.initState();
    _fetchWeatherByLocation();
  }

  Future<void> _fetchWeatherByLocation() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final weather = await _weatherService.getWeatherByLocation();
      setState(() {
        _weather = weather;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchWeatherByCity() async {
    if (_cityController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final weather = await _weatherService.getWeatherByCity(_cityController.text);
      setState(() {
        _weather = weather;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'City not found. Please try again.';
        _isLoading = false;
      });
    }
  }

  // Conversion functions
  double celsiusToFahrenheit(double celsius) {
    return (celsius * 9 / 5) + 32;
  }

  String getTemperatureDisplay(double tempCelsius) {
    if (_temperatureUnit == TemperatureUnit.celsius) {
      return '${tempCelsius.toStringAsFixed(1)}°C';
    } else {
      return '${celsiusToFahrenheit(tempCelsius).toStringAsFixed(1)}°F';
    }
  }

  void _toggleTemperatureUnit() {
    setState(() {
      _temperatureUnit = _temperatureUnit == TemperatureUnit.celsius
          ? TemperatureUnit.fahrenheit
          : TemperatureUnit.celsius;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final detailBackgroundColor = isDarkMode 
        ? const Color(0xFF212121) 
        : const Color(0xFFE0E0E0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather'),
        // AppBar styling is handled by the theme
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search bar
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _cityController,
                    decoration: InputDecoration(
                      hintText: 'Enter city name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      filled: true,
                      fillColor: isDarkMode 
                          ? const Color(0xFF212121) 
                          : const Color(0xFFF5F5F5),
                    ),
                    onSubmitted: (_) => _fetchWeatherByCity(),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _fetchWeatherByCity,
                  child: const Text('Search'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextButton.icon(
              onPressed: _fetchWeatherByLocation,
              icon: Icon(Icons.my_location),
              label: const Text('Use my location'),
            ),
            const SizedBox(height: 20),
            
            // Loading indicator
            if (_isLoading)
              CircularProgressIndicator(
                color: primaryColor,
              )
            
            // Error message
            else if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              )
            
            // Weather display
            else if (_weather != null)
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _weather!.cityName,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    
                    // Temperature unit toggle
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'C°',
                          style: TextStyle(
                            fontSize: 16, 
                            fontWeight: _temperatureUnit == TemperatureUnit.celsius 
                                ? FontWeight.bold 
                                : FontWeight.normal,
                          ),
                        ),
                        Switch(
                          value: _temperatureUnit == TemperatureUnit.fahrenheit,
                          onChanged: (value) => _toggleTemperatureUnit(),
                          activeColor: primaryColor,
                          inactiveTrackColor: isDarkMode 
                              ? Colors.grey.shade800 
                              : Colors.grey.shade300,
                        ),
                        Text(
                          'F°',
                          style: TextStyle(
                            fontSize: 16, 
                            fontWeight: _temperatureUnit == TemperatureUnit.fahrenheit 
                                ? FontWeight.bold 
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                    
                    Image.network(
                      'https://openweathermap.org/img/wn/${_weather!.icon}@4x.png',
                      height: 100,
                      width: 100,
                    ),
                    Text(
                      getTemperatureDisplay(_weather!.temperature),
                      style: const TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                    Text(
                      _weather!.description,
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 30),
                    
                    // Additional weather details
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: detailBackgroundColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          _buildWeatherDetail(
                            'Feels like', 
                            getTemperatureDisplay(_weather!.feelsLike),
                            Icons.thermostat,
                          ),
                          const SizedBox(height: 10),
                          _buildWeatherDetail(
                            'Humidity', 
                            '${_weather!.humidity.toStringAsFixed(0)}%',
                            Icons.water_drop,
                          ),
                          const SizedBox(height: 10),
                          _buildWeatherDetail(
                            'Wind speed', 
                            '${_weather!.windSpeed.toStringAsFixed(1)} m/s',
                            Icons.air,
                          ),
                        ],
                      ),
                    ),
                    
                    // Personal signature
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        'Created by Pablo with Flutter',
                        style: TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          color: isDarkMode ? Colors.grey : Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else
              const Text('No weather data available'),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherDetail(String label, String value, IconData icon) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    
    return Row(
      children: [
        Icon(icon, color: primaryColor),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(fontSize: 16),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}