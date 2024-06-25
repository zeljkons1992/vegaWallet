import 'package:flutter/material.dart';

ButtonStyle primaryButtonStyle(BuildContext context) {
  return ElevatedButton.styleFrom(
    backgroundColor: Theme.of(context).primaryColor,
    overlayColor: Theme.of(context).secondaryHeaderColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(25),
    ),
    elevation: 0,
  );
}
