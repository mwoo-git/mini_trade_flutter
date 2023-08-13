import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mini_trade_flutter/global/models/m_binance.dart';

class TickerViewModel {
  final BinanceTicker ticker;

  TickerViewModel({required this.ticker});

  String get market => ticker.market;

  String get price => ticker.kline.close;

  String get changeRate => "${ticker.changeRate.toStringAsFixed(2)}%";

  String get volume {
    final numberFormatter = NumberFormat.decimalPattern();
    final suffixes = ["", "K", "M", "B", "T"];
    var value = ticker.volume.toDouble();
    var suffixIndex = 0;

    while (value >= 1000 && suffixIndex < suffixes.length - 1) {
      value /= 1000;
      suffixIndex += 1;
    }

    final formattedValue = numberFormatter.format(value);
    return "$formattedValue${suffixes[suffixIndex]}";
  }

  String get symbol => ticker.market;

  Color get color => ticker.changeRate > 0 ? buy : sell;

  Color get buy => Colors.red;

  Color get sell => Colors.blue;
}

class UserDefault {
  static const colorKey = 'isBlue';
}
