import 'package:flutter/material.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

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
          // InkWell(
          //   onTap: () {
          //     print('refresh tapped');
          //   },
          //   child: Icon(Icons.refresh),
          // ),
         
          // GestureDetector(
          //   onTap: () {
          //     print('refresh tapped');
          //   },
          //   child: Icon(Icons.refresh),
          // ),
           IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              print('refresh tapped');
            },
          ),
        ],
      ),
      body: Center(child: Text('Weather information will be displayed here.')),
    );
  }
}

// InkWell is a widget that detects taps and can be used to wrap other widgets to make them tappable. 
// It provides a square ripple effect when tapped, giving visual feedback to the user, and does not provide padding or margin by default.
// IconButton is a widget that displays an icon and can be tapped to perform an action.
// It provides a circular ripple effect when tapped, and provides padding around the icon by default.
// GestureDetector is a widget that detects gestures, such as taps, drags, and swipes, and can be used to wrap other widgets to make them respond to gestures.
// It does not provide any visual feedback by default, so you may need to add your own feedback (like changing the color of the icon) when tapped.