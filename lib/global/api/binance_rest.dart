import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mini_trade_flutter/global/models/m_binance.dart';

enum ExchangeType {
  spot,
  futures,
}

class BinanceRestService {
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
        print("DEBUG: Fetch ${binanceCoins.length} coins.");
        return binanceCoins;
      } else {
        throw Exception("Server Error");
      }
    } catch (error) {
      print("DEBUG: BinanceRestService.fetchFuturesCoins() failed. $error");
      throw error;
    }
  }

  static Future<List<BinanceTicker>> fetchTickers(
      List<BinanceCoin> coins, ExchangeType type) async {
    final symbols = coins.map((coin) => coin.symbol).toList();
    final tickers = <BinanceTicker>[];

    const chunkSize = 10;
    final numChunks = (symbols.length + chunkSize - 1) ~/ chunkSize;

    await Future.wait(
      List<Future<List<BinanceTicker>>>.generate(numChunks, (chunkIndex) async {
        final startIndex = chunkIndex * chunkSize;
        final endIndex = (startIndex + chunkSize).clamp(0, symbols.length);
        final symbolChunk = symbols.sublist(startIndex, endIndex);

        switch (type) {
          case ExchangeType.spot:
            return fetchSpotTickersInParallel(symbolChunk);
          case ExchangeType.futures:
            return fetchFuturesTickersInParallel(symbolChunk);
        }
      }),
    ).then((chunkResults) {
      for (final chunkResult in chunkResults) {
        tickers.addAll(chunkResult);
      }
    });

    return tickers;
  }

  static Future<List<BinanceTicker>> fetchSpotTickersInParallel(
      List<String> symbols) async {
    final tickers = <BinanceTicker>[];

    await Future.wait(symbols.map((symbol) async {
      final urlString =
          "https://api.binance.com/api/v3/klines?symbol=$symbol&interval=1d&limit=1";
      final response = await http.get(Uri.parse(urlString));

      if (response.statusCode == 200) {
        final klines = json.decode(response.body) as List<dynamic>;
        if (klines.isNotEmpty) {
          final klineData = BinanceKline.fromJson(klines.first);
          final ticker = BinanceTicker(market: symbol, kline: klineData);
          tickers.add(ticker);
        }
      } else {
        print(
            "Error fetching ticker for symbol $symbol: ${response.reasonPhrase}");
      }
    }));

    return tickers;
  }

  static Future<List<BinanceTicker>> fetchFuturesTickersInParallel(
      List<String> symbols) async {
    final tickers = <BinanceTicker>[];

    await Future.wait(symbols.map((symbol) async {
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
        print(
            "Error fetching ticker for symbol $symbol: ${response.reasonPhrase}");
      }
    }));

    return tickers;
  }
}
