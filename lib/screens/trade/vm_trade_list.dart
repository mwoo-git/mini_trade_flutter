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
  int specificAmount = Prefs.specificAmount.get();
  bool useSound = Prefs.sound.get();
  bool useVibrate = Prefs.vibrate.get();

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

  playSoundOrVibrateIfPossible(int amount) async {
    if (amount >= specificAmount && MainTabView.currentIndex.value == 1) {
      switch (await SoundMode.ringerModeStatus) {
        case RingerModeStatus.silent:
          break;
        case RingerModeStatus.vibrate:
          if (useVibrate) {
            Vibration.vibrate();
          }
        case RingerModeStatus.normal:
          if (useSound) {
            await player.stop();
            await player.play(AssetSource('sounds/01.wav'));
          }
        default:
          break;
      }
    }
  }

  clearList() {
    tradelist.value = [];
  }
}
