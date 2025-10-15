import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sixam_mart_store/common/models/vat_tax_model.dart';
import 'package:sixam_mart_store/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart_store/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart_store/api/api_client.dart';
import 'package:sixam_mart_store/features/store/controllers/store_controller.dart';
import 'package:sixam_mart_store/features/store/domain/models/attr.dart';
import 'package:sixam_mart_store/features/store/domain/models/attribute_model.dart';
import 'package:sixam_mart_store/features/store/domain/models/band_model.dart';
import 'package:sixam_mart_store/features/store/domain/models/item_model.dart';
import 'package:sixam_mart_store/features/profile/domain/models/profile_model.dart';
import 'package:sixam_mart_store/features/store/domain/models/pending_item_model.dart';
import 'package:sixam_mart_store/features/store/domain/models/review_model.dart';
import 'package:sixam_mart_store/features/store/domain/models/suitable_tag_model.dart';
import 'package:sixam_mart_store/features/store/domain/models/unit_model.dart';
import 'package:sixam_mart_store/util/app_constants.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/features/store/domain/repositories/store_repository_interface.dart';

class StoreRepository implements StoreRepositoryInterface {
  final ApiClient apiClient;
  StoreRepository({required this.apiClient});

  @override
  Future<ItemModel?> getItemList({required String offset, required String type, required String search, int? categoryId}) async {
    ItemModel? itemModel;
    Response response = await apiClient.getData('${AppConstants.itemListUri}?offset=$offset&limit=10&type=$type&search=$search${categoryId != null ? '&category_id=$categoryId' : 0}');
    if(response.statusCode == 200) {
      itemModel = ItemModel.fromJson(response.body);
    }
    return itemModel;
  }

  @override
  Future<ItemModel?> getStockItemList(String offset) async {
    ItemModel? itemModel;
    Response response = await apiClient.getData('${AppConstants.stockLimitItemsUri}?offset=$offset&limit=10');
    if(response.statusCode == 200) {
      itemModel = ItemModel.fromJson(response.body);
    }
    return itemModel;
  }

  @override
  Future<PendingItemModel?> getPendingItemList(String offset, String type) async {
    PendingItemModel? pendingItemModel;
    Response response = await apiClient.getData('${AppConstants.pendingItemListUri}?status=$type&offset=$offset&limit=20');
    if(response.statusCode == 200) {
      pendingItemModel = PendingItemModel.fromJson(response.body);
    }
    return pendingItemModel;
  }

  @override
  Future<Item?> getPendingItemDetails(int itemId) async {
    Item? pendingItem;
    Response response = await apiClient.getData('${AppConstants.pendingItemDetailsUri}/$itemId');
    if(response.statusCode == 200) {
      pendingItem = Item.fromJson(response.body);
    }
    return pendingItem;
  }

  @override
  Future<Item?> get(int? id) async {
    Item? item;
    Response response = await apiClient.getData('${AppConstants.itemDetailsUri}/$id');
    if(response.statusCode == 200) {
      item = Item.fromJson(response.body);
    }
    return item;
  }

  @override
  Future<List<AttributeModel>?> getAttributeList(Item? item) async {
    List<AttributeModel>? attributeList;
    Response response = await apiClient.getData(AppConstants.attributeUri);
    if(response.statusCode == 200) {
      attributeList = [];
      response.body.forEach((attribute) {
        if(item != null) {
          bool active = item.attributes!.contains(Attr.fromJson(attribute).id);
          List<String> options = [];
          if(active) {
            options.addAll(item.choiceOptions![item.attributes!.indexOf(Attr.fromJson(attribute).id)].options!);
          }
          attributeList!.add(AttributeModel(
            attribute: Attr.fromJson(attribute),
            active: item.attributes!.contains(Attr.fromJson(attribute).id),
            controller: TextEditingController(), variants: options,
          ));
        }else {
          attributeList!.add(AttributeModel(attribute: Attr.fromJson(attribute), active: false,
            controller: TextEditingController(), variants: [],
          ));
        }
      });
    }
    return attributeList;
  }

