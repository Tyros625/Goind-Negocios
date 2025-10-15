import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/features/business/domain/models/package_model.dart';
import 'package:sixam_mart_store/features/business/widgets/curve_clipper_widget.dart';
import 'package:sixam_mart_store/features/business/widgets/package_widget.dart';
import 'package:sixam_mart_store/helper/price_converter_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';

class PackageCardWidget extends StatelessWidget {
  final int? currentIndex;
  final Packages package;
  final bool fromChangePlan;
  final bool isRental;
  const PackageCardWidget({super.key, this.currentIndex, required this.package, this.fromChangePlan = false, this.isRental = false});

  @override
  Widget build(BuildContext context) {
    bool isCommission = package.id == -1;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Stack(children: [

        Container(
          height: fromChangePlan ? 480 : 420,
          decoration: BoxDecoration(
            color: currentIndex != null ? Theme.of(context).primaryColor : Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            boxShadow:  const [BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 5)],
          ),
        ),

        Positioned(
          top: 0, left: 23, right: 0,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(topRight: Radius.circular(Dimensions.radiusDefault)),
            child: CustomPaint(
              size: const Size(183, 152),
              painter: RPSCustomPainter(
                color: currentIndex != null ? Colors.white : Colors.grey,
              ),
            ),
          ),
        ),

        Positioned(
          top: 30, left: 0, right: 0,
          child: Column(children: [

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
              child: Text(package.packageName ?? '', style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: currentIndex != null ? Theme.of(context).cardColor : Theme.of(context).primaryColor), textAlign: TextAlign.center),
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            Text(
              isCommission ? '${package.price} %' : PriceConverterHelper.convertPrice(package.price),
              style: robotoBold.copyWith(fontSize: 30, color: currentIndex != null ? Theme.of(context).cardColor : Theme.of(context).primaryColor),
            ),

            isCommission ? const SizedBox() : Text('${package.validity} ' '${'days'.tr}', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).cardColor)),

            isCommission ? const SizedBox() : Divider(color: currentIndex != null ? Theme.of(context).cardColor.withValues(alpha: 0.2) : Theme.of(context).disabledColor.withValues(alpha: 0.3), indent: 70, endIndent: 70, thickness: 1),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            isCommission ? Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              child: Text(package.description ?? '', textAlign: TextAlign.center,
                  style: robotoRegular.copyWith(color: currentIndex != null ? Theme.of(context).cardColor.withValues(alpha: 0.8) : Theme.of(context).disabledColor.withValues(alpha: 0.3)),
              ),
            ) : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              PackageWidget(title: '${isRental ? 'max_trip'.tr : 'max_order'.tr} (${package.maxOrder?.tr})', isSelect: currentIndex != null ? true : false),

              PackageWidget(title: '${isRental ? 'max_vehicle'.tr : 'max_product'.tr} (${package.maxProduct?.tr})', isSelect: currentIndex != null ? true : false),

              package.pos != 0 ? PackageWidget(title: 'pos'.tr, isSelect: currentIndex != null ? true : false) : const SizedBox(),

              package.mobileApp != 0 ? PackageWidget(title: 'mobile_app'.tr, isSelect: currentIndex != null ? true : false) : const SizedBox(),

              package.chat != 0 ? PackageWidget(title: 'chat'.tr, isSelect: currentIndex != null ? true : false) : const SizedBox(),

              package.review != 0 ? PackageWidget(title: 'review'.tr, isSelect: currentIndex != null ? true : false) : const SizedBox(),

              package.selfDelivery != 0 ? PackageWidget(title: 'self_delivery'.tr, isSelect: currentIndex != null ? true : false) : const SizedBox(),

            ]),

          ]),
        ),

      ]),
    );
  }
}
