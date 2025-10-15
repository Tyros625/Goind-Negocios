import 'package:flutter/rendering.dart';
import 'package:sixam_mart_store/features/store/controllers/store_controller.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/common/widgets/item_shimmer_widget.dart';
import 'package:sixam_mart_store/common/widgets/item_widget.dart';
import 'package:sixam_mart_store/features/store/widgets/veg_filter_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemViewWidget extends StatelessWidget {
  final ScrollController scrollController;
  final String? type;
  final Function(String type)? onVegFilterTap;
  final bool fromAllItems;
  final String? search;
  const ItemViewWidget({super.key, required this.scrollController, this.type, this.onVegFilterTap, this.fromAllItems = false, this.search});

  @override
  Widget build(BuildContext context) {
    Get.find<StoreController>().setOffset(1);
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent
          && Get.find<StoreController>().itemList != null
          && !Get.find<StoreController>().isLoading) {
        int pageSize = (Get.find<StoreController>().itemSize! / 10).ceil();
        if (Get.find<StoreController>().offset < pageSize) {
          Get.find<StoreController>().setOffset(Get.find<StoreController>().offset+1);
          debugPrint('end of the page');
          Get.find<StoreController>().showBottomLoader();
          Get.find<StoreController>().getItemList(
            offset: Get.find<StoreController>().offset.toString(), type: Get.find<StoreController>().type,
            search: search ?? '', categoryId: Get.find<StoreController>().categoryId,
          );
        }
      }

      if (scrollController.position.userScrollDirection == ScrollDirection.reverse) {
        if(Get.find<StoreController>().isFabVisible){
          Get.find<StoreController>().hideFab();
        }
      } else if (scrollController.position.userScrollDirection == ScrollDirection.forward) {
        if(!Get.find<StoreController>().isFabVisible){
          Get.find<StoreController>().showFab();
        }
      }

    });
    return GetBuilder<StoreController>(builder: (storeController) {
      return Column(children: [
        const SizedBox(height: Dimensions.paddingSizeDefault),

        !fromAllItems ? type != null ? VegFilterWidget(type: type, onSelected: onVegFilterTap) : const SizedBox() : const SizedBox(),

        storeController.itemList != null ? storeController.itemList!.isNotEmpty ? GridView.builder(
          key: UniqueKey(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: Dimensions.paddingSizeLarge,
            mainAxisSpacing: 0.01,
            crossAxisCount: 1,
            mainAxisExtent: 120,
          ),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: storeController.itemList!.length,
          padding: EdgeInsets.all(fromAllItems ? 0 : Dimensions.paddingSizeSmall),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
              child: ItemWidget(
                item: storeController.itemList![index],
                index: index, length: storeController.itemList!.length, isCampaign: false,
                inStore: true,
              ),
            );
          },
        ) : Padding(
          padding: const EdgeInsets.only(top: 200),
          child: Center(child: Text('no_item_available'.tr)),
        ) : GridView.builder(
          key: UniqueKey(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: Dimensions.paddingSizeLarge,
            mainAxisSpacing: 0.01,
            crossAxisCount: 1,
            mainAxisExtent: 120,
          ),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: 20,
          padding: EdgeInsets.all(fromAllItems ? 0 : Dimensions.paddingSizeSmall),
          itemBuilder: (context, index) {
            return ItemShimmerWidget(
              isEnabled: storeController.itemList == null, hasDivider: index != 19,
            );
          },
        ),

        storeController.isLoading ? Center(child: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
        )) : const SizedBox(),

      ]);
    });
  }
}
