import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini_trade_flutter/global/api/binance_socket.dart';

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
      onPressed: () {},
      icon: Icon(
        isConnected ? Icons.rss_feed : Icons.error,
        color: isConnected ? Colors.green : Colors.orange,
      ),
    );
  }
}
