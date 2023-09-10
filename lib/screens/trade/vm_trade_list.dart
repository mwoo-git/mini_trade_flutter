import 'package:get/get.dart';
import 'package:mini_trade_flutter/global/api/binance_socket.dart';
import 'package:mini_trade_flutter/global/data/prefs.dart';
import 'package:mini_trade_flutter/screens/trade/vm_trade_tile.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:mini_trade_flutter/screens/v_main_tab.dart';
import 'package:sound_mode/sound_mode.dart';
import 'package:sound_mode/utils/ringer_mode_statuses.dart';
import 'package:vibration/vibration.dart';

class TradeListViewModel extends GetxController {
  final BinanceWebSocketService socket = Get.find<BinanceWebSocketService>();
  RxList<TradeTileViewModel> tradelist = <TradeTileViewModel>[].obs;

  final player = AudioPlayer();

  bool? hasVibrator;

  @override
  void onInit() {
    super.onInit();

    observer();
    configure();
  }

  configure() async {
    hasVibrator = await Vibration.hasVibrator();
  }

  observer() async {
    ever(
      BinanceWebSocketService.vm,
      (vm) async {
        if (vm != null) {
          tradelist.insert(0, vm);
          playSoundOrVibrateIfPossible(vm.amounInt);
        }
        if (tradelist.length > 15) {
          tradelist.removeLast();
        }
      },
    );

    ever(
      BinanceWebSocketService.currentCoin,
      (coin) {
        clearList();
      },
    );

    ever(
      Prefs.didAmountChanged,
      (value) {
        clearList();
      },
    );
  }

  playSoundOrVibrateIfPossible(int amount) async {
    if (amount > 100000 && MainTabView.currentIndex.value == 1) {
      switch (await SoundMode.ringerModeStatus) {
        case RingerModeStatus.silent:
          break;
        case RingerModeStatus.vibrate:
          if (hasVibrator == true) {
            Vibration.vibrate();
          }
        case RingerModeStatus.normal:
          await player.stop();
          await player.play(AssetSource('sounds/01.wav'));
        default:
          break;
      }
    }
  }

  clearList() {
    tradelist.value = [];
  }
}
