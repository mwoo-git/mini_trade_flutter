import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mini_trade_flutter/global/models/m_binance.dart';

class TradeTileViewModel {
  final BinanceTradeTicker ticker;

  TradeTileViewModel({required this.ticker});

  String get time {
    final utcTimestamp = ticker.tradeTime! ~/ 1000;
    final date = DateTime.fromMillisecondsSinceEpoch(utcTimestamp * 1000);

    final dateFormatter = DateFormat('HH:mm:ss');
    return dateFormatter.format(date);
  }

  String get price => ticker.price ?? '0';

  String get quantity => ticker.quantity ?? '0';

  int get amounInt {
    final double priceValue = double.parse(ticker.price ?? '0');
    final double quantityValue = double.parse(ticker.quantity ?? '0');
    final double amount = priceValue * quantityValue;
    return amount.toInt();
  }

  String get amountStr {
    final NumberFormat numberFormat = NumberFormat("#,##0");
    final String formattedString = numberFormat.format(amounInt);

    return formattedString;
  }
}
