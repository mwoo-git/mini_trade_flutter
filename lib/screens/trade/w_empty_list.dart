import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mini_trade_flutter/global/api/binance_socket.dart';

class EmptyListView extends StatelessWidget {
  const EmptyListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isConnected = BinanceWebSocketService.isConnected.value;
      final amount = NumberFormat("#,###")
          .format(BinanceWebSocketService.userAmount.value);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isConnected ? '연결됨' : '연결안됨',
            style: TextStyle(
                color: isConnected ? Colors.green : Colors.orange,
                fontSize: 20),
          ).paddingOnly(bottom: 10),
          Text('순간거래대금 조회조건 $amount USDT 이상 ↑').paddingOnly(bottom: 10),
          const Text('알트코인은 순간거래대금 조회조건의 값이 너무 크면 체결내역이 느리게 갱신될 수 있습니다.'),
        ],
      ).paddingSymmetric(horizontal: 20);
    });
  }
}
