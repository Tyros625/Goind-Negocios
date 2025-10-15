import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/common/widgets/custom_button_widget.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';

class TrialEndBottomSheet extends StatelessWidget {
  final bool isTrial;
  const TrialEndBottomSheet({super.key, this.isTrial = true});

  @override
  Widget build(BuildContext context) {
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
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
            child: Column(mainAxisSize: MainAxisSize.min, children: [


              Image.asset(Images.trial, width: 150),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              Text(
                isTrial ? 'your_free_trial_has_been_ended'.tr : 'your_package_is_expired'.tr,
                textAlign: TextAlign.center,
                style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault),
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              Text(
                isTrial ? 'purchase_subscription_message'.tr : 'renew_or_change_your_subscription_plan_to_unblock_the_access_to_service'.tr,
                textAlign: TextAlign.center,
                style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault),
              ),
              const SizedBox(height: Dimensions.paddingSizeExtraLarge),

              CustomButtonWidget(
                buttonText: 'choose_plan'.tr,
                width: 200, height: 55,
                radius: Dimensions.radiusLarge,
                margin: const EdgeInsets.symmetric(horizontal: 80),
                onPressed: () => Get.toNamed(RouteHelper.getMySubscriptionRoute()),
              ),
              const SizedBox(height: Dimensions.paddingSizeExtraLarge),

              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                ),
                padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeSmall),
                child: Row(children: [
                  Icon(CupertinoIcons.news, color: Theme.of(context).colorScheme.error),
                  const SizedBox(width: Dimensions.paddingSizeLarge),

                  Flexible(
                    child: Text(
                      'all_access_to_service_has_been_blocked_due_to_no_active_subscription'.tr, textAlign: TextAlign.start,
                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).colorScheme.error),
                    ),
                  ),
                ]),
              ),
              const SizedBox(height: Dimensions.paddingSizeExtraLarge),

            ]),
          ),
        ),
      ]),
    );
  }
}
