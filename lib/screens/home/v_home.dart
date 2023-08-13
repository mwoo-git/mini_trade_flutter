import 'package:flutter/material.dart';
import 'package:mini_trade_flutter/screens/home/w_coin_list.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: body,
    );
  }

  PreferredSizeWidget get appBar => AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            print('햄버거 버튼 탭!');
          },
        ),
        title: const Text('바이낸스 선물'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              print('검색 탭!');
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {},
          )
        ],
      );

  Widget get body => const CoinListView();
}
