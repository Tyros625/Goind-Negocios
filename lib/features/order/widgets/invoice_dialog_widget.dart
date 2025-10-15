import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screenshot/screenshot.dart';
import 'package:sixam_mart_store/common/widgets/dotted_divider.dart';
import 'package:sixam_mart_store/features/language/controllers/language_controller.dart';
import 'package:sixam_mart_store/features/order/widgets/price_widget.dart';
import 'package:sixam_mart_store/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart_store/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart_store/features/store/domain/models/item_model.dart';
import 'package:sixam_mart_store/features/order/domain/models/order_details_model.dart';
import 'package:sixam_mart_store/features/order/domain/models/order_model.dart';
import 'package:sixam_mart_store/features/profile/domain/models/profile_model.dart';
import 'package:sixam_mart_store/helper/date_converter_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';

class InvoiceDialogWidget extends StatefulWidget {
  final OrderModel? order;
  final List<OrderDetailsModel>? orderDetails;
  final Function(Uint8List? image) onPrint;
  final bool? isPrescriptionOrder;
  final bool paper80MM;
  final double dmTips;
  final ScreenshotController screenshotController;
  final bool currentlyConnectedInSavedPrinter;
  const InvoiceDialogWidget({super.key, required this.currentlyConnectedInSavedPrinter, required this.onPrint, required this.order, required this.orderDetails, required this.isPrescriptionOrder, required this.paper80MM, required this.dmTips, required this.screenshotController});

  @override
  State<InvoiceDialogWidget> createState() => _InvoiceDialogWidgetState();
}

class _InvoiceDialogWidgetState extends State<InvoiceDialogWidget> {

  String _priceDecimal(double price) {
    return price.toStringAsFixed(Get.find<SplashController>().configModel!.digitAfterDecimalPoint!);
  }

