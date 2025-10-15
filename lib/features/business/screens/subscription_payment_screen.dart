import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/common/widgets/confirmation_dialog_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_button_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_image_widget.dart';
import 'package:sixam_mart_store/features/business/controllers/business_controller.dart';
import 'package:sixam_mart_store/features/business/widgets/payment_cart_widget.dart';
import 'package:sixam_mart_store/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart_store/helper/responsive_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';

class SubscriptionPaymentScreen extends StatefulWidget {
  final int storeId;
  final int packageId;
  const SubscriptionPaymentScreen({super.key, required this.storeId, required this.packageId});

  @override
  State<SubscriptionPaymentScreen> createState() => _SubscriptionPaymentScreenState();
}

class _SubscriptionPaymentScreenState extends State<SubscriptionPaymentScreen> {

  bool canBack = false;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BusinessController>(builder: (businessController) {
      return PopScope(
        canPop: Navigator.canPop(context),
        onPopInvokedWithResult: (didPop, result) async{
          if(canBack) {
          }else {
            _showBackPressedDialogue('your_business_plan_not_setup_yet'.tr);
          }
        },
        child: Scaffold(
          body: Column(children: [

            const SizedBox(height: Dimensions.paddingSizeExtraOverLarge),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical:  Dimensions.paddingSizeSmall),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                Text(
                  'vendor_registration'.tr,
                  style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                ),

                Text(
                  'you_are_one_step_away_choose_your_business_plan'.tr,
                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                ),

                const SizedBox(height: Dimensions.paddingSizeSmall),

                LinearProgressIndicator(
                  backgroundColor: Theme.of(context).disabledColor, minHeight: 2,
                  value: 0.75,
                ),
              ]),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(children: [

                  Padding(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                    child: Column(children: [

                      Get.find<SplashController>().configModel!.subscriptionFreeTrialStatus! ? PaymentCartWidget(
                        title: '${'continue_with'.tr} ${Get.find<SplashController>().configModel!.subscriptionFreeTrialDays} '
                            '${Get.find<SplashController>().configModel!.subscriptionFreeTrialType} ${'days_free_trial'.tr}',
                        index: 0,
                        onTap: () {
                          businessController.setPaymentIndex(0);
                        },
                      ) : const SizedBox(),

                      SizedBox(height: Get.find<SplashController>().configModel!.subscriptionFreeTrialStatus! ? Dimensions.paddingSizeExtremeLarge : 0),

                      Row(children: [
                        Text('${'pay_via_online'.tr} ', style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault)),
                        Text(
                          'faster_and_secure_way_to_pay_bill'.tr,
                          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                        ),
                      ]),

                      GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: ResponsiveHelper.isTab(context) ? 2 : 1,
                          crossAxisSpacing: Dimensions.paddingSizeLarge,
                          mainAxisSpacing: Dimensions.paddingSizeLarge,
                          mainAxisExtent: 55,
                        ),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: Get.find<SplashController>().configModel!.activePaymentMethodList!.length,
                        itemBuilder: (context, index) {
                          bool isSelected = businessController.paymentIndex == 1 && Get.find<SplashController>().configModel!.activePaymentMethodList![index].getWay! == businessController.digitalPaymentName;

                          return InkWell(
                            onTap: (){
                              businessController.setPaymentIndex(1);
                              businessController.changeDigitalPaymentName(Get.find<SplashController>().configModel!.activePaymentMethodList![index].getWay);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: isSelected ? Theme.of(context).primaryColor.withValues(alpha: 0.05) : Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                border: Border.all(color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).disabledColor.withValues(alpha: 0.2), width: 1),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeDefault),
                              child: Row(children: [
                                Container(
                                  height: 20, width: 20,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle, color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).cardColor,
                                    border: Border.all(color: Theme.of(context).disabledColor),
                                  ),
                                  child: Icon(Icons.check, color: Theme.of(context).cardColor, size: 16),
                                ),
                                const SizedBox(width: Dimensions.paddingSizeDefault),

                                Text(
                                  Get.find<SplashController>().configModel!.activePaymentMethodList![index].getWayTitle!,
                                  style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault),
                                ),
                                const Spacer(),

                                CustomImageWidget(
                                  height: 40, width: 50, fit: BoxFit.contain,
                                  image: '${Get.find<SplashController>().configModel!.activePaymentMethodList![index].getWayImageFullUrl}',
                                ),

                              ]),
                            ),
                          );
                        },
                      ),

                    ]),
                  ),

                ]),
              ),
            ),

            GetBuilder<BusinessController>(builder: (busController) {
              return Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 5)],
                ),
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeDefault),
                child: !busController.isLoading ? CustomButtonWidget(
                  height: 50,
                  radius: Dimensions.radiusDefault,
                  buttonText: 'confirm'.tr,
                  onPressed: () {
                    busController.submitBusinessPlan(storeId: widget.storeId, packageId: widget.packageId);
                  },
                ) : const Center(child: CircularProgressIndicator()),
              );
            }),

          ]),
        ),
      );
    });
  }

  void _showBackPressedDialogue(String title){
    Get.dialog(ConfirmationDialogWidget(icon: Images.support,
      title: title,
      description: 'are_you_sure_to_go_back'.tr, isLogOut: true,
      onYesPressed: () {
        if(Get.isDialogOpen!){
          Get.back();
        }
        Get.back();
      },
    ), useSafeArea: false);
  }
}
