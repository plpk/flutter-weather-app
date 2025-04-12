import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:async';
import 'screens/weather_screen.dart';

Future<void> main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Add error handling
  runZonedGuarded(() async {
    try {
      // Load environment variables with a helpful print statement
      print("Attempting to load .env file");
      await dotenv.load(fileName: ".env");
      print("ENV loaded successfully");
    } catch (e) {
      // Provide fallback for API key in case .env fails
      print("Failed to load .env file: $e");
      dotenv.env['OPENWEATHER_API_KEY'] = 'your_api_key_here';
    }
    
    runApp(const MyApp());
  }, (error, stack) {
    print("UNHANDLED ERROR: $error");
    print("STACK TRACE: $stack");
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather',
      theme: ThemeData(
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFF212121), // Dark gray
          onPrimary: Colors.white,
          secondary: Color(0xFF424242), // Medium gray
          onSecondary: Colors.white,
          error: Colors.red,
          onError: Colors.white,
          background: Colors.white,
          onBackground: Color(0xFF212121),
          surface: Colors.white,
          onSurface: Color(0xFF212121),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF212121),
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF212121),
            foregroundColor: Colors.white,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF212121),
          ),
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: const ColorScheme(
          brightness: Brightness.dark,
          primary: Color(0xFF212121), // Dark gray
          onPrimary: Colors.white,
          secondary: Color(0xFF424242), // Medium gray
          onSecondary: Colors.white,
          error: Colors.red,
          onError: Colors.white,
          background: Colors.black,
          onBackground: Colors.white,
          surface: Color(0xFF121212),
          onSurface: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF212121),
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF424242),
            foregroundColor: Colors.white,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
          ),
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system, // This will follow the system theme
      home: const WeatherScreen(),
    );
  }
}