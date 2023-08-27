import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini_trade_flutter/screens/common/w_progress.dart';
import 'package:mini_trade_flutter/screens/trade/vm_trade_list.dart';
import 'package:mini_trade_flutter/screens/trade/vm_trade_tile.dart';

import '../../global/constant/app_colors.dart';
import '../../global/data/prefs.dart';

class TradeListView extends StatefulWidget {
  const TradeListView({super.key});

  @override
  State<TradeListView> createState() => _TradeListViewState();
}

class _TradeListViewState extends State<TradeListView> {
  @override
  void initState() {
    ever(Prefs.didBinanceThemeChanged, (value) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final vm = Get.find<TradeListViewModel>();
      if (vm.tradelist.isEmpty) {
        return const ProgressView();
      } else {
        return ListView.builder(
          reverse: false,
          itemCount: vm.tradelist.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return listHeader.paddingOnly(left: 18, right: 21);
            } else {
              final ticker = vm.tradelist[index - 1];
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
          Row(
            children: [
              SizedBox(width: 100, child: Text('시간')),
              Text('가격'),
            ],
          ),
          Text('거래대금'),
        ],
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
            style:
                TextStyle(color: AppColors.getTradeColor(ticker.ticker.trade)),
          ),
        ],
      ),
    );
  }
}
