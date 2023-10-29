import 'dart:async';
import 'dart:convert';
import 'dart:isolate';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:mini_trade_flutter/global/data/prefs.dart';
import 'package:mini_trade_flutter/global/models/m_binance.dart';
import 'package:mini_trade_flutter/screens/trade/vm_trade_tile.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class IsolateParameters {
  final SendPort sendPort;
  final String currentCoin;
  final int amount;

  IsolateParameters(this.sendPort, this.currentCoin, this.amount);
}

class BinanceWebSocketService extends GetxService {
  static final url = Uri.parse('wss://fstream.binance.com/ws');

  static WebSocketChannel? _webSocketChannel;

  static final RxBool isConnected = false.obs;
  static final Rx<TradeTileViewModel?> vm = Rx<TradeTileViewModel?>(null);
  static final RxString currentCoin = RxString('BTCUSDT');
  static final RxInt userAmount = Prefs.amount.get().obs;

  static late Isolate _isolate;
  late ReceivePort? receivePort;

  @override
  void onInit() {
    configureIsolate();
    observer();
    super.onInit();
  }

  void observer() {
    ever(currentCoin, (coin) {
      closeIsolate();
      configureIsolate();
    });

    ever(
      Prefs.didAmountChanged,
      (value) {
        userAmount.value = Prefs.amount.get();
        closeIsolate();
        configureIsolate();
      },
    );
  }

  static void closeIsolate() {
    _isolate.kill(priority: Isolate.immediate);
    isConnected.value = false;
  }

  static Future<void> configureIsolate() async {
    final receivePort = ReceivePort();
    final params = IsolateParameters(
        receivePort.sendPort, currentCoin.value, userAmount.value);
    _isolate = await Isolate.spawn(connect, params);
    receivePort.listen((message) {
      if (message is bool) {
        isConnected.value = message;
      } else {
        vm.value = message;
      }
    });
  }

  static void connect(IsolateParameters params) async {
    final sendPort = params.sendPort;
    final currentCoin = params.currentCoin;
    final userAmount = params.amount;

    try {
      _webSocketChannel = IOWebSocketChannel.connect(url);
      sendPort.send(true);
      send(currentCoin);
      _webSocketChannel?.stream.listen(
        (message) async {
          TradeTileViewModel? vm = await receive(message, userAmount);
          if (vm != null) {
            sendPort.send(vm);
          }
        },
        onDone: () {
          sendPort.send(false);
        },
        onError: (error) {
          sendPort.send(false);
        },
      );
    } catch (e) {
      sendPort.send(false);
      debugPrint('DEBUG: BinanceWebSocketService.connect() failed: $e');
    }
  }

  static send(String symbol) async {
    final stream = '${symbol.toLowerCase()}@aggTrade';
    final message = '''
    {"method": "SUBSCRIBE", "params": ["$stream"], "id": 1}
    ''';
    _webSocketChannel?.sink.add(message);
  }

  static Future<TradeTileViewModel?> receive(
      String data, int userAmount) async {
    final decoded = json.decode(data) as Map<String, dynamic>;
    final ticker = BinanceTradeTicker.fromJson(decoded);
    final amount = (double.tryParse(ticker.price ?? '0') ?? 0) *
        (double.tryParse(ticker.quantity ?? '0') ?? 0);
    if (amount > userAmount) {
      final vm = TradeTileViewModel(ticker: ticker);
      return vm;
    }
    return null;
  }

  close() async {
    _webSocketChannel?.sink.close();
    isConnected.value = false;
  }

  @override
  void onClose() {
    close();
    closeIsolate();
    super.onClose();
  }
}
