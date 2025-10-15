import 'package:flutter/cupertino.dart';
import 'package:sixam_mart_store/common/widgets/details_custom_card.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:flutter/material.dart';

class SwitchButtonWidget extends StatelessWidget {
  final IconData? icon;
  final String title;
  final bool? isButtonActive;
  final Function onTap;
  final String? description;
  const SwitchButtonWidget({super.key, this.icon, required this.title, required this.onTap, this.isButtonActive, this.description});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap as void Function()?,
      child: DetailsCustomCard(
        padding: EdgeInsets.only(
          left: Dimensions.paddingSizeDefault,
          top: isButtonActive != null ? Dimensions.paddingSizeSmall : Dimensions.paddingSizeDefault,
          bottom: isButtonActive != null ? Dimensions.paddingSizeSmall : Dimensions.paddingSizeDefault,
        ),
        child: Row(children: [

          icon != null ? Icon(icon, size: 25) : const SizedBox(),
          SizedBox(width: icon != null ? Dimensions.paddingSizeSmall : 0),

          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              Text(title, style: robotoRegular),

              description != null ? Padding(
                padding: const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall),
                child: Text(description!, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor)),
              ) : const SizedBox(),

            ]),
          ),

          isButtonActive != null ? Transform.scale(
            scale: 0.7,
            child: CupertinoSwitch(
              activeTrackColor: Theme.of(context).primaryColor,
              inactiveTrackColor: Theme.of(context).hintColor.withValues(alpha: 0.5),
              value: isButtonActive!,
              onChanged: (bool? value) => onTap(),
            ),
          ) : const SizedBox(),

        ]),
      ),
    );
  }
}
