import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mini_trade_flutter/global/data/prefs.dart';

class EditSpecificAmountView extends StatefulWidget {
  const EditSpecificAmountView({super.key});

  @override
  State<EditSpecificAmountView> createState() =>
      _EditEditSpecificAmountViewState();
}

class _EditEditSpecificAmountViewState extends State<EditSpecificAmountView> {
  late TextEditingController controller = TextEditingController(text: formated);

  String title = '특정거래대금(USDT) 조건 설정';
  int current = Prefs.specificAmount.get();
  late String formated = NumberFormat('#,##0').format(current);
  String description = '설정하신 특정거래대금 이상에서만 밑줄과 알림이 사용됩니다.';
  bool isButtonEnabled = false;
  bool isSmallAmount = false;
  int? inputValue;
  int userAmount = Prefs.amount.get();

  @override
  Widget build(BuildContext context) {
    final amount = NumberFormat('#,##0').format(Prefs.amount.get());
    return Scaffold(
        appBar: AppBar(
          title: const Text('특정거래대금 조건 설정'),
          actions: [
            doneButton,
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.grey),
            ),
            textField.paddingOnly(bottom: 10),
            if (isSmallAmount)
              Text('특정거래대금은 순간거래대금($amount USDT)과 같거나 더 커야 합니다.',
                  style: const TextStyle(color: Colors.red))
            else
              Text(
                description,
                style: const TextStyle(color: Colors.grey),
              ),
          ],
        ).paddingSymmetric(horizontal: 18));
  }

  TextButton get doneButton => TextButton(
        onPressed: () {
          isButtonEnabled ? doneButtonTaped() : null;
        },
        child: Text(
          '완료',
          style: TextStyle(
            color: isButtonEnabled ? Colors.blue : Colors.grey,
            fontSize: 20,
          ),
        ),
      );

  TextField get textField => TextField(
        controller: controller,
        onChanged: (text) {
          onChanged(text);
        },
        keyboardType: TextInputType.number,
        inputFormatters: [
          _CurrencyInputFormatter(), // 커스텀 TextInputFormatter 적용
        ],
        autofocus: true,
        decoration: InputDecoration(
          hintText: '순간거래대금(USDT)',
          enabledBorder: underline,
          focusedBorder: underline,
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: clearText,
                )
              : null,
        ),
      );

  UnderlineInputBorder get underline => UnderlineInputBorder(
        borderSide: BorderSide(color: isSmallAmount ? Colors.red : Colors.grey),
      );

  void doneButtonTaped() {
    if (inputValue != null) {
      Prefs.changePrefs(PrefsType.specificAmount, inputValue);
      current = inputValue!;
      setState(() {
        isButtonEnabled = false;
      });
    }
  }

  void onChanged(String text) {
    inputValue = parseAmount(text);
    if (inputValue! >= userAmount) {
      isSmallAmount = false;
      if (current != inputValue) {
        setState(() {
          isButtonEnabled = true;
        });
      } else {
        setState(() {
          isButtonEnabled = false;
        });
      }
    } else {
      setState(() {
        isSmallAmount = true;
        isButtonEnabled = false;
      });
    }
  }

  void clearText() {
    controller.clear();
  }

  int parseAmount(String input) {
    String numericString = input.replaceAll(RegExp(r'[^0-9]'), '');
    int amount = int.tryParse(numericString) ?? 0;

    return amount;
  }
}

class _CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // 입력된 텍스트에서 숫자만 추출하여 포맷팅
    String numericText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // 숫자가 없으면 0을 추가
    if (numericText.isEmpty) {
      numericText = '0';
    }

    // 숫자를 3자리마다 쉼표를 추가하여 포맷팅
    final numberFormat = NumberFormat('#,###');
    String formattedText = numberFormat.format(int.parse(numericText));

    // 입력값이 99,999를 초과하면 수정하지 않음
    int parsedValue = int.tryParse(numericText) ?? 0;
    if (parsedValue >= 10000000) {
      formattedText = oldValue.text;
    }

    // 새로운 TextEditingValue 반환
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
