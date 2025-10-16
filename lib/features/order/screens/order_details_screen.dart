import 'dart:async';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';
import 'package:sixam_mart_store/features/order/controllers/order_controller.dart';
import 'package:sixam_mart_store/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart_store/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart_store/features/notification/domain/models/notification_body_model.dart';
import 'package:sixam_mart_store/features/chat/domain/models/conversation_model.dart';
import 'package:sixam_mart_store/features/order/domain/models/order_details_model.dart';
import 'package:sixam_mart_store/features/order/domain/models/order_model.dart';
import 'package:sixam_mart_store/helper/date_converter_helper.dart';
import 'package:sixam_mart_store/helper/invoice_print_helper.dart';
import 'package:sixam_mart_store/helper/price_converter_helper.dart';
import 'package:sixam_mart_store/helper/responsive_helper.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';
import 'package:sixam_mart_store/util/app_constants.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/common/widgets/confirmation_dialog_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_app_bar_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_button_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_image_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:sixam_mart_store/features/order/screens/invoice_print_screen.dart';
import 'package:sixam_mart_store/features/order/widgets/amount_input_dialogue_widget.dart';
import 'package:sixam_mart_store/features/order/widgets/camera_button_sheet_widget.dart';
import 'package:sixam_mart_store/features/order/widgets/collect_money_delivery_sheet_widget.dart';
import 'package:sixam_mart_store/features/order/widgets/dialogue_image_widget.dart';
import 'package:sixam_mart_store/features/order/widgets/order_item_widget.dart';
import 'package:sixam_mart_store/features/order/widgets/verify_delivery_sheet_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

