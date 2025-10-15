import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/common/widgets/custom_button_widget.dart';
import 'package:sixam_mart_store/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';

class OutOfStockWarningBottomSheet extends StatelessWidget {
  const OutOfStockWarningBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {

    int outOfStockCount = Get.find<ProfileController>().profileModel!.outOfStockCount!;

    return Container(
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
            height: 3, width: 40,
            decoration: BoxDecoration(
                color: Theme.of(context).highlightColor,
                borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall)
            ),
          ),
        ),

        Flexible(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
            child: Column(mainAxisSize: MainAxisSize.min, children: [

              Image.asset(Images.alert, width: 70),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),

              Text(
                'warning'.tr,
                textAlign: TextAlign.center,
                style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge),
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),

              RichText(
                text: TextSpan(
                  text: outOfStockCount > 3 ? '${outOfStockCount > outOfStockCount - 1 ? '${outOfStockCount - 1}${'more'.tr}' : outOfStockCount}' : outOfStockCount.toString(),
                  style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Get.isDarkMode ? Colors.white : Colors.black),
                  children: [
                    TextSpan(
                      text: outOfStockCount > 3 ? ' ${outOfStockCount > outOfStockCount - 1 ? 'products_are_low_on_stock'.tr : 'product_is_low_on_stock'.tr}' : 'product_is_low_on_stock'.tr,
                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeExtraLarge),

              CustomButtonWidget(
                buttonText: 'view_details'.tr,
                width: 200, height: 55,
                radius: Dimensions.radiusLarge,
                margin: const EdgeInsets.symmetric(horizontal: 80),
                onPressed: () {
                  Get.find<ProfileController>().hideLowStockWarning();
                  Get.back();
                  return Get.toNamed(RouteHelper.getLowStockRoute());
                },
              ),
              const SizedBox(height: Dimensions.paddingSizeExtraLarge),

            ]),
          ),
        ),
      ]),
    );
  }
}
