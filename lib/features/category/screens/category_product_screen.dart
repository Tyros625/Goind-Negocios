import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/common/widgets/custom_app_bar_widget.dart';
import 'package:sixam_mart_store/common/widgets/item_shimmer_widget.dart';
import 'package:sixam_mart_store/common/widgets/item_widget.dart';
import 'package:sixam_mart_store/features/category/controllers/category_controller.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';

class CategoryProductScreen extends StatefulWidget {
  final int categoryId;
  final String categoryName;
  const CategoryProductScreen({super.key, required this.categoryId, required this.categoryName});

  @override
  State<CategoryProductScreen> createState() => _CategoryProductScreenState();
}

class _CategoryProductScreenState extends State<CategoryProductScreen> {

  final ScrollController scrollController = ScrollController();
  
  @override
  void initState() {
    super.initState();

    Get.find<CategoryController>().getSubCategoryList(widget.categoryId, null);
    Get.find<CategoryController>().clearSelectedSubCategoryId();
    Get.find<CategoryController>().setSelectedSubCategoryIndex(0, false);
    Get.find<CategoryController>().setOffset(1);
    Get.find<CategoryController>().getCategoryItemList(offset: '1', id: widget.categoryId, willUpdate: false);

    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent
          && Get.find<CategoryController>().itemList != null
          && !Get.find<CategoryController>().isLoading) {
        int pageSize = (Get.find<CategoryController>().pageSize! / 10).ceil();
        if (Get.find<CategoryController>().offset < pageSize) {
          Get.find<CategoryController>().setOffset(Get.find<CategoryController>().offset+1);
          debugPrint('end of the page');
          Get.find<CategoryController>().showBottomLoader();
          Get.find<CategoryController>().getCategoryItemList(
            offset : Get.find<CategoryController>().offset.toString(), id:  widget.categoryId,
          );
        }
      }

    });
    
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: widget.categoryName),

      body: GetBuilder<CategoryController>(builder: (categoryController) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: Column(children: [

            categoryController.subCategoryList != null ? categoryController.subCategoryList!.isNotEmpty ? SizedBox(
              height: 40,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                ),
                child: ListView.builder(
                  controller: scrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: categoryController.subCategoryList!.length + 1,
                  itemBuilder: (context, index) {
                    final isSelected = index == categoryController.selectedSubCategoryIndex;

                    return InkWell(
                      onTap: () {
                        categoryController.setSelectedSubCategoryIndex(index, true);
                        if (index == 0) {
                          categoryController.clearSelectedSubCategoryId();
                          categoryController.getCategoryItemList(offset: '1', id: widget.categoryId, willUpdate: true);
                        } else {
                          categoryController.setSelectedSubCategoryId(
                            categoryController.subCategoryList![index - 1].id,
                          );
                        }
                      },
                      child: Row(children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.paddingSizeDefault,
                            vertical: Dimensions.paddingSizeExtraSmall,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall + 2),
                            color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).disabledColor.withValues(alpha: 0.2),
                          ),
                          child: Center(
                            child: Text(
                              index == 0 ? 'all'.tr : categoryController.subCategoryList![index - 1].name ?? '',
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeSmall,
                                color: isSelected ? Theme.of(context).cardColor : Theme.of(context).disabledColor,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                              ),
                            ),
                          ),
                        ),

                        index == categoryController.subCategoryList!.length ? const SizedBox() : Container(
                          margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                        ),
                      ]),
                    );
                  },
                ),
              ),
            ) : const SizedBox() : SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                    margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall, bottom: Dimensions.paddingSizeSmall),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall + 2),
                      color: Theme.of(context).disabledColor.withValues(alpha:0.2),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 10, width: 50,
                          decoration: BoxDecoration(
                            color: Theme.of(context).disabledColor.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: categoryController.subCategoryList != null && categoryController.subCategoryList!.isNotEmpty ? Dimensions.paddingSizeDefault : 0),

            categoryController.itemList != null ? categoryController.itemList!.isNotEmpty ? GridView.builder(
              key: UniqueKey(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: Dimensions.paddingSizeLarge,
                mainAxisSpacing: 0.01,
                crossAxisCount: 1,
                mainAxisExtent: 120,
              ),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: categoryController.itemList!.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                  child: ItemWidget(
                    item: categoryController.itemList![index],
                    index: index, length: categoryController.itemList!.length, isCampaign: false,
                    inStore: true,
                  ),
                );
              },
            ) : Padding(
              padding: const EdgeInsets.only(top: 300),
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
              itemBuilder: (context, index) {
                return ItemShimmerWidget(
                  isEnabled: categoryController.itemList == null, hasDivider: index != 19,
                );
              },
            ),

            categoryController.isLoading ? Center(child: Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
            )) : const SizedBox(),
          ]),
        );
      }),
    );
  }
}
