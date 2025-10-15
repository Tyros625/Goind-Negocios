import 'package:sixam_mart_store/common/widgets/custom_asset_image_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_card.dart';
import 'package:sixam_mart_store/features/addon/controllers/addon_controller.dart';
import 'package:sixam_mart_store/features/addon/widgets/addon_delete_dialog.dart';
import 'package:sixam_mart_store/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart_store/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart_store/features/store/controllers/store_controller.dart';
import 'package:sixam_mart_store/helper/price_converter_helper.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/common/widgets/custom_app_bar_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddonScreen extends StatefulWidget {
  const AddonScreen({super.key});

  @override
  State<AddonScreen> createState() => _AddonScreenState();
}

class _AddonScreenState extends State<AddonScreen> {

  @override
  void initState() {
    super.initState();
    Get.find<AddonController>().getAddonList();
    Get.find<AddonController>().getAddonCategoryList();

    if(Get.find<SplashController>().configModel!.systemTaxType == 'product_wise'){
      Get.find<StoreController>().getVatTaxList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: CustomAppBarWidget(title: 'addons'.tr),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if(Get.find<ProfileController>().profileModel!.stores![0].itemSection!) {
            Get.toNamed(RouteHelper.getAddAddonRoute(null));
          }else {
            showCustomSnackBar('this_feature_is_blocked_by_admin'.tr);
          }
        },
        child: Icon(Icons.add, size: 30, color: Theme.of(context).cardColor),
      ),

      body: GetBuilder<AddonController>(builder: (addonController) {
        return addonController.addonList != null ? addonController.addonList!.isNotEmpty ? RefreshIndicator(
          onRefresh: () async {
            await addonController.getAddonList();
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            itemCount: addonController.addonList!.length,
            itemBuilder: (context, index) {
              return CustomCard(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                child: Row(children: [

                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(
                        addonController.addonList?[index].name ?? '',
                        maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: robotoRegular,
                      ),

                      Text(
                        addonController.addonList![index].price! > 0 ? PriceConverterHelper.convertPrice(addonController.addonList![index].price) : 'free'.tr,
                        maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.6)),
                      ),
                    ]),
                  ),

                  PopupMenuButton(
                    itemBuilder: (context) {
                      return <PopupMenuEntry>[
                        PopupMenuItem(
                          value: 'edit',
                          child: Column(
                            children: [
                              ListTile(
                                title: Text('edit'.tr, style: robotoRegular),
                                trailing: const CustomAssetImageWidget(Images.editIcon, height: 20, width: 20),
                                contentPadding: EdgeInsets.zero,
                              ),
                              const Divider(height: 1),
                            ],
                          ),
                        ),

                        PopupMenuItem(
                          value: 'delete',
                          child: ListTile(
                            title: Text('delete'.tr, style: robotoRegular),
                            trailing: const CustomAssetImageWidget(Images.deleteIcon, height: 20, width: 20),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ];
                    },
                    borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                    menuPadding: const EdgeInsets.all(0),
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault - 2),
                      ),
                      child: Icon(Icons.more_vert, size: 25, color: Theme.of(context).primaryColor),
                    ),
                    onSelected: (dynamic value) {
                      if(Get.find<ProfileController>().profileModel!.stores![0].itemSection!) {
                        if (value == 'edit') {
                          Get.toNamed(RouteHelper.getAddAddonRoute(addonController.addonList![index]));
                        } else {
                          Get.dialog(AddonDeleteDialog(addonID: addonController.addonList![index].id!), barrierDismissible: false);
                        }
                      }else {
                        showCustomSnackBar('this_feature_is_blocked_by_admin'.tr);
                      }
                    },
                  ),

                ]),
              );
            },
          ),
        ) : Center(child: Text('no_addon_found'.tr)) : const Center(child: CircularProgressIndicator());
      }),
    );
  }
}
