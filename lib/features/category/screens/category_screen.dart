import 'package:sixam_mart_store/common/widgets/custom_card.dart';
import 'package:sixam_mart_store/features/category/controllers/category_controller.dart';
import 'package:sixam_mart_store/features/category/domain/models/category_model.dart';
import 'package:sixam_mart_store/features/category/screens/category_product_screen.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/common/widgets/custom_app_bar_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {

  @override
  void initState() {
    super.initState();
    Get.find<CategoryController>().getCategoryList(null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title:'categories'.tr),
      body: GetBuilder<CategoryController>(builder: (categoryController) {

        List<CategoryModel>? categories;
        if(categoryController.categoryList != null) {
          categories = [];
          categories.addAll(categoryController.categoryList!);
        }

        return categories != null ? categories.isNotEmpty ? RefreshIndicator(
          onRefresh: () async {
            await Get.find<CategoryController>().getCategoryList(null);
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return CustomCard(
                margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                child: InkWell(
                  onTap: () {
                    Get.to(() => CategoryProductScreen(categoryId: categories![index].id!, categoryName: categories[index].name ?? ''));
                  },
                  child: Row(children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      child: CustomImageWidget(
                        image: '${categories![index].imageFullUrl}',
                        height: 65, width: 65, fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeSmall),

                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(categories[index].name ?? '', style: robotoBold, maxLines: 1, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                      Text(
                        '${'id'.tr}: ${categories[index].id}',
                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                      ),
                    ])),

                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      ),
                      child: Text('${categories[index].productsCount} ${'items'.tr}', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor)) ,
                    ),

                  ]),
                ),
              );
            },
          ),
        ) : Center(
          child: Text('no_category_found'.tr),
        ) : const Center(child: CircularProgressIndicator());
      }),
    );
  }
}
