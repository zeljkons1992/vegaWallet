import 'dart:ui';
import 'package:flutter/material.dart';

class MapLocationError extends StatefulWidget {
  const MapLocationError({super.key});

  @override
  MapLocationErrorState createState() => MapLocationErrorState();
}

class MapLocationErrorState extends State<MapLocationError> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/img/map_error_img.png',
            fit: BoxFit.cover,
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),
          const Center(
            child: Padding(
              padding:  EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.wifi_off,
                    color: Colors.red,
                    size: 36,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'No internet connection. Please check your connection.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