  @override
  void initState() {
    super.initState();

    if (kDebugMode) {
      print('InvoiceDialogWidget - currentlyConnectedInSavedPrinter: ${widget.currentlyConnectedInSavedPrinter}');
    }

    if(widget.currentlyConnectedInSavedPrinter){
      if (kDebugMode) {
        print('InvoiceDialogWidget - Starting automatic print process');
      }
      Future.delayed(const Duration(seconds: 1), () {
        widget.screenshotController.capture(delay: const Duration(milliseconds: 10)).then((Uint8List? capturedImage) async {
          if (kDebugMode) {
            print('InvoiceDialogWidget - Screenshot captured, starting print');
          }
          Get.back();
          widget.onPrint(capturedImage!);
        }).catchError((onError) {
          log("----(ERROR)----$onError");
        });
      });
    } else {
      if (kDebugMode) {
        print('InvoiceDialogWidget - Automatic printing disabled, showing manual print dialog');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double fontSize = View.of(context).physicalSize.width > 1000 ? Dimensions.fontSizeExtraSmall - 3 : Dimensions.fontSizeSmall;
    Store store = Get.find<ProfileController>().profileModel!.stores![0];

    double itemsPrice = 0;
    double addOns = 0;

    if(widget.isPrescriptionOrder!){
      double orderAmount = widget.order!.orderAmount ?? 0;
      double discount = widget.order!.storeDiscountAmount ?? 0;
      double tax = widget.order!.totalTaxAmount ?? 0;
      double deliveryCharge = widget.order!.deliveryCharge ?? 0;
      double additionalCharge = widget.order!.additionalCharge ?? 0;
      bool taxIncluded = widget.order!.taxStatus ?? false;
      itemsPrice = (orderAmount + discount) - ((taxIncluded ? 0 : tax) + deliveryCharge + additionalCharge) - widget.dmTips;
    }
    for(OrderDetailsModel orderDetails in widget.orderDetails!) {
      for(AddOn addOn in orderDetails.addOns!) {
        addOns = addOns + (addOn.price! * addOn.quantity!);
      }
      if(!widget.isPrescriptionOrder!) {
        itemsPrice = itemsPrice + (orderDetails.price! * orderDetails.quantity!);
      }
    }

    return OrientationBuilder(builder: (context, orientation) {
      double fixedSize = View.of(context).physicalSize.width / (orientation == Orientation.portrait ? 720 : 1400);
      double printWidth = (widget.paper80MM ? 280 : 185) / fixedSize;
      bool taxIncluded = widget.order?.taxStatus! ?? false;

      return SingleChildScrollView(
        padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
        child: Column(mainAxisSize: MainAxisSize.min, children: [

          Screenshot(
            controller: widget.screenshotController,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                boxShadow: Get.isDarkMode ? null : [BoxShadow(color: Colors.grey[300]!, spreadRadius: 1, blurRadius: 5)],
              ),
              width: printWidth,
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              child: Column(mainAxisSize: MainAxisSize.min, children: [

                Image.asset(Images.invoiceStoreLogo),
                const SizedBox(height: 7),

                Text(store.name!, style: robotoMedium.copyWith(fontSize: 10)),
                //Text(store.address!, style: robotoRegular.copyWith(fontSize: fontSize)),
                //Text(store.phone!, style: robotoRegular.copyWith(fontSize: fontSize)),
                //Text(store.email!, style: robotoRegular.copyWith(fontSize: fontSize)),
                const SizedBox(height: 5),

                Text(store.address!, style: robotoMedium.copyWith(fontSize: 10)),
                const SizedBox(height: 5),

                Text(
                  DateConverterHelper.dateTimeStringToMonthAndTime(widget.order?.createdAt ?? ''),
                  style: robotoRegular.copyWith(fontSize: 9),
                ),
                const SizedBox(height: 5),

                Row(mainAxisAlignment: MainAxisAlignment.center ,children: [
                  Text('${'phone'.tr} :', style: robotoMedium.copyWith(fontSize: 9)),
                  Text(store.phone!, style: robotoMedium.copyWith(fontSize: 9)),
                ]),
                const SizedBox(height: 10),

                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('order_type'.tr, style: robotoMedium.copyWith(fontSize: 11)),
                  Text(widget.order?.paymentMethod!.tr ?? '', style: robotoMedium.copyWith(fontSize: 11)),
                ]),
                const SizedBox(height: 5),

                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 0.5),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Get.find<LocalizationController>().isLtr ? Alignment.topLeft : Alignment.topRight,
                      child: Column(children: [
                        Row(children: [
                          Text('order_id_invoice'.tr, style: robotoRegular.copyWith(fontSize: fontSize)),
                          Expanded(child: Text(widget.order?.id.toString() ?? '', style: robotoMedium.copyWith(fontSize: fontSize), textAlign: TextAlign.end,)),
                        ]),
                        const SizedBox(height: 3),

                        Row(children: [
                          Text('customer_name'.tr, style: robotoRegular.copyWith(fontSize: fontSize)),
                          Expanded(child: Text(widget.order?.deliveryAddress?.contactPersonName ?? '', style: robotoMedium.copyWith(fontSize: fontSize), textAlign: TextAlign.end,)),
                        ]),
                        const SizedBox(height: 3),

                        Row(children: [
                          Text('phone'.tr, style: robotoRegular.copyWith(fontSize: fontSize)),
                          Expanded(child: Text(widget.order?.deliveryAddress?.contactPersonNumber ?? '', style: robotoMedium.copyWith(fontSize: fontSize), textAlign: TextAlign.end,)),
                        ]),
                        const SizedBox(height: 3),

                        Row(
                          children: [
                            Text('delivery_address'.tr, style: robotoBold.copyWith(fontSize: fontSize)),
                            Expanded(child: Text(' : ${widget.order?.deliveryAddress?.address}' ?? '', style: robotoRegular.copyWith(fontSize: fontSize), textAlign: TextAlign.end)),
                          ],
                        ),

                        Align(alignment: Alignment.centerRight,
                          child: Text(
                            '${'street_number'.tr}: ${widget.order?.deliveryAddress?.streetNumber ?? ''}  '
                                '${'house'.tr}: ${widget.order?.deliveryAddress?.house ?? ''}  '
                                '${'floor'.tr}: ${widget.order?.deliveryAddress?.floor ?? ''}',
                            style: robotoRegular.copyWith(fontSize: fontSize),
                            textAlign: TextAlign.right,
                          ),
                        )
                      ]),
                    ),
                  ),
                ),





                widget.order!.scheduled == 1 ? Text(
                  '${'scheduled_order_time'.tr} ${DateConverterHelper.dateTimeStringToDateTime(widget.order!.scheduleAt!)}',
                  style: robotoRegular.copyWith(fontSize: fontSize),
                ) : const SizedBox(),
                const SizedBox(height: 5),


                (widget.order?.orderNote != null && widget.order!.orderNote!.isNotEmpty) ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: DottedDivider(height: 1, dashWidth: 4, dashHeight: 1),
                ) : const SizedBox(),

                // Mostrar la nota adicional solo si existe y no está vacía
                (widget.order?.orderNote != null && widget.order!.orderNote!.isNotEmpty) ? Column( children: [
                  Text('additional_note'.tr, style: robotoRegular.copyWith(fontSize: 10)),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                  Text("** ${widget.order!.orderNote!} **", style: robotoRegular.copyWith(fontSize: fontSize)),
                ]) : const SizedBox(),

                (widget.order?.orderNote != null && widget.order!.orderNote!.isNotEmpty) ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: DottedDivider(height: 1, dashWidth: 4, dashHeight: 1),
                ) : const SizedBox(),

                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

                  Expanded(
                    flex: 1,
                    child: Text('qty'.tr, textAlign: TextAlign.center, style: robotoMedium.copyWith(fontSize: 11)),
                  ),
                  Expanded(
                    flex: 5,
                    child: Text('item'.tr, style: robotoMedium.copyWith(fontSize: 11)),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text('price'.tr, textAlign: TextAlign.right, style: robotoMedium.copyWith(fontSize: 11)),
                  ),
                ]),

