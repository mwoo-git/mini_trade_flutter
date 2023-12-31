import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mini_trade_flutter/global/data/prefs.dart';

class EditAmountView extends StatefulWidget {
  const EditAmountView({super.key});

  @override
  State<EditAmountView> createState() => _EditAmountViewState();
}

class _EditAmountViewState extends State<EditAmountView> {
  late TextEditingController controller = TextEditingController(text: formated);

  String title = '순간거래대금(USDT) 조회조건';
  int current = Prefs.amount.get();
  late String formated = NumberFormat('#,##0').format(current);
  String description = '설정하신 순간거래대금 이상의 체결내역만 보여지게 됩니다.';
  bool isButtonEnabled = false;
  bool isSmallAmount = false;
  int? inputValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          title: const Text('순간거래대금 조회조건'),
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
              const Text(
                '순간거래대금은 10,000 USDT 이상으로 설정해주세요.',
                style: TextStyle(color: Colors.red),
              )
            else
              Text(
                description,
                style: const TextStyle(color: Colors.grey),
              )
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
      Prefs.changePrefs(PrefsType.amount, inputValue);
      if (Prefs.specificAmount.get() < inputValue!) {
        Prefs.changePrefs(PrefsType.specificAmount, inputValue);
      }
      current = inputValue!;
      setState(() {
        isButtonEnabled = false;
      });
    }
  }

  void onChanged(String text) {
    inputValue = parseAmount(text);
    if (inputValue! >= 10000) {
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
    if (parsedValue >= 1000000) {
      formattedText = oldValue.text;
    }

    // 새로운 TextEditingValue 반환
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
