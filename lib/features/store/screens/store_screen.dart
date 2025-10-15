import 'package:sixam_mart_store/features/store/controllers/store_controller.dart';
import 'package:sixam_mart_store/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart_store/features/profile/domain/models/profile_model.dart';
import 'package:sixam_mart_store/helper/date_converter_helper.dart';
import 'package:sixam_mart_store/helper/price_converter_helper.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/common/widgets/custom_image_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:sixam_mart_store/features/store/widgets/item_view_widget.dart';
import 'package:sixam_mart_store/features/store/widgets/review_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  TabController? _tabController;
  final bool? _review = Get.find<ProfileController>().profileModel!.stores![0].reviewsSection;

  @override
  void initState() {
    super.initState();

    Get.find<ProfileController>().getProfile();
    _tabController = TabController(length: _review! ? 2 : 1, initialIndex: 0, vsync: this);
    _tabController!.addListener(() {
      Get.find<StoreController>().setTabIndex(_tabController!.index);
    });
    Get.find<StoreController>().getItemList(offset: '1', type: 'all', search: '', categoryId: 0, willUpdate: false);
    Get.find<StoreController>().getStoreReviewList(Get.find<ProfileController>().profileModel!.stores![0].id, '', willUpdate: false);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StoreController>(builder: (storeController) {
      return GetBuilder<ProfileController>(builder: (profileController) {
        Store? store = profileController.profileModel != null ? profileController.profileModel!.stores![0] : null;
        bool isShowingTrialContent = profileController.profileModel != null && profileController.profileModel!.subscription != null
            && profileController.profileModel!.subscription!.isTrial == 1
            && DateConverterHelper.differenceInDaysIgnoringTime(DateTime.parse(profileController.profileModel!.subscription!.expiryDate!), null) > 0;

        bool haveSubscription;
        if(profileController.profileModel!.stores![0].storeBusinessModel == 'subscription'){
          haveSubscription = profileController.profileModel!.subscription?.review == 1;
        }else{
          haveSubscription = true;
        }

        return profileController.modulePermission!.myShop! ? Scaffold(
          backgroundColor: Theme.of(context).cardColor,

          floatingActionButton: GetBuilder<StoreController>(builder: (storeController) {
            return storeController.isFabVisible && (storeController.tabIndex == 0 && Get.find<ProfileController>().modulePermission!.item!) ? Padding(
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

          body: store != null ? CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: _scrollController,
            slivers: [

              SliverAppBar(
                expandedHeight: 230, toolbarHeight: 50,
                pinned: true, floating: false,
                backgroundColor: Theme.of(context).primaryColor,
                actions: [IconButton(
                  icon: Container(
                    height: 50, width: 40, alignment: Alignment.center,
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      border: Border.all(color: Theme.of(context).cardColor.withValues(alpha: 0.7), width: 1.5),
                    ),
                    child: Icon(Icons.edit, color: Theme.of(context).cardColor, size: 20),
                  ),
                  onPressed: () {
                    if(Get.find<ProfileController>().modulePermission!.myShop!){
                      Get.toNamed(RouteHelper.getStoreEditRoute(store));
                    }else{
                      showCustomSnackBar('access_denied'.tr);
                    }
                  },
                )],
                flexibleSpace: FlexibleSpaceBar(
                  background: CustomImageWidget(
                    fit: BoxFit.cover, placeholder: Images.restaurantCover,
                    image: '${store.coverPhotoFullUrl}',
                  ),
                ),
              ),

              SliverToBoxAdapter(child: Center(child: Container(
                width: 1170,
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  boxShadow: const [BoxShadow(color:Colors.black12, spreadRadius: 1, blurRadius: 5)],
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(Dimensions.radiusLarge),
                    bottomRight: Radius.circular(Dimensions.radiusLarge),
                  ),
                ),
                child: Column(children: [
                  Row(children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      child: CustomImageWidget(
                        image: '${store.logoFullUrl}',
                        height: 70, width: 80, fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeDefault),

                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text(
                        store.name ?? '', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                        maxLines: 1, overflow: TextOverflow.ellipsis,
                      ),

                      Text(
                        store.address ?? '', maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                      ),

                      Row(children: [
                        Icon(Icons.star_rounded, color: Theme.of(context).hintColor, size: 18),
                        Text(
                          store.avgRating!.toStringAsFixed(1),
                          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                        ),
                        const SizedBox(width: Dimensions.paddingSizeSmall),
                        Text(
                          '${store.ratingCount ?? 0} ${'ratings'.tr}',
                          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor),
                        ),
                      ]),

                    ])),

                    InkWell(
                      onTap: () => Get.toNamed(RouteHelper.getAnnouncementRoute(announcementStatus: store.isAnnouncementActive!, announcementMessage: store.announcementMessage ?? '')),
                      child: Container(
                        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).primaryColor,
                          border: Border.all(color: Theme.of(context).cardColor, width: 2),
                          boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.2), spreadRadius: 1, blurRadius: 5, offset: const Offset(0, 1))],
                        ),
                        child: Image.asset(Images.announcementIcon, height: 20, width: 20, color: Theme.of(context).cardColor),
                      ),
                    ),
                  ]),
                  SizedBox(height: store.discount != null ? Dimensions.paddingSizeDefault : 0),

                  store.discount != null ? Container(
                    width: context.width,
                    margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSmall), color: Theme.of(context).primaryColor),
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    child: Text(
                      '${store.discount!.discountType == 'percent' ? '${store.discount!.discount}%'
                        : PriceConverterHelper.convertPrice(store.discount!.discount)} '
                        '${'discount_will_be_applicable_when_order_amount_exceeds_is_more_than'.tr} ${PriceConverterHelper.convertPrice(store.discount!.minPurchase)},'
                        ' ${'max'.tr}: ${PriceConverterHelper.convertPrice(store.discount!.maxDiscount)} ${'discount_is_applicable'.tr}',
                        style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center, maxLines: 3, overflow: TextOverflow.ellipsis,
                    ),
                  ) : const SizedBox(),
                  SizedBox(height: (store.delivery! && store.freeDelivery!) ? Dimensions.paddingSizeSmall : 0),

                  (store.delivery! && store.freeDelivery!) ? Text(
                    'free_delivery'.tr,
                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
                  ) : const SizedBox(),

                ]),
              ))),

              SliverPersistentHeader(
                pinned: true,
                delegate: SliverDelegate(child: Center(child: Container(
                  width: 1170,
                  decoration: BoxDecoration(color: Theme.of(context).cardColor),
                  child: TabBar(
                    controller: _tabController,
                    indicatorColor: Theme.of(context).hintColor,
                    indicatorWeight: 3,
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelColor: Theme.of(context).textTheme.bodyLarge!.color,
                    unselectedLabelColor: Theme.of(context).disabledColor,
                    unselectedLabelStyle: robotoBold.copyWith(color: Theme.of(context).disabledColor),
                    labelStyle: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
                    tabs: _review! ? [
                      Tab(text: 'all_items'.tr),
                      Tab(text: 'reviews'.tr),
                    ] : [
                      Tab(text: 'all_items'.tr),
                    ],
                  ),
                ))),
              ),

              SliverToBoxAdapter(child: AnimatedBuilder(
                animation: _tabController!.animation!,
                builder: (context, child) {
                  if (_tabController!.index == 0) {
                    return Get.find<ProfileController>().modulePermission!.item!
                        ? ItemViewWidget(scrollController: _scrollController, type: storeController.type, onVegFilterTap: (String type) {
                      Get.find<StoreController>().getItemList(offset: '1', type: type, search: '', categoryId: 0);
                    }) : Center(child: Padding(
                      padding: const EdgeInsets.only(top: 100),
                      child: Text('you_have_no_permission_to_access_this_feature'.tr, style: robotoMedium),
                    ));
                  } else {
                    return haveSubscription ? Get.find<ProfileController>().modulePermission!.reviews! ? storeController.storeReviewList != null ? storeController.storeReviewList!.isNotEmpty ? ListView.builder(
                      itemCount: storeController.storeReviewList!.length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      itemBuilder: (context, index) {
                        return ReviewWidget(
                          review: storeController.storeReviewList![index], fromStore: true,
                          hasDivider: index != storeController.storeReviewList!.length-1,
                        );
                      },
                    ) : Padding(
                      padding: const EdgeInsets.only(top: 200),
                      child: Center(child: Text('no_review_found'.tr, style: robotoRegular.copyWith(color: Theme.of(context).disabledColor))),
                    ) : const Padding(
                      padding: EdgeInsets.only(top: Dimensions.paddingSizeLarge),
                      child: Center(child: CircularProgressIndicator()),
                    ) : Center(child: Padding(
                      padding: const EdgeInsets.only(top: 100),
                      child: Text('you_have_no_permission_to_access_this_feature'.tr, style: robotoMedium),
                    )) : Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: Center(child: Text('you_have_no_available_subscription'.tr, style: robotoRegular.copyWith(color: Theme.of(context).disabledColor))),
                    );
                  }
                },
              )),
            ],
          ) : const Center(child: CircularProgressIndicator()),
        ) : Scaffold(
          body: Center(child: Text('you_have_no_permission_to_access_this_feature'.tr, style: robotoMedium)),
        );
      });
    });
  }
}

class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;

  SliverDelegate({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != 50 || oldDelegate.minExtent != 50 || child != oldDelegate.child;
  }
}