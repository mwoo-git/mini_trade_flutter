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
            if (index == 0) {
              return listHeader;
            } else {
              // 나머지 경우 기존의 listTileView 위젯 반환
              final ticker = vm.tradelist[index - 1]; // 추가한 Row 위젯 때문에 인덱스를 -1
              return listTileView(ticker);
            }
          },
        );
      }
    });
  }

  Widget get listHeader => const Padding(
        padding: EdgeInsets.only(left: 18, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(width: 100, child: Text('시간')),
                Text('가격'),
              ],
            ),
            Text('거래대금'),
          ],
        ),
      );

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
