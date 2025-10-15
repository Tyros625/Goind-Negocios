import 'dart:io';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';
import 'package:sixam_mart_store/common/widgets/custom_asset_image_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_card.dart';
import 'package:sixam_mart_store/common/widgets/custom_image_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_text_field_widget.dart';
import 'package:sixam_mart_store/features/store/controllers/store_controller.dart';
import 'package:sixam_mart_store/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart_store/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart_store/common/models/config_model.dart';
import 'package:sixam_mart_store/features/store/domain/models/item_model.dart';
import 'package:sixam_mart_store/features/profile/domain/models/profile_model.dart' as profile;
import 'package:sixam_mart_store/helper/custom_validator_helper.dart';
import 'package:sixam_mart_store/helper/validate_check.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/common/widgets/custom_app_bar_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_button_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoreEditScreen extends StatefulWidget {
  final profile.Store store;
  const StoreEditScreen({super.key, required this.store});

  @override
  State<StoreEditScreen> createState() => _StoreEditScreenState();
}

class _StoreEditScreenState extends State<StoreEditScreen> with TickerProviderStateMixin {
  final List<TextEditingController> _nameController = [];
  final List<TextEditingController> _addressController = [];
  final TextEditingController _contactController = TextEditingController();
  final List<TextEditingController> _metaTitleController = [];
  final List<TextEditingController> _metaDescriptionController = [];

  final List<FocusNode> _nameNode = [];
  final List<FocusNode> _addressNode = [];
  final FocusNode _contactNode = FocusNode();
  final List<FocusNode> _metaTitleNode = [];
  final List<FocusNode> _metaDescriptionNode = [];

  late profile.Store _store;
  final Module? _module = Get.find<SplashController>().configModel!.moduleConfig!.module;
  final List<Language>? _languageList = Get.find<SplashController>().configModel!.language;
  final List<Translation>? translation = Get.find<ProfileController>().profileModel!.translations!;
  TabController? _tabController;
  final List<Tab> _tabs = [];
  String? _countryDialCode;
  String? _countryCode;

  @override
  void initState() {
    super.initState();

    _countryDialCode = CountryCode.fromCountryCode(Get.find<SplashController>().configModel!.country!).dialCode;
    _countryCode = CountryCode.fromCountryCode(Get.find<SplashController>().configModel!.country!).code;
    _splitPhone(widget.store.phone);
    Get.find<StoreController>().initStoreBasicData();

    _tabController = TabController(length: _languageList!.length, vsync: this);

    for (var language in _languageList) {
      _tabs.add(Tab(text: language.value));
    }

    for(int index=0; index<_languageList.length; index++) {

      _nameController.add(TextEditingController());
      _addressController.add(TextEditingController());
      _metaTitleController.add(TextEditingController());
      _metaDescriptionController.add(TextEditingController());
      _nameNode.add(FocusNode());
      _addressNode.add(FocusNode());
      _metaTitleNode.add(FocusNode());
      _metaDescriptionNode.add(FocusNode());

      for (var trans in translation!) {
        if(_languageList[index].key == trans.locale && trans.key == 'name') {
          _nameController[index] = TextEditingController(text: trans.value);
        }else if(_languageList[index].key == trans.locale && trans.key == 'address') {
          _addressController[index] = TextEditingController(text: trans.value);
        }else if (_languageList[index].key == trans.locale && trans.key == 'meta_title') {
          _metaTitleController[index] = TextEditingController(text: trans.value);
        }  else if (_languageList[index].key == trans.locale && trans.key == 'meta_description') {
          _metaDescriptionController[index] = TextEditingController(text: trans.value);
        }
      }
    }

    _store = widget.store;
  }

