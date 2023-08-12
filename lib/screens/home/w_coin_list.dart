import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini_trade_flutter/screens/home/vm_coin_list.dart';

class CoinListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Get.find<CoinListViewModel>().loadCoins(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator()); // 로딩 표시 등을 추가할 수 있음
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else {
          return GetBuilder<CoinListViewModel>(
            builder: (controller) {
              return ListView.builder(
                itemCount: controller.coinlist.length,
                itemBuilder: (context, index) {
                  final ticker = controller.coinlist[index];
                  return ListTile(
                    title: Text(ticker.market),
                    subtitle: Text(ticker.volume),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(ticker.changeRate),
                        Text(ticker.price),
                      ],
                    ),
                  );
                },
              );
            },
          );
        }
      },
    );
  }
}
