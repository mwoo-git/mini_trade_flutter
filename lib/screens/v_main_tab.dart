import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'trade/v_trade.dart';
import 'home/v_home.dart';

class MainTabView extends StatefulWidget {
  const MainTabView({super.key});

  @override
  State<MainTabView> createState() => MainTabViewState();
}

class MainTabViewState extends State<MainTabView> {
  late final List<Widget> _tabs = [
    const HomeView(),
    const TradeView(),
  ];

  static RxInt currentIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          body: IndexedStack(
            index: currentIndex.value,
            children: _tabs,
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentIndex.value,
            onTap: (index) {
              currentIndex.value = index;
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
        ));
  }
}
