import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/common/widgets/custom_app_bar_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:sixam_mart_store/features/chat/widgets/search_field_widget.dart';
import 'package:sixam_mart_store/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart_store/features/review/widgets/customer_review_screen_shimmer.dart';
import 'package:sixam_mart_store/features/review/widgets/review_card_widget.dart';
import 'package:sixam_mart_store/features/store/controllers/store_controller.dart';
import 'package:sixam_mart_store/features/store/domain/models/review_model.dart';
import 'package:sixam_mart_store/util/dimensions.dart';

class CustomerReviewScreen extends StatefulWidget {
  const CustomerReviewScreen({super.key});

  @override
  State<CustomerReviewScreen> createState() => _CustomerReviewScreenState();
}

class _CustomerReviewScreenState extends State<CustomerReviewScreen> {

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Get.find<StoreController>().getStoreReviewList(Get.find<ProfileController>().profileModel!.stores![0].id, '', willUpdate: false);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: CustomAppBarWidget(title: 'customer_reviews'.tr),
      body: GetBuilder<StoreController>(builder: (storeController) {

        List<ReviewModel>? searchReviewList;
        if(storeController.isSearching) {
          searchReviewList = storeController.searchReviewList;
        } else {
          searchReviewList = storeController.storeReviewList;
        }

        return Column(children: [
          Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            child: SizedBox(
              height: 50,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: SearchFieldWidget(
                  fromReview: true,
                  controller: _searchController,
                  hint: '${'search_by_order_id_item_or_customer'.tr}...',
                  suffixIcon: storeController.isSearching ? CupertinoIcons.clear_thick : CupertinoIcons.search,
                  iconPressed: () {
                    if (!storeController.isSearching) {
                      if (_searchController.text.trim().isNotEmpty) {
                        storeController.getStoreReviewList(Get.find<ProfileController>().profileModel!.stores![0].id, _searchController.text.trim());
                      } else {
                        showCustomSnackBar('write_order_id_food_name_for_search'.tr);
                      }
                    } else {
                      _searchController.clear();
                      storeController.getStoreReviewList(Get.find<ProfileController>().profileModel!.stores![0].id, "");
                    }
                  },
                  onSubmit: (String text) {
                    if (_searchController.text.trim().isNotEmpty) {
                      storeController.getStoreReviewList(
                          Get.find<ProfileController>().profileModel!.stores![0].id, _searchController.text.trim());
                    } else {
                      showCustomSnackBar('write_order_id_food_name_for_search'.tr);
                    }
                  },
                ),

              ),
            ),
          ),

          Expanded(
            child: searchReviewList != null ? searchReviewList.isNotEmpty ? ListView.builder(
              itemCount: searchReviewList.length,
              shrinkWrap: true,
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
                  child: ReviewCardWidget(review: searchReviewList![index]),
                );
              },
            ) : Padding(padding: EdgeInsets.only(top: context.height * 0.35), child: Text('no_review_found'.tr)) : const CustomerReviewScreenShimmer(),
          ),
        ]);
      }),
    );
  }
}
