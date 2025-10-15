import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/common/widgets/custom_app_bar_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_asset_image_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_image_widget.dart';
import 'package:sixam_mart_store/common/widgets/discount_tag_widget.dart';
import 'package:sixam_mart_store/common/widgets/not_available_widget.dart';
import 'package:sixam_mart_store/common/widgets/rating_bar_widget.dart';
import 'package:sixam_mart_store/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart_store/features/store/controllers/store_controller.dart';
import 'package:sixam_mart_store/features/store/domain/models/item_model.dart';
import 'package:sixam_mart_store/features/store/widgets/update_stock_bottom_sheet.dart';
import 'package:sixam_mart_store/helper/date_converter_helper.dart';
import 'package:sixam_mart_store/helper/price_converter_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';

class LowStockScreen extends StatefulWidget {
  const LowStockScreen({super.key});

  @override
  State<LowStockScreen> createState() => _LowStockScreenState();
}

class _LowStockScreenState extends State<LowStockScreen> {
  final ScrollController scrollController = ScrollController();
  @override
  void initState() {
    super.initState();

    Get.find<StoreController>().setOffset(1);

    Get.find<StoreController>().getLimitedStockItemList(Get.find<StoreController>().offset.toString(), willUpdate: false);
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent
          && Get.find<StoreController>().itemList != null
          && !Get.find<StoreController>().isLoading) {
        int pageSize = (Get.find<StoreController>().pageSize! / 10).ceil();
        if (Get.find<StoreController>().offset < pageSize) {
          Get.find<StoreController>().setOffset(Get.find<StoreController>().offset+1);
          debugPrint('end of the page');
          Get.find<StoreController>().showBottomLoader();
          Get.find<StoreController>().getLimitedStockItemList(
            Get.find<StoreController>().offset.toString()
          );
        }
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'low_stock_products'.tr),
      body: RefreshIndicator(
        onRefresh: () => Get.find<StoreController>().getLimitedStockItemList('1', willUpdate: false),
        child: GetBuilder<StoreController>(builder: (storeController) {
          return Column(children: [
            Expanded(
              child: storeController.stockItemList != null ? storeController.stockItemList!.isNotEmpty ? ListView.builder(
                controller: scrollController,
                itemCount: storeController.stockItemList!.length,
                shrinkWrap: true,
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                  child: itemCard(storeController.stockItemList![index]),
                );
              }) : Center(
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  CustomAssetImageWidget(
                    Images.pendingItemIcon,
                    height: 100, width: 100,
                    color: Theme.of(context).disabledColor,
                  ),
                  Text('no_item_found'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
                ]),
              ): const Center(child: CircularProgressIndicator()),
            ),

            storeController.isLoading ? Center(child: Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
            )) : const SizedBox(),
          ]);
        }),
      ),
    );
  }

  Widget itemCard(Item item) {
    double? discount;
    String? discountType;
    bool isAvailable;
    discount = (item.storeDiscount == 0) ? item.discount : item.storeDiscount;
    discountType = (item.storeDiscount == 0) ? item.discountType : 'percent';
    isAvailable = DateConverterHelper.isAvailable(item.availableTimeStarts, item.availableTimeEnds);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        color: Theme.of(context).cardColor,
        boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 5)],
      ),
      child: InkWell(
        onTap: (){
          Get.bottomSheet(
            UpdateStockBottomSheet(item: item, onSuccess: (bool isSuccess){}),
            backgroundColor: Colors.transparent, isScrollControlled: true,
          );
        },
        child: Row(children: [

          item.imageFullUrl != null ? Stack(children: [
            Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                child: CustomImageWidget(
                  image: '${item.imageFullUrl}',
                  height: 100, width: 100, fit: BoxFit.cover,
                ),
              ),
            ),
            DiscountTagWidget(
              discount: discount, discountType: discountType,
              freeDelivery: false,
            ),
            isAvailable ? const SizedBox() : const NotAvailableWidget(isStore: false),
          ]) : const SizedBox(),
          const SizedBox(width: Dimensions.paddingSizeSmall),

          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [

              Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
                Text(
                  item.name ?? '', textAlign: TextAlign.start,
                  style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                ),
                SizedBox(width: item.imageFullUrl == null ? Dimensions.paddingSizeExtraSmall : 0),

                item.imageFullUrl == null ? Text(
                  '(${discount! > 0 ? '$discount${discountType == 'percent' ? '%' : Get.find<SplashController>().configModel!.currencySymbol} ${'off'.tr}' : 'free_delivery'.tr})',
                  style: robotoMedium.copyWith(color: Colors.green, fontSize: Dimensions.fontSizeExtraSmall),
                ) : const SizedBox(),
              ]),
              SizedBox(height: item.imageFullUrl != null ? Dimensions.paddingSizeExtraSmall : 0),

              Row(children: [
                RatingBarWidget(
                  rating: item.avgRating, size: 12,
                  ratingCount: item.ratingCount,
                ),

                item.imageFullUrl == null && !isAvailable ? Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Text(
                    '(${'not_available_now'.tr})', textAlign: TextAlign.center,
                    style: robotoRegular.copyWith(color: Colors.red, fontSize: Dimensions.fontSizeExtraSmall),
                  ),
                ) : const SizedBox(),
              ]),
              const SizedBox(height: 2),

              Row(children: [

                Text(
                  PriceConverterHelper.convertPrice(item.price, discount: discount, discountType: discountType),
                  style: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall),
                ),
                SizedBox(width: discount! > 0 ? Dimensions.paddingSizeExtraSmall : 0),

                discount > 0 ? Text(
                  PriceConverterHelper.convertPrice(item.price),
                  style: robotoBold.copyWith(
                    fontSize: Dimensions.fontSizeExtraSmall,
                    color: Theme.of(context).disabledColor,
                    decoration: TextDecoration.lineThrough,
                  ),
                ) : const SizedBox(),

              ]),

            ]),
          ),



          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('${'stock'.tr}: ${item.stock}', style: robotoMedium.copyWith(color: Theme.of(context).primaryColor),),

              IconButton(
                onPressed: () {
                  Get.bottomSheet(
                    UpdateStockBottomSheet(item: item, onSuccess: (bool isSuccess){}),
                    backgroundColor: Colors.transparent, isScrollControlled: true,
                  );
                },
                icon: const Icon(Icons.add_circle, color: Colors.indigo),
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}
