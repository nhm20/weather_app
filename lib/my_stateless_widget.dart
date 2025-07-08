import 'package:flutter/material.dart';

class MyStatelessWidget extends StatelessWidget {
  const MyStatelessWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Hello World',
          style: TextStyle(fontSize: 24, color: Colors.blue),
        ),
      ),
    );
  }
}
//first constructor is called then build method is called