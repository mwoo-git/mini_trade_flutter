import 'package:flutter/material.dart';
import 'trade/v_trade.dart';
import 'home/v_home.dart';

class MainTabView extends StatefulWidget {
  const MainTabView({super.key});

  @override
  State<MainTabView> createState() => _MainTabViewState();
}

class _MainTabViewState extends State<MainTabView> {
  final PageStorageBucket _bucket = PageStorageBucket();
  late final List<Widget> _tabs = [
    PageStorage(
      bucket: _bucket,
      child: const HomeView(),
      key: const PageStorageKey<String>('Home'),
    ),
    PageStorage(
      bucket: _bucket,
      child: const TradeView(),
      key: const PageStorageKey<String>('Trade'),
    ),
  ];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_currentIndex],
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
            icon: Icon(Icons.person),
            label: 'Trade',
          ),
        ],
      ),
    );
  }
}