  @override
  Future<bool> updateStoreBasicInfo(Store store, XFile? logo, XFile? cover, List<Translation> translation, XFile? metaImage) async {
    Map<String, String> fields = {};
    fields.addAll(<String, String>{
      '_method': 'put',
      'translations': jsonEncode(translation),
      'contact_number': store.phone ?? '',
    });
    Response response = await apiClient.postMultipartData(AppConstants.vendorBasicInfoUpdateUri, fields, [MultipartBody('logo', logo), MultipartBody('cover_photo', cover), MultipartBody('meta_image', metaImage)]);
    return (response.statusCode == 200);
  }

  @override
  Future<bool> updateStore(Store store, String min, String max, String type) async {
    Map<String, String> fields = {};
    fields.addAll(<String, String>{
      '_method': 'put', 'schedule_order': store.scheduleOrder! ? '1' : '0',
      'minimum_order': store.minimumOrder.toString(), 'delivery': store.delivery! ? '1' : '0',
      'take_away': store.takeAway! ? '1' : '0', 'gst_status': store.gstStatus! ? '1' : '0', 'gst': store.gstCode!,
      'minimum_delivery_charge': store.minimumShippingCharge.toString(), 'per_km_delivery_charge': store.perKmShippingCharge.toString(),
      'veg': store.veg.toString(), 'non_veg': store.nonVeg.toString(),
      'order_place_to_schedule_interval': store.orderPlaceToScheduleInterval.toString(), 'minimum_delivery_time': min,
      'maximum_delivery_time': max, 'delivery_time_type': type, 'prescription_order': store.prescriptionStatus! ? '1' : '0',
      'cutlery': store.cutlery! ? '1' : '0', 'free_delivery': store.freeDelivery! ? '1' : '0',
      'extra_packaging_status': store.extraPackagingStatus! ? '1' : '0', 'extra_packaging_amount': store.extraPackagingAmount!.toString(),
      'minimum_stock_for_warning': store.minimumStockForWarning.toString(),
    });
    if(store.maximumShippingCharge != null){
      fields.addAll({'maximum_delivery_charge':  store.maximumShippingCharge.toString()});
    }
    Response response = await apiClient.postData(AppConstants.vendorUpdateUri, fields);
    return (response.statusCode == 200);
  }

