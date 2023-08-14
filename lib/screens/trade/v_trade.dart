import 'package:flutter/material.dart';
import 'package:mini_trade_flutter/app.dart';
import 'package:mini_trade_flutter/screens/trade/w_trade_list.dart';

class TradeView extends StatelessWidget {
  const TradeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: const TradeListView(),
    );
  }

  AppBar appBar() => AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.refresh),
        ),
        title: const Text('BTCUSDT 미니체결'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.menu),
          )
        ],
      );
}
