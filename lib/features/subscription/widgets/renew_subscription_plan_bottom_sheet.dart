import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/common/widgets/custom_button_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_image_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:sixam_mart_store/features/business/domain/models/package_model.dart';
import 'package:sixam_mart_store/features/business/widgets/curve_clipper_widget.dart';
import 'package:sixam_mart_store/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart_store/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart_store/features/subscription/controllers/subscription_controller.dart';
import 'package:sixam_mart_store/features/subscription/domain/models/check_product_limit_model.dart';
import 'package:sixam_mart_store/helper/price_converter_helper.dart';
import 'package:sixam_mart_store/helper/responsive_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';

class RenewSubscriptionPlanBottomSheet extends StatelessWidget {
  final bool isRenew;
  final Packages package;
  final Packages? activePackage;
  final CheckProductLimitModel? checkProductLimitModel;
  final bool nonSubscription;
  const RenewSubscriptionPlanBottomSheet({super.key, this.isRenew = false, required this.package, this.activePackage, required this.checkProductLimitModel, this.nonSubscription = false});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SubscriptionController>(builder: (subscriptionController) {

      double? price = Get.find<ProfileController>().profileModel?.subscriptionOtherData?.pendingBill != null ?
        (Get.find<ProfileController>().profileModel!.subscriptionOtherData!.pendingBill! + package.price!) : package.price;

      bool businessIsCommission = subscriptionController.profileModel!.stores![0].storeBusinessModel == 'commission';

      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(Dimensions.radiusExtraLarge),
            topRight: Radius.circular(Dimensions.radiusExtraLarge),
          ),
        ),
        child: Column(children: [
          Container(
            margin: const EdgeInsets.only(top: Dimensions.paddingSizeLarge, bottom: Dimensions.paddingSizeDefault),
            height: 5, width: 50,
            decoration: BoxDecoration(
              color: Theme.of(context).disabledColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Column(mainAxisSize: MainAxisSize.min, children: [


                Text(isRenew && (nonSubscription == false) ? 'renew_subscription_plan'.tr : (isRenew && nonSubscription) ? 'choose_subscription_plan'.tr : businessIsCommission ? 'shift_to_new_business_plan'.tr : 'shift_to_new_subscription_plan'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                const SizedBox(height: Dimensions.paddingSizeLarge),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                  child: Row(mainAxisAlignment: isRenew ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween, children: [

                    isRenew ? const SizedBox() : Expanded(
                      child: Stack(children: [

                        ClipRRect(
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          child: Container(
                            height: 145,
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                              boxShadow:  const [BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 5)],
                              border: Border.all(color: Theme.of(context).disabledColor.withValues(alpha: 0.1)),
                            ),
                          ),
                        ),

                        const Positioned(
                          top: 0, left: 23, right: 0,
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(topRight: Radius.circular(Dimensions.radiusDefault)),
                            child: CustomPaint(
                              size: Size(183, 152),
                              painter: RPSCustomPainter(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),

                        Positioned(
                          top: 20, left: 0, right: 0,
                          child: Column(children: [

                            Text(businessIsCommission ? 'commission_base_plan'.tr : activePackage?.packageName ?? '', style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Colors.cyan.shade700), textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),

                            Divider(color: Theme.of(context).disabledColor.withValues(alpha: 0.2), indent: 40, endIndent: 40, thickness: 1),

                            Text(
                              businessIsCommission ? '${Get.find<SplashController>().configModel!.adminCommission}%' : PriceConverterHelper.convertPrice(activePackage?.price ?? 0),
                              style: robotoBold.copyWith(fontSize: 25, color:  Colors.cyan.shade700),
                            ),

                            businessIsCommission ? const SizedBox() : Text('${activePackage?.validity} ' 'days'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor)),
                            const SizedBox(height: Dimensions.paddingSizeDefault),

                          ]),
                        ),

                      ]),
                    ),

                    isRenew ? const SizedBox() : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                      child: Image.asset(Images.changeIcon, height: 30, width: 30),
                    ),

                    isRenew ? Stack(children: [

                      ClipRRect(
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        child: Container(
                          height: 145, width: 170,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                            boxShadow:  const [BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 5)],
                          ),
                        ),
                      ),

                      const Positioned(
                        top: 0, left: 23, right: 0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(topRight: Radius.circular(Dimensions.radiusDefault)),
                          child: CustomPaint(
                            size: Size(183, 152),
                            painter: RPSCustomPainter(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      Positioned(
                        top: 20, left: 0, right: 0,
                        child: Column(children: [

                          Text(package.packageName ?? '', style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).cardColor), textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),

                          Divider(color: Colors.white.withValues(alpha: 0.2), indent: 40, endIndent: 40, thickness: 1),

                          Text(
                            PriceConverterHelper.convertPrice(package.price),
                            style: robotoBold.copyWith(fontSize: 25, color: Theme.of(context).cardColor),
                          ),

                          Text('${package.validity} ' 'days'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Colors.white.withValues(alpha: 0.8))),
                          const SizedBox(height: Dimensions.paddingSizeDefault),

                        ]),
                      ),

                    ]) : Expanded(
                      child: Stack(children: [

                        ClipRRect(
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          child: Container(
                            height: 145,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                              boxShadow:  const [BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 5)],
                            ),
                          ),
                        ),

                        const Positioned(
                          top: 0, left: 23, right: 0,
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(topRight: Radius.circular(Dimensions.radiusDefault)),
                            child: CustomPaint(
                              size: Size(183, 152),
                              painter: RPSCustomPainter(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        Positioned(
                          top: 20, left: 0, right: 0,
                          child: Column(children: [

                            Text(package.packageName ?? '', style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).cardColor), textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),

                            Divider(color: Colors.white.withValues(alpha: 0.2), indent: 40, endIndent: 40, thickness: 1),

                            Text(
                              PriceConverterHelper.convertPrice(package.price),
                              style: robotoBold.copyWith(fontSize: 25, color: Theme.of(context).cardColor),
                            ),

                            Text('${package.validity} ' 'days'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Colors.white.withValues(alpha: 0.8))),
                            const SizedBox(height: Dimensions.paddingSizeDefault),

                          ]),
                        ),

                      ]),
                    ),

                  ]),
                ),
                const SizedBox(height: Dimensions.paddingSizeLarge),

                Container(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                  decoration: BoxDecoration(
                    color: Theme.of(context).disabledColor.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    border: Border.all(color: Theme.of(context).disabledColor.withValues(alpha: 0.1)),
                  ),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('validity'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor)),
                        const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                        Text('${package.validity} ' 'days'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge)),
                      ]),
                    ),

                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('price'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor)),
                        const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                        Text(PriceConverterHelper.convertPrice(price), style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge)),
                      ]),
                    ),

                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('bill_status'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor)),
                        const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                        Text(isRenew ? 'renew'.tr : 'migrate'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge)),
                      ]),
                    ),

                  ]),

                ),
                SizedBox(height: (checkProductLimitModel != null && checkProductLimitModel!.backAmount != null && checkProductLimitModel!.backAmount! > 0) ? Dimensions.paddingSizeDefault : 0),

                (checkProductLimitModel != null && checkProductLimitModel!.backAmount != null && checkProductLimitModel!.backAmount! > 0) ? Text(
                  '${'you_will_get'.tr} ${PriceConverterHelper.convertPrice(checkProductLimitModel!.backAmount)} ${'to_your_wallet_for_remaining'.tr} ${checkProductLimitModel!.days} ${'days_subscription_plan'.tr}',
                  textAlign: TextAlign.center,
                  style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).primaryColor),
                ) : const SizedBox(),

                const SizedBox(height: Dimensions.paddingSizeDefault),

                Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  child: Row(children: [
                    Text('${'pay_via_online'.tr} ', style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault)),
                    Text(
                      'faster_and_secure_way_to_pay_bill'.tr,
                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                    ),
                  ]),
                ),

                InkWell(
                  onTap: () {
                    subscriptionController.setPaymentIndex(0);
                    subscriptionController.isSelectChange(subscriptionController.paymentIndex == 0);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                    margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                    decoration: BoxDecoration(
                      color: subscriptionController.isSelect && subscriptionController.paymentIndex == 0 ? Theme.of(context).primaryColor.withValues(alpha: 0.05) : Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      border: Border.all(color: subscriptionController.isSelect && subscriptionController.paymentIndex == 0 ? Theme.of(context).primaryColor : Theme.of(context).disabledColor.withValues(alpha: 0.2)),
                    ),
                    child:  Row(children: [
                      Container(
                        height: 20, width: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: subscriptionController.isSelect && subscriptionController.paymentIndex == 0 ? Theme.of(context).primaryColor : Theme.of(context).cardColor,
                          border: Border.all(color: Theme.of(context).disabledColor),
                        ),
                        child: Icon(Icons.check, color: Theme.of(context).cardColor, size: 16),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeDefault),

                      Image.asset(Images.walletIcon, height: 20, width: 20, fit: BoxFit.contain),
                      const SizedBox(width: Dimensions.paddingSizeSmall),

                      Text(
                        'wallet'.tr,
                        style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault),
                      ),
                      const Spacer(),

                      Text(
                        PriceConverterHelper.convertPrice(subscriptionController.profileModel!.balance),
                        style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault),
                      ),

                    ]),
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                Get.find<SplashController>().configModel!.digitalPayment! ? GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: ResponsiveHelper.isTab(context) ? 2 : 1,
                    crossAxisSpacing: Dimensions.paddingSizeLarge,
                    mainAxisSpacing: Dimensions.paddingSizeLarge,
                    mainAxisExtent: 55,
                  ),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                  itemCount: Get.find<SplashController>().configModel!.activePaymentMethodList!.length,
                  itemBuilder: (context, index) {

                    bool isSelected = subscriptionController.paymentIndex == 1 && Get.find<SplashController>().configModel!.activePaymentMethodList![index].getWay! == subscriptionController.digitalPaymentName;

                    return InkWell(
                      onTap: (){
                        subscriptionController.setPaymentIndex(1);
                        subscriptionController.changeDigitalPaymentName(Get.find<SplashController>().configModel!.activePaymentMethodList![index].getWay!);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected ? Theme.of(context).primaryColor.withValues(alpha: 0.05) : Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          border: Border.all(color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).disabledColor.withValues(alpha: 0.2)),
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
                ) : const SizedBox(),
                const SizedBox(height: Dimensions.paddingSizeDefault),

              ]),
            ),
          ),
          SafeArea(
            child: Container(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)],
              ),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                Expanded(
                  flex: 1,
                  child: CustomButtonWidget(
                    onPressed: () => Get.back(),
                    buttonText: 'cancel'.tr,
                    radius: Dimensions.radiusDefault,
                    color: Theme.of(context).disabledColor.withValues(alpha: 0.2),
                    textColor: Theme.of(context).textTheme.bodyLarge!.color?.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(width: Dimensions.paddingSizeDefault),

                Expanded(
                  flex: 2,
                  child: !subscriptionController.isLoading ? CustomButtonWidget(
                    onPressed: () {
                      if(!subscriptionController.isSelect && !subscriptionController.isDigitalPaymentSelect){
                        showCustomSnackBar('please_select_payment_method'.tr);
                      }else {
                        subscriptionController.renewBusinessPlan(storeId: subscriptionController.profileModel!.stores![0].id.toString(), isCommission: package.id == -1);
                      }
                    },
                    buttonText: isRenew ? 'renew_subscription_plan'.tr : 'shift_subscription_plan'.tr,
                    radius: Dimensions.radiusDefault,
                  ) : const Center(child: CircularProgressIndicator()),
                ),

              ]),
            ),
          ),
        ]),
      );
    });
  }
}
