import 'dart:convert';
import 'package:sixam_mart_store/common/models/vat_tax_model.dart';
import 'package:sixam_mart_store/features/addon/controllers/addon_controller.dart';
import 'package:sixam_mart_store/features/category/controllers/category_controller.dart';
import 'package:sixam_mart_store/features/category/domain/models/category_model.dart';
import 'package:sixam_mart_store/features/dashboard/screens/dashboard_screen.dart';
import 'package:sixam_mart_store/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart_store/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart_store/features/store/domain/models/band_model.dart';
import 'package:sixam_mart_store/features/store/domain/models/suitable_tag_model.dart';
import 'package:sixam_mart_store/features/store/domain/models/variant_type_model.dart';
import 'package:sixam_mart_store/features/store/domain/models/variation_body_model.dart';
import 'package:sixam_mart_store/features/store/domain/models/item_model.dart';
import 'package:sixam_mart_store/features/store/domain/models/attribute_model.dart';
import 'package:sixam_mart_store/features/store/domain/models/pending_item_model.dart';
import 'package:sixam_mart_store/features/profile/domain/models/profile_model.dart';
import 'package:sixam_mart_store/features/store/domain/models/review_model.dart';
import 'package:sixam_mart_store/features/store/domain/models/unit_model.dart';
import 'package:sixam_mart_store/features/rental_module/profile/controllers/taxi_profile_controller.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';
import 'package:sixam_mart_store/util/app_constants.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sixam_mart_store/features/store/domain/services/store_service_interface.dart';

class StoreController extends GetxController implements GetxService {
  final StoreServiceInterface storeServiceInterface;
  StoreController({required this.storeServiceInterface});

  List<Item>? _itemList;
  List<Item>? get itemList => _itemList;

  int? _itemSize;
  int? get itemSize => _itemSize;

  List<Item>? _stockItemList;
  List<Item>? get stockItemList => _stockItemList;

  List<ReviewModel>? _storeReviewList;
  List<ReviewModel>? get storeReviewList => _storeReviewList;

  List<ReviewModel>? _itemReviewList;
  List<ReviewModel>? get itemReviewList => _itemReviewList;

  List<BrandModel>? _brandList;
  List<BrandModel>? get brandList => _brandList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  int? _pageSize;
  int? get pageSize => _pageSize;

  List<String> _offsetList = [];

  int _offset = 1;
  int get offset => _offset;

  List<AttributeModel>? _attributeList;
  List<AttributeModel>? get attributeList => _attributeList;

  final List<String?> _discountTypeList = ['percent', 'amount'];
  List<String?> get discountTypeList => _discountTypeList;

  int _discountTypeIndex = 0;
  int get discountTypeIndex => _discountTypeIndex;

  XFile? _rawLogo;
  XFile? get rawLogo => _rawLogo;

  XFile? _rawCover;
  XFile? get rawCover => _rawCover;

  List<int>? _selectedAddons;
  List<int>? get selectedAddons => _selectedAddons;

  List<VariantTypeModel>? _variantTypeList;
  List<VariantTypeModel>? get variantTypeList => _variantTypeList;

  bool _isAvailable = true;
  bool get isAvailable => _isAvailable;

  List<Schedules>? _scheduleList;
  List<Schedules>? get scheduleList => _scheduleList;

  bool _scheduleLoading = false;
  bool get scheduleLoading => _scheduleLoading;

  bool? _isGstEnabled;
  bool? get isGstEnabled => _isGstEnabled;

  int _tabIndex = 0;
  int get tabIndex => _tabIndex;

  bool _isVeg = false;
  bool get isVeg => _isVeg;

  bool? _isStoreVeg = true;
  bool? get isStoreVeg => _isStoreVeg;

  bool? _isStoreNonVeg = true;
  bool? get isStoreNonVeg => _isStoreNonVeg;

  String _type = 'all';
  String get type => _type;

  static final List<String> _itemTypeList = ['all', 'veg', 'non_veg'];
  List<String> get itemTypeList => _itemTypeList;

  List<UnitModel>? _unitList;
  List<UnitModel>? get unitList => _unitList;

  int _totalStock = 0;
  int get totalStock => _totalStock;

  List<XFile> _rawImages = [];
  List<XFile> get rawImages => _rawImages;

  List<String> _savedImages = [];
  List<String> get savedImages => _savedImages;

  int _imageIndex = 0;
  int get imageIndex => _imageIndex;

  int? _unitIndex = 0;
  int? get unitIndex => _unitIndex;

  final List<String> _durations = ['min', 'hours', 'days'];
  List<String> get durations => _durations;

  String? _selectedDuration;
  String? get selectedDuration => _selectedDuration;

  List<VariationModelBodyModel>? _variationList;
  List<VariationModelBodyModel>? get variationList => _variationList;

  List<String?> _tagList = [];
  List<String?> get tagList => _tagList;

  bool _isRecommended = false;
  bool get isRecommended => _isRecommended;

  bool _isOrganic = false;
  bool get isOrganic => _isOrganic;

  Item? _item;
  Item? get item => _item;

  List<Items>? _pendingItem;
  List<Items>? get pendingItem => _pendingItem;

  final List<String> _statusList = ['all', 'pending', 'rejected'];
  List<String> get statusList => _statusList;

  bool _announcementStatus = false;
  bool get announcementStatus => _announcementStatus;