  @override
  Future<Response> addItem(Item item, XFile? image, List<XFile> images, List<String> savedImages, Map<String, String> attributes, bool isAdd, String tags, String nutrition, String allergicIngredients, String genericName) async {
    Map<String, String> fields = {};
    fields.addAll(<String, String>{
      'price': item.price.toString(), 'discount': item.discount.toString(), 'veg': item.veg.toString(),
      'discount_type': item.discountType!, 'category_id': item.categoryIds![0].id!,
      'translations': jsonEncode(item.translations), 'tags': tags, 'maximum_cart_quantity': item.maxOrderQuantity.toString(),
    });

    if(Get.find<ProfileController>().profileModel!.stores![0].module!.moduleType == 'grocery' || Get.find<ProfileController>().profileModel!.stores![0].module!.moduleType == 'food') {
      fields.addAll(<String, String> {'nutritions': nutrition, 'allergies': allergicIngredients});
    }

    if(Get.find<ProfileController>().profileModel!.stores![0].module!.moduleType == 'pharmacy') {
      fields.addAll(<String, String> {'generic_name': genericName});
      fields.addAll((<String, String> {'condition_id': item.conditionId!.toString()}));
    }

    if(Get.find<SplashController>().configModel!.moduleConfig!.module!.stock!) {
      fields.addAll((<String, String> {'current_stock': item.stock.toString()}));
    }
    if(Get.find<ProfileController>().profileModel!.stores![0].module!.moduleType == 'pharmacy') {
      fields.addAll((<String, String> {'is_prescription_required': item.isPrescriptionRequired!.toString()}));
      fields.addAll((<String, String> {'basic': item.isBasicMedicine!.toString()}));
    }
    if(Get.find<ProfileController>().profileModel!.stores![0].module!.moduleType == 'ecommerce') {
      fields.addAll((<String, String> {'brand_id': item.brandId.toString()}));
    }
    if(Get.find<ProfileController>().profileModel!.stores![0].module!.moduleType == 'grocery' || Get.find<ProfileController>().profileModel!.stores![0].module!.moduleType == 'food') {
      fields.addAll((<String, String> {'is_halal': item.isHalal.toString()}));
    }
    if(Get.find<SplashController>().configModel!.moduleConfig!.module!.unit!) {
      fields.addAll((<String, String> {'unit': item.unitType!}));
    }
    if(Get.find<SplashController>().configModel!.moduleConfig!.module!.itemAvailableTime!) {
      fields.addAll((<String, String> {'available_time_starts': item.availableTimeStarts!, 'available_time_ends': item.availableTimeEnds!}));
    }
    String addon = '';
    for(int index=0; index<item.addOns!.length; index++) {
      addon = '$addon${index == 0 ? item.addOns![index].id : ',${item.addOns![index].id}'}';
    }
    fields.addAll(<String, String> {'addon_ids': addon});
    if(item.categoryIds!.length > 1) {
      fields.addAll(<String, String> {'sub_category_id': item.categoryIds![1].id!});
    }
    if(!isAdd) {
      fields.addAll(<String, String> {'_method': 'put', 'id': item.itemId != null ? item.itemId.toString() : item.id.toString(), 'images': jsonEncode(savedImages)});
    }
    if(Get.find<SplashController>().getStoreModuleConfig().newVariation! && item.foodVariations!.isNotEmpty) {
      fields.addAll({'options': jsonEncode(item.foodVariations)});
    }
    else if(!Get.find<SplashController>().getStoreModuleConfig().newVariation! && attributes.isNotEmpty) {
      fields.addAll(attributes);
    }

    if(Get.find<SplashController>().configModel!.systemTaxType == 'product_wise'){
      fields.addAll({'tax_ids': jsonEncode(item.taxVatIds)});
    }

    List<MultipartBody> images0 = [];
    images0.add(MultipartBody('image', image));
    for(int index=0; index<images.length; index++) {
      images0.add(MultipartBody('item_images[]', images[index]));
    }

    fields.addAll({'removedImageKeys': jsonEncode(Get.find<StoreController>().removeImageList)});
    if(!isAdd){
      fields.addAll({'temp_product' : '1'});
    }

    Response response = await apiClient.postMultipartData(isAdd ? AppConstants.addItemUri : AppConstants.updateItemUri, fields,images0, handleError: false);
    return response;
  }

  @override
  Future<bool> deleteItem(int? itemID, bool pendingItem) async {
    Response response = await apiClient.deleteData('${AppConstants.deleteItemUri}?id=$itemID${pendingItem ? '&temp_product=1' : ''}');
    return (response.statusCode == 200);
  }

  @override
  Future<List<ReviewModel>?> getStoreReviewList(int? storeID, String? searchText) async {
    List<ReviewModel>? storeReviewList;
    Response response = await apiClient.getData('${AppConstants.vendorReviewUri}?store_id=$storeID&search=$searchText');
    if(response.statusCode == 200) {
      storeReviewList = [];
      response.body.forEach((review) => storeReviewList!.add(ReviewModel.fromJson(review)));
    }
    return storeReviewList;
  }

  @override
  Future<List<ReviewModel>?> getItemReviewList(int? itemID) async {
    List<ReviewModel>? itemReviewList;
    Response response = await apiClient.getData('${AppConstants.itemReviewUri}/$itemID');
    if(response.statusCode == 200) {
      itemReviewList = [];
      response.body['reviews'].forEach((review) {
        itemReviewList!.add(ReviewModel.fromJson(review));
      });
    }
    return itemReviewList;
  }

  @override
  Future<bool> updateItemStatus(int? itemID, int status) async {
    Response response = await apiClient.getData('${AppConstants.updateItemStatusUri}?id=$itemID&status=$status');
    return (response.statusCode == 200);
  }

  @override
  Future<int?> add(Schedules schedule) async {
    int? scheduleID;
    Response response = await apiClient.postData(AppConstants.addSchedule, schedule.toJson());
    if(response.statusCode == 200) {
      scheduleID = int.parse(response.body['id'].toString());
    }
    return scheduleID;
  }

  @override
  Future<Response> stockUpdate(Map<String, String> data) async {
    return await apiClient.postData(AppConstants.itemStockUpdateUri, data);
  }

  @override
  Future<bool> delete(int? id) async {
    Response response = await apiClient.deleteData('${AppConstants.deleteSchedule}$id');
    return (response.statusCode == 200);
  }

