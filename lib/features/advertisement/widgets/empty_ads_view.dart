import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/common/widgets/custom_asset_image_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_button_widget.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';

class EmptyAdsView extends StatelessWidget {
  final List<int>? counts;
  const EmptyAdsView({super.key, this.counts});

  @override
  Widget build(BuildContext context) {

    bool isAdsEmpty = false;

    for(int i=0; i<counts!.length; i++){
      if(counts![i] > 0){
        isAdsEmpty = false;
        break;
      }else{
        isAdsEmpty = true;
      }
    }

    return !isAdsEmpty ? SizedBox(
      height: Get.height * 0.7, width: Get.width,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

        const CustomAssetImageWidget(Images.adsListImage, height: 70, width: 70),
        const SizedBox(height: Dimensions.paddingSizeSmall),

        Text('no_data_available'.tr, style: robotoRegular.copyWith(color: Theme.of(context).disabledColor)),

      ]),
    ) : SizedBox(height: Get.height * 0.7,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

        const CustomAssetImageWidget(Images.adsListImage, height: 70, width: 70,),
        const SizedBox(height: Dimensions.paddingSizeSmall),

        Text('advertisement_list'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
        const SizedBox(height: Dimensions.paddingSizeSmall),

        Text(
          'uh_oh_You_didnt_created_any_advertisement_yet'.tr,
          textAlign: TextAlign.center,
          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).disabledColor),
        ),
        const SizedBox(height: Dimensions.paddingSizeExtremeLarge),

        CustomButtonWidget(
          margin: EdgeInsets.symmetric(horizontal: context.width*0.2),
          buttonText: 'create_ads'.tr,
          onPressed: (){
            Get.toNamed(RouteHelper.getCreateAdvertisementRoute());
          },
        ),
        const SizedBox(height: Dimensions.paddingSizeExtremeLarge),

        const Divider(),
        const SizedBox(height: Dimensions.paddingSizeExtremeLarge),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
          child: Text(
            'by_creating_advertisement'.tr,
            textAlign: TextAlign.center,
            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
          ),
        ),
      ]),
    );
  }
}
