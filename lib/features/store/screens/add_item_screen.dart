import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sixam_mart_store/common/widgets/custom_drop_down_button.dart.dart';
import 'package:sixam_mart_store/common/widgets/custom_dropdown_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_ink_well_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_text_field_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_tool_tip_widget.dart';
import 'package:sixam_mart_store/common/widgets/label_widget.dart';
import 'package:sixam_mart_store/features/addon/controllers/addon_controller.dart';
import 'package:sixam_mart_store/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart_store/features/store/controllers/store_controller.dart';
import 'package:sixam_mart_store/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart_store/features/category/controllers/category_controller.dart';
import 'package:sixam_mart_store/features/store/domain/models/variant_type_model.dart';
import 'package:sixam_mart_store/features/store/domain/models/variation_body_model.dart';
import 'package:sixam_mart_store/features/store/domain/models/attribute_model.dart';
import 'package:sixam_mart_store/common/models/config_model.dart';
import 'package:sixam_mart_store/features/store/domain/models/item_model.dart';
import 'package:sixam_mart_store/helper/type_converter.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/common/widgets/custom_app_bar_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_button_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_image_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_time_picker_widget.dart';
import 'package:sixam_mart_store/features/store/widgets/attribute_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/features/store/widgets/food_variation_view_widget.dart';