  @override
  Future<List<UnitModel>?> getUnitList() async {
    List<UnitModel>? unitList;
    Response response = await apiClient.getData(AppConstants.unitListUri);
    if(response.statusCode == 200) {
      unitList = [];
      response.body.forEach((unit) => unitList!.add(UnitModel.fromJson(unit)));
    }
    return unitList;
  }

  @override
  Future<bool> updateRecommendedProductStatus(int? productID, int status) async {
    Response response = await apiClient.getData('${AppConstants.updateProductRecommendedUri}?id=$productID&status=$status');
    return (response.statusCode == 200);
  }

  @override
  Future<bool> updateOrganicProductStatus(int? productID, int status) async {
    Response response = await apiClient.getData('${AppConstants.updateProductOrganicUri}?id=$productID&organic=$status');
    return (response.statusCode == 200);
  }

  @override
  Future<bool> updateAnnouncement(int status, String announcement) async {
    Map<String, String> fields = {'announcement_status': status.toString(), 'announcement_message': announcement, '_method': 'put'};
    Response response = await apiClient.postData(AppConstants.announcementUri, fields);
    return (response.statusCode == 200);
  }

  @override
  Future update(Map<String, dynamic> body) {
    throw UnimplementedError();
  }

  @override
  Future getList() {
    throw UnimplementedError();
  }

  @override
  Future<List<BrandModel>?> getBrandList() async {
    List<BrandModel>? brands;
    Response response = await apiClient.getData(AppConstants.getBrandsUri);
    if(response.statusCode == 200) {
      brands = [];
      response.body!.forEach((brand) {
        brands!.add(BrandModel.fromJson(brand));
      });
    }
    return brands;
  }

  @override
  Future<List<SuitableTagModel>?> getSuitableTagList() async {
    List<SuitableTagModel>? suitableTagList;
    Response response = await apiClient.getData(AppConstants.suitableTagUri);
    if(response.statusCode == 200) {
      suitableTagList = [];
      response.body.forEach((tag) {
        suitableTagList!.add(SuitableTagModel.fromJson(tag));
      });
    }
    return suitableTagList;
  }

  @override
  Future<bool> updateReply(int reviewID, String reply) async {
    Map<String, String> fields = {'id': reviewID.toString(), 'reply': reply, '_method': 'put'};
    Response response = await apiClient.postData(AppConstants.updateReplyUri, fields);
    return (response.statusCode == 200);
  }

  @override
  Future<List<String?>?> getNutritionSuggestionList() async {
    List<String?>? nutritionSuggestionList;
    Response response = await apiClient.getData(AppConstants.getNutritionSuggestionUri);
    if(response.statusCode == 200) {
      nutritionSuggestionList = [];
      response.body.forEach((nutrition) => nutritionSuggestionList?.add(nutrition));
    }
    return nutritionSuggestionList;
  }

  @override
  Future<List<String?>?> getAllergicIngredientsSuggestionList() async {
    List<String?>? allergicIngredientsSuggestionList;
    Response response = await apiClient.getData(AppConstants.getAllergicIngredientsSuggestionUri);
    if(response.statusCode == 200) {
      allergicIngredientsSuggestionList = [];
      response.body.forEach((allergicIngredients) => allergicIngredientsSuggestionList?.add(allergicIngredients));
    }
    return allergicIngredientsSuggestionList;
  }

  @override
  Future<List<String?>?> getGenericNameSuggestionList() async {
    List<String?>? genericNameSuggestionList;
    Response response = await apiClient.getData(AppConstants.getGenericNameSuggestionUri);
    if(response.statusCode == 200) {
      genericNameSuggestionList = [];
      response.body.forEach((genericName) => genericNameSuggestionList?.add(genericName));
    }
    return genericNameSuggestionList;
  }

  @override
  Future<List<VatTaxModel>?> getVatTaxList() async {
    List<VatTaxModel>? vatTaxList;
    Response response = await apiClient.getData(AppConstants.vatTaxListUri);
    if(response.statusCode == 200) {
      vatTaxList = [];
      response.body.forEach((vatTax) => vatTaxList!.add(VatTaxModel.fromJson(vatTax)));
    }
    return vatTaxList;
  }

}