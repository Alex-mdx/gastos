import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../utilities/theme/theme_color.dart';

class TextfieldMoney extends StatefulWidget {
  final TextEditingController text;
  final Function(double) field;
  final FocusScopeNode? focus;
  const TextfieldMoney(
      {super.key, required this.text, required this.field, this.focus});

  @override
  State<TextfieldMoney> createState() => _TextfieldMoneyState();
}

class _TextfieldMoneyState extends State<TextfieldMoney> {
  @override
  Widget build(BuildContext context) {
    return TextField(
        autofocus: false,
        onTapUpOutside: (event) {
          if (widget.focus != null) {
            if (!widget.focus!.hasPrimaryFocus) {
              widget.focus!.unfocus();
            }
          }
        },
        controller: widget.text,
        keyboardType: TextInputType.number,
        inputFormatters: [CurrencyInputFormatter()],
        style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: ThemaMain.darkBlue),
        textAlign: TextAlign.center,
        onChanged: (value) {
          double doubleValue = 0;
          if (value.isNotEmpty) {
            String digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');
            if (digitsOnly.isNotEmpty) {
              doubleValue = double.parse(digitsOnly) / 100;
            }
          }
          widget.field(doubleValue);
        },
        decoration: InputDecoration(
            hintText: '0.00',
            hintStyle: TextStyle(color: ThemaMain.grey, fontSize: 15.sp),
            filled: true,
            fillColor: ThemaMain.background,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.5.h),
            prefixIcon:
                Icon(Icons.attach_money, size: 20.sp, color: ThemaMain.green),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none)));
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Remover todo lo que no sea dígito
    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    if (digitsOnly.isEmpty) return newValue.copyWith(text: '');

    // Convertir a double y dividir entre 100 para los decimales
    double value = double.parse(digitsOnly) / 100;

    // Formatear el valor
    final formatter =
        NumberFormat.currency(locale: 'en_US', symbol: '', decimalDigits: 2);
    String newText = formatter.format(value);

    return TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length));
  }
}