                const SizedBox(height: Dimensions.paddingSizeExtraSmall),



                ListView.builder(
                  itemCount: widget.orderDetails!.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {

                    String addOnText = '';
                    for (var addOn in widget.orderDetails![index].addOns!) {
                      addOnText = '$addOnText${(addOnText.isEmpty) ? '' : ',  '}${addOn.name} (${addOn.quantity})';
                    }

                    String variationText = '';
                    if(widget.orderDetails![index].variation!.isNotEmpty) {
                      if(widget.orderDetails![index].variation!.isNotEmpty) {
                        List<String> variationTypes = widget.orderDetails![index].variation![0].type!.split('-');
                        if(variationTypes.length == widget.orderDetails![index].itemDetails!.choiceOptions!.length) {
                          int index = 0;
                          for (var choice in widget.orderDetails![index].itemDetails!.choiceOptions!) {
                            variationText = '$variationText${(index == 0) ? '' : ',  '}${choice.title} - ${variationTypes[index]}';
                            index = index + 1;
                          }
                        }else {
                          variationText = widget.orderDetails![index].itemDetails!.variations![0].type!;
                        }
                      }
                    }else if (widget.orderDetails![index].foodVariation!.isNotEmpty) {
                      for (FoodVariation variation in widget.orderDetails![index].foodVariation!) {
                        variationText += '${variationText.isNotEmpty ? '\n' : ''} ${variation.name}';
                        for (VariationValue value in variation.variationValues!) {
                          variationText += '\n# ${value.level}'; // Añadir # delante de cada valor de variación
                        }
                      }
                    }
                    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          '${widget.orderDetails![index].quantity}X', // Agrega la 'X' después de la cantidad
                          textAlign: TextAlign.center,
                          style: robotoMedium.copyWith(fontSize: 11),
                        ),
                      ),

