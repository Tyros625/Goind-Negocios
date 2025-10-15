import 'package:flutter/foundation.dart';
import 'package:sixam_mart_store/common/widgets/custom_app_bar_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_card.dart';
import 'package:sixam_mart_store/common/widgets/custom_drop_down_button.dart.dart';
import 'package:sixam_mart_store/common/widgets/custom_text_field_widget.dart';
import 'package:sixam_mart_store/features/addon/controllers/addon_controller.dart';
import 'package:sixam_mart_store/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart_store/common/models/config_model.dart';
import 'package:sixam_mart_store/features/store/controllers/store_controller.dart';
import 'package:sixam_mart_store/features/store/domain/models/item_model.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/common/widgets/custom_button_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/util/styles.dart';

class AddAddonScreen extends StatefulWidget {
  final AddOns? addon;
  const AddAddonScreen({super.key, this.addon});

  @override
  State<AddAddonScreen> createState() => _AddAddonScreenState();
}

class _AddAddonScreenState extends State<AddAddonScreen> with TickerProviderStateMixin {

  final List<TextEditingController> _nameControllers = [];
  final TextEditingController _priceController = TextEditingController();
  final List<FocusNode> _nameNodes = [];
  final FocusNode _priceNode = FocusNode();
  final List<Language>? _languageList = Get.find<SplashController>().configModel!.language;
  TabController? _tabController;
  final List<Tab> _tabs = [];
  late bool _update;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _languageList!.length, initialIndex: 0, vsync: this);
    for (var language in _languageList) {
      if (kDebugMode) {
        print(language);
      }
      _nameControllers.add(TextEditingController());
      _nameNodes.add(FocusNode());
    }

    Get.find<AddonController>().resetAddonCategory();
    Get.find<StoreController>().clearVatTax();

    _update = widget.addon != null;

    if(_update){
      if(widget.addon!.addonCategoryId != null) {
        Get.find<AddonController>().setAddonCategory(widget.addon!.addonCategoryId);
      }

      if (Get.find<StoreController>().vatTaxList != null && Get.find<StoreController>().selectedVatTaxIdList.isEmpty && widget.addon!.taxVatIds != null && widget.addon!.taxVatIds!.isNotEmpty) {
        Get.find<StoreController>().preloadVatTax(vatTaxList: widget.addon!.taxVatIds!);
      }
    }

    if(widget.addon != null) {
      for(int index = 0; index < _languageList.length; index++) {
        if(widget.addon!.translations!.isNotEmpty){
          _nameControllers.add(TextEditingController(text: widget.addon?.translations?[widget.addon!.translations!.length-1].value ?? ''));
        }
        _nameNodes.add(FocusNode());
        for(Translation translation in widget.addon!.translations!) {
          if(_languageList[index].key == translation.locale && translation.key == 'name') {
            _nameControllers[index] = TextEditingController(text: translation.value);
            break;
          }
        }
      }
      _priceController.text = widget.addon!.price.toString();
    }else {
      for (var language in _languageList) {
        _nameControllers.add(TextEditingController());
        _nameNodes.add(FocusNode());
        if (kDebugMode) {
          print(language);
        }
      }
    }

    for (var language in _languageList) {
      _tabs.add(Tab(text: language.value));
    }

  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddonController>(builder: (addonController) {
      return GetBuilder<StoreController>(builder: (storeController) {
        return Scaffold(
          appBar: CustomAppBarWidget(title: widget.addon != null ? 'update_addon'.tr : 'add_addons'.tr),
          body: Column(children: [

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                child: Column(children: [

                  CustomCard(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    child: Column(children: [

                      SizedBox(
                        height: 40,
                        child: TabBar(
                          tabAlignment: TabAlignment.start,
                          controller: _tabController,
                          indicatorColor: Theme.of(context).textTheme.bodyLarge?.color,
                          indicatorWeight: 3,
                          labelColor: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.6),
                          unselectedLabelColor: Theme.of(context).disabledColor,
                          unselectedLabelStyle: robotoRegular.copyWith(color: Theme.of(context).disabledColor),
                          labelStyle: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault),
                          labelPadding: const EdgeInsets.only(right: Dimensions.paddingSizeLarge),
                          indicatorPadding: const EdgeInsets.only(right: Dimensions.paddingSizeLarge),
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

                      CustomTextFieldWidget(
                        hintText: '${'name'.tr} (${_languageList?[_tabController!.index].value}) *',
                        labelText: 'name'.tr,
                        controller: _nameControllers[_tabController!.index],
                        focusNode: _nameNodes[_tabController!.index],
                        nextFocus: _tabController!.index != _languageList!.length-1 ? _priceNode : _priceNode,
                        inputType: TextInputType.name,
                        capitalization: TextCapitalization.words,
                        showTitle: false,
                        required: true,
                      ),
                      const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                      CustomTextFieldWidget(
                        hintText: '${'price'.tr} (${Get.find<SplashController>().configModel?.currencySymbol})',
                        labelText: '${'price'.tr} (${Get.find<SplashController>().configModel?.currencySymbol})',
                        controller: _priceController,
                        focusNode: _priceNode,
                        inputAction: TextInputAction.done,
                        inputType: TextInputType.number,
                        isAmount: true,
                        showTitle: false,
                        required: true,
                      ),

                    ]),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  CustomCard(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    child: Column(children: [

                      CustomDropdownButton(
                        hintText: 'select_category'.tr,
                        dropdownMenuItems: addonController.addonCategoryList?.map((item) => DropdownMenuItem<String>(
                          value: item.name,
                          child: Text(item.name ?? '', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),
                        )).toList(),
                        onChanged: (String? value) {
                          addonController.setAddonCategoryName(value);
                          int? id = addonController.addonCategoryList?.firstWhere((category) => category.name == value).id;
                          addonController.setAddonCategoryId(id);
                        },
                        selectedValue: addonController.addonCategoryName,
                      ),
                      SizedBox(height: Get.find<SplashController>().configModel!.systemTaxType == 'product_wise' ? Dimensions.paddingSizeExtraLarge : 0),

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

                ]),
              ),
            ),

            Container(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
              ),
              child: CustomButtonWidget(
                isLoading: addonController.isLoading,
                onPressed: () {

                  String name = _nameControllers[0].text.trim();
                  String price = _priceController.text.trim();

                  if(name.isEmpty) {
                    showCustomSnackBar('enter_addon_name'.tr);
                  }else if(price.isEmpty) {
                    showCustomSnackBar('enter_addon_price'.tr);
                  }else if(addonController.addonCategoryId == null) {
                    showCustomSnackBar('select_addon_category'.tr);
                  }else if(Get.find<SplashController>().configModel!.systemTaxType == 'product_wise' && storeController.selectedVatTaxIdList.isEmpty) {
                    showCustomSnackBar('select_vat_tax'.tr);
                  }else {
                    List<Translation> nameList = [];
                    for(int index = 0; index < _languageList.length; index++) {
                      nameList.add(Translation(
                        locale: _languageList[index].key, key: 'name',
                        value: _nameControllers[index].text.trim().isNotEmpty ? _nameControllers[index].text.trim() : _nameControllers[0].text.trim(),
                      ));
                    }

                    List<int> selectedVatTaxIds = [];
                    if(Get.find<SplashController>().configModel!.systemTaxType == 'product_wise'){
                      selectedVatTaxIds = storeController.selectedVatTaxIdList;
                    }

                    AddOns addon = AddOns(name: name, price: double.parse(price), translations: nameList, taxVatIds: selectedVatTaxIds, addonCategoryId: addonController.addonCategoryId);

                    if(widget.addon != null) {
                      addon.id = widget.addon!.id;
                      addonController.updateAddon(addon);
                    }else {
                      addonController.addAddon(addon);
                    }

                  }
                },
                buttonText: widget.addon != null ? 'update'.tr : 'submit'.tr,
              ),
            ),

          ]),
        );
      });
    });
  }
}
