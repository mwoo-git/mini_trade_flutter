import 'dart:async';
import 'dart:convert';
import 'dart:isolate';
import 'package:get/get.dart';
import 'package:mini_trade_flutter/global/models/m_binance.dart';
import 'package:mini_trade_flutter/screens/trade/vm_trade_tile.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class BinanceWebSocketService extends GetxService {
  static final url = Uri.parse('wss://fstream.binance.com/ws');
  static WebSocketChannel? _webSocketChannel;

  static final RxBool isConnected = false.obs;
  static final Rx<dynamic> vm = Rx<dynamic>(null);
  static final Rx<String?> currentCoin = Rx<String?>(null);
  static int userAmount = 100000; //임시

  late Isolate _isolate;
  final _receivePort = ReceivePort();

  @override
  void onInit() {
    configureIsolate();
    super.onInit();
  }

  Future<void> configureIsolate() async {
    _isolate = await Isolate.spawn(connect, _receivePort.sendPort);
    _receivePort.listen((message) {
      vm.value = message;
    });
  }

  static void connect(SendPort sendPort) async {
    try {
      _webSocketChannel = IOWebSocketChannel.connect(url);
      print('웹소켓 연결');

      isConnected.value = true;

      send(currentCoin.value ?? 'BTCUSDT');

      _webSocketChannel?.stream.listen(
        (message) async {
          TradeTileViewModel? vm = await receive(message);
          if (vm != null) {
            sendPort.send(vm);
          }
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

  static send(String symbol) async {
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

  static Future<TradeTileViewModel?> receive(String data) async {
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
    _receivePort.close();
    _isolate.kill(priority: Isolate.immediate);
    super.onClose();
  }
}
