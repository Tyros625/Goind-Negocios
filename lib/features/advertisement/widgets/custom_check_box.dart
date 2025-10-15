import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';

class CustomCheckBox extends StatelessWidget {
  final String title;
  final Function()? onTap;
  final bool? value;
  const CustomCheckBox({super.key, required this.title, this.onTap, this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
      child: InkWell(
        onTap: onTap,
        child: Row(children: [
          SizedBox(
            width: 20.0,
            child: Checkbox(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
              activeColor: Theme.of(context).colorScheme.primary,
              value: value,
              side: BorderSide(width: 0.7, color: Theme.of(context).textTheme.bodySmall!.color!),
              onChanged: (bool? isActive) => onTap!(),
            ),
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall),

          Text(title.tr, style: value! ? robotoMedium : robotoRegular),
        ]),
      ),
    );
  }
}
