import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/common/widgets/custom_asset_image_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_button_widget.dart';
import 'package:sixam_mart_store/util/app_constants.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';

class StoreRegistrationSuccessBottomSheet extends StatelessWidget {
  const StoreRegistrationSuccessBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius : const BorderRadius.only(
          topLeft: Radius.circular(Dimensions.paddingSizeExtraLarge),
          topRight : Radius.circular(Dimensions.paddingSizeExtraLarge),
        ),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [

        Center(
          child: Container(
            margin: const EdgeInsets.only(top: Dimensions.paddingSizeDefault, bottom: Dimensions.paddingSizeDefault),
            height: 5, width: 50,
            decoration: BoxDecoration(
              color: Theme.of(context).highlightColor,
              borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
            ),
          ),
        ),

        Flexible(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
            child: Column(mainAxisSize: MainAxisSize.min, children: [

              const CustomAssetImageWidget(Images.storeRegistrationSuccess, height: 100, width: 130),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              Text('${'welcome_to'.tr} ${AppConstants.appName}!', style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge)),
              const SizedBox(height: Dimensions.paddingSizeDefault),

              Padding(
                padding: const EdgeInsets.only(left: Dimensions.paddingSizeExtremeLarge, right: Dimensions.paddingSizeExtremeLarge),
                child: Text(
                  'thanks_for_joining_us_your_registration_is_under_review_hang_tight_we_ll_notify_you_once_approved'.tr,
                  textAlign: TextAlign.center,
                  style: robotoRegular,
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeExtraOverLarge),

              SizedBox(
                width: 100,
                child: CustomButtonWidget(
                  buttonText: 'okay'.tr,
                  fontWeight: FontWeight.w400,
                  fontSize: Dimensions.fontSizeLarge,
                  onPressed: () => Get.back(),
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),

            ]),
          ),
        ),
      ]),
    );
  }
}
