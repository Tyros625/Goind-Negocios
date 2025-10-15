import 'package:flutter/material.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';

class LabelWidget extends StatelessWidget {
  final String labelText;
  final Widget child;
  final EdgeInsetsGeometry? padding;
  const LabelWidget({super.key, required this.labelText, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Stack(clipBehavior: Clip.none, children: [

      Container(
        padding: padding,
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).disabledColor.withValues(alpha: 0.2)),
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        ),
        child: child,
      ),

      Positioned(
        left: 10, top: -15,
        child: Container(
          decoration: BoxDecoration(color: Theme.of(context).cardColor),
          padding: const EdgeInsets.all(5),
          child: Text(labelText, style: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall)),
        ),
      ),

    ]);
  }
}