  int _languageSelectedIndex = 0;
  int get languageSelectedIndex => _languageSelectedIndex;

  bool? _isExtraPackagingEnabled;
  bool? get isExtraPackagingEnabled => _isExtraPackagingEnabled;

  bool _isPrescriptionRequired = false;
  bool get isPrescriptionRequired => _isPrescriptionRequired;

  int? _brandIndex;
  int? get brandIndex => _brandIndex;

  bool _isHalal = false;
  bool get isHalal => _isHalal;

  List<ReviewModel>? _searchReviewList;
  List<ReviewModel>? get searchReviewList => _searchReviewList;

  bool _isSearching = false;
  bool get isSearching => _isSearching;

  bool _isFabVisible = true;
  bool get isFabVisible => _isFabVisible;

  bool? _isScheduleOrderEnabled = false;
  bool? get isScheduleOrderEnabled => _isScheduleOrderEnabled;

  bool? _isDeliveryEnabled = false;
  bool? get isDeliveryEnabled => _isDeliveryEnabled;

  bool? _isCutleryEnabled = false;
  bool? get isCutleryEnabled => _isCutleryEnabled;

  bool? _isFreeDeliveryEnabled = false;
  bool? get isFreeDeliveryEnabled => _isFreeDeliveryEnabled;

  bool? _isTakeAwayEnabled = false;
  bool? get isTakeAwayEnabled => _isTakeAwayEnabled;

  bool? _isPrescriptionStatusEnable = false;
  bool? get isPrescriptionStatusEnable => _isPrescriptionStatusEnable;

  List<String?>? _nutritionSuggestionList;
  List<String?>? get nutritionSuggestionList => _nutritionSuggestionList;

  List<int>? _selectedNutrition;
  List<int>? get selectedNutrition => _selectedNutrition;

  List<String?>? _selectedNutritionList;
  List<String?>? get selectedNutritionList => _selectedNutritionList;

  List<String?>? _allergicIngredientsSuggestionList;
  List<String?>? get allergicIngredientsSuggestionList => _allergicIngredientsSuggestionList;

  List<int>? _selectedAllergicIngredients;
  List<int>? get selectedAllergicIngredients => _selectedAllergicIngredients;

  List<String?>? _selectedAllergicIngredientsList = [];
  List<String?>? get selectedAllergicIngredientsList => _selectedAllergicIngredientsList;

  List<String?>? _genericNameSuggestionList;
  List<String?>? get genericNameSuggestionList => _genericNameSuggestionList;

  List<int>? _selectedGenericName;
  List<int>? get selectedGenericName => _selectedGenericName;

  List<String?>? _selectedGenericNameList = [];
  List<String?>? get selectedGenericNameList => _selectedGenericNameList;

  bool _isBasicMedicine = false;
  bool get isBasicMedicine => _isBasicMedicine;

  List<SuitableTagModel>? _suitableTagList;
  List<SuitableTagModel>? get suitableTagList => _suitableTagList;

  int? _suitableTagIndex;
  int? get suitableTagIndex => _suitableTagIndex;

  List<VatTaxModel>? _vatTaxList;
  List<VatTaxModel>? get vatTaxList => _vatTaxList;

  String? _selectedVatTaxName;
  String? get selectedVatTaxName => _selectedVatTaxName;

  final List<String> _selectedVatTaxNameList = [];
  List<String> get selectedVatTaxNameList => _selectedVatTaxNameList;

  final List<int> _selectedVatTaxIdList = [];
  List<int> get selectedVatTaxIdList => _selectedVatTaxIdList;

  final List<double> _selectedTaxRateList = [];
  List<double> get selectedTaxRateList => _selectedTaxRateList;

  List<String>? _categoryNameList;
  List<String>? get categoryNameList => _categoryNameList;

  List<int>? _categoryIdList;

  int? _categoryId = 0;
  int? get categoryId => _categoryId;

  int? _categoryIndex = 0;
  int? get categoryIndex => _categoryIndex;

  XFile? _pickedMetaImage;
  XFile? get pickedMetaImage => _pickedMetaImage;

  bool? _isHalalEnabled = false;
  bool? get isHalalEnabled => _isHalalEnabled;

  bool _isFilterClearLoading = false;
  bool get isFilterClearLoading => _isFilterClearLoading;

  bool _isSearchVisible = false;
  bool get isSearchVisible => _isSearchVisible;

  void initItemData({Item? item, bool isFood = false, bool isGrocery = false, bool isPharmacy = false}) {
    if(isFood || isGrocery) {
      _getNutritionSuggestionList();
      _getAllergicIngredientsSuggestionList();
      _selectedNutritionList = [];
      _selectedAllergicIngredientsList = [];
      if(item != null) {
        if(item.nutrition == null && item.nutritionsData != null) {

          print('======controller: ${item.nutritionsData}');

          item.nutritionsData?.forEach((nutrition) {
            _selectedNutritionList!.add(nutrition.nutrition);
          });
        } else {
          _selectedNutritionList!.addAll(item.nutrition??[]);
        }

        if(item.allergies == null && item.allergiesData != null) {
          item.allergiesData?.forEach((allergy) {
            _selectedAllergicIngredientsList!.add(allergy.allergy);
          });
        } else {
          _selectedAllergicIngredientsList!.addAll(item.allergies ?? []);
        }
      }
    }else if(isPharmacy) {
      _getGenericNameSuggestionList();
      _selectedGenericNameList = [];
      if(item != null) {
        if(item.genericName == null && item.genericNameData != null) {
          item.genericNameData?.forEach((gen) {
            _selectedGenericNameList!.add(gen.generic);
          });
        } else {
          _selectedGenericNameList!.addAll(item.genericName!);
        }
      }
    }
  }

