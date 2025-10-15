import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/common/widgets/custom_asset_image_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_button_widget.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';

class AdsCreateSuccessBottomSheet extends StatelessWidget {
  const AdsCreateSuccessBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(Dimensions.radiusLarge),
          topLeft: Radius.circular(Dimensions.radiusLarge),
        ),
      ),
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [

        Container(
          height: 6, width: 50,
          decoration: BoxDecoration(
            color: Theme.of(context).disabledColor.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
          ),
          margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
        ),

        CustomAssetImageWidget(Images.adsSuccess, height: context.height * 0.2, width: context.height * 0.2),
        const SizedBox(height: Dimensions.paddingSizeDefault),


        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
          child: Text('ads_created_successfully'.tr, textAlign: TextAlign.center, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
        ),
        const SizedBox(height: Dimensions.paddingSizeDefault),


        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
          child: Text('congratulation_description'.tr, textAlign: TextAlign.center, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).hintColor)),
        ),
        const SizedBox(height: Dimensions.paddingSizeLarge),

        Row(children: [
          const Expanded(child: SizedBox()),
          CustomButtonWidget(
            width: 150,
            buttonText: 'okay'.tr,
            onPressed: () => Get.back(),
          ),
          const Expanded(child: SizedBox()),
        ]),

      ]),
    );
  }
}
