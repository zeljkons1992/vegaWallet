import 'dart:ui';

import 'package:flutter/cupertino.dart';


Widget mapLocationInitial(BuildContext context){
  return Stack(
    children: [
      BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
      ),
    ],
  );
}