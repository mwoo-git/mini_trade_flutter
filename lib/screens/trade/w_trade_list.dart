import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini_trade_flutter/screens/common/w_progress.dart';
import 'package:mini_trade_flutter/screens/trade/vm_trade_list.dart';
import 'package:mini_trade_flutter/screens/trade/vm_trade_tile.dart';

class TradeListView extends StatelessWidget {
  const TradeListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final vm = Get.find<TradeListViewModel>();
      if (vm.tradelist.isEmpty) {
        return const ProgressView();
      } else {
        return ListView.builder(
          reverse: false,
          itemCount: vm.tradelist.length,
          itemBuilder: (context, index) {
            final ticker = vm.tradelist[index];
            return listTileView(ticker);
          },
        );
      }
    });
  }

  ListTile listTileView(TradeTileViewModel ticker) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(width: 100, child: Text(ticker.time)),
              Text(ticker.price),
            ],
          ),
          Text(
            ticker.amount,
            style: TextStyle(color: ticker.color),
          ),
        ],
      ),
    );
  }
}
