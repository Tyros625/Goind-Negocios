import 'package:sixam_mart_store/features/store/controllers/store_controller.dart';
import 'package:sixam_mart_store/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart_store/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart_store/common/models/config_model.dart';
import 'package:sixam_mart_store/features/store/domain/models/item_model.dart';
import 'package:sixam_mart_store/features/store/widgets/update_stock_bottom_sheet.dart';
import 'package:sixam_mart_store/features/store/widgets/variation_view_widget.dart';
import 'package:sixam_mart_store/helper/date_converter_helper.dart';
import 'package:sixam_mart_store/helper/price_converter_helper.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/common/widgets/custom_app_bar_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_button_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_image_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:sixam_mart_store/features/store/widgets/review_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';

class ItemDetailsScreen extends StatefulWidget {
  final Item product;
  const ItemDetailsScreen({super.key, required this.product});

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  Item item = Item();

  @override
  void initState() {
    super.initState();

    item = widget.product;
  }

  @override
  Widget build(BuildContext context) {
    BoxShadow boxShadow = BoxShadow(color: Theme.of(context).disabledColor.withValues(alpha: 0.3), blurRadius: 10);
    double cardRadius = Dimensions.radiusDefault;
    bool isGrocery = Get.find<ProfileController>().profileModel!.stores![0].module!.moduleType == 'grocery';
    final isPharmacy = Get.find<ProfileController>().profileModel!.stores![0].module!.moduleType == 'pharmacy';
    final isFood = Get.find<SplashController>().getStoreModuleConfig().newVariation!;

    Get.find<StoreController>().setAvailability(item.status == 1);
    Get.find<StoreController>().setRecommended(item.recommendedStatus == 1);
    if(isGrocery){
      Get.find<StoreController>().setOrganic(item.organicStatus == 1);
    }
    if(Get.find<ProfileController>().profileModel!.stores![0].reviewsSection!) {
      Get.find<StoreController>().getItemReviewList(item.id);
    }
    Module? module = Get.find<SplashController>().configModel!.moduleConfig!.module;

    return Scaffold(

      appBar: CustomAppBarWidget(title: 'item_details'.tr),

      body: SafeArea(
        child: GetBuilder<StoreController>(builder: (storeController) {
          return Column(children: [

            Expanded(child: SingleChildScrollView(
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              physics: const BouncingScrollPhysics(),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(cardRadius),
                    color: Theme.of(context).cardColor,
                    boxShadow: [boxShadow],
                  ),
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: Column(children: [
                    Row(children: [

                      InkWell(
                        onTap: () => Get.toNamed(RouteHelper.getItemImagesRoute(item)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(cardRadius),
                          child: CustomImageWidget(
                            image: '${item.imageFullUrl}',
                            height: 70, width: 80, fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeSmall),

                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                        Text(
                          item.name!, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                        ),

                        module != null && module.stock != null ? Row(children: [

                          Text('${'total_stock'.tr}:', style: robotoRegular),
                          const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                          Text(
                            item.stock.toString(),
                            style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                          ),

                        ]) : const SizedBox(),
                        // SizedBox(height: module.stock! ? Dimensions.paddingSizeLarge : 0),

                        Text(
                          '${'price'.tr}: ${item.price}', maxLines: 1, overflow: TextOverflow.ellipsis,
                          style: robotoRegular,
                        ),

                        Row(children: [

                          Expanded(child: Text(
                            '${'discount'.tr}: ${item.discount} ${item.discountType == 'percent' ? '%'
                                : Get.find<SplashController>().configModel!.currencySymbol}',
                            maxLines: 1, overflow: TextOverflow.ellipsis,
                            style: robotoRegular,
                          )),

                          (module!.unit! || Get.find<SplashController>().configModel!.toggleVegNonVeg!) ? Container(
                            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall, horizontal: Dimensions.paddingSizeSmall),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(cardRadius),
                              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                            ),
                            child: Text(
                              module.unit! ? item.unitType??'' : item.veg == 0 ? 'non_veg'.tr : 'veg'.tr,
                              style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).primaryColor),
                            ),
                          ) : const SizedBox(),

                        ]),

                      ])),

                    ]),

                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    module.itemAvailableTime! ? Row(children: [

                      Text('daily_time'.tr, style: robotoRegular.copyWith(color: Theme.of(context).disabledColor)),
                      const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                      Expanded(child: Text(
                        '${DateConverterHelper.convertStringTimeToTime(item.availableTimeStarts!)}'
                            ' - ${DateConverterHelper.convertStringTimeToTime(item.availableTimeEnds!)}',
                        maxLines: 1,
                        style: robotoMedium.copyWith(color: Theme.of(context).primaryColor),
                      )),

                    ]) : const SizedBox(),

                    Row(children: [

                      Icon(Icons.star, color: Theme.of(context).primaryColor, size: 20),

                      Text(item.avgRating!.toStringAsFixed(1), style: robotoRegular),
                      const SizedBox(width: Dimensions.paddingSizeSmall),

                      Expanded(child: Text(
                        '${item.ratingCount} ${'ratings'.tr}',
                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                      )),

                    ]),

                  ]),
                ),
                const SizedBox(height: Dimensions.paddingSizeLarge),

                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(cardRadius),
                    color: Theme.of(context).cardColor,
                    boxShadow: [boxShadow],
                  ),
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: Row(children: [

                    Expanded(
                      child: Text(
                        'available'.tr,
                        style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                      ),
                    ),

                    FlutterSwitch(
                      width: 60, height: 30, valueFontSize: Dimensions.fontSizeExtraSmall, showOnOff: true,
                      activeColor: Theme.of(context).primaryColor,
                      value: storeController.isAvailable,
                      onToggle: (bool isActive) {
                        storeController.toggleAvailable(item.id);
                       },
                    ),

                  ]),
                ),
                const SizedBox(height: Dimensions.paddingSizeLarge),

                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(cardRadius),
                    color: Theme.of(context).cardColor,
                    boxShadow: [boxShadow],
                  ),
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: Row(children: [

                    Expanded(
                      child: Text(
                        'recommended'.tr,
                        style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                      ),
                    ),

                    FlutterSwitch(
                      width: 60, height: 30, valueFontSize: Dimensions.fontSizeExtraSmall, showOnOff: true,
                      activeColor: Theme.of(context).primaryColor,
                      value: storeController.isRecommended, onToggle: (bool isActive) {
                      storeController.toggleRecommendedProduct(item.id);
                      },
                    ),

                  ]),
                ),
                const SizedBox(height: Dimensions.paddingSizeLarge),

                isGrocery ? Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(cardRadius),
                    color: Theme.of(context).cardColor,
                    boxShadow: [boxShadow],
                  ),
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: Row(children: [

                    Expanded(
                      child: Text(
                        'organic'.tr,
                        style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                      ),
                    ),

                    FlutterSwitch(
                      width: 60, height: 30, valueFontSize: Dimensions.fontSizeExtraSmall, showOnOff: true,
                      activeColor: Theme.of(context).primaryColor,
                      value: storeController.isOrganic, onToggle: (bool isActive) {
                      storeController.toggleOrganicProduct(item.id);
                      },
                    ),

                  ]),
                ) : const SizedBox(),
                SizedBox(height: isGrocery ? Dimensions.paddingSizeLarge : 0),

                Get.find<SplashController>().getStoreModuleConfig().newVariation! ? FoodVariationView(item: item)
                    : VariationView(item: item, stock: module.stock),

                (isFood || isGrocery) && item.nutrition!.isNotEmpty ? Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(cardRadius),
                    color: Theme.of(context).cardColor,
                    boxShadow: [boxShadow],
                  ),
                  width: double.infinity,
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                    Text('nutrition'.tr, style: robotoMedium),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    Text(
                      item.nutrition!.join(', '),
                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                    ),

                  ]),
                ) : const SizedBox(),

                (isFood || isGrocery) && item.allergies!.isNotEmpty ? Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(cardRadius),
                    color: Theme.of(context).cardColor,
                    boxShadow: [boxShadow],
                  ),
                  width: double.infinity,
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                    Text('allergic_ingredients'.tr, style: robotoMedium),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    Text(
                      item.allergies!.join(', '),
                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                    ),

                  ]),
                ) : const SizedBox(),

                isPharmacy && item.genericName!.isNotEmpty ? Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(cardRadius),
                    color: Theme.of(context).cardColor,
                    boxShadow: [boxShadow],
                  ),
                  width: double.infinity,
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                    Text('generic_name'.tr, style: robotoMedium),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    Text(
                      item.genericName!.join(', '),
                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                    ),

                  ]),
                ) : const SizedBox(),

                (item.addOns!.isNotEmpty && module.addOn!) ? Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(cardRadius),
                    color: Theme.of(context).cardColor,
                    boxShadow: [boxShadow],
                  ),
                  width: double.infinity,
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('addons'.tr, style: robotoMedium),
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                      ListView.builder(
                        itemCount: item.addOns!.length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Row(children: [

                            Text('${item.addOns![index].name!}:', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                            const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                            Text(
                              PriceConverterHelper.convertPrice(item.addOns![index].price),
                              style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                            ),

                          ]);
                        },
                      ),
                    ],
                  ),
                ) : const SizedBox(),
                SizedBox(height: item.addOns!.isNotEmpty ? Dimensions.paddingSizeDefault : 0),

                (item.description != null && item.description!.isNotEmpty) ? Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(cardRadius),
                    color: Theme.of(context).cardColor,
                    boxShadow: [boxShadow],
                  ),
                  width: double.infinity,
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('description'.tr, style: robotoMedium),
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                      Text(item.description ?? '', style: robotoRegular),
                    ],
                  ),
                ) : const SizedBox(),
                SizedBox(height: (item.description != null && item.description!.isNotEmpty) ? Dimensions.paddingSizeDefault : 0),

                (item.taxData != null && item.taxData!.isNotEmpty) ? Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(cardRadius),
                    color: Theme.of(context).cardColor,
                    boxShadow: [boxShadow],
                  ),
                  width: double.infinity,
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('vat_tax'.tr, style: robotoMedium),
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                      ListView.builder(
                        itemCount: item.taxData!.length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Row(children: [

                            Text('${item.taxData?[index].name}:', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                            const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                            Text(
                              '(${item.taxData![index].taxRate} %)',
                              style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                            ),

                          ]);
                        },
                      ),
                    ],
                  ),
                ) : const SizedBox(),
                SizedBox(height: item.taxData != null && item.taxData!.isNotEmpty ? Dimensions.paddingSizeDefault : 0),

                Get.find<ProfileController>().profileModel!.stores![0].reviewsSection! ? Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(cardRadius),
                    color: Theme.of(context).cardColor,
                    boxShadow: [boxShadow],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        child: Text('reviews'.tr, style: robotoMedium),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeSmall),

                      storeController.itemReviewList != null ? storeController.itemReviewList!.isNotEmpty ? SizedBox(
                        height: 150,
                        child: ListView.builder(
                          itemCount: storeController.itemReviewList!.length,
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault, bottom: Dimensions.paddingSizeDefault, top: Dimensions.paddingSizeSmall),
                          itemBuilder: (context, index) {
                            return ReviewWidget(
                              review: storeController.itemReviewList![index], fromStore: false,
                              hasDivider: index != storeController.itemReviewList!.length-1,
                            );
                          },
                        ),
                      ) : Padding(
                        padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall, bottom: Dimensions.paddingSizeExtremeLarge),
                        child: Center(child: Text('no_review_found'.tr, style: robotoRegular.copyWith(color: Theme.of(context).disabledColor))),
                      ) : const Padding(
                        padding: EdgeInsets.only(top: Dimensions.paddingSizeSmall, bottom: Dimensions.paddingSizeExtremeLarge),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    ],
                  ),
                ) : const SizedBox(),

              ]),
            )),

            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: [boxShadow],
              ),
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              child: Row(children: [

                !Get.find<SplashController>().getStoreModuleConfig().newVariation! ? Expanded(
                  child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      border: Border.all(color: Theme.of(context).primaryColor),
                    ),
                    child: CustomButtonWidget(
                      transparent: true,
                      onPressed: () {
                        Get.bottomSheet(
                          UpdateStockBottomSheet(item: item, onSuccess: (bool isSuccess){
                            if(isSuccess) {
                              Get.back();
                            }
                          }),
                          backgroundColor: Colors.transparent, isScrollControlled: true,
                        );
                      },
                      buttonText: 'update_stock'.tr,
                    ),
                  ),
                ) : const SizedBox(),
                SizedBox(width: Get.find<SplashController>().getStoreModuleConfig().newVariation! ? 0 : Dimensions.paddingSizeDefault),

                Expanded(
                  child: CustomButtonWidget(
                    onPressed: () {
                      if(Get.find<ProfileController>().profileModel!.stores![0].itemSection!) {
                        Get.toNamed(RouteHelper.getAddItemRoute(item));
                      }else {
                        showCustomSnackBar('this_feature_is_blocked_by_admin'.tr);
                      }
                    },
                    radius: Dimensions.radiusDefault,
                    buttonText: 'update_item'.tr,
                  ),
                ),
              ]),
            ),

          ]);
        }),
      ),
    );
  }
}

