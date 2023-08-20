import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini_trade_flutter/global/api/binance_socket.dart';
import 'trade/v_trade.dart';
import 'home/v_home.dart';

class MainTabView extends StatefulWidget {
  const MainTabView({super.key});

  @override
  State<MainTabView> createState() => _MainTabViewState();
}

class _MainTabViewState extends State<MainTabView> {
  late final List<Widget> _tabs = [
    const HomeView(),
    const TradeView(),
  ];

  int _currentIndex = 0;

  @override
  void initState() {
    obserber();
    super.initState();
  }

  void obserber() {
    ever(
      BinanceWebSocketService.switchTabIndex,
      (i) => {setState(() => _currentIndex = 1)},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _tabs,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Trade',
          ),
        ],
      ),
    );
  }
}
