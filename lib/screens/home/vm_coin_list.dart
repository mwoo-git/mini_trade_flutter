import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:mini_trade_flutter/global/api/binance_rest.dart';
import 'package:mini_trade_flutter/global/models/m_binance.dart';
import 'package:mini_trade_flutter/screens/home/vm_ticker.dart';

enum SortCoins {
  rise,
  fall,
  volume,
}

class CoinListViewModel extends GetxController {
  RxList<TickerViewModel> coinlist = <TickerViewModel>[].obs;

  List<BinanceTicker>? _tickers;

  List<BinanceTicker>? get tickers => _tickers;

  set tickers(List<BinanceTicker>? value) {
    _tickers = value;
    updateCoinlist();
  }

  static List<BinanceCoin>? coins;

  var sort = SortCoins.volume;

  @override
  void onInit() {
    fetchCoins();
    super.onInit();
  }

  Future<void> fetchCoins() async {
    try {
      var coin = await BinanceRestService.fetchFuturesCoins();
      coins = coin;
      fetchTickers();
    } catch (error) {
      // Handle error
      print("DEBUG: fetchCoins() Failed.");
    }
  }

  Future<void> fetchTickers() async {
    if (coins != null) {
      try {
        final tickers = await compute(fetchTickersIsolate, coins);
        this.tickers = tickers;
      } catch (e) {
        print("DEBUG: CoinListViewModel.fetchTickers() Failed. $e");
      }
    } else {
      fetchCoins();
    }
  }

  static Future<List<BinanceTicker>> fetchTickersIsolate(dynamic coins) async {
    final tickers = BinanceRestService.fetchTickers(coins);
    return tickers;
  }

  void updateCoinlist() {
    final sortedArray = sortCoins();
    final viewModels = convertToViewModels(sortedArray);

    coinlist.assignAll(viewModels);
  }

  List<BinanceTicker> sortCoins() {
    if (tickers == null) return [];
    switch (sort) {
      case SortCoins.rise:
        return List.from(tickers!)
          ..sort((a, b) => b.changeRate.compareTo(a.changeRate));
      case SortCoins.fall:
        return List.from(tickers!)
          ..sort((a, b) => a.changeRate.compareTo(b.changeRate));
      case SortCoins.volume:
        return List.from(tickers!)
          ..sort((a, b) => b.volume.compareTo(a.volume));
    }
  }

  List<TickerViewModel> convertToViewModels(List<BinanceTicker> tickers) {
    final viewModels =
        tickers.map((ticker) => TickerViewModel(ticker: ticker)).toList();
    return viewModels;
  }

  void updateSortOption(SortCoins option) {
    sort = option;
    updateCoinlist();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
