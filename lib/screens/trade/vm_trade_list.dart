import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mini_trade_flutter/global/api/binance_socket.dart';
import 'package:mini_trade_flutter/global/data/prefs.dart';
import 'package:mini_trade_flutter/screens/trade/vm_trade_tile.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:mini_trade_flutter/screens/v_main_tab.dart';
import 'package:sound_mode/sound_mode.dart';
import 'package:sound_mode/utils/ringer_mode_statuses.dart';

class TradeListViewModel extends GetxController {
  final BinanceWebSocketService socket = Get.find<BinanceWebSocketService>();
  static RxList<TradeTileViewModel> tradelist = <TradeTileViewModel>[].obs;

  final player = AudioPlayer();
  int specificAmount = Prefs.specificAmount.get();
  bool useSound = Prefs.sound.get();
  bool useVibrate = Prefs.vibrate.get();

  @override
  void onInit() {
    super.onInit();

    observer();
  }

  observer() async {
    ever(
      BinanceWebSocketService.vm,
      (vm) async {
        if (vm != null) {
          tradelist.insert(0, vm);
          playSoundOrVibrateIfPossible(vm.amounInt, vm.ticker.trade);
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

    ever(Prefs.didSpecificAmountChanged, (value) {
      specificAmount = Prefs.specificAmount.get();
    });

    ever(Prefs.didSoundChanged, (value) {
      useSound = Prefs.sound.get();
    });

    ever(Prefs.didVibrateChanged, (value) {
      useVibrate = Prefs.vibrate.get();
    });
  }

  playSoundOrVibrateIfPossible(int amount, bool? isSell) async {
    if (amount >= specificAmount && MainTabView.currentIndex.value == 1) {
      switch (await SoundMode.ringerModeStatus) {
        case RingerModeStatus.silent:
          break;
        case RingerModeStatus.vibrate:
          HapticFeedback.mediumImpact();
        case RingerModeStatus.normal:
          if (useSound && isSell != null) {
            await player.stop();
            await player.play(
                AssetSource(isSell ? 'sounds/sell.wav' : 'sounds/buy.wav'));
          }
        default:
          break;
      }
    }
  }

  static clearList() {
    tradelist.value = [];
  }
}
