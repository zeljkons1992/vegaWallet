import 'package:flutter/material.dart';

class MapsUnsuccessfully extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRefresh;

  const MapsUnsuccessfully({
    super.key,
    required this.errorMessage,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.red.shade100,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 32.0,
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Text(
                    errorMessage,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20.0),
          GestureDetector(
            onTap: onRefresh,
            child: Container(
              width: 50.0,
              height: 50.0,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.refresh,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