class FoodVariationView extends StatelessWidget {
  final Item item;
  const FoodVariationView({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return (item.foodVariations != null && item.foodVariations!.isNotEmpty) ? Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        color: Theme.of(context).cardColor,
        boxShadow: [BoxShadow(color: Theme.of(context).disabledColor.withValues(alpha: 0.3), blurRadius: 10)],
      ),
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        Text('variations'.tr, style: robotoMedium),
        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

        ListView.builder(
          itemCount: item.foodVariations!.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                Row(children: [
                  Text('${item.foodVariations![index].name!} - ', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault)),
                  Text(
                    ' ${item.foodVariations![index].type == 'multi' ? 'multiple_select'.tr : 'single_select'.tr}'
                      ' (${item.foodVariations![index].required == 'on' ? 'required'.tr : 'optional'.tr})',
                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                  ),
                ]),

                const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                ListView.builder(
                  itemCount: item.foodVariations![index].variationValues!.length,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(left: 20),
                  shrinkWrap: true,
                  itemBuilder: (context, i){
                    return Text(
                      '${item.foodVariations![index].variationValues![i].level}'
                          ' - ${PriceConverterHelper.convertPrice(double.parse(item.foodVariations![index].variationValues![i].optionPrice!))}',
                      style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall),
                    );
                  },
                ),

              ]),
            );
          },
        ),

      ]),
    ) : const SizedBox();
  }
}