  void setSelectedDuration(String? duration) {
    _selectedDuration = duration;
    update();
  }

  void initSetup() {
    _isPrescriptionRequired = false;
    _isHalal = false;
    _isBasicMedicine = false;
  }

  void setLanguageSelect(int index) {
    _languageSelectedIndex = index;
    update();
  }

  void setRecommended(bool isRecommended) {
    _isRecommended = isRecommended;
  }

  void setOrganic(bool isOrganic) {
    _isOrganic = isOrganic;
  }

  void toggleRecommendedProduct(int? productID) async {
    bool isSuccess = await storeServiceInterface.updateRecommendedProductStatus(productID, _isRecommended ? 0 : 1);
    if(isSuccess) {
      getItemList(offset: '1', type: 'all', search: '', categoryId: 0);
      _isRecommended = !_isRecommended;
      showCustomSnackBar(Get.find<SplashController>().moduleType == 'food' ? 'food_status_updated_successfully'.tr : 'product_status_updated_successfully'.tr, isError: false);
    }
    update();
  }

  void toggleOrganicProduct(int? productID) async {
    bool isSuccess = await storeServiceInterface.updateOrganicProductStatus(productID, _isOrganic ? 0 : 1);
    if(isSuccess) {
      getItemList(offset: '1', type: 'all', search: '', categoryId: 0);
      _isOrganic = !_isOrganic;
      showCustomSnackBar(Get.find<SplashController>().moduleType == 'food' ? 'food_status_updated_successfully'.tr : 'product_status_updated_successfully'.tr, isError: false);
    }
    update();
  }

  void setTag(String? name, {bool isUpdate = true, bool isClear = false}){
    if(isClear){
      _tagList = [];
    }else{
      _tagList.add(name);
      if(isUpdate) {
        update();
      }
    }
  }

  void initializeTags(String name){
    _tagList.add(name);
    update();
  }

  void removeTag(int index){
    _tagList.removeAt(index);
    update();
  }

  void updateSelectedFoodType(String type) {
    _type = type;
    update();
  }

  void applyFilters({bool isClearFilter = false}) async{
    isClearFilter ? _isFilterClearLoading = true : _isLoading = true;
    update();

    await getItemList(offset: '1', type: _type, search: '', categoryId: _categoryIndex != 0 ? _categoryIdList![_categoryIndex!] : 0);
    Get.back();

    isClearFilter ? _isFilterClearLoading = false : _isLoading = false;
    update();
  }

  void setSearchVisibility() {
    _isSearchVisible = !_isSearchVisible;
    update();
  }

  Future<void> getItemList({required String offset, required String type, required String search, int? categoryId, bool willUpdate = true}) async {

    if (search.isEmpty) {
      _isSearching = false;
    } else {
      _isSearching = true;
    }

    if(offset == '1') {
      _offsetList = [];
      _offset = 1;
      _type = type;
      _itemList = null;
      if(willUpdate) {
        update();
      }
    }
    if (!_offsetList.contains(offset)) {
      _offsetList.add(offset);
      ItemModel? itemModel = await storeServiceInterface.getItemList(offset: offset, type: type, search: search, categoryId: categoryId);
      if (itemModel != null) {
        if (offset == '1') {
          _itemList = [];
        }
        _itemList!.addAll(itemModel.items!);
        _itemSize = itemModel.totalSize;
        _isLoading = false;
        update();
      }
    } else {
      if(isLoading) {
        _isLoading = false;
        update();
      }
    }
  }

  Future<void> getLimitedStockItemList(String offset, {bool willUpdate = true}) async {
    if(offset == '1') {
      _offsetList = [];
      _offset = 1;
      _stockItemList = null;
      if(willUpdate) {
        update();
      }
    }
    if (!_offsetList.contains(offset)) {
      _offsetList.add(offset);
      ItemModel? itemModel = await storeServiceInterface.getStockItemList(offset);
      if (itemModel != null) {
        if (offset == '1') {
          _stockItemList = [];
        }
        _stockItemList!.addAll(itemModel.items!);
        _pageSize = itemModel.totalSize;
        _isLoading = false;
        update();
      }
    } else {
      if(isLoading) {
        _isLoading = false;
        update();
      }
    }
  }

  Future<Item?> getItemDetails(int itemId) async {
    _isLoading = true;
    update();
    Item? item = await storeServiceInterface.getItemDetails(itemId);
    if (item != null) {
      _item = item;
      _isLoading = false;
      update();
    }
    _isLoading = false;
    update();
    return _item;
  }

  Future<void> getPendingItemList(String offset, String type, {bool canNotify = true}) async {
    if(offset == '1') {
      _offsetList = [];
      _offset = 1;
      _type = type;
      _pendingItem = null;
      if(canNotify) {
        update();
      }
    }
    if (!_offsetList.contains(offset)) {
      _offsetList.add(offset);
      PendingItemModel? pendingItemModel = await storeServiceInterface.getPendingItemList(offset, type);
      if (pendingItemModel != null) {
        if (offset == '1') {
          _pendingItem = [];
        }
        _pendingItem!.addAll(pendingItemModel.items!);
        _pageSize = pendingItemModel.totalSize;
        _isLoading = false;
        update();
      }
    } else {
      if(isLoading) {
        _isLoading = false;
        update();
      }
    }
  }


