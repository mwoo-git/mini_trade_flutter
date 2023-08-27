import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini_trade_flutter/global/api/binance_socket.dart';
import 'package:mini_trade_flutter/screens/common/w_progress.dart';
import 'package:mini_trade_flutter/screens/home/vm_coin_list.dart';
import 'package:mini_trade_flutter/screens/home/vm_ticker.dart';

import '../../global/data/prefs.dart';

class CoinListView extends StatelessWidget {
  const CoinListView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Get.find<CoinListViewModel>();
    return Obx(() {
      if (vm.coinlist.isEmpty) {
        return const ProgressView();
      } else {
        return ListView.builder(
          itemCount: vm.coinlist.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return listHeader.paddingOnly(left: 17, right: 21);
            } else {
              final ticker = vm.coinlist[index - 1];
              return listTileView(ticker, context);
            }
          },
        );
      }
    });
  }

  Row get listHeader => const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('심볼 / 거래량'),
          Text('변동률 / 가격'),
        ],
      );

  ListTile listTileView(TickerViewModel ticker, BuildContext context) {
    Color color = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
    return ListTile(
      onTap: () => listTileTabed(ticker.market),
      title: RichText(
        text: TextSpan(
          text: ticker.symbol,
          style: TextStyle(fontSize: 16.0, color: color),
          children: const <TextSpan>[
            TextSpan(
              text: ' / USDT',
              style: TextStyle(fontSize: 12.0, color: Colors.grey),
            ),
          ],
        ),
      ),
      subtitle: Text(ticker.volume),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            ticker.changeRate,
            style: TextStyle(
              color: ticker.color,
              fontSize: 14.0,
            ),
          ),
          Text(
            ticker.price,
            style: const TextStyle(
              fontSize: 14.0,
            ),
          ),
        ],
      ),
    );
  }

  static listTileTabed(String market) {
    BinanceWebSocketService.currentCoin.value = market;
    BinanceWebSocketService.switchTabIndex.toggle();
  }
}
