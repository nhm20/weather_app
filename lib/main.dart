import 'package:flutter/material.dart';
import 'package:weather_app/weather_screen_layout.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // theme: ThemeData(
      //   scaffoldBackgroundColor: Colors.white,
      // ),
      // theme:ThemeData.dark(useMaterial3: true).copyWith(
      //   scaffoldBackgroundColor: Colors.black,
      //   appBarTheme: const AppBarTheme(
      //     backgroundColor: Colors.black,
      //     foregroundColor: Colors.white,
      //     elevation: 0,
      //   ),
      // ),
      theme: ThemeData.dark(useMaterial3: true),
      home: WeatherScreen(),
    );
  }
}