  void _splitPhone(String? phone) async {
    try {
      if (phone != null && phone.isNotEmpty) {
        PhoneNumber phoneNumber = PhoneNumber.parse(phone);
        _countryDialCode = '+${phoneNumber.countryCode}';
        _countryCode = phoneNumber.isoCode.name;
        _contactController.text = phoneNumber.international.substring(_countryDialCode!.length);
      }
    } catch (e) {
      debugPrint('Phone Number Parse Error: $e');
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: CustomAppBarWidget(title: _module!.showRestaurantText! ? 'edit_restaurant_info'.tr : 'edit_store_info'.tr),

      body: GetBuilder<StoreController>(builder: (storeController) {
        return Column(children: [

          Expanded(child: SingleChildScrollView(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              Text('basic_info'.tr, style: robotoBold),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              CustomCard(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                  SizedBox(
                    height: 40,
                    child: TabBar(
                      tabAlignment: TabAlignment.start,
                      controller: _tabController,
                      indicatorColor: Theme.of(context).primaryColor,
                      indicatorWeight: 3,
                      labelColor: Theme.of(context).primaryColor,
                      unselectedLabelColor: Theme.of(context).hintColor,
                      unselectedLabelStyle: robotoRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall),
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
                    padding: EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                    child: Divider(height: 0),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  CustomTextFieldWidget(
                    hintText: '${_module.showRestaurantText! ? 'restaurant_name'.tr : 'store_name'.tr} (${_languageList?[_tabController!.index].value!})',
                    labelText: '${_module.showRestaurantText! ? 'restaurant_name'.tr : 'store_name'.tr} (${_languageList?[_tabController!.index].value!})',
                    controller: _nameController[_tabController!.index],
                    capitalization: TextCapitalization.words,
                    focusNode: _nameNode[_tabController!.index],
                    nextFocus: _tabController!.index != _languageList!.length-1 ? _addressNode[_tabController!.index] : _contactNode,
                    required: true,
                  ),
                  const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                  CustomTextFieldWidget(
                    hintText: '${'address'.tr} (${_languageList[_tabController!.index].value!})',
                    labelText: '${'address'.tr} (${_languageList[_tabController!.index].value!})',
                    controller: _addressController[_tabController!.index],
                    focusNode: _addressNode[_tabController!.index],
                    capitalization: TextCapitalization.sentences,
                    maxLines: 3,
                    nextFocus: _contactNode,
                    required: true,
                  ),

                ]),
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),

              Text('contact_info'.tr, style: robotoBold),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              CustomCard(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                child: CustomTextFieldWidget(
                  hintText: 'xxx-xxxxxxx',
                  labelText: 'phone_number'.tr,
                  controller: _contactController,
                  focusNode: _contactNode,
                  nextFocus: _metaTitleNode[0],
                  required: true,
                  inputType: TextInputType.phone,
                  isPhone: true,
                  onCountryChanged: (CountryCode countryCode) {
                    _countryDialCode = countryCode.dialCode;
                  },
                  countryDialCode: _countryCode ?? CountryCode.fromCountryCode(Get.find<SplashController>().configModel!.country!).code,
                  validator: (value) => ValidateCheck.validateEmptyText(value, null),
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),

              RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: 'business_logo'.tr,
                    style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge!.color),
                  ),

                  TextSpan(
                    text: '*',
                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Colors.red),
                  ),
                ]),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              CustomCard(
                width: context.width,
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                  Align(alignment: Alignment.center, child: Stack(children: [

                    Padding(
                      padding: const EdgeInsets.all(2),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        child:  storeController.rawLogo != null ? GetPlatform.isWeb ? Image.network(
                           storeController.rawLogo!.path, width: 120, height: 120, fit: BoxFit.cover,
                        ) : Image.file(
                          File( storeController.rawLogo!.path), width: 120, height: 120, fit: BoxFit.cover,
                        ) : widget.store.logoFullUrl != null ? CustomImageWidget(
                          image: widget.store.logoFullUrl ?? '',
                          height: 120, width: 120, fit: BoxFit.cover,
                        ) : SizedBox(
                          width: 120, height: 120,
                          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                            CustomAssetImageWidget(Images.uploadIcon, height: 30, width: 30, color: Theme.of(context).hintColor),
                            const SizedBox(height: Dimensions.paddingSizeSmall),

                            Text(
                              'click_to_upload'.tr,
                              style: robotoMedium.copyWith(color: Colors.blue, fontSize: Dimensions.fontSizeSmall), textAlign: TextAlign.center,
                            ),

                          ]),
                        ),
                      ),
                    ),

                    Positioned(
                      bottom: 0, right: 0, top: 0, left: 0,
                      child: InkWell(
                        onTap: () => storeController.pickImage(true, false),
                        child: DottedBorder(
                          color: Theme.of(context).hintColor,
                          strokeWidth: 1,
                          strokeCap: StrokeCap.butt,
                          dashPattern: const [5, 5],
                          padding: const EdgeInsets.all(0),
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(Dimensions.radiusDefault),
                          child: const SizedBox(width: 120, height: 120),
                        ),
                      ),
                    ),

                  ])),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'image_format_and_ratio_for_business_logo'.tr,
                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor), textAlign: TextAlign.center,
                    ),
                  ),
                ]),
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),

              RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: 'cover_photo'.tr,
                    style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge!.color),
                  ),

                  TextSpan(
                    text: '*',
                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Colors.red),
                  ),
                ]),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              CustomCard(
                width: context.width,
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                  Padding(
                    padding: const EdgeInsets.only(
                      left: 40, right: 40,
                    ),
                    child: Stack(children: [

                      Padding(
                        padding: const EdgeInsets.all(2),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          child: storeController.rawCover != null ? GetPlatform.isWeb ? Image.network(
                            storeController.rawCover!.path, width: context.width, height: 140, fit: BoxFit.cover,
                          ) : Image.file(
                            File(storeController.rawCover!.path), width: context.width, height: 140, fit: BoxFit.cover,
                          ) : widget.store.coverPhotoFullUrl != null ? CustomImageWidget(
                            image: widget.store.coverPhotoFullUrl ?? '',
                            height: 140, width: context.width * 0.7, fit: BoxFit.cover,
                          ) : SizedBox(
                            width: context.width, height: 140,
                            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [

                              CustomAssetImageWidget(Images.uploadIcon, height: 30, width: 30, color: Theme.of(context).hintColor),
                              const SizedBox(width: Dimensions.paddingSizeSmall),

                              Text(
                                'click_to_upload'.tr,
                                style: robotoMedium.copyWith(color: Colors.blue, fontSize: Dimensions.fontSizeSmall), textAlign: TextAlign.center,
                              ),

                            ]),
                          ),
                        ),
                      ),

                      Positioned(
                        bottom: 0, right: 0, top: 0, left: 0,
                        child: InkWell(
                          onTap: () => storeController.pickImage(false, false),
                          child: DottedBorder(
                            color: Theme.of(context).hintColor,
                            strokeWidth: 1,
                            strokeCap: StrokeCap.butt,
                            dashPattern: const [5, 5],
                            padding: const EdgeInsets.all(0),
                            borderType: BorderType.RRect,
                            radius: const Radius.circular(Dimensions.radiusDefault),
                            child: SizedBox(width: context.width, height: 140),
                          ),
                        ),
                      ),

                    ]),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'image_format_and_ratio_for_business_cover'.tr,
                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor), textAlign: TextAlign.center,
                    ),
                  ),
                ]),
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),

              Text('meta_data'.tr, style: robotoBold),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              CustomCard(
                child: Column(children: [

                  Padding(
                    padding: const EdgeInsets.only(
                      left: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeDefault,
                      top: Dimensions.paddingSizeSmall, bottom: Dimensions.paddingSizeDefault,
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
                          unselectedLabelColor: Theme.of(context).hintColor,
                          unselectedLabelStyle: robotoRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall),
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
                        hintText: '${'meta_title'.tr} (${_languageList[_tabController!.index].value!})',
                        labelText: 'title'.tr,
                        controller: _metaTitleController[_tabController!.index],
                        capitalization: TextCapitalization.words,
                        focusNode: _metaTitleNode[_tabController!.index],
                        nextFocus: _tabController!.index != _languageList.length-1 ? _metaDescriptionNode[_tabController!.index] : _metaDescriptionNode[0],
                        showTitle: false,
                        required: true,
                      ),
                      const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                      CustomTextFieldWidget(
                        hintText: '${'meta_description'.tr} (${_languageList[_tabController!.index].value!})',
                        labelText: 'description'.tr,
                        controller: _metaDescriptionController[_tabController!.index],
                        focusNode: _metaDescriptionNode[_tabController!.index],
                        capitalization: TextCapitalization.sentences,
                        maxLines: 5,
                        inputAction: _tabController!.index != _languageList.length-1 ? TextInputAction.next : TextInputAction.done,
                        nextFocus: _tabController!.index != _languageList.length-1 ? _metaDescriptionNode[_tabController!.index + 1] : null,
                        showTitle: false,
                        required: true,
                      ),

                    ]),
                  ),

                ]),
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),

              Text('meta_image'.tr, style: robotoMedium.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              CustomCard(
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                child: Column(children: [

                  Stack(clipBehavior: Clip.none, children: [

                    Padding(
                      padding: const EdgeInsets.all(2),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        child: storeController.pickedMetaImage != null ? GetPlatform.isWeb ? Image.network(
                            storeController.pickedMetaImage!.path, width: 120, height: 120, fit: BoxFit.cover) : Image.file(
                            File(storeController.pickedMetaImage!.path), width: 120, height: 120, fit: BoxFit.cover) : CustomImageWidget(
                          image: '${widget.store.metaImageFullUrl}',
                          height: 120, width: 120, fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    Positioned(
                      bottom: 0, right: 0, top: 0, left: 0,
                      child: InkWell(
                        onTap: () => storeController.pickMetaImage(),
                        child: DottedBorder(
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(Dimensions.radiusDefault),
                          dashPattern: const [8, 4],
                          strokeWidth: 1,
                          color: Theme.of(context).hintColor,
                          child: const SizedBox(width: 120, height: 120),
                        ),
                      ),
                    ),

                    Positioned(
                      top: -10, right: -10,
                      child: InkWell(
                        onTap: () => storeController.pickMetaImage(),
                        child: Container(
                          padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.blue, width: 0.5),
                          ),
                          child: const Icon(Icons.edit, color: Colors.blue, size: 16),
                        ),
                      ),
                    ),

                  ]),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'image_format_and_ratio_for_business_logo'.tr,
                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor), textAlign: TextAlign.center,
                    ),
                  ),

                ]),
              ),

            ]),
          )),

          Container(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 5)],
            ),
            child: CustomButtonWidget(
              isLoading: storeController.isLoading,
              onPressed: () async {
                bool defaultNameNull = false;
                bool defaultAddressNull = false;
                bool defaultMetaTitleNull = false;
                bool defaultMetaDescriptionNull = false;

                for(int index=0; index<_languageList.length; index++) {
                  if(_languageList[index].key == 'en') {
                    if (_nameController[index].text.trim().isEmpty) {
                      defaultNameNull = true;
                    }
                    if(_addressController[index].text.trim().isEmpty){
                      defaultAddressNull = true;
                    }
                    if(_metaTitleController[index].text.trim().isEmpty){
                      defaultMetaTitleNull = true;
                    }
                    if(_metaDescriptionController[index].text.trim().isEmpty){
                      defaultMetaDescriptionNull = true;
                    }
                    break;
                  }
                }

                String contact = _contactController.text.trim();

                String numberWithCountryCode = _countryDialCode! + contact;
                PhoneValid phoneValid = await CustomValidatorHelper.isPhoneValid(numberWithCountryCode);
                numberWithCountryCode = phoneValid.phone;

                bool? showRestaurantText = _module.showRestaurantText;

                if(defaultNameNull) {
                  showCustomSnackBar(showRestaurantText! ? 'enter_your_restaurant_name'.tr : 'enter_your_store_name'.tr);
                }else if(defaultAddressNull) {
                  showCustomSnackBar(showRestaurantText! ? 'enter_restaurant_address'.tr : 'enter_store_address'.tr);
                }else if(contact.isEmpty) {
                  showCustomSnackBar(showRestaurantText! ? 'enter_restaurant_contact_number'.tr : 'enter_store_contact_number'.tr);
                }else if(widget.store.logoFullUrl == null && storeController.rawLogo == null) {
                  showCustomSnackBar('upload_business_logo'.tr);
                }else if(widget.store.coverPhotoFullUrl == null && storeController.rawCover == null) {
                  showCustomSnackBar('upload_cover_image'.tr);
                }else if(defaultMetaTitleNull) {
                  showCustomSnackBar('enter_meta_title'.tr);
                }else if(defaultMetaDescriptionNull) {
                  showCustomSnackBar('enter_meta_description'.tr);
                }else {

                  List<Translation> translation = [];

                  for(int index=0; index<_languageList.length; index++) {
                    translation.add(Translation(
                      locale: _languageList[index].key, key: 'name',
                      value: _nameController[index].text.trim().isNotEmpty ? _nameController[index].text.trim() : _nameController[0].text.trim(),
                    ));
                    translation.add(Translation(
                      locale: _languageList[index].key, key: 'address',
                      value: _addressController[index].text.trim().isNotEmpty ? _addressController[index].text.trim() : _addressController[0].text.trim(),
                    ));
                    translation.add(Translation(
                      locale: _languageList[index].key, key: 'meta_title',
                      value: _metaTitleController[index].text.trim().isNotEmpty ? _metaTitleController[index].text.trim() : _metaTitleController[0].text.trim(),
                    ));
                    translation.add(Translation(
                      locale: _languageList[index].key, key: 'meta_description',
                      value: _metaDescriptionController[index].text.trim().isNotEmpty ? _metaDescriptionController[index].text.trim() : _metaDescriptionController[0].text.trim(),
                    ));
                  }

                  _store.phone = numberWithCountryCode;

                  storeController.updateStoreBasicInfo(_store, translation);
                }
              },
              buttonText: 'update'.tr,
            ),
          ),

        ]);
      }),
    );
  }
}
