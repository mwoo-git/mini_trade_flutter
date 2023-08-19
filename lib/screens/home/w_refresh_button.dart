import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini_trade_flutter/screens/home/vm_coin_list.dart';

class RefreshButton extends StatefulWidget {
  const RefreshButton({super.key});

  @override
  State<RefreshButton> createState() => _RefreshButtonState();
}

class _RefreshButtonState extends State<RefreshButton> {
  final vm = Get.find<CoinListViewModel>();
  int countdown = 15;
  bool isCountingDown = false;
  bool isRefreshing = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: isCountingDown ? Text('$countdown') : const Icon(Icons.refresh),
      onPressed: () {
        isRefreshing ? null : startCountdown();
      },
    );
  }

  void startCountdown() {
    setState(() {
      vm.fetchTickers();
      isCountingDown = true;
      isRefreshing = true;
    });
    timer();
  }

  void timer() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        countdown--;
        if (countdown == 0) {
          timer.cancel();
          isCountingDown = false;
          isRefreshing = false;
          countdown = 15;
        }
      });
    });
  }
}