  Future<bool> getPendingItemDetails(int itemId, {bool canUpdate = true}) async {
    _item = null;
    _languageSelectedIndex = 0;
    bool success = false;
    _isLoading = true;
    if(canUpdate == true) {
      update();
    }
    Item? pendingItem = await storeServiceInterface.getPendingItemDetails(itemId);
    if (pendingItem != null) {
      _item = pendingItem;
      success = true;
    }
    _isLoading = false;
    update();
    return success;
  }

  void showBottomLoader() {
    _isLoading = true;
    update();
  }

  void setOffset(int offset) {
    _offset = offset;
  }

  void getAttributeList(Item? item) async {
    _attributeList = null;
    _discountTypeIndex = 0;
    _rawLogo = null;
    _selectedAddons = [];
    _variantTypeList = [];
    _totalStock = 0;
    _rawImages = [];
    _savedImages = [];
    if(item != null) {
      for (var e in item.imagesFullUrl!) {
        if(e != null) {
          _savedImages.add(e);
        }
      }
    }
    List<AttributeModel>? attributeList = await storeServiceInterface.getAttributeList(item);
    if(attributeList != null) {
      _attributeList = [];
      _attributeList!.addAll(attributeList);
    }
    if(Get.find<SplashController>().configModel!.moduleConfig!.module!.addOn!) {
      List<int?> addonsIds = await Get.find<AddonController>().getAddonList();
      if(item != null && item.addOns != null) {
        for(int index=0; index<item.addOns!.length; index++) {
          setSelectedAddonIndex(addonsIds.indexOf(item.addOns![index].id), false);
        }
      }
    }
    if(Get.find<SplashController>().configModel!.moduleConfig!.module!.unit!) {
      await getUnitList(item);
    }
    generateVariantTypes(item);
  }

  void setDiscountTypeIndex(int index, bool notify) {
    _discountTypeIndex = index;
    if(notify) {
      update();
    }
  }

  void toggleAttribute(int index, Item? product) {
    _attributeList![index].active = !_attributeList![index].active;
    generateVariantTypes(product);
    update();
  }

  void addVariant(int index, String variant, Item? product) {
    _attributeList![index].variants.add(variant);
    generateVariantTypes(product);
    update();
  }

  void removeVariant(int mainIndex, int index, Item? product) {
    _attributeList![mainIndex].variants.removeAt(index);
    generateVariantTypes(product);
    update();
  }

  Future<void> updateStoreBasicInfo(Store store, List<Translation> translation) async {
    _isLoading = true;
    update();

    bool isSuccess = await storeServiceInterface.updateStoreBasicInfo(store,  _rawLogo, _rawCover, translation, _pickedMetaImage);
    if(isSuccess) {
      await Get.find<ProfileController>().getProfile();
      Get.back();
      showCustomSnackBar(Get.find<SplashController>().configModel!.moduleConfig!.module!.showRestaurantText!
          ? 'restaurant_edit_updated_successfully'.tr : 'store_edit_updated_successfully'.tr, isError: false);
    }
    _isLoading = false;
    update();
  }

  Future<void> updateStore(Store store, String min, String max) async {
    _isLoading = true;
    update();
    bool isSuccess = await storeServiceInterface.updateStore(store, min, max, _selectedDuration!);
    if(isSuccess) {
      await Get.find<ProfileController>().getProfile();
      getItemList(offset: '1', type: 'all', search: '', categoryId: 0);
      Get.find<StoreController>().getStoreReviewList(Get.find<ProfileController>().profileModel!.stores![0].id, '');
      showCustomSnackBar(Get.find<SplashController>().configModel!.moduleConfig!.module!.showRestaurantText!
          ? 'restaurant_settings_updated_successfully'.tr : 'store_settings_updated_successfully'.tr, isError: false);
      Get.offAllNamed(RouteHelper.getMainRoute('cart'));
    }
    _isLoading = false;
    update();
  }

  void pickImage(bool isLogo, bool isRemove) async {
    if(isRemove) {
      _rawLogo = null;
      _rawCover = null;
    }else {
      isLogo ? _rawLogo = await storeServiceInterface.pickImageFromGallery() : _rawCover = await storeServiceInterface.pickImageFromGallery();
      update();
    }
  }

  void setSelectedAddonIndex(int index, bool notify) {
    if(!_selectedAddons!.contains(index)) {
      _selectedAddons!.add(index);
      if(notify) {
        update();
      }
    }
  }

  void removeAddon(int index) {
    _selectedAddons!.removeAt(index);
    update();
  }

