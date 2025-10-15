import 'package:flutter/material.dart';
import 'package:sixam_mart_store/features/auth/controllers/auth_controller.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';

class BaseCardWidget extends StatelessWidget {
  final AuthController authController;
  final String title;
  final String? description;
  final int index;
  final Function onTap;
  const BaseCardWidget({super.key, required this.authController, required this.title, required this.index, required this.onTap, this.description});

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: onTap as void Function()?,
      child: Stack(clipBehavior: Clip.none, children: [

        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            color: authController.businessIndex == index ? Theme.of(context).primaryColor.withValues(alpha: 0.05) : Theme.of(context).cardColor,
            border: Border.all(color: authController.businessIndex == index ? Theme.of(context).primaryColor
                : Theme.of(context).disabledColor.withValues(alpha: 0.2), width: 1),
          ),
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeLarge),
          child: Align(
            alignment: Alignment.center,
            child: Text(title, style: robotoMedium.copyWith(color: authController.businessIndex == index ? Theme.of(context).primaryColor : Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.7), fontSize: Dimensions.fontSizeDefault,
              fontWeight: authController.businessIndex == index ? FontWeight.w600 : FontWeight.w400,
            )),
          ),
        ),

        authController.businessIndex == index ? Positioned(
          top: -10, right: -10,
          child: Container(
            padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
            decoration: BoxDecoration(
              shape: BoxShape.circle, color: Theme.of(context).primaryColor,
            ),
            child: Icon(Icons.check, size: 14, color: Theme.of(context).cardColor),
          ),

        ) : const SizedBox()
      ]),
    );
  }
}