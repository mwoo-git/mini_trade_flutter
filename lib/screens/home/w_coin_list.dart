import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini_trade_flutter/screens/home/vm_coin_list.dart';
import 'package:mini_trade_flutter/screens/home/vm_ticker.dart';

class CoinListView extends StatelessWidget {
  const CoinListView({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Get.find<CoinListViewModel>().fetchCoins(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return progressView;
        } else if (snapshot.hasError) {
          return errorView(snapshot);
        } else {
          return GetBuilder<CoinListViewModel>(
            builder: (controller) {
              return ListView.builder(
                itemCount: controller.coinlist.length,
                itemBuilder: (context, index) {
                  final ticker = controller.coinlist[index];
                  return listTileView(ticker);
                },
              );
            },
          );
        }
      },
    );
  }

  ListTile listTileView(TickerViewModel ticker) {
    return ListTile(
      title: Text(ticker.market),
      subtitle: Text(ticker.volume),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(ticker.changeRate, style: TextStyle(color: ticker.color)),
          Text(ticker.price),
        ],
      ),
    );
  }

  Widget get progressView => const Center(
        child: CircularProgressIndicator(),
      );

  Center errorView(AsyncSnapshot<void> snapshot) =>
      Center(child: Text("Error: ${snapshot.error}"));
}
