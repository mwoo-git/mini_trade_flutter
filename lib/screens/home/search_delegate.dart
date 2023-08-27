import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini_trade_flutter/global/api/binance_socket.dart';
import 'package:mini_trade_flutter/screens/home/vm_coin_list.dart';

class CoinSearchDelegate extends SearchDelegate {
  final CoinListViewModel vm;

  CoinSearchDelegate(this.vm);

  @override
  String? get searchFieldLabel => '심볼 검색';

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    final isDarkTheme = brightness == Brightness.dark;

    return theme.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: isDarkTheme
            ? Colors.black.withOpacity(0)
            : Colors.white, // 검색바 배경색 조정
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(
          color: isDarkTheme ? Colors.white : Colors.black, // 힌트 텍스트 색상 조정
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: isDarkTheme ? Colors.white : Colors.black,
      ),
    );
  }

  /// 삭제 버튼
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  /// 뒤로가기 버튼
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  /// '검색'버튼을 눌렀을 때 결과
  @override
  Widget buildResults(BuildContext context) {
    return listView();
  }

  /// 검색어를 입력할 때마다 호출
  @override
  Widget buildSuggestions(BuildContext context) {
    return listView();
  }

  ListView listView() {
    final list = vm.coinlist
        .where(
            (coin) => coin.symbol.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        final ticker = list[index];
        return ListTile(
          onTap: () => listTileTabed(context, ticker.market),
          title: Text(ticker.symbol),
          trailing: Text(
            ticker.changeRate,
            style: TextStyle(color: ticker.color),
          ),
          // You can add more details here if needed
        );
      },
    );
  }

  listTileTabed(BuildContext context, String market) {
    BinanceWebSocketService.currentCoin.value = market;
    BinanceWebSocketService.switchTabIndex.toggle();
    close(context, null);
  }
}
