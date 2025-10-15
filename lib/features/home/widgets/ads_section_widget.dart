import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/common/widgets/custom_asset_image_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_button_widget.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';

class AdsSectionWidget extends StatelessWidget {
  const AdsSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: 170,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                color: Theme.of(context).cardColor,
                boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                ),
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                child: Row(children: [

                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text('want_to_get_highlighted'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    Text(
                      'in_the_customer_app_and_websites'.tr,
                      textAlign: TextAlign.center,
                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).disabledColor),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                  ]),

                ]),
              ),
            ),

            const Positioned(
              top: 3, right: 3,
              child: CustomAssetImageWidget(Images.adsRoundShape, height: 100, width: 100, color: Colors.white),
            ),

            const Positioned(
              bottom: 3, left: 3,
              child: CustomAssetImageWidget(Images.adsCurveShape, height: 100, width: 100, color: Colors.white),
            ),

          ],
        ),

        Positioned(
          bottom: 15, left: 15,
          width: 120,
          child: CustomButtonWidget(
            buttonText: 'create_ads'.tr,
            fontWeight: FontWeight.w500,
            fontSize: Dimensions.fontSizeDefault,
            onPressed: (){
              Get.toNamed(RouteHelper.getCreateAdvertisementRoute());
            },
          ),
        ),

        const Positioned(
          top: 30, right: 15,
          child:  CustomAssetImageWidget(Images.adsImage, height: 85, width: 98),
        ),

      ],
    );
  }
}

