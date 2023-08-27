import 'package:flutter/material.dart';
import 'package:mini_trade_flutter/global/data/prefs.dart';

class AppColors {
  static Color sellColor() =>
      Prefs.isBinanceTheme.get() ? Colors.red : Colors.blue;
  static Color buyColor() =>
      Prefs.isBinanceTheme.get() ? Colors.green : Colors.red;

  static Color getTradeColor(dynamic value) {
    if (value is double) {
      return value > 0 ? AppColors.buyColor() : AppColors.sellColor();
    } else if (value is bool) {
      return value ? AppColors.buyColor() : AppColors.sellColor();
    }
    return Colors.black;
  }
}
