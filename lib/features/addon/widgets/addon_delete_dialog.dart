import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/common/widgets/custom_button_widget.dart';
import 'package:sixam_mart_store/features/addon/controllers/addon_controller.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';

class AddonDeleteDialog extends StatelessWidget {
  final int addonID;
  const AddonDeleteDialog({super.key, required this.addonID});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusLarge)),
      insetPadding: const EdgeInsets.all(30),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: GetBuilder<AddonController>(builder: (addonController) {
        return Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
          child: Column(mainAxisSize: MainAxisSize.min, children: [

            Padding(
              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
              child: Image.asset(Images.deleteDialogIcon, width: 70, height: 70),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
              child: Text(
                'are_you_sure'.tr, textAlign: TextAlign.center,
                style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: Text('you_want_to_delete_this_addon'.tr, style: robotoRegular.copyWith(color: Theme.of(context).hintColor), textAlign: TextAlign.center),
            ),
            const SizedBox(height: 10),

            Row(children: [

              Expanded(
                child: CustomButtonWidget(
                  buttonText: 'yes_delete'.tr,
                  color: const Color(0xffFF4040),
                  isLoading: addonController.isLoading,
                  onPressed: () {
                    addonController.deleteAddon(addonID);
                  },
                ),
              ),
              const SizedBox(width: Dimensions.paddingSizeSmall),

              Expanded(
                child: CustomButtonWidget(
                  buttonText: 'cancel'.tr,
                  color: Theme.of(context).disabledColor.withValues(alpha: 0.1),
                  textColor: Theme.of(context).disabledColor,
                  isBorder: true,
                  onPressed: () {
                    Get.back();
                  },
                ),
              ),

            ]),

          ]),
        );
      }),
    );
  }
}

