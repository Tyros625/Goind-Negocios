import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/common/widgets/custom_button_widget.dart';
import 'package:sixam_mart_store/features/store/controllers/store_controller.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';

class AnnouncementStatusBottomSheet extends StatefulWidget {
  const AnnouncementStatusBottomSheet({super.key});

  @override
  State<AnnouncementStatusBottomSheet> createState() => _AnnouncementStatusBottomSheetState();
}

class _AnnouncementStatusBottomSheetState extends State<AnnouncementStatusBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width,
      padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(Dimensions.radiusExtraLarge), topRight: Radius.circular(Dimensions.radiusExtraLarge),
        ),
      ),
      child: GetBuilder<StoreController>(builder: (storeController) {
        return Column(mainAxisSize: MainAxisSize.min, children: [

          Container(
            height: 5, width: 50,
            decoration: BoxDecoration(
              color: Theme.of(context).hintColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            ),
          ),
          const SizedBox(height: 35),

          Image.asset(
            Images.cautionDialogIcon, height: 60, width: 60,
          ),
          const SizedBox(height: 35),

          Text('are_you_sure'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge), textAlign: TextAlign.center),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
            child: Text(
              storeController.announcementStatus ? 'you_want_to_disable_announcement'.tr : 'you_want_to_enable_announcement'.tr,
              style: robotoRegular.copyWith(color: Theme.of(context).hintColor), textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 50),

          Row(children: [

            Expanded(
              child: CustomButtonWidget(
                onPressed: () async {
                  storeController.setAnnouncementStatus(!storeController.announcementStatus);
                  Get.back();
                },
                buttonText: 'yes'.tr,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            const SizedBox(width: Dimensions.paddingSizeSmall),

            Expanded(
              child: CustomButtonWidget(
                onPressed: () {
                  Get.back();
                },
                buttonText: 'no'.tr,
                color: Theme.of(context).disabledColor.withValues(alpha: 0.5),
                textColor: Theme.of(context).textTheme.bodyLarge!.color,
              ),
            ),

          ]),

        ]);
      }),
    );
  }
}
