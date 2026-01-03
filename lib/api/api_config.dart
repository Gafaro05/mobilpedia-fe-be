import 'package:flutter/foundation.dart';

class ApiConfig {
  static String get baseUrl {
    // Flutter Web
    //if (kIsWeb) {
      //return 'http://localhost:3000';
    //}

    // Android Emulator
    //if (defaultTargetPlatform == TargetPlatform.android) {
      //return 'http://10.0.2.2:3000';
    //}

    // iOS Simulator
    //if (defaultTargetPlatform == TargetPlatform.iOS) {
      //return 'http://localhost:3000';
    //}

    // REAL DEVICE (HP fisik)
    return 'http://192.168.1.217:3000'; // IP laptop kamu
  }
}
