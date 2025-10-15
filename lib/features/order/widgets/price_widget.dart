import 'package:flutter/material.dart';
import 'package:sixam_mart_store/util/styles.dart';

class PriceWidget extends StatelessWidget {
  final String title;
  final String value;
  final double fontSize;
  final bool isTotal;
  const PriceWidget({super.key, required this.title, required this.value, required this.fontSize, this.isTotal = false});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(title, style: isTotal ? robotoMedium.copyWith(fontSize: fontSize) : robotoRegular.copyWith(fontSize: fontSize)),
      Text(value, style: robotoMedium.copyWith(fontSize: fontSize)),
    ]);
  }
}