  Future<void> addItem(Item item, bool isAdd, {String? genericNameData}) async {
    _isLoading = true;
    update();
    Map<String, String> fields = {};
    if(!Get.find<SplashController>().getStoreModuleConfig().newVariation! && _variantTypeList!.isNotEmpty) {
      List<int?> idList = [];
      List<String?> nameList = [];
      for (var attributeModel in _attributeList!) {
        if(attributeModel.active) {
          idList.add(attributeModel.attribute.id);
          nameList.add(attributeModel.attribute.name);
          String variantString = '';
          for (var variant in attributeModel.variants) {
            variantString = variantString + (variantString.isEmpty ? '' : ',') + variant.replaceAll(' ', '');
          }
          fields.addAll(<String, String>{'choice_options_${attributeModel.attribute.id}': jsonEncode([variantString])});
        }
      }
      fields.addAll(<String, String> {
        'attribute_id': jsonEncode(idList), 'choice_no': jsonEncode(idList), 'choice': jsonEncode(nameList)
      });
      for(int index=0; index<_variantTypeList!.length; index++) {
        fields.addAll(<String, String> {'price_${_variantTypeList![index].variantType.replaceAll(' ', '_')}': _variantTypeList![index].priceController.text.trim(),
          'stock_${_variantTypeList![index].variantType.replaceAll(' ', '_')}': _variantTypeList![index].stockController.text.trim().isEmpty ? '0'
              : _variantTypeList![index].stockController.text.trim()});
      }
    }
    String tags = '';
    for (var element in _tagList) {
      tags = tags + (tags.isEmpty ? '' : ',') + element!.replaceAll(' ', '');
    }

    String nutrition = '';
    String allergicIngredients = '';
    if(Get.find<ProfileController>().profileModel!.stores![0].module!.moduleType == 'grocery' || Get.find<ProfileController>().profileModel!.stores![0].module!.moduleType == 'food') {
      for (var index in _selectedNutritionList!) {
        nutrition = nutrition + (nutrition.isEmpty ? '' : ',') + index!.replaceAll(' ', '');
      }

      for (var index in _selectedAllergicIngredientsList!) {
        allergicIngredients = allergicIngredients + (allergicIngredients.isEmpty ? '' : ',') + index!.replaceAll(' ', '');
      }
    }

    String genericName = '';
    if(Get.find<ProfileController>().profileModel!.stores![0].module!.moduleType == 'pharmacy') {
      genericName = genericNameData ?? '';
    }

    Response response = await storeServiceInterface.addItem(item, _rawLogo, _rawImages, _savedImages, fields, isAdd, tags, nutrition, allergicIngredients, genericName);
    if(response.statusCode == 200) {
      Get.offAll(() => const DashboardScreen(pageIndex: 2));
      showCustomSnackBar(response.body['message'], isError: false);
      _tagList.clear();
      getItemList(offset: '1', type: 'all', search: '', categoryId: 0, willUpdate: false);
    }
    _isLoading = false;
    update();
  }

  Future<void> deleteItem(int? itemID, {bool pendingItem = false}) async {
    _isLoading = true;
    update();
    bool isSuccess = await storeServiceInterface.deleteItem(itemID, pendingItem);
    if(isSuccess) {
      Get.back();
      Get.back();
      showCustomSnackBar('product_deleted_successfully'.tr, isError: false);
      if(pendingItem) {
        getPendingItemList(offset.toString(), type);
      }else {
        getItemList(offset: '1', type: 'all', search: '', categoryId: 0);
      }
    }
    _isLoading = false;
    update();
  }

  void generateVariantTypes(Item? item) {
    _variantTypeList = storeServiceInterface.variationTypeList(_attributeList, item);
    _totalStock = storeServiceInterface.totalStock(_attributeList, item);
  }

  bool hasAttribute() {
    bool hasData = storeServiceInterface.hasAttributeData(_attributeList);
    return hasData;
  }

  Future<void> getStoreReviewList(int? storeID, String? searchText, {bool willUpdate = true}) async {
    if (searchText!.isEmpty) {
      _storeReviewList = null;
      _isSearching = false;
    } else {
      _searchReviewList = null;
      _isSearching = true;
    }
    if(willUpdate) {
      update();
    }
    _tabIndex = 0;
    List<ReviewModel>? storeReviewList = await storeServiceInterface.getStoreReviewList(storeID, searchText);

    if (storeReviewList != null) {
      if (searchText.isEmpty) {
        _storeReviewList = [];
        _storeReviewList!.addAll(storeReviewList);
      } else {
        _searchReviewList = [];
        _searchReviewList!.addAll(storeReviewList);
      }
    }
    update();
  }

  Future<void> getBrandList(Item? item) async {
    List<BrandModel>? brands = await storeServiceInterface.getBrandList();
    if(brands != null) {
      _brandList = [];
      _brandList!.addAll(brands);
      _brandIndex = storeServiceInterface.setBrandIndex(_brandList, item);
    }
    update();
  }

  void setBrandIndex(int index, bool notify) {
    _brandIndex = index;
    if(notify) {
      update();
    }
  }

  Future<void> getSuitableTagList(Item? item) async {
    List<SuitableTagModel>? suitableTagList = await storeServiceInterface.getSuitableTagList();
    if(suitableTagList != null) {
      _suitableTagList = [];
      _suitableTagList!.addAll(suitableTagList);
      _suitableTagIndex = storeServiceInterface.setSuitableTagIndex(_suitableTagList, item);
    }
    update();
  }

  void setSuitableTagIndex(int index, bool notify) {
    _suitableTagIndex = index;
    if(notify) {
      update();
    }
  }

  Future<void> getItemReviewList(int? itemID) async {
    _itemReviewList = null;
    List<ReviewModel>? itemReviewList = await storeServiceInterface.getItemReviewList(itemID);
    if(itemReviewList != null) {
      _itemReviewList = [];
      _itemReviewList!.addAll(itemReviewList);
    }
    update();
  }

