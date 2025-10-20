import 'package:sixam_mart_store/features/order/controllers/order_controller.dart';
import 'package:sixam_mart_store/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart_store/helper/price_converter_helper.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/common/widgets/custom_button_widget.dart';
import 'package:sixam_mart_store/common/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CollectMoneyDeliverySheetWidget extends StatefulWidget {
  final int? orderID;
  final bool? verify;
  final bool cod;
  final double? orderAmount;
  const CollectMoneyDeliverySheetWidget({super.key, required this.orderID, required this.verify, required this.orderAmount, required this.cod});

  @override
  State<CollectMoneyDeliverySheetWidget> createState() => _CollectMoneyDeliverySheetWidgetState();
}

class _CollectMoneyDeliverySheetWidgetState extends State<CollectMoneyDeliverySheetWidget> {
  bool _bringChange = false;
  final TextEditingController _amountReceivedController = TextEditingController();
  final FocusNode _amountReceivedFocus = FocusNode();
  double _changeAmount = 0.0;

  @override
  void initState() {
    super.initState();
    _amountReceivedController.text = widget.orderAmount.toString();
    _amountReceivedController.addListener(_calculateChange);
  }

  @override
  void dispose() {
    _amountReceivedController.dispose();
    _amountReceivedFocus.dispose();
    super.dispose();
  }

  void _calculateChange() {
    if (_amountReceivedController.text.isNotEmpty) {
      double receivedAmount = double.tryParse(_amountReceivedController.text) ?? 0.0;
      setState(() {
        _changeAmount = receivedAmount - widget.orderAmount!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: GetBuilder<OrderController>(builder: (orderController) {
        return Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
          child: Column(mainAxisSize: MainAxisSize.min, children: [

            Container(
              height: 5, width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                color: Theme.of(context).disabledColor,
              ),
            ),

            widget.cod ? Column(children: [
              const SizedBox(height: Dimensions.paddingSizeLarge),

              Image.asset(Images.deliveredSuccess, height: 100, width: 100),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Text(
                'collect_money_from_customer'.tr, textAlign: TextAlign.center,
                style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              // Order Amount
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(
                  '${'order_amount'.tr}:', textAlign: TextAlign.center,
                  style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge),
                ),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                Text(
                  PriceConverterHelper.convertPrice(widget.orderAmount), textAlign: TextAlign.center,
                  style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).primaryColor),
                ),
              ]),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              // Bring Change Toggle
              Row(children: [
                Expanded(
                  child: Text(
                    'bring_change'.tr,
                    style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault),
                  ),
                ),
                Switch(
                  value: _bringChange,
                  onChanged: (value) {
                    setState(() {
                      _bringChange = value;
                      if (!value) {
                        _amountReceivedController.text = widget.orderAmount.toString();
                        _changeAmount = 0.0;
                      }
                    });
                  },
                  activeThumbColor: Theme.of(context).primaryColor,
                ),
              ]),
              const SizedBox(height: Dimensions.paddingSizeDefault),

              // Amount Received Input (only show if bring change is enabled)
              if (_bringChange) ...[
                TextFieldWidget(
                  hintText: 'enter_amount_received'.tr,
                  controller: _amountReceivedController,
                  focusNode: _amountReceivedFocus,
                  inputAction: TextInputAction.done,
                  isAmount: true,
                  amountIcon: true,
                ),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                // Change Amount Display
                if (_changeAmount >= 0) ...[
                  Container(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    ),
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(
                        '${'change_amount'.tr}: ', textAlign: TextAlign.center,
                        style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault),
                      ),
                      Text(
                        PriceConverterHelper.convertPrice(_changeAmount), textAlign: TextAlign.center,
                        style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).primaryColor),
                      ),
                    ]),
                  ),
                ] else ...[
                  Container(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    ),
                    child: Text(
                      'insufficient_amount'.tr, textAlign: TextAlign.center,
                      style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Colors.red),
                    ),
                  ),
                ],
                const SizedBox(height: Dimensions.paddingSizeDefault),
              ],

              SizedBox(height: widget.verify! ? 20 : 40),
            ]) : const SizedBox(),

            !orderController.isLoading ? CustomButtonWidget(
              buttonText: 'ok'.tr,
              radius: Dimensions.radiusDefault,
              margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeLarge),
              onPressed: () {
                // Validate change amount if bring change is enabled
                if (widget.cod && _bringChange) {
                  double receivedAmount = double.tryParse(_amountReceivedController.text) ?? 0.0;
                  if (receivedAmount < widget.orderAmount!) {
                    Get.snackbar(
                      'error'.tr,
                      'insufficient_amount'.tr,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                    return;
                  }
                }

                if(widget.verify!) {
                  Get.offAllNamed(RouteHelper.getInitialRoute());
                } else {
                  // Pass change information to the order controller
                  double receivedAmount = widget.cod && _bringChange 
                      ? (double.tryParse(_amountReceivedController.text) ?? widget.orderAmount!)
                      : widget.orderAmount!;
                  double changeAmount = widget.cod && _bringChange ? _changeAmount : 0.0;

                  Get.find<OrderController>().updateOrderStatus(
                    widget.orderID, 
                    'delivered',
                    amountReceived: receivedAmount,
                    changeAmount: changeAmount,
                  ).then((success) {
                    if(success) {
                      Get.find<ProfileController>().getProfile();
                      Get.find<OrderController>().getCurrentOrders();
                      Get.offAllNamed(RouteHelper.getInitialRoute());
                    }
                  });
                }
              },
            ) : const Center(child: CircularProgressIndicator()),

            const SizedBox(height: Dimensions.paddingSizeLarge),
          ]),
        );
      }),
    );
  }
}
