import 'package:get/get_connect/http/src/response/response.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sixam_mart_store/common/models/vat_tax_model.dart';
import 'package:sixam_mart_store/features/profile/domain/models/profile_model.dart';
import 'package:sixam_mart_store/features/store/domain/models/band_model.dart';
import 'package:sixam_mart_store/features/store/domain/models/review_model.dart';
import 'package:sixam_mart_store/features/store/domain/models/suitable_tag_model.dart';
import 'package:sixam_mart_store/interface/repository_interface.dart';
import 'package:sixam_mart_store/features/store/domain/models/item_model.dart';

abstract class StoreRepositoryInterface<T> extends RepositoryInterface<Schedules> {
  Future<ItemModel?> getItemList({required String offset, required String type, required String search, int? categoryId});
  Future<dynamic> getStockItemList(String offset);
  Future<dynamic> getPendingItemList(String offset, String type);
  Future<dynamic> getPendingItemDetails(int itemId);
  Future<dynamic> getAttributeList(Item? item);
  Future<bool> updateStoreBasicInfo(Store store, XFile? logo, XFile? cover, List<Translation> translation, XFile? metaImage);
  Future<dynamic> updateStore(Store store, String min, String max, String type);
  Future<dynamic> addItem(Item item, XFile? image, List<XFile> images, List<String> savedImages, Map<String, String> attributes, bool isAdd, String tags, String nutrition, String allergicIngredients, String genericName);
  Future<dynamic> deleteItem(int? itemID, bool pendingItem);
  Future<List<ReviewModel>?> getStoreReviewList(int? storeID, String? searchText);
  Future<dynamic> getItemReviewList(int? itemID);
  Future<dynamic> updateItemStatus(int? itemID, int status);
  Future<dynamic> getUnitList();
  Future<dynamic> updateRecommendedProductStatus(int? productID, int status);
  Future<dynamic> updateOrganicProductStatus(int? productID, int status);
  Future<dynamic> updateAnnouncement(int status, String announcement);
  Future<List<BrandModel>?> getBrandList();
  Future<bool> updateReply(int reviewID, String reply);
  Future<List<String?>?> getNutritionSuggestionList();
  Future<List<String?>?> getAllergicIngredientsSuggestionList();
  Future<List<String?>?> getGenericNameSuggestionList();
  Future<Response> stockUpdate(Map<String, String> data);
  Future<List<SuitableTagModel>?> getSuitableTagList();
  Future<List<VatTaxModel>?> getVatTaxList();
}