  void setAvailability(bool isAvailable) {
    _isAvailable = isAvailable;
  }

  void toggleAvailable(int? productID) async {
    bool isSuccess = await storeServiceInterface.updateItemStatus(productID, _isAvailable ? 0 : 1);
    if(isSuccess) {
      getItemList(offset: '1', type: 'all', search: '', categoryId: 0);
      _isAvailable = !_isAvailable;
      showCustomSnackBar('item_status_updated_successfully'.tr, isError: false);
    }
    update();
  }

  void initStoreBasicData() {
    _rawLogo = null;
    _rawCover = null;
    _pickedMetaImage = null;
  }

  void initStoreData(Store store) {
    _isGstEnabled = store.gstStatus;
    _scheduleList = [];
    _scheduleList!.addAll(store.schedules!);
    _isStoreVeg = store.veg == 1;
    _isStoreNonVeg = store.nonVeg == 1;
    _isExtraPackagingEnabled = store.extraPackagingStatus;
    _isScheduleOrderEnabled = store.scheduleOrder;
    _isDeliveryEnabled = store.delivery;
    _isCutleryEnabled = store.cutlery;
    _isFreeDeliveryEnabled = store.freeDelivery;
    _isTakeAwayEnabled = store.takeAway;
    _isPrescriptionStatusEnable = store.prescriptionStatus;
    _isHalalEnabled = store.isHalalActive;
  }

  void toggleGst() {
    _isGstEnabled = !_isGstEnabled!;
    update();
  }

  void toggleExtraPackaging() {
    _isExtraPackagingEnabled = !_isExtraPackagingEnabled!;
    update();
  }

  void togglePrescriptionRequired({bool willUpdate = true}) {
    _isPrescriptionRequired = !_isPrescriptionRequired;
    if(willUpdate) {
      update();
    }
  }

  Future<void> addSchedule(Schedules schedule) async {
    schedule.openingTime = '${schedule.openingTime!}:00';
    schedule.closingTime = '${schedule.closingTime!}:00';
    _scheduleLoading = true;
    update();
    int? scheduleID = await storeServiceInterface.addSchedule(schedule);
    if(scheduleID != null) {
      schedule.id = scheduleID;
      _scheduleList!.add(schedule);
      Get.back();
      showCustomSnackBar('schedule_added_successfully'.tr, isError: false);
    }
    _scheduleLoading = false;
    update();
  }

  Future<void> deleteSchedule(int? scheduleID) async {
    _scheduleLoading = true;
    update();
    bool isSuccess = await storeServiceInterface.deleteSchedule(scheduleID);
    if(isSuccess) {
      _scheduleList!.removeWhere((schedule) => schedule.id == scheduleID);
      Get.back();
      showCustomSnackBar('schedule_removed_successfully'.tr, isError: false);
    }
    _scheduleLoading = false;
    update();
  }

  void setTabIndex(int index) {
    bool notify = true;
    if(_tabIndex == index) {
      notify = false;
    }
    _tabIndex = index;
    if(notify) {
      update();
    }
  }

  void setVeg(bool isVeg, bool notify) {
    _isVeg = isVeg;
    if(notify) {
      update();
    }
  }

  void toggleHalal({bool willUpdate = true}) {
    _isHalal = !_isHalal;
    if(willUpdate) {
      update();
    }
  }

  void toggleBasicMedicine({bool willUpdate = true}) {
    _isBasicMedicine = !_isBasicMedicine;
    if(willUpdate) {
      update();
    }
  }

  void toggleStoreVeg() {
    _isStoreVeg = !_isStoreVeg!;
    update();
  }

  void toggleStoreNonVeg() {
    _isStoreNonVeg = !_isStoreNonVeg!;
    update();
  }

  void setStoreVeg(bool? isVeg, bool notify) {
    _isStoreVeg = isVeg;
    if(notify) {
      update();
    }
  }

  void setStoreNonVeg(bool? isNonVeg, bool notify) {
    _isStoreNonVeg = isNonVeg;
    if(notify) {
      update();
    }
  }

  Future<void> getUnitList(Item? item) async {
    _unitIndex = 0;
    List<UnitModel>? unitList = await storeServiceInterface.getUnitList();
    if(unitList != null) {
      _unitList = [];
      _unitList!.addAll(unitList);
      _unitIndex = storeServiceInterface.setUnitIndex(_unitList, item, _unitIndex!);
    }
    update();
  }

  void setTotalStock() {
    _totalStock = 0;
    for (var variant in _variantTypeList!) {
      _totalStock = variant.stockController.text.trim().isNotEmpty ? _totalStock + int.parse(variant.stockController.text.trim()) : _totalStock;
    }
    update();
  }

  void pickImages() async {
    XFile? xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if(xFile != null) {
      _rawImages.add(xFile);
    }
    update();
  }

  void removeImage(int index) {
    _rawImages.removeAt(index);
    update();
  }

  List<String> _removeImageList = [];
  List<String> get removeImageList => _removeImageList;

  void removeSavedImage(int index) {
    String imageUrl = _savedImages[index];
    _savedImages.removeAt(index);

    // Extract the file name from the URL
    String fileName = Uri.parse(imageUrl).pathSegments.last;
    _removeImageList.add(fileName);

    update();
  }