class AddItemScreen extends StatefulWidget {
  final Item? item;
  const AddItemScreen({super.key, required this.item});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> with TickerProviderStateMixin {

  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();
  final TextEditingController _maxOrderQuantityController = TextEditingController();
  final FocusNode _priceNode = FocusNode();
  final FocusNode _discountNode = FocusNode();
  TextEditingController _c = TextEditingController();
  TextEditingController _nutritionSuggestionController = TextEditingController();
  TextEditingController _allergicIngredientsSuggestionController = TextEditingController();
  final TextEditingController _genericNameSuggestionController = TextEditingController();
  late bool _update;
  late Item _item;
  final Module? _module = Get.find<SplashController>().configModel!.moduleConfig!.module;
  final isPharmacy = Get.find<ProfileController>().profileModel!.stores![0].module!.moduleType == 'pharmacy';
  final isEcommerce = Get.find<ProfileController>().profileModel!.stores![0].module!.moduleType == 'ecommerce';
  final isGrocery = Get.find<ProfileController>().profileModel!.stores![0].module!.moduleType == 'grocery';
  final isFood = Get.find<SplashController>().getStoreModuleConfig().newVariation!;
  final bool storeHalalActive = Get.find<ProfileController>().profileModel!.stores![0].isHalalActive!;

  final List<TextEditingController> _nameControllerList = [];
  final List<TextEditingController> _descriptionControllerList = [];

  final List<FocusNode> _nameFocusList = [];
  final List<FocusNode> _descriptionFocusList = [];

  final List<Language>? _languageList = Get.find<SplashController>().configModel!.language;

  TabController? _tabController;
  final List<Tab> _tabs =[];

  @override
  void initState() {
    super.initState();

    Get.find<StoreController>().initItemData(item: widget.item, isFood: isFood, isGrocery: isGrocery, isPharmacy: isPharmacy);
    Get.find<CategoryController>().getCategoryList(widget.item);
    if(Get.find<SplashController>().configModel!.systemTaxType == 'product_wise'){
      Get.find<StoreController>().getVatTaxList();
    }
    Get.find<StoreController>().clearVatTax();

    _tabController = TabController(length: _languageList!.length, vsync: this);
    for (var language in _languageList) {
      if (kDebugMode) {
        print(language);
      }
      _nameControllerList.add(TextEditingController());
      _descriptionControllerList.add(TextEditingController());
      _nameFocusList.add(FocusNode());
      _descriptionFocusList.add(FocusNode());
    }

    for (var language in _languageList) {
      _tabs.add(Tab(text: language.value));
    }

    if(widget.item != null) {
      for(int index=0; index<_languageList.length; index++) {
        _nameControllerList.add(TextEditingController(
          text: widget.item!.translations![widget.item!.translations!.length-2].value,
        ));
        _descriptionControllerList.add(TextEditingController(
          text: widget.item!.translations![widget.item!.translations!.length-1].value,
        ));
        _nameFocusList.add(FocusNode());
        _descriptionFocusList.add(FocusNode());
        for (var translation in widget.item!.translations!) {
          if(_languageList[index].key == translation.locale && translation.key == 'name') {
            _nameControllerList[index] = TextEditingController(text: translation.value);
          }else if(_languageList[index].key == translation.locale && translation.key == 'description') {
            _descriptionControllerList[index] = TextEditingController(text: translation.value);
          }
        }
      }
    }else {
      for (var language in _languageList) {
        if (kDebugMode) {
          print(language);
        }
        _nameControllerList.add(TextEditingController());
        _descriptionControllerList.add(TextEditingController());
        _nameFocusList.add(FocusNode());
        _descriptionFocusList.add(FocusNode());
      }
    }

    _update = widget.item != null;
    if(isEcommerce) {
      Get.find<StoreController>().getBrandList(widget.item);
    }
    if(isPharmacy) {
      Get.find<StoreController>().getSuitableTagList(widget.item);
    }
    Get.find<StoreController>().getAttributeList(widget.item);
    Get.find<StoreController>().setTag('', isClear: true);
    if(_update) {
      _item = Item.fromJson(widget.item!.toJson());
      if(_item.tags != null && _item.tags!.isNotEmpty){

        for (var tag in _item.tags!) {
          Get.find<StoreController>().setTag(tag.tag, isUpdate: false);
        }
      }
      _priceController.text = _item.price.toString();
      _discountController.text = _item.discount.toString();
      _stockController.text = _item.stock.toString();
      _maxOrderQuantityController.text = _item.maxOrderQuantity.toString();
      _genericNameSuggestionController.text = (_item.genericName != null && _item.genericName!.isNotEmpty) ? _item.genericName![0]! : '';
      Get.find<StoreController>().setDiscountTypeIndex(_item.discountType == 'percent' ? 0 : 1, false);
      Get.find<StoreController>().setVeg(_item.veg == 1, false);
      Get.find<StoreController>().initSetup();
      Get.find<StoreController>().removeImageFromList();
      if(_item.isHalal == 1) {
        Get.find<StoreController>().toggleHalal(willUpdate: false);
      }
      if(_item.isBasicMedicine == 1) {
        Get.find<StoreController>().toggleBasicMedicine(willUpdate: false);
      }
      if(_item.isPrescriptionRequired == 1) {
        Get.find<StoreController>().togglePrescriptionRequired(willUpdate: false);
      }
      if(Get.find<SplashController>().getStoreModuleConfig().newVariation!) {
        Get.find<StoreController>().setExistingVariation(_item.foodVariations);
      }
    }else {
      _item = Item(imagesFullUrl: []);
      Get.find<StoreController>().setTag('', isUpdate: false, isClear: true);
      Get.find<StoreController>().setEmptyVariationList();
      Get.find<StoreController>().pickImage(false, true);
      Get.find<StoreController>().setVeg(false, false);
      if(Get.find<StoreController>().isHalal) {
        Get.find<StoreController>().toggleHalal(willUpdate: false);
      }
      if(Get.find<StoreController>().isBasicMedicine) {
        Get.find<StoreController>().toggleBasicMedicine(willUpdate: false);
      }
    }
  }

  void _validateDiscount() {
    double price = double.tryParse(_priceController.text) ?? 0.0;
    double discount = double.tryParse(_discountController.text) ?? 0.0;

    if (Get.find<StoreController>().discountTypeIndex == 0) {
      if (discount > 100) {
        showCustomSnackBar('discount_cannot_be_more_than_100'.tr, isError: true);
        _discountController.text = '100';
      }
    } else if (Get.find<StoreController>().discountTypeIndex == 1) {
      if (discount > price) {
        showCustomSnackBar('discount_cannot_be_more_than_price'.tr, isError: true);
        _discountController.text = price.toString();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: CustomAppBarWidget(title: widget.item != null ? 'update_item'.tr : 'add_item'.tr),

      body: SafeArea(
        child: GetBuilder<CategoryController>(builder: (categoryController) {
          return GetBuilder<StoreController>(builder: (storeController) {

            List<DropdownItem<int>> unitList = [];
            if(storeController.unitList != null) {
              for(int i = 0; i<storeController.unitList!.length; i++) {
                unitList.add(DropdownItem<int>(value: i, child: SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(storeController.unitList![i].unit!),
                  ),
                )));
              }
            }

            List<DropdownItem<int>> categoryList = [];
            if(categoryController.categoryList != null) {
              for(int i=0; i<categoryController.categoryList!.length; i++) {
                categoryList.add(DropdownItem<int>(value: i, child: SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(categoryController.categoryList![i].name!),
                  ),
                )));
              }
            }

            List<DropdownItem<int>> subCategoryList = [];
            if(categoryController.subCategoryList != null) {
              for(int i=0; i<categoryController.subCategoryList!.length; i++) {
                subCategoryList.add(DropdownItem<int>(value: i, child: SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(categoryController.subCategoryList![i].name!),
                  ),
                )));
              }
            }

            List<DropdownItem<int>> suitableTagList = [];
            if(storeController.suitableTagList != null) {
              for(int i=0; i<storeController.suitableTagList!.length; i++) {
                suitableTagList.add(DropdownItem<int>(value: i, child: SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(storeController.suitableTagList![i].name!),
                  ),
                )));
              }
            }

            List<DropdownItem<int>> brandList = [];
            if(storeController.brandList != null) {
              for(int i=0; i<storeController.brandList!.length; i++) {
                brandList.add(DropdownItem<int>(value: i, child: SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(storeController.brandList![i].name!),
                  ),
                )));
              }
            }

            List<DropdownItem<int>> discountTypeList = [];
            for(int i=0; i<storeController.discountTypeList.length; i++) {
              discountTypeList.add(DropdownItem<int>(value: i, child: SizedBox(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(storeController.discountTypeList[i]!.tr),
                ),
              )));
            }

            if(_module!.stock! && storeController.variantTypeList!.isNotEmpty) {
              _stockController.text = storeController.totalStock.toString();
            }

            List<int> nutritionSuggestion = [];
            if(storeController.nutritionSuggestionList != null) {
              for(int index = 0; index<storeController.nutritionSuggestionList!.length; index++) {
                nutritionSuggestion.add(index);
              }
            }

            List<int> allergicIngredientsSuggestion = [];
            if(storeController.allergicIngredientsSuggestionList != null) {
              for(int index = 0; index<storeController.allergicIngredientsSuggestionList!.length; index++) {
                allergicIngredientsSuggestion.add(index);
              }
            }

            List<int> genericNameSuggestion = [];
            if(storeController.genericNameSuggestionList != null) {
              for(int index = 0; index<storeController.genericNameSuggestionList!.length; index++) {
                genericNameSuggestion.add(index);
              }
            }

            if(_update){
              if (storeController.vatTaxList != null && storeController.selectedVatTaxIdList.isEmpty && widget.item!.taxVatIds != null && widget.item!.taxVatIds!.isNotEmpty) {
                storeController.preloadVatTax(vatTaxList: widget.item!.taxVatIds!);
              }
            }

            return (storeController.attributeList != null && categoryController.categoryList != null /*&& (widget.item != null ? categoryController.subCategoryList != null : true)*/) ? Column(children: [

              Expanded(child: SingleChildScrollView(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                physics: const BouncingScrollPhysics(),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                  Text('item_info'.tr, style: robotoMedium),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeSmall),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
                    ),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                      SizedBox(
                        height: 40,
                        child: TabBar(
                          tabAlignment: TabAlignment.start,
                          controller: _tabController,
                          indicatorColor: Theme.of(context).primaryColor,
                          indicatorWeight: 3,
                          labelColor: Theme.of(context).primaryColor,
                          unselectedLabelColor: Theme.of(context).disabledColor,
                          unselectedLabelStyle: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall),
                          labelStyle: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).primaryColor),
                          labelPadding: const EdgeInsets.only(right: Dimensions.radiusDefault),
                          isScrollable: true,
                          indicatorSize: TabBarIndicatorSize.tab,
                          dividerColor: Colors.transparent,
                          tabs: _tabs,
                          onTap: (int ? value) {
                            setState(() {});
                          },
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(bottom: Dimensions.paddingSizeLarge),
                        child: Divider(height: 0),
                      ),

                      Text('insert_language_wise_item_name_and_description'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor)),
                      const SizedBox(height: Dimensions.paddingSizeDefault),

                      CustomTextFieldWidget(
                        hintText: 'name'.tr,
                        labelText: 'name'.tr,
                        controller: _nameControllerList[_tabController!.index],
                        capitalization: TextCapitalization.words,
                        focusNode: _nameFocusList[_tabController!.index],
                        nextFocus: _tabController!.index != _languageList!.length-1 ? _descriptionFocusList[_tabController!.index] : _descriptionFocusList[0],
                        showTitle: false,
                      ),
                      const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                      CustomTextFieldWidget(
                        hintText: 'description'.tr,
                        labelText: 'description'.tr,
                        controller: _descriptionControllerList[_tabController!.index],
                        focusNode: _descriptionFocusList[_tabController!.index],
                        capitalization: TextCapitalization.sentences,
                        maxLines: 3,
                        inputAction: _tabController!.index != _languageList.length-1 ? TextInputAction.next : TextInputAction.done,
                        nextFocus: _tabController!.index != _languageList.length-1 ? _nameFocusList[_tabController!.index + 1] : null,
                        showTitle: false,
                      ),

                    ]),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  Text('item_setup'.tr, style: robotoBold),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeDefault),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
                    ),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          color: Theme.of(context).cardColor,
                          border: Border.all(color: Theme.of(context).disabledColor.withValues(alpha: 0.5)),
                        ),
                        child: CustomDropdown(
                          onChange: (int? value, int index) {
                            categoryController.setCategoryIndex(value!, true);
                            categoryController.getSubCategoryList(categoryController.categoryList![categoryController.categoryIndex!].id, null);
                          },
                          dropdownButtonStyle: DropdownButtonStyle(
                            height: 45,
                            padding: const EdgeInsets.symmetric(
                              vertical: Dimensions.paddingSizeExtraSmall,
                              horizontal: Dimensions.paddingSizeExtraSmall,
                            ),
                            primaryColor: Theme.of(context).textTheme.bodyLarge!.color,
                          ),
                          iconColor: Theme.of(context).disabledColor,
                          dropdownStyle: DropdownStyle(
                            elevation: 10,
                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                            padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                          ),
                          items: categoryList,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(
                              widget.item != null && categoryController.categoryIndex != null ? categoryController.categoryList![categoryController.categoryIndex!].name! : 'category'.tr,
                              style: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeLarge),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                      categoryController.subCategoryList != null && categoryController.subCategoryList!.isNotEmpty ? Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          color: Theme.of(context).cardColor,
                          border: Border.all(color: Theme.of(context).disabledColor.withValues(alpha: 0.5)),
                        ),
                        child: CustomDropdown(
                          onChange: (int? value, int index) {
                            categoryController.setSubCategoryIndex(value!, true);
                          },
                          dropdownButtonStyle: DropdownButtonStyle(
                            height: 45,
                            padding: const EdgeInsets.symmetric(
                              vertical: Dimensions.paddingSizeExtraSmall,
                              horizontal: Dimensions.paddingSizeExtraSmall,
                            ),
                            primaryColor: Theme.of(context).textTheme.bodyLarge!.color,
                          ),
                          iconColor: Theme.of(context).disabledColor,
                          dropdownStyle: DropdownStyle(
                            elevation: 10,
                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                            padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                          ),
                          items: subCategoryList,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(
                              widget.item != null && categoryController.subCategoryIndex != null ? categoryController.subCategoryList![categoryController.subCategoryIndex!].name! : 'sub_category'.tr,
                              style: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeLarge),
                            ),
                          ),
                        ),
                      ) : const SizedBox(),
                      SizedBox(height: categoryController.subCategoryList != null && categoryController.subCategoryList!.isNotEmpty ? Dimensions.paddingSizeExtraLarge : 0),

                      isPharmacy ? Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          color: Theme.of(context).cardColor,
                          border: Border.all(color: Theme.of(context).disabledColor.withValues(alpha: 0.5)),
                        ),
                        child: CustomDropdown(
                          onChange: (int? value, int index) {
                            storeController.setSuitableTagIndex(value!, true);
                          },
                          dropdownButtonStyle: DropdownButtonStyle(
                            height: 45,
                            padding: const EdgeInsets.symmetric(
                              vertical: Dimensions.paddingSizeExtraSmall,
                              horizontal: Dimensions.paddingSizeExtraSmall,
                            ),
                            primaryColor: Theme.of(context).textTheme.bodyLarge!.color,
                          ),
                          iconColor: Theme.of(context).disabledColor,
                          dropdownStyle: DropdownStyle(
                            elevation: 10,
                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                            padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                          ),
                          items: suitableTagList,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(
                              widget.item != null && storeController.suitableTagIndex != null ? storeController.suitableTagList![storeController.suitableTagIndex!].name! : 'suitable_for'.tr,
                              style: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeLarge),
                            ),
                          ),
                        ),
                      ) : const SizedBox(),
                      SizedBox(height: isPharmacy ? Dimensions.paddingSizeExtraLarge : 0),

                      isEcommerce ? Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          color: Theme.of(context).cardColor,
                          border: Border.all(color: Theme.of(context).disabledColor.withValues(alpha: 0.5)),
                        ),
                        child: CustomDropdown(
                          onChange: (int? value, int index) {
                            storeController.setBrandIndex(value!, true);
                          },
                          dropdownButtonStyle: DropdownButtonStyle(
                            height: 45,
                            padding: const EdgeInsets.symmetric(
                              vertical: Dimensions.paddingSizeExtraSmall,
                              horizontal: Dimensions.paddingSizeExtraSmall,
                            ),
                            primaryColor: Theme.of(context).textTheme.bodyLarge!.color,
                          ),
                          iconColor: Theme.of(context).disabledColor,
                          dropdownStyle: DropdownStyle(
                            elevation: 10,
                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                            padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                          ),
                          items: brandList,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(
                              widget.item != null && storeController.brandIndex != null ? storeController.brandList![storeController.brandIndex!].name! : 'brand'.tr,
                              style: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeLarge),
                            ),
                          ),
                        ),
                      ) : const SizedBox(),
                      SizedBox(height: isEcommerce ? Dimensions.paddingSizeExtraLarge : 0),

                      isPharmacy ? Column(children: [
                        Row(children: [
                          Expanded(
                            child: Autocomplete<int>(
                              optionsBuilder: (TextEditingValue value) {
                                if(value.text.isEmpty) {
                                  return const Iterable<int>.empty();
                                }else {
                                  return genericNameSuggestion.where((genericName) => storeController.genericNameSuggestionList![genericName]!.toLowerCase().contains(value.text.toLowerCase()));
                                }
                              },
                              optionsViewBuilder: (context, onAutoCompleteSelect, options) {
                                List<int> result = TypeConverter.convertIntoListOfInteger(options.toString());

                                return Align(
                                  alignment: Alignment.topLeft,
                                  child: Material(
                                    color: Theme.of(context).primaryColorLight,
                                    elevation: 4.0,
                                    child: Container(
                                      color: Theme.of(context).cardColor,
                                      width: MediaQuery.of(context).size.width - 110,
                                      child: ListView.separated(
                                        shrinkWrap: true,
                                        padding: const EdgeInsets.all(8.0),
                                        itemCount: result.length,
                                        separatorBuilder: (context, i) {
                                          return const Divider(height: 0,);
                                        },
                                        itemBuilder: (BuildContext context, int index) {
                                          return CustomInkWellWidget(
                                            onTap: () {
                                              if(storeController.selectedGenericNameList!.length > 1) {
                                              }else {
                                                _genericNameSuggestionController.text = storeController.genericNameSuggestionList![result[index]]!;
                                                storeController.setSelectedGenericNameIndex(result[index], true);
                                              }
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                                              child: Text(storeController.genericNameSuggestionList![result[index]]!),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              },
                              fieldViewBuilder: (context, genericNameController, node, onComplete) {
                                genericNameController.text = _genericNameSuggestionController.text;
                                return Container(
                                  height: 50,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
                                  child: TextField(
                                    controller: genericNameController,
                                    focusNode: node,
                                    onEditingComplete: () {
                                      node.unfocus();
                                      _genericNameSuggestionController.text = genericNameController.text;
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'generic_name'.tr,
                                      labelText: 'generic_name'.tr,
                                      hintStyle: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).disabledColor),
                                      labelStyle : robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).disabledColor),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                        borderSide: BorderSide(color: Theme.of(context).disabledColor.withValues(alpha: 0.5)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                        borderSide: BorderSide(color: Theme.of(context).disabledColor.withValues(alpha: 0.5)),
                                      ),
                                      suffixIcon: CustomToolTip(
                                        message: 'specify_the_medicine_active_ingredient_that_makes_it_work'.tr,
                                        preferredDirection: AxisDirection.up,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              displayStringForOption: (value) => storeController.genericNameSuggestionList![value]!,
                              onSelected: (int value) {
                                if(storeController.selectedGenericNameList!.length > 1) {
                                }else {
                                  _genericNameSuggestionController.text = storeController.genericNameSuggestionList![value]!;
                                  storeController.setSelectedGenericNameIndex(value, true);
                                }
                              },
                            ),
                          ),
                        ]),
                      ]) : const SizedBox(),
                      SizedBox(height: isPharmacy ? Dimensions.paddingSizeExtraLarge : 0),

                      isFood || isGrocery ? Column(children: [
                        Row(children: [
                          Expanded(
                            flex: 8,
                            child: Autocomplete<int>(
                              optionsBuilder: (TextEditingValue value) {
                                if(value.text.isEmpty) {
                                  return const Iterable<int>.empty();
                                }else {
                                  return nutritionSuggestion.where((nutrition) => storeController.nutritionSuggestionList![nutrition]!.toLowerCase().contains(value.text.toLowerCase()));
                                }
                              },
                              optionsViewBuilder: (context, onAutoCompleteSelect, options) {
                                List<int> result = TypeConverter.convertIntoListOfInteger(options.toString());

                                return Align(
                                  alignment: Alignment.topLeft,
                                  child: Material(
                                    color: Theme.of(context).primaryColorLight,
                                    elevation: 4.0,
                                    child: Container(
                                        color: Theme.of(context).cardColor,
                                        width: MediaQuery.of(context).size.width - 110,
                                        child: ListView.separated(
                                          shrinkWrap: true,
                                          padding: const EdgeInsets.all(8.0),
                                          itemCount: result.length,
                                          separatorBuilder: (context, i) {
                                            return const Divider(height: 0,);
                                          },
                                          itemBuilder: (BuildContext context, int index) {
                                            return CustomInkWellWidget(
                                              onTap: () {
                                                if(storeController.selectedNutritionList!.length >= 5) {
                                                  showCustomSnackBar('you_can_select_or_add_maximum_5_nutrition'.tr, isError: true);
                                                }else {
                                                  _nutritionSuggestionController.text = '';
                                                  storeController.setSelectedNutritionIndex(result[index], true);
                                                }
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                                                child: Text(storeController.nutritionSuggestionList![result[index]]!),
                                              ),
                                            );
                                          },
                                        )
                                    ),
                                  ),
                                );
                              },
                              fieldViewBuilder: (context, controller, node, onComplete) {
                                _nutritionSuggestionController = controller;
                                return Container(
                                  height: 50,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
                                  child: TextField(
                                    controller: controller,
                                    focusNode: node,
                                    onEditingComplete: () {
                                      onComplete();
                                      controller.text = '';
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'type_and_click_add_button'.tr,
                                      labelText: 'nutrition'.tr,
                                      hintStyle: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).disabledColor),
                                      labelStyle : robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).disabledColor),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                        borderSide: BorderSide(color: Theme.of(context).disabledColor.withValues(alpha: 0.5)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                        borderSide: BorderSide(color: Theme.of(context).disabledColor.withValues(alpha: 0.5)),
                                      ),
                                      suffixIcon: CustomToolTip(
                                        message: 'specify_the_necessary_keywords_relating_to_energy_values_for_the_item'.tr,
                                        preferredDirection: AxisDirection.up,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              displayStringForOption: (value) => storeController.nutritionSuggestionList![value]!,
                              onSelected: (int value) {
                                if(storeController.selectedNutritionList!.length >= 5) {
                                  showCustomSnackBar('you_can_select_or_add_maximum_5_nutrition'.tr, isError: true);
                                }else {
                                  _nutritionSuggestionController.text = '';
                                  storeController.setSelectedNutritionIndex(value, true);
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: Dimensions.paddingSizeSmall),

                          Expanded(
                            flex: 2,
                            child: CustomButtonWidget(buttonText: 'add'.tr, onPressed: (){
                              if(storeController.selectedNutritionList!.length >= 5) {
                                showCustomSnackBar('you_can_select_or_add_maximum_5_nutrition'.tr, isError: true);
                              }else{
                                if(_nutritionSuggestionController.text.isNotEmpty) {
                                  storeController.setNutrition(_nutritionSuggestionController.text.trim());
                                  _nutritionSuggestionController.text = '';
                                }
                              }
                            }),
                          ),
                        ]),
                        SizedBox(height: storeController.selectedNutritionList != null ? Dimensions.paddingSizeSmall : 0),

                        storeController.selectedNutritionList != null ? SizedBox(
                          height: storeController.selectedNutritionList!.isNotEmpty ? 40 : 0,
                          child: ListView.builder(
                            itemCount: storeController.selectedNutritionList!.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Container(
                                padding: const EdgeInsets.only(left: Dimensions.paddingSizeExtraSmall),
                                margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).disabledColor.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                ),
                                child: Row(children: [

                                  Text(
                                    storeController.selectedNutritionList![index]!,
                                    style: robotoRegular.copyWith(color: Theme.of(context).disabledColor.withValues(alpha: 0.7)),
                                  ),

                                  InkWell(
                                    onTap: () => storeController.removeNutrition(index),
                                    child: Padding(
                                      padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                      child: Icon(Icons.close, size: 15, color: Theme.of(context).disabledColor.withValues(alpha: 0.7)),
                                    ),
                                  ),

                                ]),
                              );
                            },
                          ),
                        ) : const SizedBox(),
                      ]) : const SizedBox(),
                      SizedBox(height: isFood || isGrocery ? Dimensions.paddingSizeDefault : 0),

                      isFood || isGrocery ? Column(children: [
                        Row(children: [
                          Expanded(
                            flex: 8,
                            child: Autocomplete<int>(
                              optionsBuilder: (TextEditingValue value) {
                                if(value.text.isEmpty) {
                                  return const Iterable<int>.empty();
                                }else {
                                  return allergicIngredientsSuggestion.where((allergicIngredients) => storeController.allergicIngredientsSuggestionList![allergicIngredients]!.toLowerCase().contains(value.text.toLowerCase()));
                                }
                              },
                              optionsViewBuilder: (context, onAutoCompleteSelect, options) {
                                List<int> result = TypeConverter.convertIntoListOfInteger(options.toString());

                                return Align(
                                  alignment: Alignment.topLeft,
                                  child: Material(
                                    color: Theme.of(context).primaryColorLight,
                                    elevation: 4.0,
                                    child: Container(
                                        color: Theme.of(context).cardColor,
                                        width: MediaQuery.of(context).size.width - 110,
                                        child: ListView.separated(
                                          shrinkWrap: true,
                                          padding: const EdgeInsets.all(8.0),
                                          itemCount: result.length,
                                          separatorBuilder: (context, i) {
                                            return const Divider(height: 0,);
                                          },
                                          itemBuilder: (BuildContext context, int index) {
                                            return CustomInkWellWidget(
                                              onTap: () {
                                                if(storeController.selectedAllergicIngredientsList!.length >= 5) {
                                                  showCustomSnackBar('you_can_select_or_add_maximum_5_allergic_ingredients'.tr, isError: true);
                                                }else {
                                                  _allergicIngredientsSuggestionController.text = '';
                                                  storeController.setSelectedAllergicIngredientsIndex(result[index], true);
                                                }
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                                                child: Text(storeController.allergicIngredientsSuggestionList![result[index]]!),
                                              ),
                                            );
                                          },
                                        )
                                    ),
                                  ),
                                );
                              },
                              fieldViewBuilder: (context, controller, node, onComplete) {
                                _allergicIngredientsSuggestionController = controller;
                                return Container(
                                  height: 50,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
                                  child: TextField(
                                    controller: controller,
                                    focusNode: node,
                                    onEditingComplete: () {
                                      onComplete();
                                      controller.text = '';
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'type_and_click_add_button'.tr,
                                      labelText: 'allergic_ingredients'.tr,
                                      hintStyle: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).disabledColor),
                                      labelStyle : robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).disabledColor),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                        borderSide: BorderSide(color: Theme.of(context).disabledColor.withValues(alpha: 0.5)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                        borderSide: BorderSide(color: Theme.of(context).disabledColor.withValues(alpha: 0.5)),
                                      ),
                                      suffixIcon: CustomToolTip(
                                        message: 'specify_the_ingredients_of_the_item_which_can_make_a_reaction_as_an_allergen'.tr,
                                        preferredDirection: AxisDirection.up,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              displayStringForOption: (value) => storeController.allergicIngredientsSuggestionList![value]!,
                              onSelected: (int value) {
                                if(storeController.selectedAllergicIngredientsList!.length >= 5) {
                                  showCustomSnackBar('you_can_select_or_add_maximum_5_allergic_ingredients'.tr, isError: true);
                                }else {
                                  _allergicIngredientsSuggestionController.text = '';
                                  storeController.setSelectedAllergicIngredientsIndex(value, true);
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: Dimensions.paddingSizeSmall),

                          Expanded(
                            flex: 2,
                            child: CustomButtonWidget(buttonText: 'add'.tr, onPressed: (){
                              if(storeController.selectedAllergicIngredientsList!.length >= 5) {
                                showCustomSnackBar('you_can_select_or_add_maximum_5_allergic_ingredients'.tr, isError: true);
                              }else{
                                if(_allergicIngredientsSuggestionController.text.isNotEmpty) {
                                  storeController.setAllergicIngredients(_allergicIngredientsSuggestionController.text.trim());
                                  _allergicIngredientsSuggestionController.text = '';
                                }
                              }
                            }),
                          ),
                        ]),
                        SizedBox(height: storeController.selectedAllergicIngredientsList != null ? Dimensions.paddingSizeSmall : 0),

                        storeController.selectedAllergicIngredientsList != null ? SizedBox(
                          height: storeController.selectedAllergicIngredientsList!.isNotEmpty ? 40 : 0,
                          child: ListView.builder(
                            itemCount: storeController.selectedAllergicIngredientsList!.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Container(
                                padding: const EdgeInsets.only(left: Dimensions.paddingSizeExtraSmall),
                                margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).disabledColor.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                ),
                                child: Row(children: [

                                  Text(
                                    storeController.selectedAllergicIngredientsList![index]!,
                                    style: robotoRegular.copyWith(color: Theme.of(context).disabledColor.withValues(alpha: 0.7)),
                                  ),

                                  InkWell(
                                    onTap: () => storeController.removeAllergicIngredients(index),
                                    child: Padding(
                                      padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                      child: Icon(Icons.close, size: 15, color: Theme.of(context).disabledColor.withValues(alpha: 0.7)),
                                    ),
                                  ),

                                ]),
                              );
                            },
                          ),
                        ) : const SizedBox(),
                      ]) : const SizedBox(),
                      SizedBox(height: isFood || isGrocery ? Dimensions.paddingSizeDefault : 0),

                      (_module.vegNonVeg! && Get.find<SplashController>().configModel!.toggleVegNonVeg!) ? LabelWidget(
                        labelText: 'food_type'.tr,
                        child: Row(children: [

                          Expanded(
                            child: Row(children: [

                              Radio(
                                value: 'veg',
                                groupValue: storeController.isVeg ? 'veg' : 'non_veg',
                                onChanged: (String? value) => storeController.setVeg(value == 'veg', true),
                                fillColor: WidgetStateProperty.all<Color>(
                                  storeController.isVeg ? Theme.of(context).primaryColor : Theme.of(context).disabledColor,
                                ),
                              ),

                              Text(
                                'veg'.tr, style: robotoMedium.copyWith(
                                  fontSize: Dimensions.fontSizeSmall, color: storeController.isVeg ? Theme.of(context).textTheme.bodyLarge?.color : Theme.of(context).disabledColor),
                              ),

                            ]),
                          ),

                          Expanded(
                            child: Row(children: [

                              Radio(
                                value: 'non_veg',
                                groupValue: storeController.isVeg ? 'veg' : 'non_veg',
                                onChanged: (String? value) => storeController.setVeg(value == 'veg', true),
                                fillColor: WidgetStateProperty.all<Color>(
                                  storeController.isVeg ? Theme.of(context).disabledColor : Theme.of(context).primaryColor,
                                ),
                              ),

                              Text(
                                'non_veg'.tr, style: robotoMedium.copyWith(
                                  fontSize: Dimensions.fontSizeSmall, color: storeController.isVeg ? Theme.of(context).disabledColor : Theme.of(context).textTheme.bodyLarge?.color),
                              ),

                            ]),
                          ),

                        ]),
                      )  : const SizedBox(),

                      SizedBox(height: (_module.vegNonVeg! && Get.find<SplashController>().configModel!.toggleVegNonVeg!) ? Dimensions.paddingSizeExtraLarge : 0),

                      (isFood || isGrocery) && storeHalalActive ? LabelWidget(
                        labelText: 'halal_tag'.tr,
                        padding: const EdgeInsets.only(
                          left: Dimensions.paddingSizeDefault, top: Dimensions.paddingSizeExtraSmall, bottom: Dimensions.paddingSizeExtraSmall,
                        ),
                        child: Row(children: [

                          Expanded(child: Text('status'.tr, style: robotoMedium)),

                          Transform.scale(
                            scale: 0.7,
                            child: CupertinoSwitch(
                              value: storeController.isHalal,
                              onChanged: (bool isChecked) => storeController.toggleHalal(),
                              activeTrackColor: Theme.of(context).primaryColor,
                            ),
                          ),

                        ]),
                      ) : const SizedBox(),

                      isPharmacy ? LabelWidget(
                        labelText: 'basic_medicine'.tr,
                        padding: const EdgeInsets.only(
                          left: Dimensions.paddingSizeDefault, top: Dimensions.paddingSizeExtraSmall, bottom: Dimensions.paddingSizeExtraSmall,
                        ),
                        child: Row(children: [

                          Expanded(child: Text('status'.tr, style: robotoMedium)),

                          Transform.scale(
                            scale: 0.7,
                            child: CupertinoSwitch(
                              value: storeController.isBasicMedicine,
                              onChanged: (bool? isChecked) => storeController.toggleBasicMedicine(),
                              activeTrackColor: Theme.of(context).primaryColor,
                            ),
                          ),

                        ]),
                      ) : const SizedBox(),
                      SizedBox(height: isPharmacy ? Dimensions.paddingSizeExtraLarge : 0),

                      Get.find<SplashController>().configModel!.systemTaxType == 'product_wise' ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        CustomDropdownButton(
                        dropdownMenuItems: storeController.vatTaxList?.map((e) {
                          bool isInVatTaxList = storeController.selectedVatTaxNameList.contains(e.name);
                          return DropdownMenuItem<String>(
                            value: e.name,
                            child: Row(
                              children: [
                                Text('${e.name!} (${e.taxRate}%)', style: robotoRegular),
                                const Spacer(),
                                if (isInVatTaxList)
                                  const Icon(Icons.check, color: Colors.green),
                              ],
                            ),
                          );
                        }).toList(),
                        showTitle: false,
                        hintText: 'select_vat_tax'.tr,
                        onChanged: (String? value) {
                          final selectedVatTax = storeController.vatTaxList?.firstWhere((vatTax) => vatTax.name == value);
                          if (selectedVatTax != null) {
                            storeController.setSelectedVatTax(selectedVatTax.name, selectedVatTax.id, selectedVatTax.taxRate);
                          }
                        },
                        selectedValue: storeController.selectedVatTaxName,
                      ),
                      SizedBox(height: storeController.selectedVatTaxNameList.isNotEmpty ? Dimensions.paddingSizeSmall : 0),

                      Wrap(
                        children: List.generate(storeController.selectedVatTaxNameList.length, (index) {
                          final vatTaxName = storeController.selectedVatTaxNameList[index];
                          final vatTaxId = storeController.selectedVatTaxIdList[index];
                          final taxRate = storeController.selectedTaxRateList[index];
                          return Padding(
                            padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                            child: Stack(clipBehavior: Clip.none, children: [
                              FilterChip(
                                label: Text('$vatTaxName ($taxRate%)'),
                                selected: false,
                                onSelected: (bool value) {},
                              ),

                              Positioned(
                                right: -5,
                                top: 0,
                                child: InkWell(
                                  onTap: () {
                                    storeController.removeVatTax(vatTaxName, vatTaxId, taxRate);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(1),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.red, width: 1),
                                    ),
                                    child: const Icon(Icons.close, size: 15, color: Colors.red),
                                  ),
                                ),
                              ),
                            ]),
                          );
                        }),
                      ),
                    ]) : const SizedBox(),

                    ]),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  isPharmacy ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('prescription_required'.tr, style: robotoBold),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault - 2),
                        boxShadow:const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
                      ),
                      child: ListTile(
                        onTap: () => storeController.togglePrescriptionRequired(),
                        leading: Checkbox(
                          activeColor: Theme.of(context).primaryColor,
                          value: storeController.isPrescriptionRequired,
                          onChanged: (bool? isChecked) => storeController.togglePrescriptionRequired(),
                        ),
                        title: Text('this_item_need_prescription_to_place_order'.tr, style: robotoMedium),
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        horizontalTitleGap: 0,
                      ),
                    ),
                  ]) : const SizedBox(),
                  SizedBox(height: isPharmacy ? Dimensions.paddingSizeDefault : 0),

                  Text('price_info'.tr, style: robotoBold),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeDefault),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
                    ),
                    child: Column(
                      children: [

                        CustomTextFieldWidget(
                          hintText: 'price'.tr,
                          labelText: 'price'.tr,
                          controller: _priceController,
                          focusNode: _priceNode,
                          nextFocus: _discountNode,
                          isAmount: true,
                        ),
                        const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                        Row(children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                color: Theme.of(context).cardColor,
                                border: Border.all(color: Theme.of(context).disabledColor.withValues(alpha: 0.5)),
                              ),
                              child: CustomDropdown(
                                onChange: (int? value, int index) {
                                  storeController.setDiscountTypeIndex(value!, true);
                                  _validateDiscount();
                                },
                                dropdownButtonStyle: DropdownButtonStyle(
                                  height: 45,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: Dimensions.paddingSizeExtraSmall,
                                    horizontal: Dimensions.paddingSizeExtraSmall,
                                  ),
                                  primaryColor: Theme.of(context).textTheme.bodyLarge!.color,
                                ),
                                iconColor: Theme.of(context).disabledColor,
                                dropdownStyle: DropdownStyle(
                                  elevation: 10,
                                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                  padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                ),
                                items: discountTypeList,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Text(
                                    widget.item != null ? storeController.discountTypeList[storeController.discountTypeIndex]!.tr : 'discount_type'.tr,
                                    style: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeLarge),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: Dimensions.paddingSizeDefault),

                          Expanded(
                            child: CustomTextFieldWidget(
                              hintText: 'discount'.tr,
                              labelText: 'discount'.tr,
                              controller: _discountController,
                              focusNode: _discountNode,
                              isAmount: true,
                              onChanged: (value) => _validateDiscount(),
                            ),
                          ),
                        ]),
                        const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                        CustomTextFieldWidget(
                          hintText: 'maximum_order_quantity'.tr,
                          labelText: 'maximum_order_quantity'.tr,
                          controller: _maxOrderQuantityController,
                          isNumber: true,
                        ),
                        SizedBox(height: (_module.stock! || _module.unit!) ? Dimensions.paddingSizeExtraLarge : 0),

                        (_module.stock! || _module.unit!) ? Row(children: [
                          _module.stock! ? Expanded(child: CustomTextFieldWidget(
                            hintText: 'total_stock'.tr,
                            labelText: 'total_stock'.tr,
                            controller: _stockController,
                            isNumber: true,
                            isEnabled: storeController.variantTypeList!.isEmpty,
                          )) : const SizedBox(),
                          SizedBox(width: _module.stock! ? Dimensions.paddingSizeSmall : 0),

                          _module.unit! ? Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                color: Theme.of(context).cardColor,
                                border: Border.all(color: Theme.of(context).disabledColor.withValues(alpha: 0.5)),
                              ),
                              child: CustomDropdown(
                                onChange: (int? value, int index) {
                                  storeController.setUnitIndex(value!, true);
                                },
                                dropdownButtonStyle: DropdownButtonStyle(
                                  height: 45,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: Dimensions.paddingSizeExtraSmall,
                                    horizontal: Dimensions.paddingSizeExtraSmall,
                                  ),
                                  primaryColor: Theme.of(context).textTheme.bodyLarge!.color,
                                ),
                                iconColor: Theme.of(context).disabledColor,
                                dropdownStyle: DropdownStyle(
                                  elevation: 10,
                                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                  padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                ),
                                items: unitList,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Text(
                                    widget.item != null && storeController.unitList != null ? storeController.unitList![storeController.unitIndex!].unit!.tr : 'unit'.tr,
                                    style: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeLarge),
                                  ),
                                ),
                              ),
                            ),
                          ) : const SizedBox(),

                        ]) : const SizedBox(),

                      ],
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  Get.find<SplashController>().getStoreModuleConfig().newVariation! ? FoodVariationViewWidget(
                    storeController: storeController, item: widget.item,
                  ) : AttributeViewWidget(storeController: storeController, product: widget.item),

                  _module.addOn! ? Text('addons'.tr, style: robotoBold) : const SizedBox(),
                  SizedBox(height: _module.addOn! ? Dimensions.paddingSizeSmall : 0),

                  _module.addOn! ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeLarge),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
                    ),
                    child: Column(
                      children: [
                        _module.addOn! ? GetBuilder<AddonController>(builder: (addonController) {
                          List<int> addons = [];
                          if(addonController.addonList != null) {
                            for(int index=0; index<addonController.addonList!.length; index++) {
                              if(addonController.addonList![index].status == 1 && !storeController.selectedAddons!.contains(index)) {
                                addons.add(index);
                              }
                            }
                          }
                          return Autocomplete<int>(
                            optionsBuilder: (TextEditingValue value) {
                              if(value.text.isEmpty) {
                                return const Iterable<int>.empty();
                              }else {
                                return addons.where((addon) => addonController.addonList![addon].name!.toLowerCase().contains(value.text.toLowerCase()));
                              }
                            },
                            fieldViewBuilder: (context, controller, node, onComplete) {
                              _c = controller;
                              return SizedBox(
                                height: 50,
                                child: CustomTextFieldWidget(
                                  controller: controller,
                                  focusNode: node,
                                  hintText: 'addons'.tr,
                                  labelText: 'addons'.tr,
                                  onEditingComplete: () {
                                    onComplete();
                                    controller.text = '';
                                  },
                                ),
                              );
                            },
                            displayStringForOption: (value) => addonController.addonList![value].name!,
                            onSelected: (int value) {
                              _c.text = '';
                              storeController.setSelectedAddonIndex(value, true);
                              //_addons.removeAt(value);
                            },
                          );
                        }) : const SizedBox(),
                        SizedBox(height: (_module.addOn! && storeController.selectedAddons!.isNotEmpty) ? Dimensions.paddingSizeSmall : 0),

                        _module.addOn! ? SizedBox(
                          height: storeController.selectedAddons!.isNotEmpty ? 40 : 0,
                          child: ListView.builder(
                            itemCount: storeController.selectedAddons!.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Container(
                                padding: const EdgeInsets.only(left: Dimensions.paddingSizeExtraSmall),
                                margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).disabledColor.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                ),
                                child: Row(children: [
                                  GetBuilder<AddonController>(builder: (addonController) {
                                    return Text(
                                      addonController.addonList![storeController.selectedAddons![index]].name!,
                                      style: robotoRegular.copyWith(color: Theme.of(context).disabledColor.withValues(alpha: 0.7)),
                                    );
                                  }),
                                  InkWell(
                                    onTap: () => storeController.removeAddon(index),
                                    child: Padding(
                                      padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                      child: Icon(Icons.close, size: 15, color: Theme.of(context).disabledColor.withValues(alpha: 0.7),),
                                    ),
                                  ),
                                ]),
                              );
                            },
                          ),
                        ) : const SizedBox(),
                      ],
                    ),
                  ) : const SizedBox(),
                  SizedBox(height: _module.addOn! ? Dimensions.paddingSizeDefault : 0),

                  Text('tag'.tr, style: robotoBold),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeLarge),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
                    ),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                      Row(children: [

                        Expanded(
                          flex: 8,
                          child: CustomTextFieldWidget(
                            hintText: 'tag'.tr,
                            labelText: 'tag'.tr,
                            controller: _tagController,
                            inputAction: TextInputAction.done,
                            onSubmit: (name){
                              if(name != null && name.isNotEmpty) {
                                storeController.setTag(name);
                                _tagController.text = '';
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: Dimensions.paddingSizeSmall),

                        Expanded(
                          flex: 2,
                          child: CustomButtonWidget(buttonText: 'add'.tr, onPressed: (){
                            if(_tagController.text != '' && _tagController.text.isNotEmpty) {
                              storeController.setTag(_tagController.text.trim());
                              _tagController.text = '';
                            }
                          }),
                        ),

                      ]),
                      const SizedBox(height: Dimensions.paddingSizeDefault),

                      storeController.tagList.isNotEmpty ? SizedBox(
                        height: 40,
                        child: ListView.builder(
                          shrinkWrap: true, scrollDirection: Axis.horizontal,
                          itemCount: storeController.tagList.length,
                          itemBuilder: (context, index){
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                              decoration: BoxDecoration(color: Theme.of(context).disabledColor.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
                              child: Center(child: Row(children: [
                                Text(storeController.tagList[index]!, style: robotoRegular.copyWith(color: Theme.of(context).disabledColor.withValues(alpha: 0.7))),
                                const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                                InkWell(onTap: () => storeController.removeTag(index), child: Icon(Icons.clear, size: 18, color: Theme.of(context).disabledColor.withValues(alpha: 0.7))),
                              ])),
                            );
                          }),
                      ) : const SizedBox(),
                    ]),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  _module.itemAvailableTime! ? Text('availability'.tr, style: robotoBold) : const SizedBox(),
                  SizedBox(height: _module.itemAvailableTime! ? Dimensions.paddingSizeSmall : 0),

                  _module.itemAvailableTime! ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeLarge),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
                    ),
                    child: Column(children: [

                      CustomTimePickerWidget(
                        title: 'available_time_starts'.tr, time: _item.availableTimeStarts,
                        onTimeChanged: (time) => _item.availableTimeStarts = time,
                      ),
                      const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                      CustomTimePickerWidget(
                        title: 'available_time_ends'.tr, time: _item.availableTimeEnds,
                        onTimeChanged: (time) => _item.availableTimeEnds = time,
                      ),

                    ]),
                  ) : const SizedBox(),
                  SizedBox(height: _module.itemAvailableTime! ? Dimensions.paddingSizeDefault : 0),

                  Text('thumbnail_image'.tr, style: robotoBold),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeLarge),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
                    ),
                    child: Column(children: [
                      
                      Align(alignment: Alignment.center, child: Stack(children: [
                      
                        ClipRRect(
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          child: storeController.rawLogo != null ? GetPlatform.isWeb ? Image.network(
                            storeController.rawLogo!.path, width: 150, height: 150, fit: BoxFit.cover,
                          ) : Image.file(
                            File(storeController.rawLogo!.path), width: 150, height: 150, fit: BoxFit.cover,
                          ) : _item.imageFullUrl != null ? CustomImageWidget(
                            image: _item.imageFullUrl ?? '',
                            height: 150, width: 150, fit: BoxFit.cover,
                          ) : Container(
                            height: 150, width: 150,
                            decoration: BoxDecoration(
                              color: Get.isDarkMode ? Colors.white.withValues(alpha: 0.05) : const Color(0xFFFAFAFA),
                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                            ),
                            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                              Icon(CupertinoIcons.photo_camera_solid, color: Theme.of(context).disabledColor.withValues(alpha: 0.5), size: 30),
                              const SizedBox(height: Dimensions.paddingSizeDefault),

                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(children: [
                                  TextSpan(text: 'click_to_upload'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor)),
                                ]),
                              ),

                            ]),
                          ),
                        ),

                        Positioned(
                          bottom: 0, right: 0, top: 0, left: 0,
                          child: InkWell(
                            onTap: () => storeController.pickImage(true, false),
                            child: DottedBorder(
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(Dimensions.radiusDefault),
                              dashPattern: const [8, 4],
                              strokeWidth: 1,
                              color: Theme.of(context).primaryColor.withValues(alpha: 0.5),
                              child: const SizedBox(height: 150, width: 150),
                            ),
                          ),
                        ),
                      
                      ])),
                      const SizedBox(height: Dimensions.paddingSizeDefault),
                      
                      Text(
                        'thumbnail_image_format'.tr, style: robotoRegular.copyWith(color: Theme.of(context).disabledColor),
                        textAlign: TextAlign.center,
                      ),
                      
                    ]),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  Row(children: [
                    Text('item_images'.tr, style: robotoBold),
                    const SizedBox(width: Dimensions.paddingSizeSmall),

                    Text(
                      '(${'max_size_2_mb'.tr})',
                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).colorScheme.error),
                    ),
                  ]),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeLarge),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
                    ),
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, childAspectRatio: (1/1),
                        mainAxisSpacing: Dimensions.paddingSizeSmall, crossAxisSpacing: Dimensions.paddingSizeSmall,
                      ),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: storeController.savedImages.length+storeController.rawImages.length+1,
                      itemBuilder: (context, index) {
                        bool savedImage = index < storeController.savedImages.length;
                        XFile? file = (savedImage || index == (storeController.rawImages.length + storeController.savedImages.length))
                            ? null : storeController.rawImages[index-storeController.savedImages.length];
                        if(index == (storeController.rawImages.length + storeController.savedImages.length)) {
                          return InkWell(
                            onTap: () {
                              if((storeController.savedImages.length+storeController.rawImages.length) < 6) {
                                storeController.pickImages();
                              }else {
                                showCustomSnackBar('maximum_image_limit_is_6'.tr);
                              }
                            },
                            child: DottedBorder(
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(Dimensions.radiusDefault),
                              dashPattern: const [8, 4],
                              strokeWidth: 1,
                              color: Theme.of(context).primaryColor.withValues(alpha: 0.5),
                              child: Container(
                                width: context.width, height: context.width,
                                decoration: BoxDecoration(
                                  color: Get.isDarkMode ? Colors.white.withValues(alpha: 0.05) : const Color(0xFFFAFAFA),
                                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                ),
                                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                                  Icon(CupertinoIcons.photo_camera_solid, color: Theme.of(context).disabledColor.withValues(alpha: 0.5), size: 30),
                                  const SizedBox(height: Dimensions.paddingSizeDefault),

                                  RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(children: [
                                      TextSpan(text: 'click_to_upload'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor)),
                                    ]),
                                  ),

                                ]),
                              ),
                            ),
                          );
                        }
                        return DottedBorder(
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(Dimensions.radiusDefault),
                          dashPattern: const [8, 4],
                          strokeWidth: 1,
                          color: Theme.of(context).primaryColor.withValues(alpha: 0.5),
                          child: Stack(children: [

                            ClipRRect(
                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                              child: savedImage ? CustomImageWidget(
                                image: storeController.savedImages[index],
                                width: context.width, height: context.width, fit: BoxFit.cover,
                              ) : GetPlatform.isWeb ? Image.network(
                                file!.path, width: context.width, height: context.width, fit: BoxFit.cover,
                              ) : Image.file(
                                File(file!.path), width: context.width, height: context.width, fit: BoxFit.cover,
                              ) ,
                            ),

                            Positioned(
                              right: 0, top: 0,
                              child: InkWell(
                                onTap: () {
                                  if(savedImage) {
                                    storeController.removeSavedImage(index);
                                  }else {
                                    storeController.removeImage(index - storeController.savedImages.length);
                                  }
                                },
                                child: const Padding(
                                  padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                                  child: Icon(Icons.delete_forever, color: Colors.red),
                                ),
                              ),
                            ),

                          ]),
                        );
                      },
                    ),
                  ),

                ]),
              )),

              Container(
                padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeLarge),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
                ),
                child: CustomButtonWidget(
                  buttonText: _update ? 'update'.tr : 'submit'.tr,
                  isLoading: storeController.isLoading,
                  onPressed: () {
                    String price = _priceController.text.trim();
                    String discount = _discountController.text.trim();
                    int maxOrderQuantity = _maxOrderQuantityController.text.isNotEmpty ? int.parse(_maxOrderQuantityController.text) : 0;
                    bool haveBlankVariant = false;
                    bool blankVariantPrice = false;
                    bool blankVariantStock = false;

                    bool variationNameEmpty = false;
                    bool variationMinMaxEmpty = false;
                    bool variationOptionNameEmpty = false;
                    bool variationOptionPriceEmpty = false;
                    bool variationMinLessThenZero = false;
                    bool variationMaxSmallThenMin = false;
                    bool variationMaxBigThenOptions = false;
                    for(AttributeModel attr in storeController.attributeList!) {
                      if(attr.active && attr.variants.isEmpty) {
                        haveBlankVariant = true;
                        break;
                      }
                    }
                    if(Get.find<SplashController>().getStoreModuleConfig().newVariation!){
                      for(VariationModelBodyModel variationModel in storeController.variationList!){
                        if(variationModel.nameController!.text.isEmpty){
                          variationNameEmpty = true;
                        }else if(!variationModel.isSingle){
                          if(variationModel.minController!.text.isEmpty || variationModel.maxController!.text.isEmpty){
                            variationMinMaxEmpty = true;
                          }else if(int.parse(variationModel.minController!.text) < 1){
                            variationMinLessThenZero = true;
                          }else if(int.parse(variationModel.maxController!.text) < int.parse(variationModel.minController!.text)){
                            variationMaxSmallThenMin = true;
                          }else if(int.parse(variationModel.maxController!.text) > variationModel.options!.length){
                            variationMaxBigThenOptions = true;
                          }
                        }else {
                          for(Option option in variationModel.options!){
                            if(option.optionNameController!.text.isEmpty){
                              variationOptionNameEmpty = true;
                            }else if(option.optionPriceController!.text.isEmpty){
                              variationOptionPriceEmpty = true;
                            }
                          }
                        }
                      }
                    } else{
                      for(VariantTypeModel variantType in storeController.variantTypeList!) {
                        if(variantType.priceController.text.isEmpty) {
                          blankVariantPrice = true;
                          break;
                        }
                        if(_module.stock! && variantType.stockController.text.isEmpty) {
                          blankVariantStock = true;
                          break;
                        }
                      }
                    }

                    bool defaultDataNull = false;
                    for(int index=0; index<_languageList.length; index++) {
                      if(_languageList[index].key == 'en') {
                        if (_nameControllerList[index].text.trim().isEmpty || _descriptionControllerList[index].text.trim().isEmpty) {
                          defaultDataNull = true;
                        }
                        break;
                      }
                    }

                    bool checkDiscountWithVariationPrice = false;
                    if(storeController.discountTypeIndex == 1 && storeController.variantTypeList!.isNotEmpty) {
                      for(VariantTypeModel variantType in storeController.variantTypeList!) {
                        double variantPrice = double.parse(variantType.priceController.text);
                        double discountValue = double.parse(discount);
                        if(variantPrice < discountValue) {
                          checkDiscountWithVariationPrice = true;
                          break;
                        }
                      }
                    }

                    if(defaultDataNull) {
                      showCustomSnackBar('enter_data_for_english'.tr);
                    }else if(categoryController.categoryIndex == null) {
                      showCustomSnackBar('select_a_category'.tr);
                    }else if(price.isEmpty) {
                      showCustomSnackBar('enter_item_price'.tr);
                    }else if(discount.isEmpty) {
                      showCustomSnackBar('enter_item_discount'.tr);
                    }else if(haveBlankVariant) {
                      showCustomSnackBar('add_at_least_one_variant_for_every_attribute'.tr);
                    }else if(blankVariantPrice) {
                      showCustomSnackBar('enter_price_for_every_variant'.tr);
                    }else if(variationNameEmpty){
                      showCustomSnackBar('enter_name_for_every_variation'.tr);
                    }else if(variationMinMaxEmpty){
                      showCustomSnackBar('enter_min_max_for_every_multipart_variation'.tr);
                    }else if(variationOptionNameEmpty){
                      showCustomSnackBar('enter_option_name_for_every_variation'.tr);
                    }else if(variationOptionPriceEmpty){
                      showCustomSnackBar('enter_option_price_for_every_variation'.tr);
                    }else if(variationMinLessThenZero){
                      showCustomSnackBar('minimum_type_cant_be_less_then_1'.tr);
                    }else if(variationMaxSmallThenMin){
                      showCustomSnackBar('max_type_cant_be_less_then_minimum_type'.tr);
                    }else if(variationMaxBigThenOptions){
                      showCustomSnackBar('max_type_length_should_not_be_more_then_options_length'.tr);
                    }else if(_module.stock! && blankVariantStock) {
                      showCustomSnackBar('enter_stock_for_every_variant'.tr);
                    }else if(_module.stock! && storeController.variantTypeList!.isEmpty && _stockController.text.trim().isEmpty) {
                      showCustomSnackBar('enter_stock'.tr);
                    }else if(_module.unit! && (storeController.unitIndex == null)) {
                      showCustomSnackBar('add_an_unit'.tr);
                    }else if(maxOrderQuantity < 0) {
                      showCustomSnackBar('maximum_item_order_quantity_can_not_be_negative'.tr);
                    }else if(_module.itemAvailableTime! && _item.availableTimeStarts == null) {
                      showCustomSnackBar('pick_start_time'.tr);
                    }else if(_module.itemAvailableTime! && _item.availableTimeEnds == null) {
                      showCustomSnackBar('pick_end_time'.tr);
                    }else if(!_update && (Get.find<SplashController>().getStoreModuleConfig().newVariation! ? false : storeController.rawLogo == null)) {
                      showCustomSnackBar('upload_item_thumbnail_image'.tr);
                    }else if(!_update && (Get.find<SplashController>().getStoreModuleConfig().newVariation! ? false : storeController.rawImages.isEmpty)) {
                      showCustomSnackBar('upload_item_image'.tr);
                    }else if(checkDiscountWithVariationPrice){
                      showCustomSnackBar('discount_cant_be_more_then_minimum_variation_price'.tr);
                    }else if(Get.find<SplashController>().configModel!.systemTaxType == 'product_wise' && storeController.selectedVatTaxIdList.isEmpty) {
                      showCustomSnackBar('select_vat_tax'.tr);
                    }else {
                      _item.veg = storeController.isVeg ? 1 : 0;
                      _item.isPrescriptionRequired = storeController.isPrescriptionRequired ? 1 : 0;
                      _item.isHalal = storeController.isHalal ? 1 : 0;
                      _item.isBasicMedicine = storeController.isBasicMedicine ? 1 : 0;
                      _item.price = double.parse(price);
                      _item.discount = double.parse(discount);
                      _item.discountType = storeController.discountTypeIndex == 0 ? 'percent' : 'amount';
                      _item.categoryIds = [];
                      _item.maxOrderQuantity = maxOrderQuantity;
                      _item.categoryIds!.add(CategoryIds(id: categoryController.categoryList![categoryController.categoryIndex!].id.toString()));
                      if (categoryController.subCategoryIndex != null) {
                        _item.categoryIds!.add(CategoryIds(id: categoryController.subCategoryList![categoryController.subCategoryIndex!].id.toString()));
                      }else {
                        if(_item.categoryIds!.length > 1) {
                          _item.categoryIds!.removeAt(1);
                        }
                      }
                      _item.addOns = [];
                      for (var index in storeController.selectedAddons!) {
                        _item.addOns!.add(Get.find<AddonController>().addonList![index]);
                      }
                      if(_module.unit!) {
                        _item.unitType = storeController.unitList![storeController.unitIndex!].id.toString();
                      }
                      if(_module.stock!) {
                        _item.stock = int.parse(_stockController.text.trim());
                      }
                      if(Get.find<SplashController>().configModel!.systemTaxType == 'product_wise'){
                        _item.taxVatIds = [];
                        _item.taxVatIds = storeController.selectedVatTaxIdList;
                      }

                      List<Translation> translations = [];
                      for(int index=0; index<_languageList.length; index++) {
                        translations.add(Translation(
                          locale: _languageList[index].key, key: 'name',
                          value: _nameControllerList[index].text.trim().isNotEmpty ? _nameControllerList[index].text.trim()
                              : _nameControllerList[0].text.trim(),
                        ));
                        translations.add(Translation(
                          locale: _languageList[index].key, key: 'description',
                          value: _descriptionControllerList[index].text.trim().isNotEmpty ? _descriptionControllerList[index].text.trim()
                              : _descriptionControllerList[0].text.trim(),
                        ));
                      }

                      _item.translations = [];
                      _item.translations!.addAll(translations);

                      _item.brandId = storeController.brandList != null && storeController.brandList!.isNotEmpty ? storeController.brandList![storeController.brandIndex!].id : 0;
                      _item.conditionId = storeController.suitableTagList != null && storeController.suitableTagList!.isNotEmpty ? storeController.suitableTagList![storeController.suitableTagIndex!].id : 0;
                      bool hasEmptyValue = false;
                      if(Get.find<SplashController>().getStoreModuleConfig().newVariation!) {
                        _item.foodVariations = [];
                        for(VariationModelBodyModel variation in storeController.variationList!) {
                          if(variation.nameController!.text.trim().isEmpty) {
                            hasEmptyValue = true;
                            break;
                          }
                          List<VariationValue> values = [];
                          for(Option option in variation.options!) {
                            if(option.optionNameController!.text.trim().isEmpty || option.optionPriceController!.text.trim().isEmpty) {
                              hasEmptyValue = true;
                              break;
                            }
                            values.add(VariationValue(
                              level: option.optionNameController!.text.trim(),
                              optionPrice: option.optionPriceController!.text.trim(),
                            ));
                          }
                          if(hasEmptyValue) {
                            break;
                          }
                          _item.foodVariations!.add(FoodVariation(
                            name: variation.nameController!.text.trim(), type: variation.isSingle ? 'single' : 'multi',
                            min: variation.minController!.text.trim(), max: variation.maxController!.text.trim(),
                            required: variation.required ? 'on' : 'off', variationValues: values,
                          ));
                        }
                      }
                      if(hasEmptyValue) {
                        showCustomSnackBar('set_value_for_all_variation'.tr);
                      }else {
                        storeController.addItem(_item, widget.item == null, genericNameData: _genericNameSuggestionController.text.trim());
                      }
                    }
                  },
                ),
              ),

            ]) : const Center(child: CircularProgressIndicator());
          });
        }),
      ),
    );
  }
}