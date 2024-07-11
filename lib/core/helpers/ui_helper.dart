import 'package:flutter/material.dart';

abstract class UIHelper {

  static Color getTextColorFromBackgroundColor(Color backgroundColor) {
    
    double luminance = backgroundColor.computeLuminance();

    double threshold = 0.5;

    if(luminance > threshold){
      return Colors.black;
    } else {
      return Colors.white;
    }

  }

}