  void removeImageFromList() {
    _removeImageList = [];
  }

  void setImageIndex(int index, bool notify) {
    _imageIndex = index;
    if(notify) {
      update();
    }
  }

  void setUnitIndex(int index, bool notify) {
    _unitIndex = index;
    if(notify) {
      update();
    }
  }

  void setEmptyVariationList(){
    _variationList = [];
  }

  void setExistingVariation(List<FoodVariation>? variationList) {
    _variationList = storeServiceInterface.setExistingVariation(variationList);
  }

  void changeSelectVariationType(int index) {
    _variationList![index].isSingle = !_variationList![index].isSingle;
    update();
  }

  void setVariationRequired(int index) {
    _variationList![index].required = !_variationList![index].required;
    update();
  }

  void addVariation() {
    _variationList!.add(VariationModelBodyModel(
      nameController: TextEditingController(), required: false, isSingle: true, maxController: TextEditingController(), minController: TextEditingController(),
      options: [Option(optionNameController: TextEditingController(), optionPriceController: TextEditingController())],
    ));
    update();
  }

  void removeVariation(int index) {
    _variationList!.removeAt(index);
    update();
  }

  void addOptionVariation(int index) {
    _variationList![index].options!.add(Option(optionNameController: TextEditingController(), optionPriceController: TextEditingController()));
    update();
  }

  void removeOptionVariation(int vIndex, int oIndex) {
    _variationList![vIndex].options!.removeAt(oIndex);
    update();
  }

  Future<void> updateAnnouncement(int status, String announcement) async{
    _isLoading = true;
    update();
    bool isSuccess = await storeServiceInterface.updateAnnouncement(status, announcement);
    if(isSuccess){
      Get.back();
      showCustomSnackBar('announcement_updated_successfully'.tr, isError: false);
      Get.find<ProfileController>().getProfile();
      Get.find<TaxiProfileController>().getProfile();
    }
    _isLoading = false;
    update();
  }

  void setAnnouncementStatus(bool status, {bool willUpdate = true}) {
    _announcementStatus = status;
    if(willUpdate) {
      update();
    }
  }

  bool isFoodModule() {
    final profileModel = Get.find<ProfileController>().profileModel;
    return profileModel?.stores?.first.module?.moduleType == AppConstants.food;
  }

  Future<void> updateReply(int reviewID, String reply) async {
    _isLoading = true;
    update();
    bool isSuccess = await storeServiceInterface.updateReply(reviewID, reply);
    if(isSuccess) {
      Get.back();
      showCustomSnackBar('reply_updated_successfully'.tr, isError: false);
      getStoreReviewList(Get.find<ProfileController>().profileModel!.stores![0].id, '');
    }
    _isLoading = false;
    update();
  }

  void showFab() {
    _isFabVisible = true;
    update();
  }

  void hideFab() {
    _isFabVisible = false;
    update();
  }

  void toggleScheduleOrder() {
    _isScheduleOrderEnabled = !_isScheduleOrderEnabled!;
    update();
  }

  void toggleDelivery() {
    _isDeliveryEnabled = !_isDeliveryEnabled!;
    update();
  }

  void toggleCutlery() {
    _isCutleryEnabled = !_isCutleryEnabled!;
    update();
  }

  void toggleFreeDelivery() {
    _isFreeDeliveryEnabled = !_isFreeDeliveryEnabled!;
    update();
  }

  void toggleTakeAway() {
    _isTakeAwayEnabled = !_isTakeAwayEnabled!;
    update();
  }

  void togglePrescription() {
    _isPrescriptionStatusEnable = !_isPrescriptionStatusEnable!;
    update();
  }

  Future<void> _getNutritionSuggestionList() async{
    _nutritionSuggestionList = [];
    _selectedNutrition = [];
    List<String?>? suggestionList = await storeServiceInterface.getNutritionSuggestionList();
    if(suggestionList != null) {
      _nutritionSuggestionList!.addAll(suggestionList);
      for(int index=0; index<_nutritionSuggestionList!.length; index++){
        _selectedNutrition!.add(index);
      }
    }
    update();
  }

  void setNutrition(String? name, {bool willUpdate = true}){
    _selectedNutritionList!.add(name);
    if(willUpdate) {
      update();
    }
  }

  void setSelectedNutritionIndex(int index, bool notify) {
    if(_selectedNutrition!.contains(index)) {
      _selectedNutritionList!.add(_nutritionSuggestionList![index]);
      if(notify) {
        update();
      }
    }
  }

  void removeNutrition(int index) {
    _selectedNutritionList!.removeAt(index);
    update();
  }

  Future<void> _getAllergicIngredientsSuggestionList() async{
    _allergicIngredientsSuggestionList = [];
    _selectedAllergicIngredients = [];
    List<String?>? suggestionList = await storeServiceInterface.getAllergicIngredientsSuggestionList();
    if(suggestionList != null) {
      _allergicIngredientsSuggestionList!.addAll(suggestionList);
      for(int index=0; index<_allergicIngredientsSuggestionList!.length; index++){
        _selectedAllergicIngredients!.add(index);
      }
    }
    update();
  }

  void setAllergicIngredients(String? name, {bool willUpdate = true}){
    _selectedAllergicIngredientsList!.add(name);
    if(willUpdate) {
      update();
    }
  }

