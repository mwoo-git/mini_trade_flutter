import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini_trade_flutter/global/api/binance_rest.dart';
import 'package:mini_trade_flutter/screens/home/vm_coin_list.dart';
import 'package:velocity_x/velocity_x.dart';

class ApiErrorView extends StatefulWidget {
  const ApiErrorView({super.key});

  @override
  State<ApiErrorView> createState() => _ApiErrorViewState();
}

class _ApiErrorViewState extends State<ApiErrorView> {
  bool isRefresh = false;

  @override
  void initState() {
    observer();
    super.initState();
  }

  observer() {
    ever(BinanceRestService.apiStatus, (value){

    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.error_outline,
          color: Colors.grey,
          size: 60,
        ),
        const Text(
          'Oops..!',
          style: TextStyle(fontSize: 24),
        ),
        const Text('Something went wrong', style: TextStyle(fontSize: 24))
            .paddingOnly(bottom: 30),
        const Text('바이낸스로부터 코인 데이터를 받아오지 못 했습니다.'),
        const Text('잠시 후에 다시 시도해주세요.').paddingOnly(bottom: 10),
        const Text('바이낸스가 차단된 국가에서는 사용할 수 없습니다.'),
        const Text('(미국, 영국, 캐나다, 일본 등의 국가)').paddingOnly(bottom: 30),
        const Text('Failed to retrieve coin data from Binance.'),
        const Text('Please try again shortly.').paddingOnly(bottom: 10),
        const Text(
          'This service is not available in countries where Binance is restricted.',
          textAlign: TextAlign.center,
        ),
        const Text(
          '(United States, United Kingdom, Canada, Japan, etc.)',
          textAlign: TextAlign.center,
        ).paddingOnly(bottom: 50),
        refreshButton()
      ],
    ).centered().paddingSymmetric(horizontal: 20);
  }

  ElevatedButton refreshButton() {
    return ElevatedButton(
        onPressed: () {
          setState(() {
            isRefresh = true;
            BinanceRestService.apiStatus.value = RestApiStatus.none;
            CoinListViewModel.fetchCoin.value.toggle();
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          minimumSize: const Size(120, 40),
        ),
        child: const Icon(
                Icons.refresh, // 리프레시 아이콘 사용
                color: Colors.white, // 아이콘 색상 설정
              ),
      );
  }
}
