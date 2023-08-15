import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:mini_trade_flutter/global/models/m_binance.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class BinanceWebSocketService extends GetxService {
  WebSocketChannel? _webSocketChannel;
  StreamSubscription? _subscription;

  final RxBool isConnected = false.obs;
  final Rx<BinanceTradeTicker?> ticker = Rx<BinanceTradeTicker?>(null);
  final Rx<String?> currentCoin = Rx<String?>(null);
  int userAmount = 10000; //임시

  void connect() {
    final url = Uri.parse('wss://fstream.binance.com/ws');

    try {
      _webSocketChannel = IOWebSocketChannel.connect(url);

      isConnected.value = true;

      send(currentCoin.value ?? 'BTCUSDT');

      _subscription = _webSocketChannel!.stream.listen((message) {
        onReceiveData(message);
      });
    } catch (e) {
      isConnected.value = false;
      print('DEBUG: BinanceWebSocketService.connect() failed: $e');
    }
  }

  void send(String symbol) {
    if (currentCoin.value != null) {
      final unsubscribeStream = '${currentCoin.value?.toLowerCase()}@aggTrade';
      final unsubscribeMessage = '''
          {"method": "UNSUBSCRIBE", "params": ["$unsubscribeStream"], "id": 1}
          ''';
      _webSocketChannel?.sink.add(unsubscribeMessage);
    }

    currentCoin.value = symbol;

    final stream = '${symbol.toLowerCase()}@aggTrade';
    final message = '''
    {"method": "SUBSCRIBE", "params": ["$stream"], "id": 1}
    ''';
    _webSocketChannel?.sink.add(message);
  }

  void onReceiveData(dynamic message) {
    if (message is String) {
      final decoded = json.decode(message) as Map<String, dynamic>;
      final ticker = BinanceTradeTicker.fromJson(decoded);

      final amount = (double.tryParse(ticker.price) ?? 0) *
          (double.tryParse(ticker.quantity) ?? 0);
      final intAmount = amount.toInt();

      if (intAmount > userAmount) {
        this.ticker.value = ticker;
      }
    }
  }

  void close() {
    _subscription?.cancel();
    _webSocketChannel?.sink.close();
    isConnected.value = false;
  }
}