  void setSelectedAllergicIngredientsIndex(int index, bool notify) {
    if(_selectedAllergicIngredients!.contains(index)) {
      _selectedAllergicIngredientsList!.add(_allergicIngredientsSuggestionList![index]);
      if(notify) {
        update();
      }
    }
  }

  void removeAllergicIngredients(int index) {
    _selectedAllergicIngredientsList!.removeAt(index);
    update();
  }

  Future<void> _getGenericNameSuggestionList() async{
    _genericNameSuggestionList = [];
    _selectedGenericName = [];
    List<String?>? suggestionList = await storeServiceInterface.getGenericNameSuggestionList();
    if(suggestionList != null) {
      _genericNameSuggestionList!.addAll(suggestionList);
      for(int index=0; index<_genericNameSuggestionList!.length; index++){
        _selectedGenericName!.add(index);
      }
    }
    update();
  }

  void setGenericName(String? name, {bool willUpdate = true}){
    _selectedGenericNameList!.add(name);
    if(willUpdate) {
      update();
    }
  }

  void setSelectedGenericNameIndex(int index, bool notify) {
    if(_selectedGenericName!.contains(index)) {
      _selectedGenericNameList!.add(_genericNameSuggestionList![index]);
      if(notify) {
        update();
      }
    }
  }

  void removeGenericName(int index) {
    _selectedGenericNameList!.removeAt(index);
    update();
  }

  Future<bool> stockUpdate(Map<String, String> data, int itemId) async{
    _isLoading = true;
    update();
    Response response = await storeServiceInterface.stockUpdate(data);

    if(response.statusCode == 200) {
      getItemList(offset: '1', type: _type, search: '', categoryId: 0);
      Get.find<StoreController>().getLimitedStockItemList(Get.find<StoreController>().offset.toString(), willUpdate: false);
      Get.back();
    }
    _isLoading = false;
    update();
    return response.statusCode == 200;
  }

  Future<void> getVatTaxList() async {
    List<VatTaxModel>? vatTaxList = await storeServiceInterface.getVatTaxList();
    if(vatTaxList != null) {
      _vatTaxList = [];
      _vatTaxList!.addAll(vatTaxList);
    }
    update();
  }

  void setSelectedVatTax(String? vatTaxName, int? vatTaxId, double? taxRate) {
    if (vatTaxName != null && vatTaxId != null) {
      if (_selectedVatTaxNameList.contains(vatTaxName) || _selectedVatTaxIdList.contains(vatTaxId)) {
        showCustomSnackBar('vat_tax_already_added_please_select_another'.tr);
      } else {
        _selectedVatTaxName = vatTaxName;
        _selectedVatTaxNameList.add(vatTaxName);
        _selectedVatTaxIdList.add(vatTaxId);
        _selectedTaxRateList.add(taxRate ?? 0);
        update();
      }
    }
  }

  void removeVatTax(String vatTaxName, int vatTaxId, double taxRate) {
    _selectedVatTaxName = null;
    _selectedVatTaxNameList.remove(vatTaxName);
    _selectedVatTaxIdList.remove(vatTaxId);
    _selectedTaxRateList.remove(taxRate);
    update();
  }

  void clearVatTax() {
    _selectedVatTaxName = null;
    _selectedVatTaxNameList.clear();
    _selectedVatTaxIdList.clear();
    _selectedTaxRateList.clear();
  }

  void preloadVatTax({required List<int> vatTaxList}) {
    _selectedVatTaxNameList.clear();
    _selectedVatTaxIdList.clear();
    _selectedTaxRateList.clear();
    for (int id in vatTaxList) {
      final VatTaxModel? vatTax = _vatTaxList?.firstWhereOrNull((vat) => vat.id == id);
      if (vatTax != null) {
        _selectedVatTaxNameList.add(vatTax.name!);
        _selectedVatTaxIdList.add(vatTax.id!);
        _selectedTaxRateList.add(vatTax.taxRate ?? 0);
      }
    }
  }

  Future<void> getStoreCategories({bool isUpdate = true}) async {
    if(Get.find<CategoryController>().categoryList == null) {
      await Get.find<CategoryController>().getCategoryList(null);
    }
    _categoryNameList = [];
    _categoryIdList = [];
    _categoryNameList!.add('all');
    _categoryIdList!.add(0);
    if(Get.find<CategoryController>().categoryList != null) {
      for(CategoryModel categoryModel in Get.find<CategoryController>().categoryList!) {
        _categoryNameList!.add(categoryModel.name!);
        _categoryIdList!.add(categoryModel.id!);
      }
    }

    if(isUpdate) {
      update();
    }
  }

  void setCategory({required int index, required String foodType}) {
    _categoryIndex = index;
    _itemList == null;
    _categoryId = _categoryIdList![index];
    getItemList(offset: '1', type: _type, search: '', categoryId: _categoryIndex != 0 ? _categoryIdList![_categoryIndex!] : 0);
    update();
  }

  void setCategoryForSearch({required int index}) {
    _categoryIndex = index;
    _categoryId = _categoryIdList![index];
    update();
  }

  void pickMetaImage() async {
    _pickedMetaImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    update();
  }

  void toggleHalalTag() {
    _isHalalEnabled = !_isHalalEnabled!;
    update();
  }

  void setSelectedDurationInitData(String duration) {
    _selectedDuration = duration;
  }

}