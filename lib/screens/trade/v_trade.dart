import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini_trade_flutter/global/api/binance_socket.dart';
import 'package:mini_trade_flutter/screens/trade/w_trade_list.dart';

class TradeView extends StatefulWidget {
  const TradeView({super.key});

  @override
  State<TradeView> createState() => _TradeViewState();
}

class _TradeViewState extends State<TradeView> {
  String curruntCoin = 'BTCUSDT';

  @override
  void initState() {
    super.initState();
    obserber();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: const TradeListView(),
    );
  }

  void obserber() {
    ever(BinanceWebSocketService.currentCoin, (coin) {
      setState(() {
        curruntCoin = coin ?? 'BTCUSDT';
      });
    });
  }

  AppBar appBar() => AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.refresh),
        ),
        title: Text('$curruntCoin 미니체결'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.menu),
          )
        ],
      );
}