class OrderDetailsScreen extends StatefulWidget {
  final int orderId;
  final bool isRunningOrder;
  final bool fromNotification;
  const OrderDetailsScreen({super.key, required this.orderId, required this.isRunningOrder, this.fromNotification = false});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> with WidgetsBindingObserver {
  Timer? _timer;
  bool selfDelivery = false;
  String? _selectedProcessingTime;
  final List<String> _processingTimeOptions = ['5', '10', '15', '20', '25', '30', '35', '40'];

  Future<void> loadData() async {

    if(Get.find<ProfileController>().profileModel == null) {
      Get.find<ProfileController>().getProfile();
    }
    Get.find<OrderController>().pickPrescriptionImage(isRemove: true, isCamera: false);
    await Get.find<OrderController>().getOrderDetails(widget.orderId); ///order

    Get.find<OrderController>().getOrderItemsDetails(widget.orderId); ///order details

    if(Get.find<OrderController>().showDeliveryImageField){
      Get.find<OrderController>().changeDeliveryImageStatus(isUpdate: false);
    }

    _startApiCalling();
  }

  void _startApiCalling() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      Get.find<OrderController>().getOrderDetails(widget.orderId);
    });
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    _selectedProcessingTime = '5';
    Get.find<OrderController>().clearPreviousData();
    loadData();
  }

  @override
  void didChangeAppLifecycleState(final AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _startApiCalling();
    }else if(state == AppLifecycleState.paused){
      _timer?.cancel();
    }
  }

  @override
  void dispose() {
    super.dispose();

    WidgetsBinding.instance.removeObserver(this);

    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    bool? cancelPermission = Get.find<SplashController>().configModel!.canceledByStore;
    if(Get.find<ProfileController>().profileModel != null) {
      selfDelivery = Get.find<ProfileController>().profileModel!.stores![0].selfDeliverySystem == 1;
    }

    return PopScope(
      canPop: Navigator.canPop(context),
      onPopInvokedWithResult: (didPop, result) async{
        if(widget.fromNotification && !didPop) {
          Get.offAllNamed(RouteHelper.getInitialRoute());
        } else {
          return;
        }
      },
      child: Scaffold(
        appBar: CustomAppBarWidget(title: 'order_details'.tr, onTap: (){
          if(widget.fromNotification) {
            Get.offAllNamed(RouteHelper.getInitialRoute());
          } else {
            Get.back();
          }
        }),
        body: SafeArea(
          child: GetBuilder<OrderController>(builder: (orderController) {

            OrderModel? controllerOrderModel = orderController.orderModel;

            bool restConfModel = Get.find<SplashController>().configModel!.orderConfirmationModel != 'deliveryman';
            bool showSlider = controllerOrderModel != null ? (controllerOrderModel.orderStatus == 'pending' && (controllerOrderModel.orderType == 'take_away' || restConfModel || selfDelivery))
                || controllerOrderModel.orderStatus == 'confirmed' || controllerOrderModel.orderStatus == 'processing'
                || (controllerOrderModel.orderStatus == 'accepted' && controllerOrderModel.confirmed != null)
                || (controllerOrderModel.orderStatus == 'handover' && (selfDelivery || controllerOrderModel.orderType == 'take_away')) : false;
            bool showBottomView = controllerOrderModel != null ? showSlider || controllerOrderModel.orderStatus == 'picked_up' || widget.isRunningOrder : false;
            bool showDeliveryConfirmImage = orderController.showDeliveryImageField;

            double? deliveryCharge = 0;
            double itemsPrice = 0;
            double? discount = 0;
            double? couponDiscount = 0;
            double? tax = 0;
            double addOns = 0;
            double? dmTips = 0;
            double additionalCharge = 0;
            double extraPackagingAmount = 0;
            double referrerBonusAmount = 0;
            bool? isPrescriptionOrder = false;
            bool? taxIncluded = false;
            OrderModel? order = controllerOrderModel;
            if(order != null && orderController.orderDetailsModel != null) {
              if(order.orderType == 'delivery') {
                deliveryCharge = order.deliveryCharge;
                dmTips = order.dmTips;
                isPrescriptionOrder = order.prescriptionOrder;
              }
              discount = order.storeDiscountAmount! + order.flashAdminDiscountAmount! + order.flashStoreDiscountAmount!;
              tax = order.totalTaxAmount;
              taxIncluded = order.taxStatus;
              additionalCharge = order.additionalCharge!;
              extraPackagingAmount = order.extraPackagingAmount!;
              referrerBonusAmount = order.referrerBonusAmount!;
              couponDiscount = order.couponDiscountAmount;
              if(isPrescriptionOrder!){
                double orderAmount = order.orderAmount ?? 0;
                itemsPrice = (orderAmount + discount) - ((taxIncluded! ? 0 : tax!) + deliveryCharge! + additionalCharge) - dmTips!;
              }else {
                for (OrderDetailsModel orderDetails in orderController.orderDetailsModel!) {
                  for (AddOn addOn in orderDetails.addOns!) {
                    addOns = addOns + (addOn.price! * addOn.quantity!);
                  }
                  itemsPrice = itemsPrice + (orderDetails.price! * orderDetails.quantity!);
                }
              }
            }
            double subTotal = itemsPrice + addOns;
            double total = itemsPrice + addOns - discount+ (taxIncluded! ? 0 : tax!) + deliveryCharge! - couponDiscount! + dmTips! + additionalCharge + extraPackagingAmount - referrerBonusAmount;

            return (orderController.orderDetailsModel != null && controllerOrderModel != null) ? Column(children: [

              Expanded(child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                child: Center(child: SizedBox(width: 1170, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                  Row(children: [
                    Text('${'order_id'.tr}:', style: robotoRegular),
                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                    Text(order!.id.toString(), style: robotoMedium),
                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                    const Expanded(child: SizedBox()),
                    const Icon(Icons.watch_later, size: 17),
                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                    Text(
                      DateConverterHelper.dateTimeStringToDateTime(order.createdAt!),
                      style: robotoRegular,
                    ),
                  ]),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  order.scheduled == 1 ? Row(children: [
                    Text('${'scheduled_at'.tr}:', style: robotoRegular),
                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                    Text(DateConverterHelper.dateTimeStringToDateTime(order.scheduleAt!), style: robotoMedium),
                  ]) : const SizedBox(),
                  SizedBox(height: order.scheduled == 1 ? Dimensions.paddingSizeSmall : 0),

                  Row(children: [
                    Text(order.orderType!.tr, style: robotoMedium),
                    const Expanded(child: SizedBox()),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      ),
                      child: Text(
                        order.paymentMethod == 'cash_on_delivery' ? 'cash_on_delivery'.tr
                            : order.paymentMethod == 'wallet' ? 'wallet_payment'
                            : order.paymentMethod == 'partial_payment' ? 'partial_payment'.tr
                            : 'digital_payment'.tr,
                        style: robotoMedium.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeExtraSmall),
                      ),
                    ),
                  ]),
                  const Divider(height: Dimensions.paddingSizeLarge),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                    child: Row(children: [
                      Text('${'item'.tr}:', style: robotoRegular),
                      const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                      Text(
                        orderController.orderDetailsModel!.length.toString(),
                        style: robotoMedium.copyWith(color: Theme.of(context).primaryColor),
                      ),
                      const Expanded(child: SizedBox()),
                      Container(height: 7, width: 7, decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle)),
                      const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                      Text(
                        order.orderStatus == 'delivered' ? '${'delivered_at'.tr} ${order.delivered != null ? DateConverterHelper.dateTimeStringToDateTime(order.delivered!) : ''}'
                            : order.orderStatus!.tr,
                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                      ),
                    ]),
                  ),

                  Get.find<SplashController>().getModuleConfig(order.moduleType).newVariation!
                  ? Column(children: [
                    const Divider(height: Dimensions.paddingSizeLarge),

                    Row(children: [
                      Text('${'cutlery'.tr}: ', style: robotoRegular),
                      const Expanded(child: SizedBox()),

                      Text(
                        order.cutlery! ? 'yes'.tr : 'no'.tr,
                        style: robotoRegular,
                      ),
                    ]),
                  ]) : const SizedBox(),

                  order.unavailableItemNote != null ? Column(
                    children: [
                      const Divider(height: Dimensions.paddingSizeLarge),

                      Row(children: [
                        Text('${'unavailable_item_note'.tr}: ', style: robotoMedium),

                        Text(
                          order.unavailableItemNote!,
                          style: robotoRegular,
                        ),
                      ]),
                    ],
                  ) : const SizedBox(),

                  order.deliveryInstruction != null ? Column(children: [
                    const Divider(height: Dimensions.paddingSizeLarge),

                    Row(children: [
                      Text('${'delivery_instruction'.tr}: ', style: robotoMedium),

                      Text(
                        order.deliveryInstruction!,
                        style: robotoRegular,
                      ),
                    ]),
                  ]) : const SizedBox(),
                  SizedBox(height: order.deliveryInstruction != null ? Dimensions.paddingSizeSmall : 0),

                  const Divider(height: Dimensions.paddingSizeLarge),

                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: orderController.orderDetailsModel!.length,
                    itemBuilder: (context, index) {
                      return OrderItemWidget(order: order, orderDetails: orderController.orderDetailsModel![index]);
                    },
                  ),

                  (order.orderNote  != null && order.orderNote!.isNotEmpty) ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('additional_note'.tr, style: robotoRegular),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    Container(
                      width: 1170,
                      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                        border: Border.all(width: 1, color: Theme.of(context).disabledColor),
                      ),
                      child: Text(
                        order.orderNote!,
                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                      ),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeLarge),
                  ]) : const SizedBox(),

                  (Get.find<SplashController>().getModuleConfig(order.moduleType).orderAttachment! && order.orderAttachmentFullUrl != null
                  && order.orderAttachmentFullUrl!.isNotEmpty) ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('prescription'.tr, style: robotoRegular),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 1,
                          crossAxisCount: ResponsiveHelper.isTab(context) ? 5 : 3,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 5,
                        ),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: order.orderAttachmentFullUrl!.length,
                        itemBuilder: (BuildContext context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: InkWell(
                              onTap: () => openDialog(context, order.orderAttachmentFullUrl![index]),
                              child: Center(child: ClipRRect(
                                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                child: CustomImageWidget(
                                  image: order.orderAttachmentFullUrl![index],
                                  width: 100, height: 100,
                                ),
                              )),
                            ),
                          );
                        }),

                    const SizedBox(height: Dimensions.paddingSizeLarge),
                  ]) : const SizedBox(),

                  (controllerOrderModel.orderStatus == 'delivered' && order.orderProofFullUrl != null
                  && order.orderProofFullUrl!.isNotEmpty) ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('order_proof'.tr, style: robotoRegular),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 1.5,
                          crossAxisCount: ResponsiveHelper.isTab(context) ? 5 : 3,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 5,
                        ),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: order.orderProofFullUrl!.length,
                        itemBuilder: (BuildContext context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: InkWell(
                              onTap: () => openDialog(context, order.orderProofFullUrl![index]),
                              child: Center(child: ClipRRect(
                                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                child: CustomImageWidget(
                                  image: order.orderProofFullUrl![index],
                                  width: 100, height: 100,
                                ),
                              )),
                            ),
                          );
                        }),

                    const SizedBox(height: Dimensions.paddingSizeLarge),
                  ]) : const SizedBox(),

                  Text('customer_details'.tr, style: robotoRegular),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                  order.deliveryAddress != null ? Row(children: [
                    SizedBox(
                      height: 35, width: 35,
                      child: ClipOval(child: CustomImageWidget(
                        image: '${order.customer != null ? order.customer!.imageFullUrl : ''}',
                        height: 35, width: 35, fit: BoxFit.cover,
                      )),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeSmall),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(
                        order.deliveryAddress!.contactPersonName!, maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                      ),
                      Text(
                        order.deliveryAddress!.address ?? '', maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                      ),

                      Wrap(children: [
                        (order.deliveryAddress!.streetNumber != null && order.deliveryAddress!.streetNumber!.isNotEmpty) ? Text('${'street_number'.tr}: ${order.deliveryAddress!.streetNumber!}, ',
                          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor), maxLines: 1, overflow: TextOverflow.ellipsis,
                        ) : const SizedBox(),

                        (order.deliveryAddress!.house != null && order.deliveryAddress!.house!.isNotEmpty) ? Text('${'house'.tr}: ${order.deliveryAddress!.house!}, ',
                          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor), maxLines: 1, overflow: TextOverflow.ellipsis,
                        ) : const SizedBox(),

                        (order.deliveryAddress!.floor != null && order.deliveryAddress!.floor!.isNotEmpty) ? Text('${'floor'.tr}: ${order.deliveryAddress!.floor!}' ,
                          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor), maxLines: 1, overflow: TextOverflow.ellipsis,
                        ) : const SizedBox(),
                      ]),

                    ])),

                    (order.orderType == 'take_away' && (order.orderStatus == 'pending' || order.orderStatus == 'confirmed' || order.orderStatus == 'processing')) ? TextButton.icon(
                      onPressed: () async {
                        String url ='https://www.google.com/maps/dir/?api=1&destination=${order.deliveryAddress!.latitude}'
                            ',${order.deliveryAddress!.longitude}&mode=d';
                        if (await canLaunchUrlString(url)) {
                          await launchUrlString(url, mode: LaunchMode.externalApplication);
                        }else {
                          showCustomSnackBar('unable_to_launch_google_map'.tr);
                        }
                      },
                      icon: const Icon(Icons.directions), label: Text('direction'.tr),
                    ) : const SizedBox(),
                    const SizedBox(width: Dimensions.paddingSizeSmall),

                    (order.orderStatus != 'delivered' && order.orderStatus != 'failed' && Get.find<ProfileController>().modulePermission!.chat!
                    && order.orderStatus != 'canceled' && order.orderStatus != 'refunded') ? order.isGuest! ? const SizedBox() : TextButton.icon(
                      onPressed: () async {

                        if(Get.find<ProfileController>().profileModel!.subscription != null && Get.find<ProfileController>().profileModel!.subscription!.chat == 0
                        && Get.find<ProfileController>().profileModel!.stores![0].storeBusinessModel == 'subscription') {

                        showCustomSnackBar('you_have_no_available_subscription'.tr);

                        } else {
                          _timer?.cancel();
                          await Get.toNamed(RouteHelper.getChatRoute(
                            notificationBody: NotificationBodyModel(
                              orderId: order.id, customerId: order.customer!.id,
                            ),
                            user: User(
                              id: order.customer!.id, fName: order.customer!.fName,
                              lName: order.customer!.lName, imageFullUrl: order.customer!.imageFullUrl,
                            ),
                          ));
                          _startApiCalling();
                        }
                      },
                      icon: Icon(Icons.message, color: Theme.of(context).primaryColor, size: 20),
                      label: Text(
                        'chat'.tr,
                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
                      ),
                    ) : const SizedBox(),
                  ]) : const SizedBox(),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  order.deliveryMan != null ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                    Text('delivery_man'.tr, style: robotoRegular),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    Row(children: [

                      ClipOval(child: CustomImageWidget(
                        image: order.deliveryMan != null ? '${order.deliveryMan!.imageFullUrl}' : '',
                        height: 35, width: 35, fit: BoxFit.cover,
                      )),
                      const SizedBox(width: Dimensions.paddingSizeSmall),

                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(
                          '${order.deliveryMan!.fName} ${order.deliveryMan!.lName}', maxLines: 1, overflow: TextOverflow.ellipsis,
                          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                        ),
                        Text(
                          order.deliveryMan!.email!, maxLines: 1, overflow: TextOverflow.ellipsis,
                          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                        ),
                      ])),

                      (controllerOrderModel.orderStatus != 'delivered' && controllerOrderModel.orderStatus != 'failed'
                      && controllerOrderModel.orderStatus != 'canceled' && controllerOrderModel.orderStatus != 'refunded') ? TextButton.icon(
                        onPressed: () async {
                          if(await canLaunchUrlString('tel:${order.deliveryMan!.phone ?? '' }')) {
                            launchUrlString('tel:${order.deliveryMan!.phone ?? '' }', mode: LaunchMode.externalApplication);
                          }else {
                            showCustomSnackBar('${'can_not_launch'.tr} ${order.deliveryMan!.phone ?? ''}');
                          }
                        },
                        icon: Icon(Icons.call, color: Theme.of(context).primaryColor, size: 20),
                        label: Text(
                          'call'.tr,
                          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
                        ),
                      ) : const SizedBox(),

                      (controllerOrderModel.orderStatus != 'delivered' && controllerOrderModel.orderStatus != 'failed' && controllerOrderModel.orderStatus != 'canceled'
                      && controllerOrderModel.orderStatus != 'refunded' && Get.find<ProfileController>().modulePermission!.chat!) ? TextButton.icon(
                        onPressed: () async {

                          if(Get.find<ProfileController>().profileModel!.subscription != null && Get.find<ProfileController>().profileModel!.subscription!.chat == 0
                          && Get.find<ProfileController>().profileModel!.stores![0].storeBusinessModel == 'subscription') {

                            showCustomSnackBar('you_have_no_available_subscription'.tr);

                          } else {
                            _timer?.cancel();
                            await Get.toNamed(RouteHelper.getChatRoute(
                              notificationBody: NotificationBodyModel(
                                orderId: controllerOrderModel.id, deliveryManId: order.deliveryMan!.id,
                              ),
                              user: User(
                                id: controllerOrderModel.deliveryMan!.id, fName: controllerOrderModel.deliveryMan!.fName,
                                lName: controllerOrderModel.deliveryMan!.lName, imageFullUrl: controllerOrderModel.deliveryMan!.imageFullUrl,
                              ),
                            ));
                            _startApiCalling();
                          }

                        },
                        icon: Icon(Icons.chat_bubble_outline, color: Theme.of(context).primaryColor, size: 20),
                        label: Text(
                          'chat'.tr,
                          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
                        ),
                      ) : const SizedBox(),

                    ]),

                    const SizedBox(height: Dimensions.paddingSizeSmall),
                  ]) : const SizedBox(),

                  // Total
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('item_price'.tr, style: robotoRegular),
                    Row(mainAxisSize: MainAxisSize.min, children: [
                      order.prescriptionOrder! ? IconButton(
                        constraints: const BoxConstraints(maxHeight: 36),
                        onPressed: () =>  Get.dialog(AmountInputDialogueWidget(orderId: widget.orderId, isItemPrice: true, amount: itemsPrice, additionalCharge: additionalCharge), barrierDismissible: true),
                        icon: const Icon(Icons.edit, size: 16),
                      ) : const SizedBox(),
                      Text(PriceConverterHelper.convertPrice(itemsPrice), style: robotoRegular),
                    ]),
                  ]),
                  const SizedBox(height: 10),

                  Get.find<SplashController>().getModuleConfig(order.moduleType).addOn! ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('addons'.tr, style: robotoRegular),
                      Text('(+) ${PriceConverterHelper.convertPrice(addOns)}', style: robotoRegular),
                    ],
                  ) : const SizedBox(),

                  Get.find<SplashController>().getModuleConfig(order.moduleType).addOn! ? Divider(
                    thickness: 1, color: Theme.of(context).hintColor.withValues(alpha: 0.5),
                  ) : const SizedBox(),

                  Get.find<SplashController>().getModuleConfig(order.moduleType).addOn! ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('subtotal'.tr, style: robotoMedium),
                      Text(PriceConverterHelper.convertPrice(subTotal), style: robotoMedium),
                    ],
                  ) : const SizedBox(),
                  SizedBox(height: Get.find<SplashController>().getModuleConfig(order.moduleType).addOn! ? 10 : 0),

                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('discount'.tr, style: robotoRegular),
                    Row(mainAxisSize: MainAxisSize.min, children: [
                      order.prescriptionOrder! ? IconButton(
                        constraints: const BoxConstraints(maxHeight: 36),
                        onPressed: () => Get.dialog(AmountInputDialogueWidget(orderId: widget.orderId, isItemPrice: false, amount: discount), barrierDismissible: true),
                        icon: const Icon(Icons.edit, size: 16),
                      ) : const SizedBox(),
                      Text('(-) ${PriceConverterHelper.convertPrice(discount)}', style: robotoRegular),
                    ]),
                  ]),
                  const SizedBox(height: 10),

                  couponDiscount > 0 ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('coupon_discount'.tr, style: robotoRegular),
                    Text(
                      '(-) ${PriceConverterHelper.convertPrice(couponDiscount)}',
                      style: robotoRegular,
                    ),
                  ]) : const SizedBox(),
                  SizedBox(height: couponDiscount > 0 ? 10 : 0),

                  (referrerBonusAmount > 0) ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('referral_discount'.tr, style: robotoRegular),
                      Text('(-) ${PriceConverterHelper.convertPrice(referrerBonusAmount)}', style: robotoRegular),
                    ],
                  ) : const SizedBox(),
                  SizedBox(height: referrerBonusAmount > 0 ? 10 : 0),

                  taxIncluded || (tax == 0) ? const SizedBox() : Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('vat_tax'.tr, style: robotoRegular),
                    Text('(+) ${PriceConverterHelper.convertPrice(tax)}', style: robotoRegular),
                  ]),
                  SizedBox(height: taxIncluded || (tax == 0) ? 0 : 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('delivery_man_tips'.tr, style: robotoRegular),
                      Text('(+) ${PriceConverterHelper.convertPrice(dmTips)}', style: robotoRegular),
                    ],
                  ),
                  const SizedBox(height: 10),

                  (extraPackagingAmount > 0) ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('extra_packaging'.tr, style: robotoRegular),
                      Text('(+) ${PriceConverterHelper.convertPrice(extraPackagingAmount)}', style: robotoRegular),
                    ],
                  ) : const SizedBox(),
                  SizedBox(height: extraPackagingAmount > 0 ? 10 : 0),

                  (order.additionalCharge != null && order.additionalCharge! > 0) ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text(Get.find<SplashController>().configModel!.additionalChargeName!, style: robotoRegular),
                    Text('(+) ${PriceConverterHelper.convertPrice(order.additionalCharge)}', style: robotoRegular, textDirection: TextDirection.ltr),
                  ]) : const SizedBox(),
                  (order.additionalCharge != null && order.additionalCharge! > 0) ? const SizedBox(height: 10) : const SizedBox(),

                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('delivery_fee'.tr, style: robotoRegular),
                    Text('(+) ${PriceConverterHelper.convertPrice(deliveryCharge)}', style: robotoRegular),
                  ]),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                    child: Divider(thickness: 1, color: Theme.of(context).hintColor.withValues(alpha: 0.5)),
                  ),

                  order.paymentMethod == 'partial_payment' ? DottedBorder(
                    color: Theme.of(context).primaryColor,
                    strokeWidth: 1,
                    strokeCap: StrokeCap.butt,
                    dashPattern: const [8, 5],
                    padding: const EdgeInsets.all(0),
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(Dimensions.radiusDefault),
                    child: Ink(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      color: restConfModel ? Theme.of(context).primaryColor.withValues(alpha: 0.05) : Colors.transparent,
                      child: Column(children: [

                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Text('total_amount'.tr, style: robotoMedium.copyWith(
                            fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).primaryColor,
                          )),
                          Text(
                            PriceConverterHelper.convertPrice(total),
                            style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).primaryColor),
                          ),
                        ]),
                        const SizedBox(height: 10),

                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Text('paid_by_wallet'.tr, style: restConfModel ? robotoMedium : robotoRegular),
                          Text(
                            PriceConverterHelper.convertPrice(order.payments![0].amount),
                            style: restConfModel ? robotoMedium : robotoRegular,
                          ),
                        ]),
                        const SizedBox(height: 10),

                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Text('${order.payments?[1].paymentStatus == 'paid' ? 'paid_by'.tr : 'due_amount'.tr} (${order.payments![1].paymentMethod?.tr})', style: restConfModel ? robotoMedium : robotoRegular),
                          Text(
                            PriceConverterHelper.convertPrice(order.payments![1].amount),
                            style: restConfModel ? robotoMedium : robotoRegular,
                          ),
                        ]),
                      ]),
                    ),
                  ) : const SizedBox(),

                  order.paymentMethod != 'partial_payment' ? Row(children: [
                    Text('total_amount'.tr, style: robotoMedium.copyWith(
                      fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).primaryColor,
                    )),

                    taxIncluded ? Text(' ${'vat_tax_inc'.tr}', style: robotoMedium.copyWith(
                      fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).primaryColor,
                    )) : const SizedBox(),

                    const Expanded(child: SizedBox()),

                    Text(
                      PriceConverterHelper.convertPrice(total),
                      style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).primaryColor),
                    ),
                  ]) : const SizedBox(),

                ]))),
              )),

              showDeliveryConfirmImage && Get.find<SplashController>().configModel!.dmPictureUploadStatus! && controllerOrderModel.orderStatus != 'delivered'
              ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const SizedBox(height: Dimensions.paddingSizeDefault),
                  Text('completed_after_delivery_picture'.tr, style: robotoRegular),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  Container(
                    height: 80,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    ),
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: orderController.pickedPrescriptions.length+1,
                      itemBuilder: (context, index) {
                        XFile? file = index == orderController.pickedPrescriptions.length ? null : orderController.pickedPrescriptions[index];
                        if(index < 5 && index == orderController.pickedPrescriptions.length) {
                          return InkWell(
                            onTap: () {
                              if(GetPlatform.isIOS) {
                                Get.find<OrderController>().pickPrescriptionImage(isRemove: false, isCamera: false);
                              }else {
                                Get.bottomSheet(const CameraButtonSheetWidget());
                              }
                            },
                            child: Container(
                              height: 60, width: 60, alignment: Alignment.center, decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                            ),
                              child:  Icon(Icons.camera_alt_sharp, color: Theme.of(context).primaryColor, size: 32),
                            ),
                          );
                        }
                        return file != null ? Container(
                          margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          ),
                          child: Stack(children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                              child: GetPlatform.isWeb ? Image.network(
                                file.path, width: 60, height: 60, fit: BoxFit.cover,
                              ) : Image.file(
                                File(file.path), width: 60, height: 60, fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              right: 0, top: 0,
                              child: InkWell(
                                onTap: () => orderController.removePrescriptionImage(index),
                                child: const Padding(
                                  padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                                  child: Icon(Icons.delete_forever, color: Colors.red),
                                ),
                              ),
                            ),
                          ]),
                        ) : const SizedBox();
                      },
                    ),
                  ),
                ]),
              ) : const SizedBox(),

              showDeliveryConfirmImage && controllerOrderModel.orderStatus != 'delivered' ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                child: CustomButtonWidget(
                  buttonText: 'complete_delivery'.tr,
                  onPressed: () {
                    if(Get.find<SplashController>().configModel!.orderDeliveryVerification!) {
                      orderController.sendDeliveredNotification(controllerOrderModel.id);

                      Get.bottomSheet(VerifyDeliverySheetWidget(
                        orderID: controllerOrderModel.id, verify: Get.find<SplashController>().configModel!.orderDeliveryVerification,
                        orderAmount: order.paymentMethod == 'partial_payment' ? order.payments![1].amount!.toDouble() : controllerOrderModel.orderAmount,
                        cod: controllerOrderModel.paymentMethod == 'cash_on_delivery' || (order.paymentMethod == 'partial_payment' && order.payments![1].paymentMethod == 'cash_on_delivery'),
                      ), isScrollControlled: true).then((isSuccess) {

                        if(isSuccess && controllerOrderModel.paymentMethod == 'cash_on_delivery' || (order.paymentMethod == 'partial_payment' && order.payments![1].paymentMethod == 'cash_on_delivery')){
                          Get.bottomSheet(CollectMoneyDeliverySheetWidget(
                            orderID: controllerOrderModel.id, verify: Get.find<SplashController>().configModel!.orderDeliveryVerification,
                            orderAmount: order.paymentMethod == 'partial_payment' ? order.payments![1].amount!.toDouble() : controllerOrderModel.orderAmount,
                            cod: controllerOrderModel.paymentMethod == 'cash_on_delivery' || (order.paymentMethod == 'partial_payment' && order.payments![1].paymentMethod == 'cash_on_delivery'),
                          ), isScrollControlled: true, isDismissible: false);
                        }
                      });
                    } else {
                      Get.bottomSheet(CollectMoneyDeliverySheetWidget(
                        orderID: controllerOrderModel.id, verify: Get.find<SplashController>().configModel!.orderDeliveryVerification,
                        orderAmount: order.paymentMethod == 'partial_payment' ? order.payments![1].amount!.toDouble() : controllerOrderModel.orderAmount,
                        cod: controllerOrderModel.paymentMethod == 'cash_on_delivery' || (order.paymentMethod == 'partial_payment' && order.payments![1].paymentMethod == 'cash_on_delivery'),
                      ), isScrollControlled: true);
                    }

                  },
                ),
              ) : showBottomView ? (controllerOrderModel.orderStatus == 'picked_up') ? Container(
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  border: Border.all(width: 1, color: Get.isDarkMode ? Colors.grey[700]! : Colors.grey[200]!),
                ),
                alignment: Alignment.center,
                child: Text('item_is_on_the_way'.tr, style: robotoMedium),
              ) : showSlider ? (controllerOrderModel.orderStatus == 'pending' && (controllerOrderModel.orderType == 'take_away'
              || restConfModel || selfDelivery) && cancelPermission!) ? Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                child: Row(children: [

                  // Expanded(child: TextButton(
                  //   onPressed: (){
                  //     orderController.setOrderCancelReason('');
                  //     Get.dialog(CancellationDialogueWidget(orderId: order.id));
                  //   },
                  //   style: TextButton.styleFrom(
                  //     minimumSize: const Size(1170, 40), padding: EdgeInsets.zero,
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  //       side: BorderSide(width: 1, color: Theme.of(context).textTheme.bodyLarge!.color!),
                  //     ),
                  //   ),
                  //   child: Text('cancel'.tr, textAlign: TextAlign.center, style: robotoRegular.copyWith(
                  //     color: Theme.of(context).textTheme.bodyLarge!.color,
                  //     fontSize: Dimensions.fontSizeLarge,
                  //   )),
                  // )),
                  // const SizedBox(width: Dimensions.paddingSizeSmall),

                  Expanded(flex: 4,child: CustomButtonWidget(
                    buttonText: 'accept'.tr, height: 50,
                    onPressed: () async {
                      Get.dialog(ConfirmationDialogWidget(
                        icon: Images.warning, title: 'are_you_sure_to_confirm'.tr, description: 'you_want_to_confirm_this_order'.tr,
                        onYesPressed: () async {
                          await orderController.updateOrderStatus(widget.orderId, AppConstants.confirmed, back: true, fromNotification: true);

                          // invoice auto print
                          Get.find<OrderController>().getOrderDetails(widget.orderId).then((value) async{

                            await Get.find<OrderController>().getOrderItemsDetails(widget.orderId);
                            final SplashController splashController = Get.find();
                            final OrderController oc = Get.find();

                            String? savedMacAddress = splashController.getBluetoothAddress();
                            bool currentlyConnectedInSavedPrinter = false;
                            OrderModel? acceptedOrder = oc.orderModel;
                            bool isRx = false;
                            double acceptedDmTips = 0.0;
                            if(acceptedOrder?.orderType == 'delivery') {
                              acceptedDmTips = acceptedOrder?.dmTips ?? 0.0;
                              isRx = acceptedOrder?.prescriptionOrder ?? false;
                            }

                            if(savedMacAddress?.isNotEmpty ?? false){
                              currentlyConnectedInSavedPrinter = await InvoicePrintHelper.checkConnectionStatus();

                              if(!currentlyConnectedInSavedPrinter) {
                                bool reconnected = await InvoicePrintHelper.attemptReconnection(savedMacAddress!);
                                if(reconnected) {
                                  currentlyConnectedInSavedPrinter = true;
                                } else {
                                    print('Failed to reconnect to printer');
                                }
                              }
                            }

                            allowPermission().then((access) {

                              Get.back();
                              Get.dialog(Dialog(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
                                insetPadding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                                child: InVoicePrintScreen(
                                  order : acceptedOrder,
                                  dmTips: acceptedDmTips,
                                  isPrescriptionOrder: isRx,
                                  orderDetails: oc.orderDetailsModel,
                                  currentlyConnectedInSavedPrinter : currentlyConnectedInSavedPrinter,
                                ),
                              ));
                            });

                          });
                        },
                      ), barrierDismissible: false);
                    },
                  )),
                  const SizedBox(width: Dimensions.paddingSizeSmall),

                  Expanded(flex: 2,child: Container(
                    alignment:Alignment.center,
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      border: Border.all(width: 1, color: Theme.of(context).primaryColor.withValues(alpha: 1)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: _selectedProcessingTime,
                        hint: Text('select_processing_time_min'.tr, overflow: TextOverflow.ellipsis, maxLines: 1,
                            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),
                        items: _processingTimeOptions.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text('$value ${'min'.tr}', overflow: TextOverflow.ellipsis, maxLines: 1,
                                style: robotoMedium.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeDefault)),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedProcessingTime = newValue;
                          });
                        },
                      ),
                    ),
                  )),

                ]),
              ) : controllerOrderModel.orderStatus == 'processing' ? Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                child: CustomButtonWidget(
                  onPressed: () {
                    Get.find<OrderController>().updateOrderStatus(widget.orderId, AppConstants.handover);
                  },
                  buttonText: 'ready_for_handover'.tr,
                  height: 50,
                ),
              ) : (controllerOrderModel.orderStatus == 'confirmed' &&
                  ((order.paymentStatus == 'partially_paid' && order.paymentMethod == 'partial_payment') ||
                      order.paymentStatus == 'paid' ||
                      order.paymentStatus == 'unpaid')) ?
              Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                child: Row(children: [
                  Expanded(flex: 4, child: CustomButtonWidget(
                    buttonText: 'update'.tr,
                    height: 50,
                    onPressed: () async {
                      if(_selectedProcessingTime == null || _selectedProcessingTime!.isEmpty) {
                        showCustomSnackBar('please_select_processing_time'.tr);
                        return;
                      }

                      await Get.find<OrderController>().updateOrderStatus(
                          controllerOrderModel.id,
                          AppConstants.processing,
                          processingTime: _selectedProcessingTime
                      );

                      Get.find<ProfileController>().getProfile();
                      Get.find<OrderController>().getCurrentOrders();

                      // Auto print receipt after updating to processing
                      Get.find<OrderController>().getOrderDetails(widget.orderId).then((value) async{
                        await Get.find<OrderController>().getOrderItemsDetails(widget.orderId);
                        final SplashController splashController = Get.find();
                        final OrderController oc = Get.find();

                        String? savedMacAddress = splashController.getBluetoothAddress();
                        bool currentlyConnectedInSavedPrinter = false;
                        OrderModel? processingOrder = oc.orderModel;
                        bool isRx = false;
                        double processingDmTips = 0.0;
                        if(processingOrder?.orderType == 'delivery') {
                          processingDmTips = processingOrder?.dmTips ?? 0.0;
                          isRx = processingOrder?.prescriptionOrder ?? false;
                        }

                        if(savedMacAddress?.isNotEmpty ?? false){
                          currentlyConnectedInSavedPrinter = await InvoicePrintHelper.checkConnectionStatus();

                          if(!currentlyConnectedInSavedPrinter) {
                            bool reconnected = await InvoicePrintHelper.attemptReconnection(savedMacAddress!);
                            if(reconnected) {
                              currentlyConnectedInSavedPrinter = true;
                            } else {
                                print('Failed to reconnect to printer');
                            }
                          }
                        }

                        allowPermission().then((access) {
                          Get.dialog(Dialog(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
                            insetPadding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                            child: InVoicePrintScreen(
                              order : processingOrder,
                              dmTips: processingDmTips,
                              isPrescriptionOrder: isRx,
                              orderDetails: oc.orderDetailsModel,
                              currentlyConnectedInSavedPrinter : currentlyConnectedInSavedPrinter,
                            ),
                          ));
                        });
                      });
                    },
                  )),
                  const SizedBox(width: Dimensions.paddingSizeSmall),

                  Expanded(flex: 2, child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      border: Border.all(width: 1, color: Theme.of(context).primaryColor.withValues(alpha: 1)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: _selectedProcessingTime,
                        hint: Text('select_processing_time_min'.tr, overflow: TextOverflow.ellipsis, maxLines: 1,
                            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),
                        items: _processingTimeOptions.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text('$value ${'min'.tr}', overflow: TextOverflow.ellipsis, maxLines: 1,
                                style: robotoMedium.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeDefault)),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedProcessingTime = newValue;
                          });
                        },
                      ),
                    ),
                  )),
                ]),
              ) : Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                child: Row(children: [
                  Expanded(flex: 4, child: CustomButtonWidget(
                    buttonText: (controllerOrderModel.orderStatus == 'pending' && (controllerOrderModel.orderType == 'take_away' || restConfModel || selfDelivery)) ? 'accept_order'.tr
                        : (controllerOrderModel.orderStatus == 'confirmed' || (controllerOrderModel.orderStatus == 'accepted' && controllerOrderModel.confirmed != null))
                        ? Get.find<SplashController>().configModel!.moduleConfig!.module!.showRestaurantText! ? 'start_cooking'.tr : 'start_processing'.tr
                        : (controllerOrderModel.orderStatus == 'processing') ? 'ready_for_handover'.tr
                        : (controllerOrderModel.orderStatus == 'handover' && (controllerOrderModel.orderType == 'take_away' || selfDelivery)) ? 'deliver_order'.tr : '',
                    height: 50,
                    onPressed: () {
                    if(controllerOrderModel.orderStatus == 'pending' && (controllerOrderModel.orderType == 'take_away'
                        || restConfModel || selfDelivery))  {
                      Get.dialog(ConfirmationDialogWidget(
                        icon: Images.warning, title: 'are_you_sure_to_confirm'.tr, description: 'you_want_to_confirm_this_order'.tr,
                        onYesPressed: () async {
                          await orderController.updateOrderStatus(widget.orderId, AppConstants.confirmed, back: true);

                          // Auto print invoice after accepting order
                          Get.find<OrderController>().getOrderDetails(widget.orderId).then((value) async{
                            await Get.find<OrderController>().getOrderItemsDetails(widget.orderId);
                            final SplashController splashController = Get.find();
                            final OrderController oc = Get.find();

                            String? savedMacAddress = splashController.getBluetoothAddress();
                            bool currentlyConnectedInSavedPrinter = false;
                            OrderModel? acceptedOrder = oc.orderModel;
                            bool isRx = false;
                            double acceptedDmTips = 0.0;
                            if(acceptedOrder?.orderType == 'delivery') {
                              acceptedDmTips = acceptedOrder?.dmTips ?? 0.0;
                              isRx = acceptedOrder?.prescriptionOrder ?? false;
                            }

                            if(savedMacAddress?.isNotEmpty ?? false){
                              currentlyConnectedInSavedPrinter = await InvoicePrintHelper.checkConnectionStatus();

                              if(!currentlyConnectedInSavedPrinter) {
                                bool reconnected = await InvoicePrintHelper.attemptReconnection(savedMacAddress!);
                                if(reconnected) {
                                  currentlyConnectedInSavedPrinter = true;
                                } else {
                                    print('Failed to reconnect to printer');
                                }
                              }
                            }

                            allowPermission().then((access) {
                              Get.back();
                              Get.dialog(Dialog(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
                                insetPadding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                                child: InVoicePrintScreen(
                                  order : acceptedOrder,
                                  dmTips: acceptedDmTips,
                                  isPrescriptionOrder: isRx,
                                  orderDetails: oc.orderDetailsModel,
                                  currentlyConnectedInSavedPrinter : currentlyConnectedInSavedPrinter,
                                ),
                              ));
                            });
                          });
                        },
                        onNoPressed: () {
                          if(cancelPermission!) {
                            orderController.updateOrderStatus(widget.orderId, AppConstants.canceled, back: true);
                          }else {
                            Get.back();
                          }
                        },
                      ), barrierDismissible: false);
                    }

                    else if(controllerOrderModel.orderStatus == 'processing') {
                        Get.find<OrderController>().updateOrderStatus(widget.orderId, AppConstants.handover);
                    }

                    else if(controllerOrderModel.orderStatus == 'confirmed' || (controllerOrderModel.orderStatus == 'accepted'
                        && controllerOrderModel.confirmed != null)) {
                      debugPrint('accepted & confirm call----------------');

                        if(_selectedProcessingTime == null || _selectedProcessingTime!.isEmpty) {
                          showCustomSnackBar('please_select_processing_time'.tr);
                          return;
                        }

                        Get.find<OrderController>().updateOrderStatus(controllerOrderModel.id, AppConstants.processing, processingTime: _selectedProcessingTime).then((success) {
                          if(success) {
                            Get.find<ProfileController>().getProfile();
                            Get.find<OrderController>().getCurrentOrders();

                            // Auto print receipt after updating to processing
                            Get.find<OrderController>().getOrderDetails(widget.orderId).then((value) async{
                              await Get.find<OrderController>().getOrderItemsDetails(widget.orderId);
                              final SplashController splashController = Get.find();
                              final OrderController oc = Get.find();

                              String? savedMacAddress = splashController.getBluetoothAddress();
                              bool currentlyConnectedInSavedPrinter = false;
                              OrderModel? processingOrder = oc.orderModel;
                              bool isRx = false;
                              double processingDmTips = 0.0;
                              if(processingOrder?.orderType == 'delivery') {
                                processingDmTips = processingOrder?.dmTips ?? 0.0;
                                isRx = processingOrder?.prescriptionOrder ?? false;
                              }

                              if(savedMacAddress?.isNotEmpty ?? false){
                                currentlyConnectedInSavedPrinter = await InvoicePrintHelper.checkConnectionStatus();

                                if(!currentlyConnectedInSavedPrinter) {
                                  bool reconnected = await InvoicePrintHelper.attemptReconnection(savedMacAddress!);
                                  if(reconnected) {
                                    currentlyConnectedInSavedPrinter = true;
                                  } else {
                                      print('Failed to reconnect to printer');
                                  }
                                }
                              }

                              allowPermission().then((access) {
                                Get.dialog(Dialog(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
                                  insetPadding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                                  child: InVoicePrintScreen(
                                    order : processingOrder,
                                    dmTips: processingDmTips,
                                    isPrescriptionOrder: isRx,
                                    orderDetails: oc.orderDetailsModel,
                                    currentlyConnectedInSavedPrinter : currentlyConnectedInSavedPrinter,
                                  ),
                                ));
                              });
                            });
                          }
                        });
                    }

                    else if((controllerOrderModel.orderStatus == 'handover' && (controllerOrderModel.orderType == 'take_away' || selfDelivery))) {
                      if (Get.find<SplashController>().configModel!.orderDeliveryVerification! || controllerOrderModel.paymentMethod == 'cash_on_delivery') {
                        orderController.changeDeliveryImageStatus();
                        if (kDebugMode) {
                          print('=====jjj : ${Get.find<SplashController>().configModel!.dmPictureUploadStatus!}');
                        }
                        if(Get.find<SplashController>().configModel!.dmPictureUploadStatus!) {
                          Get.dialog(const DialogImageWidget(), barrierDismissible: false);
                        }
                      } else {
                        Get.find<OrderController>().updateOrderStatus(controllerOrderModel.id, AppConstants.delivered);
                      }
                    }
                    },
                  )),
                  const SizedBox(width: Dimensions.paddingSizeSmall),

                  // Show dropdown only for confirmed/accepted orders that need processing time
                  if((controllerOrderModel.orderStatus == 'confirmed' || (controllerOrderModel.orderStatus == 'accepted' && controllerOrderModel.confirmed != null)))
                    Expanded(flex: 2, child: Container(
                      alignment: Alignment.center,
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                        border: Border.all(width: 1, color: Theme.of(context).primaryColor.withValues(alpha: 1)),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: _selectedProcessingTime,
                          hint: Text('select_processing_time_min'.tr, overflow: TextOverflow.ellipsis, maxLines: 1,
                              style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),
                          items: _processingTimeOptions.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text('$value ${'min'.tr}', overflow: TextOverflow.ellipsis, maxLines: 1,
                                  style: robotoMedium.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeDefault)),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedProcessingTime = newValue;
                            });
                          },
                        ),
                      ),
                    )),
                ]),
              ) : const SizedBox() : const SizedBox(),

              if(Platform.isAndroid)
                Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: CustomButtonWidget(
                    onPressed: () {
                      allowPermission().then((access) {
                        Get.dialog(Dialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
                          child: InVoicePrintScreen(
                            currentlyConnectedInSavedPrinter: false,
                            order: order,
                            orderDetails: orderController.orderDetailsModel,
                            isPrescriptionOrder: isPrescriptionOrder,
                            dmTips: dmTips!,
                          ),
                        ));
                      });
                    },
                    icon: Icons.local_print_shop,
                    buttonText: 'print_invoice'.tr,
                  ),
                ),


            ]) : const Center(child: CircularProgressIndicator());
          }),
        ),
      ),
    );
  }

  void openDialog(BuildContext context, String imageUrl) => showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusLarge)),
        child: Stack(children: [

          ClipRRect(
            borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
            child: PhotoView(
              tightMode: true,
              imageProvider: NetworkImage(imageUrl),
              heroAttributes: PhotoViewHeroAttributes(tag: imageUrl),
            ),
          ),

          Positioned(top: 0, right: 0, child: IconButton(
            splashRadius: 5,
            onPressed: () => Get.back(),
            icon: const Icon(Icons.cancel, color: Colors.red),
          )),

        ]),
      );
    },
  );
}


Future<bool> allowPermission() async {
  if (!await _requestAndCheckPermission(Permission.location)) {
    return false;
  }
  if (!await _requestAndCheckPermission(Permission.bluetooth)) {
    return false;
  }
  if (!await _requestAndCheckPermission(Permission.bluetoothConnect)) {
    return false;
  }
  if (!await _requestAndCheckPermission(Permission.bluetoothScan)) {
    return false;
  }

  return true;
}

Future<bool> _requestAndCheckPermission(Permission permission) async {
  await permission.request();
  var status = await permission.status;
  return !status.isDenied;
}
