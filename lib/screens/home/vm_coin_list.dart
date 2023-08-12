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
  var coinlist = <TickerViewModel>[].obs;
  var filterd = <TickerViewModel>[].obs;

  List<BinanceTicker>? _tickers;

  List<BinanceTicker>? get tickers => _tickers;
  set tickers(List<BinanceTicker>? value) {
    _tickers = value;
    updateCoinlist();
  }

  List<BinanceCoin>? coins;

  var sort = SortCoins.volume;

  @override
  void onInit() {
    fetchCoins();
    super.onInit();
  }

  Future<void> loadCoins() async {
    update();
  }

  Future<void> fetchCoins() async {
    try {
      final coins = await BinanceRestService.fetchFuturesCoins();
      this.coins = coins;
      fetchTickers();
    } catch (error) {
      // Handle error
      print("DEBUG: fetchCoins() Failed.");
    }
  }

  Future<void> fetchTickers() async {
    try {
      if (coins != null) {
        final tickers =
            await BinanceRestService.fetchTickers(coins!, ExchangeType.futures);
        this.tickers = tickers;
      }
    } catch (error) {
      // Handle error
      print("DEBUG: fetchTickers() Failed.");
    }
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

  @override
  void dispose() {
    super.dispose();
  }
}
