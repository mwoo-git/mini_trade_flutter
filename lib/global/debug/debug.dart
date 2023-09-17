import 'package:flutter/foundation.dart';

class Debug {
  static print(String str) {
    if (kDebugMode) {
      print('DEBUG: $str');
    }
  }
}
