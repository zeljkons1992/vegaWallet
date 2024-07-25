import 'dart:ui';

import 'package:flutter/material.dart';

class MapsUnsuccessfully extends StatelessWidget {

  const MapsUnsuccessfully({
    super.key});

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
                      Icons.location_off_outlined,
                      color: Colors.red,
                      size: 36,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'No Address founded',
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
