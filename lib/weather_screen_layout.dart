import 'dart:convert';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weather_app/additional_info_item.dart';
import 'package:weather_app/hourly_forecast_card.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  double temperature = 0;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    getCurrentWeather();
  }

  Future getCurrentWeather() async {
    try {
      setState(() {
        isLoading = true;
      });
      String city = "London";
      final apiKey = dotenv.env['API_KEY'];

      final res = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$apiKey',
        ),
      );
      // debugPrint(res.body);
      final data = jsonDecode(res.body);
      if (data['cod'] != '200') {
        debugPrint("Error: ${data['message']}");
        return;
      }
      setState(() {
        {
          temperature = data['list'][0]['main']['temp'];
          isLoading = false;
        }
      });
    } catch (e) {
      debugPrint("Error fetching weather data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Weather App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              print('refresh tapped');
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //main card
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
                                  '${temperature.toStringAsFixed(1)} °K',
                                  style: TextStyle(
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 16),
                                Icon(
                                  Icons.cloud,
                                  size: 64,
                                  color: Colors.blue,
                                ), // Placeholder for weather icon
                                SizedBox(height: 16),
                                Text(
                                  'Partly Cloudy',
                                  style: TextStyle(fontSize: 24),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  //weather forecast cards
                  const Text(
                    "Weather Forecast",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        HourlyForecastCard(
                          time: "00:00",
                          temperature: "20 °K",
                          icon: Icons.cloud,
                        ),
                        HourlyForecastCard(
                          time: "01:00",
                          temperature: "21 °K",
                          icon: Icons.sunny,
                        ),
                        HourlyForecastCard(
                          time: "02:00",
                          temperature: "22 °K",
                          icon: Icons.sunny_snowing,
                        ),
                        HourlyForecastCard(
                          time: "03:00",
                          temperature: "23 °K",
                          icon: Icons.cloud,
                        ),
                        HourlyForecastCard(
                          time: "04:00",
                          temperature: "24 °K",
                          icon: Icons.sunny,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  //additional information cards
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
                        value: '91%',
                      ),
                      AdditionalInfoItem(
                        icon: Icons.beach_access,
                        label: 'Pressure',
                        value: '1000',
                      ),
                      AdditionalInfoItem(
                        icon: Icons.air,
                        label: 'Wind Speed',
                        value: '5 m/s',
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
