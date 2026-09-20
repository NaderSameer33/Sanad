import 'package:flutter/material.dart';

class SanadApp extends StatelessWidget {
  const SanadApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sanad App',

      home: const Scaffold(
        body: Center(
          child: Text('Welcome to Sanad App!'),
        ),
      ),
    );
  }
}