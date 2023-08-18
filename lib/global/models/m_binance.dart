class BinanceTradeTicker {
  final int? eventTime;
  final int? tradeTime;
  final String? symbol;
  final String? price;
  final String? quantity;
  final bool? trade;
  final int? tradeId;

  BinanceTradeTicker({
    required this.eventTime,
    required this.tradeTime,
    required this.symbol,
    required this.price,
    required this.quantity,
    required this.trade,
    required this.tradeId,
  });

  factory BinanceTradeTicker.fromJson(Map<String, dynamic> json) {
    return BinanceTradeTicker(
      eventTime: json['E'],
      tradeTime: json['T'],
      symbol: json['s'],
      price: json['p'],
      quantity: json['q'],
      trade: json['m'],
      tradeId: json['a'],
    );
  }
}

class BinanceExchangeInfo {
  final List<BinanceCoin> symbols;

  BinanceExchangeInfo({required this.symbols});

  factory BinanceExchangeInfo.fromJson(Map<String, dynamic> json) {
    return BinanceExchangeInfo(
      symbols: List<BinanceCoin>.from(
          json['symbols'].map((x) => BinanceCoin.fromJson(x))),
    );
  }
}

class BinanceCoin {
  final String symbol;
  final String baseAsset;
  final String quoteAsset;
  final String status;

  BinanceCoin({
    required this.symbol,
    required this.baseAsset,
    required this.quoteAsset,
    required this.status,
  });

  factory BinanceCoin.fromJson(Map<String, dynamic> json) {
    return BinanceCoin(
      symbol: json['symbol'],
      baseAsset: json['baseAsset'],
      quoteAsset: json['quoteAsset'],
      status: json['status'],
    );
  }
}

class BinanceTicker {
  final String market;
  final BinanceKline kline;

  double get changeRate {
    final openPrice = double.tryParse(kline.open);
    final closePrice = double.tryParse(kline.close);
    if (openPrice != null && closePrice != null && openPrice != 0) {
      return ((closePrice - openPrice) / openPrice) * 100;
    }
    return 0;
  }

  double get volume => double.tryParse(kline.quoteVolume) ?? 0;

  BinanceTicker({
    required this.market,
    required this.kline,
  });

  factory BinanceTicker.fromJson(Map<String, dynamic> json) {
    return BinanceTicker(
      market: json['market'],
      kline: BinanceKline.fromJson(json['kline']),
    );
  }
}

class BinanceKline {
  final int openTime;
  final String open;
  final String high;
  final String low;
  final String close;
  final String volume;
  final int closeTime;
  final String quoteVolume;
  final int trades;
  final String buyAssetVolume;
  final String buyQuoteVolume;
  final String ignored;

  BinanceKline({
    required this.openTime,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
    required this.closeTime,
    required this.quoteVolume,
    required this.trades,
    required this.buyAssetVolume,
    required this.buyQuoteVolume,
    required this.ignored,
  });

  factory BinanceKline.fromJson(List<dynamic> json) {
    return BinanceKline(
      openTime: json[0],
      open: json[1],
      high: json[2],
      low: json[3],
      close: json[4],
      volume: json[5],
      closeTime: json[6],
      quoteVolume: json[7],
      trades: json[8],
      buyAssetVolume: json[9],
      buyQuoteVolume: json[10],
      ignored: json[11],
    );
  }
}

class BinanceFuturesExchangeInfo {
  final String timezone;
  final int serverTime;
  final List<BinanceRateLimit> rateLimits;
  final List<BinanceFuturesSymbol> symbols;

  BinanceFuturesExchangeInfo({
    required this.timezone,
    required this.serverTime,
    required this.rateLimits,
    required this.symbols,
  });

  factory BinanceFuturesExchangeInfo.fromJson(Map<String, dynamic> json) {
    return BinanceFuturesExchangeInfo(
      timezone: json['timezone'],
      serverTime: json['serverTime'],
      rateLimits: List<BinanceRateLimit>.from(
          json['rateLimits'].map((x) => BinanceRateLimit.fromJson(x))),
      symbols: List<BinanceFuturesSymbol>.from(
          json['symbols'].map((x) => BinanceFuturesSymbol.fromJson(x))),
    );
  }
}

class BinanceFuturesSymbol {
  final String symbol;
  final String pair;
  final String contractType;
  final int deliveryDate;
  final int onboardDate;
  final String status;
  final String baseAsset;
  final int baseAssetPrecision;
  final String quoteAsset;
  final int quotePrecision;
  final List<BinanceFuturesSymbolFilter> filters;
  final List<String> orderTypes;
  final List<String> timeInForce;

  BinanceFuturesSymbol({
    required this.symbol,
    required this.pair,
    required this.contractType,
    required this.deliveryDate,
    required this.onboardDate,
    required this.status,
    required this.baseAsset,
    required this.baseAssetPrecision,
    required this.quoteAsset,
    required this.quotePrecision,
    required this.filters,
    required this.orderTypes,
    required this.timeInForce,
  });

  factory BinanceFuturesSymbol.fromJson(Map<String, dynamic> json) {
    return BinanceFuturesSymbol(
      symbol: json['symbol'],
      pair: json['pair'],
      contractType: json['contractType'],
      deliveryDate: json['deliveryDate'],
      onboardDate: json['onboardDate'],
      status: json['status'],
      baseAsset: json['baseAsset'],
      baseAssetPrecision: json['baseAssetPrecision'],
      quoteAsset: json['quoteAsset'],
      quotePrecision: json['quotePrecision'],
      filters: List<BinanceFuturesSymbolFilter>.from(
          json['filters'].map((x) => BinanceFuturesSymbolFilter.fromJson(x))),
      orderTypes: List<String>.from(json['orderTypes']),
      timeInForce: List<String>.from(json['timeInForce']),
    );
  }
}

class BinanceFuturesSymbolFilter {
  final String filterType;
  final String? minPrice;
  final String? maxPrice;
  final String? tickSize;
  final String? minQuantity;
  final String? maxQuantity;
  final String? stepSize;
  final int? maxNumOrders;
  final int? maxNumAlgoOrders;
  final int? limit;

  BinanceFuturesSymbolFilter({
    required this.filterType,
    this.minPrice,
    this.maxPrice,
    this.tickSize,
    this.minQuantity,
    this.maxQuantity,
    this.stepSize,
    this.maxNumOrders,
    this.maxNumAlgoOrders,
    this.limit,
  });

  factory BinanceFuturesSymbolFilter.fromJson(Map<String, dynamic> json) {
    return BinanceFuturesSymbolFilter(
      filterType: json['filterType'],
      minPrice: json['minPrice'],
      maxPrice: json['maxPrice'],
      tickSize: json['tickSize'],
      minQuantity: json['minQuantity'],
      maxQuantity: json['maxQuantity'],
      stepSize: json['stepSize'],
      maxNumOrders: json['maxNumOrders'],
      maxNumAlgoOrders: json['maxNumAlgoOrders'],
      limit: json['limit'],
    );
  }
}

class BinanceRateLimit {
  final String rateLimitType;
  final String interval;
  final int intervalNum;
  final int limit;

  BinanceRateLimit({
    required this.rateLimitType,
    required this.interval,
    required this.intervalNum,
    required this.limit,
  });

  factory BinanceRateLimit.fromJson(Map<String, dynamic> json) {
    return BinanceRateLimit(
      rateLimitType: json['rateLimitType'],
      interval: json['interval'],
      intervalNum: json['intervalNum'],
      limit: json['limit'],
    );
  }
}
