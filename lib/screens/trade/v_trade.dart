import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini_trade_flutter/global/api/binance_socket.dart';
import 'package:mini_trade_flutter/global/dart/extension/context_extension.dart';
import 'package:mini_trade_flutter/screens/settings/v_settings.dart';
import 'package:mini_trade_flutter/screens/trade/w_trade_list.dart';

import 'w_connect_icon.dart';

class TradeView extends StatefulWidget {
  const TradeView({super.key});

  @override
  State<TradeView> createState() => _TradeViewState();
}

class _TradeViewState extends State<TradeView> {
  String curruntCoin = 'BTC';

  @override
  void initState() {
    super.initState();
    obserber();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: const TradeListView(),
    );
  }

  void obserber() {
    ever(BinanceWebSocketService.currentCoin, (coin) {
      setState(() {
        curruntCoin = coin.replaceFirst('USDT', '');
      });
    });
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.transparent,
      leading: const ConnectIconView(),
      title: RichText(
        text: TextSpan(
          text: curruntCoin,
          style: TextStyle(
              fontSize: 20.0,
              color: context.appColors.textColor,
              fontWeight: FontWeight.bold,
              ),
          children: const <TextSpan>[
            TextSpan(
              text: '  / USDT',
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
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
        ),
      ],
    );
  }
}
