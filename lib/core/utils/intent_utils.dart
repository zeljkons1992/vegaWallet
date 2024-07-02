import 'dart:io' show Platform;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart';

class IntentUtils {
  IntentUtils._();

  static Future<void> launchMaps(double destinationLatitude, double destinationLongitude) async {
    final googleMapsUri = Uri(
      scheme: 'google.navigation',
      queryParameters: {
        'q': '$destinationLatitude,$destinationLongitude'
      },
    );

    final appleMapsUri = Uri(
      scheme: 'https',
      host: 'maps.apple.com',
      queryParameters: {
        'q': '$destinationLatitude,$destinationLongitude'
      },
    );

    final uri = Platform.isIOS ? appleMapsUri : googleMapsUri;

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      debugPrint('An error occurred');
    }
  }
}
