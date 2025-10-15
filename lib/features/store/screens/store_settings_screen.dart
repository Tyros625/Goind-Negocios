import 'package:flutter/cupertino.dart';
import 'package:sixam_mart_store/common/widgets/custom_card.dart';
import 'package:sixam_mart_store/common/widgets/custom_text_field_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_tool_tip_widget.dart';
import 'package:sixam_mart_store/features/store/controllers/store_controller.dart';
import 'package:sixam_mart_store/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart_store/common/models/config_model.dart';
import 'package:sixam_mart_store/features/profile/domain/models/profile_model.dart' as profile;
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/common/widgets/custom_app_bar_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_button_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:sixam_mart_store/common/widgets/switch_button_widget.dart';
import 'package:sixam_mart_store/features/store/widgets/daily_time_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/features/store/widgets/pickup_time_input.dart';

class StoreSettingsScreen extends StatefulWidget {
  final profile.Store store;
  const StoreSettingsScreen({super.key, required this.store});

  @override
  State<StoreSettingsScreen> createState() => _StoreSettingsScreenState();
}

class _StoreSettingsScreenState extends State<StoreSettingsScreen> {

  final TextEditingController _orderAmountController = TextEditingController();
  final TextEditingController _minimumDeliveryFeeController = TextEditingController();
  final TextEditingController _maximumDeliveryFeeController = TextEditingController();
  final TextEditingController _processingTimeController = TextEditingController();
  final TextEditingController _gstController = TextEditingController();
  final TextEditingController _minimumController = TextEditingController();
  final TextEditingController _maximumController = TextEditingController();
  final TextEditingController _deliveryChargePerKmController = TextEditingController();
  final TextEditingController _extraPackagingController = TextEditingController();
  final TextEditingController _minimumStockController = TextEditingController();

  final FocusNode _orderAmountNode = FocusNode();
  final FocusNode _minimumDeliveryFeeNode = FocusNode();
  final FocusNode _maximumDeliveryFeeNode = FocusNode();
  final FocusNode _minimumNode = FocusNode();
  final FocusNode _minimumProcessingTimeNode = FocusNode();
  final FocusNode _deliveryChargePerKmNode = FocusNode();
  final FocusNode _minimumStockNode = FocusNode();
  late profile.Store _store;
  final Module? _module = Get.find<SplashController>().configModel!.moduleConfig!.module;

