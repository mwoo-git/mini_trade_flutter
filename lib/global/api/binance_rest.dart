import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mini_trade_flutter/global/models/m_binance.dart';

enum ExchangeType {
  spot,
  futures,
}

enum RestApiStatus {
  none,
  error,
  success,
}

class BinanceRestService {
  static Rx<RestApiStatus> apiStatus = Rx(RestApiStatus.none);

  static Future<List<BinanceCoin>> fetchFuturesCoins() async {
    const baseUrl = "https://fapi.binance.com/fapi/v1";
    final url = Uri.parse("$baseUrl/exchangeInfo");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final binanceExchangeInfo =
            BinanceFuturesExchangeInfo.fromJson(json.decode(response.body));
        final filteredSymbols = binanceExchangeInfo.symbols.where((symbol) =>
            symbol.quoteAsset == "USDT" &&
            symbol.contractType == "PERPETUAL" &&
            symbol.status == "TRADING");
        final binanceCoins = filteredSymbols
            .map((symbol) => BinanceCoin(
                  symbol: symbol.symbol,
                  baseAsset: symbol.baseAsset,
                  quoteAsset: symbol.quoteAsset,
                  status: symbol.status,
                ))
            .toList();
        debugPrint("DEBUG: Fetch ${binanceCoins.length} coins.");
        return binanceCoins;
      } else {
        throw Exception("Server Error");
      }
    } catch (error) {
      
      
      debugPrint("DEBUG: BinanceRestService.fetchFuturesCoins() failed. $error");
      rethrow;
    }
  }

  // 190여개의 코인캔들 정보를 10개씩 병렬로 가져오는 함수
  static Future<List<BinanceTicker>> fetchTickers(
      List<BinanceCoin> coins) async {
    const chunkSize = 10;
    final numChunks = (coins.length + chunkSize - 1) ~/ chunkSize;

    final tickers = <BinanceTicker>[];

    await Future.wait(
      List.generate(numChunks, (chunkIndex) {
        final startIndex = chunkIndex * chunkSize;
        final endIndex = (startIndex + chunkSize).clamp(0, coins.length);
        final coinChunk = coins.sublist(startIndex, endIndex);

        return fetchTickerChunk(coinChunk);
      }),
    ).then((chunkResults) {
      for (final chunkResult in chunkResults) {
        tickers.addAll(chunkResult);
      }
    });

    return tickers;
  }

  static Future<List<BinanceTicker>> fetchTickerChunk(
      List<BinanceCoin> coins) async {
    final tickers = <BinanceTicker>[];
    for (final coin in coins) {
      List<BinanceTicker> coinTicker = await fetchFuturesTickers(coin.symbol);
      tickers.addAll(coinTicker);
    }

    return tickers;
  }

  static Future<List<BinanceTicker>> fetchFuturesTickers(String symbol) async {
    final tickers = <BinanceTicker>[];

    final urlString =
        "https://fapi.binance.com/fapi/v1/klines?symbol=$symbol&interval=1d&limit=1";
    final response = await http.get(Uri.parse(urlString));

    if (response.statusCode == 200) {
      final klines = json.decode(response.body) as List<dynamic>;
      if (klines.isNotEmpty) {
        final klineData = BinanceKline.fromJson(klines.first);
        final ticker = BinanceTicker(market: symbol, kline: klineData);
        tickers.add(ticker);
      }
    } else {
      debugPrint(
          "Error fetching ticker for symbol $symbol: ${response.reasonPhrase}");
    }

    return tickers;
  }
}
