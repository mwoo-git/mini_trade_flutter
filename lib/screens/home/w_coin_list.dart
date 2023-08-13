import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini_trade_flutter/screens/home/vm_coin_list.dart';
import 'package:mini_trade_flutter/screens/home/vm_ticker.dart';

class CoinListView extends StatelessWidget {
  const CoinListView({super.key});
  get vm => Get.find<CoinListViewModel>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (vm.coinlist.isEmpty) {
        return progressView;
      } else {
        return ListView.builder(
          itemCount: vm.coinlist.length,
          itemBuilder: (context, index) {
            final ticker = vm.coinlist[index];
            return listTileView(ticker);
          },
        );
      }
    });
  }

  ListTile listTileView(TickerViewModel ticker) {
    return ListTile(
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

  Widget get progressView => const Center(
        child: CircularProgressIndicator(),
      );
}