                      Expanded(flex: 5, child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(widget.orderDetails![index].itemDetails!.name!, style: robotoMedium.copyWith(fontSize: 11),),
                        const SizedBox(height: 2),

                        addOnText.isNotEmpty ? Text('${'addons'.tr}: $addOnText', style: robotoMedium.copyWith(fontSize: 11),) : const SizedBox(),

                        (widget.orderDetails![index].variation != null && widget.orderDetails![index].variation!.isNotEmpty) || (widget.orderDetails![index].foodVariation != null && widget.orderDetails![index].foodVariation!.isNotEmpty) ? Text(
                          variationText.split(',').map((e) {
                            return ' ${e.trim()}';
                          }).join('\n'),
                          style: robotoRegular.copyWith(fontSize: 8.0),
                        ) : const SizedBox(),

                      ])),
                      Expanded(
                        flex: 2,
                        child: Text(
                          '${_priceDecimal(widget.orderDetails![index].price!)}€', // Agrega '€' después del precio
                          textAlign: TextAlign.right,
                          style: robotoMedium.copyWith(fontSize: 11),
                        ),
                      ),
                    ]);
                  },
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: DottedDivider(height: 1, dashWidth: 4, dashHeight: 1),
                ),

                itemsPrice != 0.0 ? Column(children: [

                  PriceWidget(title: 'item_price'.tr, value: _priceDecimal(itemsPrice), fontSize: fontSize),
                  const SizedBox(height: 5),

                ]) : const SizedBox(),


                addOns > 0 ? Column(children: [
                  PriceWidget(title: 'add_ons'.tr, value: _priceDecimal(addOns), fontSize: fontSize),
                  const SizedBox(height: 5),
                ]) : const SizedBox(),


                widget.order?.storeDiscountAmount! != 0.0 ? Column(children: [
                  PriceWidget(title: 'discount'.tr, value: _priceDecimal(widget.order?.storeDiscountAmount! ?? 0), fontSize: fontSize),
                  const SizedBox(height: 5),
                ]) : const SizedBox(),


                widget.order?.couponDiscountAmount! != 0.0 ? Column(children: [
                  PriceWidget(title: 'coupon_discount'.tr, value: _priceDecimal(widget.order?.couponDiscountAmount! ?? 0), fontSize: fontSize),
                  const SizedBox(height: 5),
                ]) : const SizedBox(),

                ((widget.order?.referrerBonusAmount ??0) > 0) ? Column(children: [
                  PriceWidget(title: 'referral_discount'.tr, value: _priceDecimal(widget.order?.referrerBonusAmount! ?? 0), fontSize: fontSize),
                  const SizedBox(height: 5),
                ]) : const SizedBox(),

                SizedBox(height: (widget.order?.referrerBonusAmount! ?? 0) > 0 ? 5 : 0),

                !taxIncluded ? ((widget.order?.totalTaxAmount! ??0 ) > 0 ? Column(children: [
                  PriceWidget(title: 'vat_tax'.tr, value: _priceDecimal(widget.order!.totalTaxAmount!), fontSize: fontSize),
                  const SizedBox(height: 5),
                ]) : const SizedBox()) : const SizedBox(),
                SizedBox(height: taxIncluded || (widget.order!.totalTaxAmount == 0) ? 0 : 5),

                widget.dmTips != 0.0 ? Column(children: [
                  PriceWidget(title: 'delivery_man_tips'.tr, value: _priceDecimal(widget.dmTips), fontSize: fontSize),
                  const SizedBox(height: 5),
                ]) : const SizedBox(),

                ((widget.order?.extraPackagingAmount ?? 0) > 0) ? Column(children: [
                  PriceWidget(title: 'extra_packaging'.tr, value: _priceDecimal(widget.order!.extraPackagingAmount!), fontSize: fontSize),
                  const SizedBox(height: 5),
                ]) : const SizedBox(),
                SizedBox(height: (widget.order?.extraPackagingAmount! ??0) > 0 ? 5 : 0),

                widget.order?.deliveryCharge! != 0.0 ? Column(children: [
                  PriceWidget(title: 'delivery_fee'.tr, value: _priceDecimal(widget.order?.deliveryCharge ?? 0), fontSize: fontSize),
                  SizedBox(height: (widget.order?.additionalCharge != null && widget.order!.additionalCharge! > 0) ? 5 : 0),
                ]) : const SizedBox(),

                (widget.order?.additionalCharge != null && widget.order!.additionalCharge! > 0) ? Column(children: [
                  PriceWidget(title: Get.find<SplashController>().configModel!.additionalChargeName!, value: _priceDecimal(widget.order!.additionalCharge!), fontSize: fontSize),
                  const SizedBox(height: 5),
                ]) : const SizedBox(),

                widget.order?.orderAmount! != 0.0 ? Column(children: [
                  PriceWidget(title: 'total_amount'.tr, value: _priceDecimal(widget.order?.orderAmount ?? 0), fontSize: fontSize + 1, isTotal: true),
                  const SizedBox(height: 5),
                ]) : const SizedBox(),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: DottedDivider(height: 1, dashWidth: 4, dashHeight: 1),
                ),

                Text('thank_you'.tr, style: robotoBold.copyWith(fontSize: 15)),
                Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('for_ordering_from'.tr, style: robotoMedium.copyWith(fontSize: 11)),
                    Text(' ${Get.find<SplashController>().configModel!.businessName}', style: robotoMedium.copyWith(fontSize: 11)),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: DottedDivider(height: 1, dashWidth: 4, dashHeight: 1),
                ),

                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    '${Get.find<SplashController>().configModel!.footerText} ${Get.find<SplashController>().configModel!.businessName}. ',
                    style: robotoRegular.copyWith(fontSize: fontSize),
                  ),
                  Text('all_right_reserved'.tr, style: robotoRegular.copyWith(fontSize: fontSize))
                ]),

              ]),
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),

        ]),
      );
    });
  }

}