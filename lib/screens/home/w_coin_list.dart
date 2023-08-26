import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini_trade_flutter/global/api/binance_socket.dart';
import 'package:mini_trade_flutter/screens/common/w_progress.dart';
import 'package:mini_trade_flutter/screens/home/vm_coin_list.dart';
import 'package:mini_trade_flutter/screens/home/vm_ticker.dart';

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
              return listTileView(ticker);
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

  ListTile listTileView(TickerViewModel ticker) {
    return ListTile(
      onTap: () => listTileTabed(ticker.market),
      title: Text(ticker.market),
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