  @override
  void initState() {
    super.initState();

    StoreController storeController = Get.find<StoreController>();
    storeController.initStoreData(widget.store);

    _orderAmountController.text = widget.store.minimumOrder.toString();
    _minimumDeliveryFeeController.text = widget.store.minimumShippingCharge.toString();
    _maximumDeliveryFeeController.text = widget.store.maximumShippingCharge != null ? widget.store.maximumShippingCharge.toString() : '';
    _deliveryChargePerKmController.text = widget.store.perKmShippingCharge.toString();
    _gstController.text = widget.store.gstCode!;
    _processingTimeController.text = widget.store.orderPlaceToScheduleInterval.toString();
    _extraPackagingController.text = widget.store.extraPackagingAmount.toString();
    _minimumStockController.text = widget.store.minimumStockForWarning.toString();
    if(widget.store.deliveryTime != null && widget.store.deliveryTime!.isNotEmpty) {
      try {
        _minimumController.text = getDeliveryData(widget.store.deliveryTime!, 'min');
        _maximumController.text = getDeliveryData(widget.store.deliveryTime!, 'max');
        storeController.setSelectedDurationInitData(getDeliveryData(widget.store.deliveryTime!, 'type'));
      }catch(_) {
        _minimumController.text = '';
        _maximumController.text = '';
      }
    }
    _store = widget.store;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: CustomAppBarWidget(title: _module!.showRestaurantText! ? 'restaurant_configure'.tr : 'store_configure'.tr),

      body: GetBuilder<StoreController>(builder: (storeController) {
        return GetBuilder<SplashController>(builder: (splashController) {

          ConfigModel? configModel = splashController.configModel;
          bool isFood = widget.store.module!.moduleType! == 'food';
          bool isPharmacy = widget.store.module!.moduleType! == 'pharmacy';
          bool isGrocery = widget.store.module!.moduleType! == 'grocery';

          return Column(children: [

            Expanded(child: SingleChildScrollView(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                Text('business_settings'.tr, style: robotoBold),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                CustomCard(
                  padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
                  child: Column(children: [

                    configModel!.scheduleOrder! ? SwitchButtonWidget(
                      title: 'schedule_order'.tr,
                      description: 'schedule_order_description'.tr,
                      isButtonActive: storeController.isScheduleOrderEnabled,
                      onTap: () {
                        storeController.toggleScheduleOrder();
                      },
                    ) : const SizedBox(),
                    SizedBox(height: configModel.scheduleOrder! ? Dimensions.paddingSizeDefault : 0),

                    SwitchButtonWidget(
                      title: 'home_delivery'.tr,
                      description: 'home_delivery_description'.tr,
                      isButtonActive: storeController.isDeliveryEnabled,
                      onTap: () {
                        storeController.toggleDelivery();
                      },
                    ),
                    const SizedBox(height: Dimensions.paddingSizeDefault),

                    SwitchButtonWidget(
                      title: 'take_away'.tr,
                      description: 'take_away_description'.tr,
                      isButtonActive: storeController.isTakeAwayEnabled,
                      onTap: () {
                        storeController.toggleTakeAway();
                      },
                    ),
                    const SizedBox(height: Dimensions.paddingSizeDefault),

                    isFood || isGrocery ? SwitchButtonWidget(
                      title: 'halal_tag_status'.tr,
                      description: 'halal_tag_description'.tr,
                      isButtonActive: storeController.isHalalEnabled,
                      onTap: () {
                        storeController.toggleHalalTag();
                      },
                    ) : const SizedBox(),
                    SizedBox(height: isFood || isGrocery ? Dimensions.paddingSizeDefault : 0),

                    _module.vegNonVeg! && configModel.toggleVegNonVeg! ? SwitchButtonWidget(
                      title: 'veg'.tr,
                      isButtonActive: storeController.isStoreVeg,
                      onTap: () {
                        storeController.toggleStoreVeg();
                      },
                    ) : const SizedBox(),
                    SizedBox(height: _module.vegNonVeg! && configModel.toggleVegNonVeg! ? Dimensions.paddingSizeDefault : 0),

                    _module.vegNonVeg! && configModel.toggleVegNonVeg! ? SwitchButtonWidget(
                      title: 'non_veg'.tr,
                      isButtonActive: storeController.isStoreNonVeg,
                      onTap: () {
                        storeController.toggleStoreNonVeg();
                      },
                    ) : const SizedBox(),
                    SizedBox(height: _module.vegNonVeg! && configModel.toggleVegNonVeg! ? Dimensions.paddingSizeDefault : 0),

                    isFood ? SwitchButtonWidget(
                      title: 'cutlery'.tr,
                      isButtonActive: storeController.isCutleryEnabled,
                      onTap: () {
                        storeController.toggleCutlery();
                      },
                    ) : const SizedBox(),
                    SizedBox(height: isFood ? Dimensions.paddingSizeDefault : 0),

                    _store.selfDeliverySystem == 1 ? SwitchButtonWidget(
                      title: 'free_delivery'.tr,
                      isButtonActive: storeController.isFreeDeliveryEnabled,
                      onTap: () {
                        storeController.toggleFreeDelivery();
                      },
                    ) : const SizedBox(),
                    SizedBox(height: _store.selfDeliverySystem == 1 ? Dimensions.paddingSizeDefault : 0),

                    isPharmacy && configModel.prescriptionOrderStatus! ? SwitchButtonWidget(
                      title: 'prescription_order'.tr,
                      isButtonActive: storeController.isPrescriptionStatusEnable,
                      onTap: () {
                        storeController.togglePrescription();
                      },
                    ) : const SizedBox(),

                  ]),
                ),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                Text('other_settings'.tr, style: robotoBold),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                CustomCard(
                  padding: const EdgeInsets.all(12),
                  child: Column(children: [

                    CustomTextFieldWidget(
                      hintText: 'minimum_order_amount'.tr,
                      labelText: '${'minimum_order_amount'.tr} (${Get.find<SplashController>().configModel!.currencySymbol})',
                      controller: _orderAmountController,
                      focusNode: _orderAmountNode,
                      nextFocus: _store.selfDeliverySystem == 1 ? _deliveryChargePerKmNode : _minimumNode,
                      inputType: TextInputType.number,
                      isAmount: true,
                    ),
                    const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                    PickupTimeInput(
                      minTimeController: _minimumController,
                      maxTimeController: _maximumController,
                    ),
                    SizedBox(height: _store.selfDeliverySystem == 1 ? Dimensions.paddingSizeExtraLarge : 0),

                    _store.selfDeliverySystem == 1 ? Column(children: [

                      CustomTextFieldWidget(
                        hintText: 'delivery_charge_per_km'.tr,
                        labelText: '${'delivery_charge_per_km'.tr} (${Get.find<SplashController>().configModel!.currencySymbol})',
                        controller: _deliveryChargePerKmController,
                        focusNode: _deliveryChargePerKmNode,
                        nextFocus: _minimumDeliveryFeeNode,
                        inputType: TextInputType.number,
                        isAmount: true,
                      ),
                      const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                      CustomTextFieldWidget(
                        hintText: 'minimum_delivery_charge'.tr,
                        labelText: '${'minimum_delivery_charge'.tr} (${Get.find<SplashController>().configModel!.currencySymbol})',
                        controller: _minimumDeliveryFeeController,
                        focusNode: _minimumDeliveryFeeNode,
                        nextFocus: _maximumDeliveryFeeNode,
                        inputType: TextInputType.number,
                        isAmount: true,
                      ),
                      const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                      CustomTextFieldWidget(
                        hintText: 'maximum_delivery_charge'.tr,
                        labelText: '${'maximum_delivery_charge'.tr} (${Get.find<SplashController>().configModel!.currencySymbol})',
                        controller: _maximumDeliveryFeeController,
                        focusNode: _maximumDeliveryFeeNode,
                        inputAction: TextInputAction.done,
                        inputType: TextInputType.number,
                        nextFocus: _minimumNode,
                        isAmount: true,
                      ),

                    ]) : const SizedBox(),
                    SizedBox(height: _module.orderPlaceToScheduleInterval! ? Dimensions.paddingSizeExtraLarge : 0),

                    _module.orderPlaceToScheduleInterval! ? CustomTextFieldWidget(
                      hintText: 'minimum_processing_time'.tr,
                      labelText: 'minimum_processing_time'.tr,
                      controller: _processingTimeController,
                      focusNode: _minimumProcessingTimeNode,
                      nextFocus: _minimumStockNode,
                      inputType: TextInputType.number,
                      isAmount: true,
                    ) : const SizedBox(),
                    SizedBox(height: !_module.showRestaurantText! ? Dimensions.paddingSizeExtraLarge : 0),

                    !_module.showRestaurantText! ? Column(
                      children: [

                        Row(children: [
                          Text(
                            'minimum_stock_for_warning'.tr,
                            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                          ),
                          const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                          CustomToolTip(
                            preferredDirection: AxisDirection.up,
                            message: 'minimum_stock_for_warning_tooltip'.tr,
                          ),
                        ]),

                        CustomTextFieldWidget(
                          hintText: 'minimum_stock_for_warning'.tr,
                          labelText: 'minimum_stock_for_warning'.tr,
                          controller: _minimumStockController,
                          focusNode: _minimumStockNode,
                          inputAction: TextInputAction.done,
                          inputType: TextInputType.number,
                          isAmount: true,
                        ),
                      ],
                    ) : const SizedBox(),

                  ]),
                ),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                CustomCard(
                  child: Column(children: [

                    Row(children: [

                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text('gst'.tr, style: robotoRegular),

                            Text('gst_description'.tr, style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor,
                            )),
                          ]),
                        ),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeDefault),

                      Transform.scale(
                        scale: 0.7,
                        child: CupertinoSwitch(
                          value: storeController.isGstEnabled!,
                          activeTrackColor: Theme.of(context).primaryColor,
                          inactiveTrackColor: Theme.of(context).hintColor.withValues(alpha: 0.5),
                          onChanged: (bool isActive) => storeController.toggleGst(),
                        ),
                      ),

                    ]),

                    Padding(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      child: CustomTextFieldWidget(
                        hintText: 'eg_18'.tr,
                        labelText: '${'gst_amount'.tr} (${configModel.currencySymbol})',
                        controller: _gstController,
                        inputAction: TextInputAction.done,
                        showTitle: false,
                        isEnabled: storeController.isGstEnabled!,
                        hideEnableText: true,
                        isAmount: true,
                      ),
                    ),

                  ]),
                ),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                CustomCard(
                  child: Column(children: [

                    Row(children: [

                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text('extra_packaging_charge'.tr, style: robotoRegular),

                            Text('extra_packaging_charge_description'.tr, style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor,
                            )),
                          ]),
                        ),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeDefault),

                      Transform.scale(
                        scale: 0.7,
                        child: CupertinoSwitch(
                          value: storeController.isExtraPackagingEnabled!,
                          activeTrackColor: Theme.of(context).primaryColor,
                          inactiveTrackColor: Theme.of(context).hintColor.withValues(alpha: 0.5),
                          onChanged: (bool isActive) => storeController.toggleExtraPackaging(),
                        ),
                      ),

                    ]),

                    Padding(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      child: CustomTextFieldWidget(
                        hintText: 'eg_18'.tr,
                        labelText: '${'charge_amount'.tr} (${configModel.currencySymbol})',
                        controller: _extraPackagingController,
                        inputAction: TextInputAction.done,
                        isEnabled: storeController.isExtraPackagingEnabled!,
                        hideEnableText: true,
                        isAmount: true,
                      ),
                    ),

                  ]),
                ),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                _module.alwaysOpen! ? const SizedBox() : Text('daily_schedule_time'.tr, style: robotoBold),
                SizedBox(height: _module.alwaysOpen! ? 0 : Dimensions.paddingSizeSmall),

                _module.alwaysOpen! ? const SizedBox() : CustomCard(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 7,
                    itemBuilder: (context, index) {
                      return Column(children: [
                        DailyTimeWidget(weekDay: index),

                        index != 6 ? const Divider() : const SizedBox(),
                      ]);
                    },
                  ),
                ),

              ]),
            )),

            Container(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 5)],
              ),
              child: CustomButtonWidget(
                isLoading: storeController.isLoading,
                onPressed: () {

                  String minimumOrder = _orderAmountController.text.trim();
                  String deliveryFee = _minimumDeliveryFeeController.text.trim();
                  String minimum = _minimumController.text.trim();
                  String maximum = _maximumController.text.trim();
                  String processingTime = _processingTimeController.text.trim();
                  String deliveryChargePerKm = _deliveryChargePerKmController.text.trim();
                  String gstCode = _gstController.text.trim();
                  String extraPackagingAmount = _extraPackagingController.text.trim();
                  String maximumFee = _maximumDeliveryFeeController.text.trim();
                  String minimumStockForWarning = _minimumStockController.text.trim();

                  if(minimumOrder.isEmpty) {
                    showCustomSnackBar('enter_minimum_order_amount'.tr);
                  }else if(minimum.isEmpty) {
                    showCustomSnackBar('enter_minimum_delivery_time'.tr);
                  }else if(maximum.isEmpty) {
                    showCustomSnackBar('enter_maximum_delivery_time'.tr);
                  }else if(storeController.selectedDuration == null) {
                    showCustomSnackBar('select_delivery_time_type'.tr);
                  }else if(deliveryChargePerKm.isEmpty) {
                    showCustomSnackBar('enter_delivery_charge_per_km'.tr);
                  }else if(_store.selfDeliverySystem == 1 && deliveryFee.isEmpty) {
                    showCustomSnackBar('enter_minimum_delivery_charge'.tr);
                  }else if(_store.selfDeliverySystem == 1 && deliveryFee.isEmpty && maximumFee.isNotEmpty) {
                    showCustomSnackBar('enter_minimum_delivery_charge'.tr);
                  }else if(_store.selfDeliverySystem == 1 && maximumFee.isNotEmpty && double.parse(maximumFee) == 0) {
                    showCustomSnackBar('enter_maximum_delivery_charge_more_than_0'.tr);
                  }else if(_store.selfDeliverySystem == 1 && deliveryFee.isNotEmpty && maximumFee.isNotEmpty && double.parse(maximumFee) != 0 && (double.parse(deliveryFee) > double.parse(maximumFee))) {
                    showCustomSnackBar('minimum_charge_can_not_be_more_then_maximum_charge'.tr);
                  }else if(_module.orderPlaceToScheduleInterval! && processingTime.isEmpty) {
                    showCustomSnackBar('enter_minimum_processing_time'.tr);
                  }else if((_module.vegNonVeg! && Get.find<SplashController>().configModel!.toggleVegNonVeg!) &&
                      !storeController.isStoreVeg! && !storeController.isStoreNonVeg!){
                    showCustomSnackBar('select_at_least_one_item_type'.tr);
                  }else if(_module.orderPlaceToScheduleInterval! && processingTime.isEmpty) {
                    showCustomSnackBar('enter_minimum_processing_time'.tr);
                  }else if(storeController.isGstEnabled! && gstCode.isEmpty) {
                    showCustomSnackBar('enter_gst_code'.tr);
                  } else if(storeController.isExtraPackagingEnabled! && extraPackagingAmount.isEmpty) {
                    showCustomSnackBar('enter_extra_packaging_amount_more_than_0'.tr);
                  }else if(storeController.isExtraPackagingEnabled! && extraPackagingAmount.isNotEmpty && double.parse(extraPackagingAmount) == 0) {
                    showCustomSnackBar('enter_extra_packaging_amount_more_than_0'.tr);
                  }else {
                    _store.minimumOrder = minimumOrder.isNotEmpty ? double.parse(minimumOrder) : 0;
                    _store.gstStatus = storeController.isGstEnabled;
                    _store.gstCode = gstCode;
                    _store.orderPlaceToScheduleInterval = _module.orderPlaceToScheduleInterval! ? double.parse(_processingTimeController.text).toInt() : 0;
                    _store.minimumShippingCharge = deliveryFee.isNotEmpty ? double.parse(deliveryFee) : null;
                    _store.maximumShippingCharge = maximumFee.isNotEmpty ? double.parse(maximumFee) : null;
                    _store.perKmShippingCharge = deliveryChargePerKm.isNotEmpty ? double.parse(deliveryChargePerKm) : 0;
                    _store.veg = (_module.vegNonVeg! && storeController.isStoreVeg!) ? 1 : 0;
                    _store.nonVeg = (!_module.vegNonVeg! || storeController.isStoreNonVeg!) ? 1 : 0;
                    _store.extraPackagingStatus = storeController.isExtraPackagingEnabled;
                    _store.extraPackagingAmount = extraPackagingAmount.isNotEmpty ? double.parse(extraPackagingAmount) : 0;
                    _store.scheduleOrder = storeController.isScheduleOrderEnabled;
                    _store.delivery = storeController.isDeliveryEnabled;
                    _store.cutlery = storeController.isCutleryEnabled;
                    _store.freeDelivery = storeController.isFreeDeliveryEnabled;
                    _store.takeAway = storeController.isTakeAwayEnabled;
                    _store.prescriptionStatus = storeController.isPrescriptionStatusEnable;
                    _store.minimumStockForWarning = minimumStockForWarning.isNotEmpty ? double.parse(minimumStockForWarning) : 0;

                    storeController.updateStore(_store, minimum, maximum);
                  }
                },
                buttonText: 'update'.tr,
              ),
            ),

          ]);
        });
      }),
    );
  }

  dynamic getDeliveryData(String deliveryTime, String type) {
    RegExp regExp = RegExp(r'(\d+)-(\d+) (hours|days|min)');
    RegExpMatch? match = regExp.firstMatch(deliveryTime);

    if (match != null) {
      switch (type) {
        case 'min':
          return match.group(1)!;
        case 'max':
          return match.group(2)!;
        case 'type':
          return match.group(3)!;
        default:
          throw ArgumentError('Invalid type requested');
      }
    } else {
      throw const FormatException('Invalid delivery time format');
    }
  }

}
