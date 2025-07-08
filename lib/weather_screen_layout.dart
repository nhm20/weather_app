import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import 'package:weather_app/additional_info_item.dart';
import 'package:weather_app/hourly_forecast_card.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<Map<String, dynamic>> weather;

  // Fetch weather data
  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String city = "London";
      final apiKey = dotenv.env['API_KEY'];

      final res = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$apiKey&units=metric',
        ),
      );

      final data = jsonDecode(res.body);
      if (data['cod'] != '200') {
        throw "Error fetching weather data: ${data['message']}";
      }
      return data;
    } catch (e) {
      debugPrint("Error fetching weather data: $e");
      throw Exception("Failed to fetch weather data: $e");
    }
  }

  // Map weather descriptions to icons
  IconData getWeatherIcon(String description) {
    switch (description.toLowerCase()) {
      case 'clouds':
        return Icons.cloud;
      case 'rain':
        return Icons.beach_access;
      case 'clear':
        return Icons.wb_sunny;
      case 'snow':
        return Icons.ac_unit;
      default:
        return Icons.wb_cloudy;
    }
  }

  @override
  void initState() {
    super.initState();
    weather = getCurrentWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                weather = getCurrentWeather();
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: weather,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 48),
                  const SizedBox(height: 8),
                  Text('Error: ${snapshot.error}', textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        weather = getCurrentWeather();
                      });
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else {
            final data = snapshot.data!;

            // Safety: Check list existence
            final List<dynamic> forecastList = data['list'] ?? [];
            if (forecastList.isEmpty) {
              return const Center(child: Text("No weather data available."));
            }

            final currentWeatherData = forecastList[0];
            final mainData = currentWeatherData['main'] ?? {};
            final weatherArray = currentWeatherData['weather'] ?? [];
            final windData = currentWeatherData['wind'] ?? {};

            final currentTemp = mainData['temp'] ?? 0.0;
            final weatherDescription = weatherArray.isNotEmpty
                ? weatherArray[0]['main'] ?? 'Unknown'
                : 'Unknown';
            final pressure = mainData['pressure'] ?? 0;
            final humidity = mainData['humidity'] ?? 0;
            final windSpeed = windData['speed'] ?? 0.0;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Main weather card
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Text(
                                  '${currentTemp.toStringAsFixed(1)} °C',
                                  style: const TextStyle(
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Icon(
                                  getWeatherIcon(weatherDescription),
                                  size: 64,
                                  color: Colors.blue,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  weatherDescription,
                                  style: const TextStyle(fontSize: 24),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Hourly Forecast
                  const Text(
                    "Hourly Forecast",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      itemCount: forecastList.length >= 6
                          ? 5
                          : forecastList.length - 1,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final hourlyForecast = forecastList[index + 1];
                        final hourlyMain = hourlyForecast['main'] ?? {};
                        final hourlyWeather = hourlyForecast['weather'] ?? [];

                        final hourlySky = hourlyWeather.isNotEmpty
                            ? hourlyWeather[0]['main'] ?? 'Unknown'
                            : 'Unknown';
                        final hourlyTemp = hourlyMain['temp'] ?? 0.0;
                        final time = DateTime.parse(hourlyForecast['dt_txt']);

                        return HourlyForecastCard(
                          time: DateFormat.j().format(time),
                          icon: getWeatherIcon(hourlySky),
                          temperature: '${hourlyTemp.toStringAsFixed(1)} °C',
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Additional Info
                  const Text(
                    "Additional Information",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      AdditionalInfoItem(
                        icon: Icons.water_drop,
                        label: 'Humidity',
                        value: '$humidity%',
                      ),
                      AdditionalInfoItem(
                        icon: Icons.speed,
                        label: 'Pressure',
                        value: '$pressure hPa',
                      ),
                      AdditionalInfoItem(
                        icon: Icons.air,
                        label: 'Wind Speed',
                        value: '${windSpeed.toStringAsFixed(1)} m/s',
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
