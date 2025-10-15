import 'package:flutter/cupertino.dart';
import 'package:sixam_mart_store/common/widgets/custom_app_bar_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_bottom_sheet_widget.dart';
import 'package:sixam_mart_store/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart_store/features/store/controllers/store_controller.dart';
import 'package:sixam_mart_store/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart_store/features/profile/domain/models/profile_model.dart';
import 'package:sixam_mart_store/features/store/widgets/filter_data_bottom_sheet.dart';
import 'package:sixam_mart_store/helper/date_converter_helper.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:sixam_mart_store/features/store/widgets/item_view_widget.dart';
import 'package:sixam_mart_store/features/chat/widgets/search_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllItemsScreen extends StatefulWidget {
  const AllItemsScreen({super.key});

  @override
  State<AllItemsScreen> createState() => _AllItemsScreenState();
}

class _AllItemsScreenState extends State<AllItemsScreen> {

  final ScrollController _scrollController = ScrollController();
  final ScrollController _categoryScrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Get.find<ProfileController>().getProfile();
    Get.find<StoreController>().getItemList(offset: '1', type: 'all', search: '', categoryId: 0, willUpdate: false);
    Get.find<StoreController>().getStoreCategories(isUpdate: false);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StoreController>(builder: (storeController) {
      return GetBuilder<ProfileController>(builder: (profileController) {
        Store? store = profileController.profileModel != null ? profileController.profileModel!.stores![0] : null;
        bool isShowingTrialContent = profileController.profileModel != null && profileController.profileModel!.subscription != null
            && profileController.profileModel!.subscription!.isTrial == 1
            && DateConverterHelper.differenceInDaysIgnoringTime(DateTime.parse(profileController.profileModel!.subscription!.expiryDate!), null) > 0;

        return Scaffold(
          appBar: CustomAppBarWidget(title: 'all_items'.tr),

          floatingActionButton: GetBuilder<StoreController>(builder: (storeController) {
            return storeController.isFabVisible && Get.find<ProfileController>().modulePermission!.item! ? Padding(
              padding: EdgeInsets.only(bottom: isShowingTrialContent ? 100 : 0),
              child: FloatingActionButton(
                heroTag: 'nothing',
                onPressed: () {
                  if(Get.find<ProfileController>().profileModel!.stores![0].itemSection!) {
                    if (store != null) {
                      Get.toNamed(RouteHelper.getAddItemRoute(null));
                    }
                  }else {
                    showCustomSnackBar('this_feature_is_blocked_by_admin'.tr);
                  }
                },
                backgroundColor: Theme.of(context).primaryColor,
                child: Icon(Icons.add, color: Theme.of(context).cardColor, size: 30),
              ),
            ) : const SizedBox();
          }),

          body: store != null ? SingleChildScrollView(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            controller: _scrollController,
            child: Column(children: [

              storeController.categoryNameList != null ? SizedBox(
                height: 40,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                   border: Border.all(color: Theme.of(context).disabledColor.withValues(alpha: 0.3)),
                  ),
                  child: ListView.builder(
                    controller: _categoryScrollController,
                    scrollDirection: Axis.horizontal,
                    itemCount: storeController.categoryNameList!.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () => storeController.setCategory(index: index, foodType: 'all'),
                        child: Row(children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeExtraSmall),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.radiusSmall + 2),
                              color: index == storeController.categoryIndex ? Theme.of(context).primaryColor : Colors.transparent,
                            ),
                            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                              Text(
                                index == 0 ? 'all'.tr : storeController.categoryNameList![index],
                                style: robotoRegular.copyWith(
                                  fontSize: Dimensions.fontSizeSmall,
                                  color: index == storeController.categoryIndex ? Theme.of(context).cardColor : Theme.of(context).disabledColor,
                                  fontWeight: index == storeController.categoryIndex ? FontWeight.w700 : FontWeight.w400,
                                ),
                              ),
                            ]),
                          ),

                          index == storeController.categoryNameList!.length - 1 ? const SizedBox() : Container(
                            height: 20, width: 1,
                            color: Theme.of(context).disabledColor.withValues(alpha: 0.3),
                          ),
                        ]),
                      );
                    },
                  ),
                ),
              ) : SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                      margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall + 2),
                        color: Theme.of(context).hintColor.withValues(alpha: 0.2),
                      ),
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Container(
                          height: 10, width: 50,
                          decoration: BoxDecoration(
                            color: Theme.of(context).hintColor.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                          ),
                        ),
                      ]),
                    );
                  },
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),

              Row(children: [

                Text('${'item_found'.tr} ${'(${storeController.itemSize ?? 0})'}', style: robotoMedium),
                const Spacer(),

                InkWell(
                  onTap: () {
                    storeController.setSearchVisibility();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall - 2),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    ),
                    child: Icon(storeController.isSearchVisible ? Icons.close : CupertinoIcons.search, color: Theme.of(context).primaryColor, size: 18),
                  ),
                ),
                SizedBox(width: (Get.find<SplashController>().configModel!.toggleVegNonVeg! && Get.find<SplashController>().configModel!.moduleConfig!.module!.vegNonVeg!) ? Dimensions.paddingSizeSmall : 0),

                (Get.find<SplashController>().configModel!.toggleVegNonVeg! && Get.find<SplashController>().configModel!.moduleConfig!.module!.vegNonVeg!) ? InkWell(
                  onTap: () {
                    showCustomBottomSheet(child: const FilterDataBottomSheet());
                  },
                  child: Container(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      border: Border.all(color: Theme.of(context).primaryColor),
                    ),
                    child: Icon(Icons.filter_list, color: Theme.of(context).primaryColor, size: 18),
                  ),
                ) : const SizedBox(),

              ]),
              SizedBox(height: storeController.isSearchVisible ? Dimensions.paddingSizeDefault : 0),
              
              Visibility(
                visible: storeController.isSearchVisible,
                child: SizedBox(
                  height: 50,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: SearchFieldWidget(
                      fromReview: true,
                      controller: _searchController,
                      hint: '${'search_by_item_name'.tr}...',
                      suffixIcon: storeController.isSearching ? CupertinoIcons.clear_thick : CupertinoIcons.search,
                      iconPressed: () {
                        if (!storeController.isSearching) {
                          if (_searchController.text.trim().isNotEmpty) {
                            storeController.setCategoryForSearch(index: 0);
                            _categoryScrollController.animateTo(0, duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
                            storeController.getItemList(offset: '1', type: 'all', search: _searchController.text.trim(), categoryId: 0);
                          } else {
                            showCustomSnackBar('write_item_name_for_search'.tr);
                          }
                        } else {
                          _searchController.clear();
                          storeController.setCategoryForSearch(index: 0);
                          _categoryScrollController.animateTo(0, duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
                          storeController.getItemList(offset: '1', type: 'all', search: '', categoryId: 0);
                        }
                      },
                      onSubmit: (String text) {
                        if (_searchController.text.trim().isNotEmpty) {
                          storeController.setCategoryForSearch(index: 0);
                          _categoryScrollController.animateTo(0, duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
                          storeController.getItemList(offset: '1', type: 'all', search: _searchController.text.trim(), categoryId: 0);
                        } else {
                          showCustomSnackBar('write_item_name_for_search'.tr);
                        }
                      },
                    ),

                  ),
                ),
              ),

              Container(
                child: Get.find<ProfileController>().modulePermission!.item!
                  ? ItemViewWidget(scrollController: _scrollController, fromAllItems: true, type: storeController.type, search: _searchController.text) : Center(child: Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: Text('you_have_no_permission_to_access_this_feature'.tr, style: robotoMedium),
                )),
              ),

            ]),
          ) : const Center(child: CircularProgressIndicator()),
        );
      });
    });
  }
}
