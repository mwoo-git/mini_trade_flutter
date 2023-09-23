import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mini_trade_flutter/global/api/binance_socket.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mini_trade_flutter/screens/trade/vm_trade_list.dart';

class ConnectIconView extends StatefulWidget {
  const ConnectIconView({super.key});

  @override
  State<ConnectIconView> createState() => _ConnectIconViewState();
}

class _ConnectIconViewState extends State<ConnectIconView> {
  bool isConnected = BinanceWebSocketService.isConnected.value;

  @override
  void initState() {
    observer();
    super.initState();
  }

  void observer() {
    ever(BinanceWebSocketService.isConnected, (value) {
      setState(() {
        isConnected = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        if (isConnected) {
          BinanceWebSocketService.closeIsolate();
          TradeListViewModel.clearList();
        } else {
          BinanceWebSocketService.closeIsolate();
          BinanceWebSocketService.configureIsolate();
        }
        HapticFeedback.lightImpact();
      },
      icon: Icon(isConnected ? Icons.pause : Icons.play_arrow),
    );
  }
}
