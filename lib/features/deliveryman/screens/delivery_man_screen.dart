import 'package:sixam_mart_store/features/deliveryman/controllers/deliveryman_controller.dart';
import 'package:sixam_mart_store/features/deliveryman/domain/models/delivery_man_model.dart';
import 'package:sixam_mart_store/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/common/widgets/confirmation_dialog_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_app_bar_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeliveryManScreen extends StatefulWidget {
  const DeliveryManScreen({super.key});

  @override
  State<DeliveryManScreen> createState() => _DeliveryManScreenState();
}

class _DeliveryManScreenState extends State<DeliveryManScreen> {

  @override
  void initState() {
    super.initState();
    Get.find<DeliveryManController>().getDeliveryManList();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(builder: (profileController) {
      return Scaffold(
        appBar: CustomAppBarWidget(title: 'delivery_man'.tr),

        floatingActionButton: profileController.modulePermission!.deliveryman! ? FloatingActionButton(
          onPressed: () => Get.toNamed(RouteHelper.getAddDeliveryManRoute(null)),
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(Icons.add_circle_outline, color: Theme.of(context).cardColor, size: 30),
        ) : null,

        body: profileController.modulePermission!.deliverymanList! ? GetBuilder<DeliveryManController>(builder: (dmController) {
          return dmController.deliveryManList != null ? dmController.deliveryManList!.isNotEmpty ? ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: dmController.deliveryManList!.length,
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            itemBuilder: (context, index) {
              DeliveryManModel deliveryMan = dmController.deliveryManList![index];
              return InkWell(
                onTap: () => Get.toNamed(RouteHelper.getDeliveryManDetailsRoute(deliveryMan)),
                child: Column(children: [

                  Row(children: [

                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: deliveryMan.active == 1 ? Colors.green : Colors.red, width: 2),
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(child: CustomImageWidget(
                        image: deliveryMan.imageFullUrl ?? '',
                        height: 50, width: 50, fit: BoxFit.cover,
                      )),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeSmall),

                    Expanded(child: Text(
                      '${deliveryMan.fName} ${deliveryMan.lName}', maxLines: 2, overflow: TextOverflow.ellipsis,
                      style: robotoMedium,
                    )),
                    const SizedBox(width: Dimensions.paddingSizeSmall),

                    IconButton(
                      onPressed: () => Get.toNamed(RouteHelper.getAddDeliveryManRoute(deliveryMan)),
                      icon: const Icon(Icons.edit, color: Colors.blue),
                    ),

                    IconButton(
                      onPressed: () {
                        Get.dialog(ConfirmationDialogWidget(
                          icon: Images.warning, description: 'are_you_sure_want_to_delete_this_delivery_man'.tr,
                          onYesPressed: () => Get.find<DeliveryManController>().deleteDeliveryMan(deliveryMan.id),
                        ));
                      },
                      icon: const Icon(Icons.delete_forever, color: Colors.red),
                    ),

                  ]),

                  Padding(
                    padding: const EdgeInsets.only(left: 60),
                    child: Divider(
                      color: index == dmController.deliveryManList!.length-1 ? Colors.transparent : Theme.of(context).disabledColor,
                    ),
                  ),

                ]),
              );
            },
          ) : Center(child: Text('no_delivery_man_found'.tr)) : const Center(child: CircularProgressIndicator());
        }) : Center(child: Text('you_have_no_permission_to_access_this_feature'.tr, style: robotoMedium)),
      );
    });
  }
}
