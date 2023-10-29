import 'package:flutter/material.dart';
import 'package:mini_trade_flutter/global/dart/extension/context_extension.dart';
import 'package:mini_trade_flutter/screens/home/vm_coin_list.dart';
import '../../global/constant/app_colors.dart';
import '../trade/w_trade_list.dart';

class CoinSearchDelegate extends SearchDelegate {
  final CoinListViewModel vm;

  CoinSearchDelegate(this.vm);

  @override
  TextInputType? get keyboardType => TextInputType.text;

  @override
  String? get searchFieldLabel => '심볼 검색';

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);

    return theme.copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: context.appColors.textColor,
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
          title: Text(
            ticker.symbol,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          trailing: Text(
            ticker.changeRate,
            style: TextStyle(
                fontSize: 14,
                color: AppColors.getTradeColor(ticker.ticker.changeRate),
                fontWeight: FontWeight.bold),
          ),
          // You can add more details here if needed
        );
      },
    );
  }

  listTileTabed(BuildContext context, String market) {
    TradeListView.updateView(market);
    close(context, null);
  }
}
