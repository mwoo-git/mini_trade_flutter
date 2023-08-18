import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:mini_trade_flutter/global/models/m_binance.dart';
import 'package:mini_trade_flutter/screens/trade/vm_trade_list.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class BinanceWebSocketService extends GetxService {
  final url = Uri.parse('wss://fstream.binance.com/ws');
  WebSocketChannel? _webSocketChannel;

  final RxBool isConnected = false.obs;
  final Rx<dynamic> data = Rx<dynamic>(null);
  // final Rx<BinanceTradeTicker?> ticker = Rx<BinanceTradeTicker?>(null);
  final Rx<String?> currentCoin = Rx<String?>(null);
  int userAmount = 1000; //임시

  @override
  void onInit() {
    connect();
    super.onInit();
  }

  void connect() async {
    try {
      _webSocketChannel = IOWebSocketChannel.connect(url);

      isConnected.value = true;

      send(currentCoin.value ?? 'BTCUSDT');

      _webSocketChannel?.stream.listen(
        (message) {
          data.value = json.encode(message);
        },
        onDone: () {
          isConnected.value = false;
        },
        onError: (error) {
          isConnected.value = false;
        },
      );
    } catch (e) {
      isConnected.value = false;
      print('DEBUG: BinanceWebSocketService.connect() failed: $e');
    }
  }

  send(String symbol) async {
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

  close() async {
    _webSocketChannel?.sink.close();
    isConnected.value = false;
  }
}
