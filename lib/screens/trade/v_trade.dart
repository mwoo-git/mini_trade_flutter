import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini_trade_flutter/global/api/binance_socket.dart';
import 'package:mini_trade_flutter/global/dart/extension/context_extension.dart';
import 'package:mini_trade_flutter/screens/settings/v_settings.dart';
import 'package:mini_trade_flutter/screens/trade/w_trade_list.dart';
import 'package:velocity_x/velocity_x.dart';

import 'w_connect_icon.dart';

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
        curruntCoin = coin;
      });
    });
  }

  AppBar appBar() => AppBar(
        leading: const ConnectIconView(),
        title: Text('$curruntCoin 미니체결'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsView(),
                ),
              );
            },
            icon: const Icon(Icons.menu),
          )
        ],
      );
}
