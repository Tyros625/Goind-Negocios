import 'dart:convert';
import 'dart:io';
import 'package:card_swiper/card_swiper.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/common/widgets/confirmation_dialog_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_asset_image_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_tool_tip_widget.dart';
import 'package:sixam_mart_store/features/auth/controllers/auth_controller.dart';
import 'package:sixam_mart_store/features/address/controllers/address_controller.dart';
import 'package:sixam_mart_store/features/business/domain/models/package_model.dart';
import 'package:sixam_mart_store/features/business/widgets/base_card_widget.dart';
import 'package:sixam_mart_store/features/business/widgets/package_card_widget.dart';
import 'package:sixam_mart_store/features/language/controllers/language_controller.dart';
import 'package:sixam_mart_store/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart_store/features/store/domain/models/store_body_model.dart';
import 'package:sixam_mart_store/common/models/config_model.dart';
import 'package:sixam_mart_store/features/store/domain/models/item_model.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';
import 'package:sixam_mart_store/helper/validate_check.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/common/widgets/custom_app_bar_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_button_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_text_field_widget.dart';
import 'package:sixam_mart_store/features/auth/widgets/custom_time_picker_widget.dart';
import 'package:sixam_mart_store/features/auth/widgets/pass_view_widget.dart';
import 'package:sixam_mart_store/features/address/widgets/select_location_module_view_widget.dart';

class StoreRegistrationScreen extends StatefulWidget {
  const StoreRegistrationScreen({super.key});

  @override
  State<StoreRegistrationScreen> createState() => _StoreRegistrationScreenState();
}

class _StoreRegistrationScreenState extends State<StoreRegistrationScreen> with TickerProviderStateMixin {

  final List<TextEditingController> _nameController = [];
  final List<TextEditingController> _addressController = [];
  //final TextEditingController _vatController = TextEditingController();
  final TextEditingController _tinNumberController = TextEditingController();
  final TextEditingController _fNameController = TextEditingController();
  final TextEditingController _lNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final List<FocusNode> _nameFocus = [];
  final List<FocusNode> _addressFocus = [];
  //final FocusNode _vatFocus = FocusNode();
  final FocusNode _fNameFocus = FocusNode();
  final FocusNode _lNameFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final List<Language>? _languageList = Get.find<SplashController>().configModel!.language;

  final ScrollController _scrollController = ScrollController();
  String? _countryDialCode;
  bool firstTime = true;
  TabController? _tabController;
  final List<Tab> _tabs =[];

  GlobalKey<FormState>? _formKeyLogin;
  GlobalKey<FormState>? _formKeySecond;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _languageList!.length, initialIndex: 0, vsync: this);
    _countryDialCode = CountryCode.fromCountryCode(Get.find<SplashController>().configModel!.country!).dialCode;
    for (var language in _languageList) {
      if (kDebugMode) {
        print(language);
      }
      _nameController.add(TextEditingController());
      _addressController.add(TextEditingController());
      _nameFocus.add(FocusNode());
      _addressFocus.add(FocusNode());
    }
    Get.find<AuthController>().resetData();
    Get.find<AuthController>().storeStatusChange(0.1, isUpdate: false);
    Get.find<AddressController>().getZoneList();
    Get.find<AuthController>().setDeliveryTimeTypeIndex(Get.find<AuthController>().deliveryTimeTypeList[0], false);
    if(Get.find<AuthController>().showPassView){
      Get.find<AuthController>().showHidePass(isUpdate: false);
    }
    Get.find<AuthController>().pickImageForReg(false, true);
    Get.find<AuthController>().resetBusiness();
    Get.find<AddressController>().clearPickupZone();

    for (var language in _languageList) {
      _tabs.add(Tab(text: language.value));
    }
    _formKeyLogin = GlobalKey<FormState>();
    _formKeySecond = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (authController) {
      return GetBuilder<AddressController>(builder: (addressController) {

        if(addressController.storeAddress != null && _languageList!.isNotEmpty){
          _addressController[0].text = addressController.storeAddress.toString();
        }

        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) async{
            if(authController.storeStatus == 0.6 && firstTime){
              authController.storeStatusChange(0.1);
              firstTime = false;
            }else if(authController.storeStatus == 0.9){
              authController.storeStatusChange(0.6);
            }else {
              await _showBackPressedDialogue('your_registration_not_setup_yet'.tr);
            }
          },
          child: Scaffold(

            appBar: CustomAppBarWidget(title: 'vendor_registration'.tr, onTap: () async {
              if(authController.storeStatus == 0.6 && firstTime){
                authController.storeStatusChange(0.1);
                firstTime = false;
              }else if(authController.storeStatus == 0.9){
                authController.storeStatusChange(0.6);
              }else {
                await _showBackPressedDialogue('your_registration_not_setup_yet'.tr);
              }
            }),

            body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical:  Dimensions.paddingSizeSmall),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                  Text(
                    authController.storeStatus == 0.1 ? 'provide_vendor_information_to_proceed_next'.tr : authController.storeStatus == 0.6 ? 'provide_owner_information_to_confirm'.tr : 'you_are_one_step_away_choose_your_business_plan'.tr,
                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  LinearProgressIndicator(
                    backgroundColor: Theme.of(context).disabledColor, minHeight: 2,
                    value: authController.storeStatus,
                  ),

                ]),
              ),

              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeDefault),
                  child: Column(children: [

                    Visibility(
                      visible: authController.storeStatus == 0.1,
                      child: Form(
                        key: _formKeyLogin,
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                          Text('vendor_info'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                          const SizedBox(height: Dimensions.paddingSizeDefault),

                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)],
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeDefault),
                            child: Column(children: [

                              SizedBox(
                                height: 40,
                                child: Align(
                                  alignment: Alignment.centerLeft,
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
                                    tabs: _tabs,
                                    onTap: (int ? value) {
                                      setState(() {});
                                    },
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(bottom: Dimensions.paddingSizeLarge),
                                child: Divider(height: 0),
                              ),

                              CustomTextFieldWidget(
                                hintText: 'write_vendor_name'.tr,
                                labelText: 'vendor_name'.tr,
                                controller: _nameController[_tabController!.index],
                                focusNode: _nameFocus[_tabController!.index],
                                nextFocus: _tabController!.index != _languageList!.length-1 ? _addressFocus[_tabController!.index] : _addressFocus[0],
                                inputType: TextInputType.name,
                                prefixImage: Images.shopIcon,
                                capitalization: TextCapitalization.words,
                                required: true,
                                validator: (value) => ValidateCheck.validateEmptyText(value, "vendor_name_field_is_required".tr),
                              ),
                              const SizedBox(height: Dimensions.paddingSizeExtremeLarge),

                              Row(children: [

                                Expanded(flex: 4,
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                                    Row(children: [
                                      Text('vendor_logo'.tr, style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.7))),
                                      Text(' (${'1:1'})', style: robotoRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall)),
                                    ]),
                                    const SizedBox(height: Dimensions.paddingSizeDefault),

                                    Align(alignment: Alignment.center, child: Stack(children: [
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                          child: authController.pickedLogo != null ? GetPlatform.isWeb ? Image.network(
                                            authController.pickedLogo!.path, width: 150, height: 120, fit: BoxFit.cover,
                                          ) : Image.file(
                                            File(authController.pickedLogo!.path), width: 150, height: 120, fit: BoxFit.cover,
                                          ) : SizedBox(
                                            width: 150, height: 120,
                                            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                                              Icon(CupertinoIcons.photo_camera_solid, size: 30, color: Theme.of(context).disabledColor.withValues(alpha: 0.6)),
                                              const SizedBox(height: Dimensions.paddingSizeSmall),

                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                                                child: Text(
                                                  'upload_vendor_logo'.tr,
                                                  style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.7)), textAlign: TextAlign.center,
                                                ),
                                              ),

                                            ]),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 0, right: 0, top: 0, left: 0,
                                        child: InkWell(
                                          onTap: () => authController.pickImageForReg(true, false),
                                          child: DottedBorder(
                                            color: Theme.of(context).primaryColor,
                                            strokeWidth: 1,
                                            strokeCap: StrokeCap.butt,
                                            dashPattern: const [5, 5],
                                            padding: const EdgeInsets.all(0),
                                            borderType: BorderType.RRect,
                                            radius: const Radius.circular(Dimensions.radiusDefault),
                                            child: Center(
                                              child: Visibility(
                                                visible: authController.pickedLogo != null,
                                                child: Container(
                                                  padding: const EdgeInsets.all(25),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(width: 2, color: Colors.white),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: const Icon(CupertinoIcons.photo_camera_solid, color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ])),
                                  ]),
                                ),
                                const SizedBox(width: Dimensions.paddingSizeDefault),

                                Expanded(flex: 6,
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                                    Row(children: [
                                      Text('vendor_cover'.tr, style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.7))),
                                      Text(' (${'3:1'})', style: robotoRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall)),
                                    ]),
                                    const SizedBox(height: Dimensions.paddingSizeDefault),

                                    Stack(children: [
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                          child: authController.pickedCover != null ? GetPlatform.isWeb ? Image.network(
                                            authController.pickedCover!.path, width: context.width, height: 120, fit: BoxFit.cover,
                                          ) : Image.file(
                                            File(authController.pickedCover!.path), width: context.width, height: 120, fit: BoxFit.cover,
                                          ) : SizedBox(
                                            width: context.width, height: 120,
                                            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                                              Icon(CupertinoIcons.photo_camera_solid, size: 30, color: Theme.of(context).disabledColor.withValues(alpha: 0.6)),

                                              Text(
                                                'upload_vendor_cover'.tr,
                                                style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.7)), textAlign: TextAlign.center,
                                              ),

                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                                                child: Text(
                                                  'upload_jpg_png_gif_maximum_2_mb'.tr,
                                                  style: robotoRegular.copyWith(color: Theme.of(context).disabledColor.withValues(alpha: 0.6), fontSize: Dimensions.fontSizeSmall),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),

                                            ]),
                                          ),
                                        ),
                                      ),

                                      Positioned(
                                        bottom: 0, right: 0, top: 0, left: 0,
                                        child: InkWell(
                                          onTap: () => authController.pickImageForReg(false, false),
                                          child: DottedBorder(
                                            color: Theme.of(context).primaryColor,
                                            strokeWidth: 1,
                                            strokeCap: StrokeCap.butt,
                                            dashPattern: const [5, 5],
                                            padding: const EdgeInsets.all(0),
                                            borderType: BorderType.RRect,
                                            radius: const Radius.circular(Dimensions.radiusDefault),
                                            child: Center(
                                              child: Visibility(
                                                visible: authController.pickedCover != null,
                                                child: Container(
                                                  padding: const EdgeInsets.all(25),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(width: 3, color: Colors.white),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: const Icon(CupertinoIcons.photo_camera_solid, color: Colors.white, size: 50),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ]),

                                  ]),
                                ),
                              ]),
                            ]),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeDefault),

                          Text('location_info'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                          const SizedBox(height: Dimensions.paddingSizeDefault),

                          addressController.zoneList != null ? SelectLocationAndModuleViewWidget(
                            fromView: true,  addressController: _addressController[0], addressFocus: _addressFocus[0],
                          ) : const Center(child: CircularProgressIndicator()),

                          const SizedBox(height: Dimensions.paddingSizeLarge),

                          Text('vendor_preference'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                          const SizedBox(height: Dimensions.paddingSizeDefault),

                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                              boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.1), spreadRadius: 1, blurRadius: 10, offset: const Offset(0, 1))],
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeDefault),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                              InkWell(
                                onTap: () {
                                  Get.dialog(const CustomTimePickerWidget());
                                },
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).cardColor,
                                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                        border: Border.all(color: Theme.of(context).disabledColor, width: 0.5),
                                      ),
                                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                                      child: Row(children: [
                                        Expanded(child: Text(
                                          '${authController.storeMinTime} : ${authController.storeMaxTime} ${authController.storeTimeUnit}',
                                          style: robotoMedium,
                                        )),
                                        Icon(Icons.access_time_filled, color: Theme.of(context).primaryColor,)
                                      ]),
                                    ),

                                    Positioned(
                                      left: 10, top: -15,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).cardColor,
                                        ),
                                        padding: const EdgeInsets.all(5),
                                        child: Text('select_time'.tr, style: robotoRegular.copyWith(color: Theme.of(context).disabledColor)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeLarge),

                          Text('business_tin'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                          const SizedBox(height: Dimensions.paddingSizeDefault),

                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                              boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.1), spreadRadius: 1, blurRadius: 10, offset: const Offset(0, 1))],
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeDefault),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                              CustomTextFieldWidget(
                                hintText: 'taxpayer_identification_number_tin'.tr,
                                labelText: 'tin'.tr,
                                controller: _tinNumberController,
                                inputAction: TextInputAction.done,
                                inputType: TextInputType.number,
                                required: true,
                                validator: (value) => ValidateCheck.validateEmptyText(value, "vendor_tin_field_is_required".tr),
                              ),
                              const SizedBox(height: Dimensions.paddingSizeExtremeLarge),

                              InkWell(
                                onTap: () async {
                                  final DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    firstDate: DateTime.now(),
                                    initialDate: DateTime.now(),
                                    lastDate: DateTime(2100),
                                  );

                                  if (pickedDate != null) {
                                    authController.setTinExpireDate(pickedDate);
                                  }
                                },
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).cardColor,
                                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                        border: Border.all(color: Theme.of(context).disabledColor, width: 0.5),
                                      ),
                                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                                      child: Row(children: [
                                        Expanded(child: Text(
                                          authController.tinExpireDate ?? 'select_date'.tr,
                                          style: robotoMedium,
                                        )),
                                        Icon(Icons.calendar_month, color: Theme.of(context).primaryColor),
                                      ]),
                                    ),

                                    Positioned(
                                      left: 10, top: -15,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).cardColor,
                                        ),
                                        padding: const EdgeInsets.all(5),
                                        child: Row(
                                          children: [
                                            Text('expire_date'.tr, style: robotoRegular.copyWith(color: Theme.of(context).disabledColor)),
                                            Text(' *', style: robotoRegular.copyWith(color: Colors.red)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: Dimensions.paddingSizeLarge),

                              Text('tin_certificate'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),

                              Text('vehicle_doc_format'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor)),
                              const SizedBox(height: Dimensions.paddingSizeLarge),

                              authController.tinFiles!.isEmpty ? InkWell(
                                onTap: () {
                                  authController.pickFiles();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge),
                                  child: DottedBorder(
                                    borderType: BorderType.RRect,
                                    radius: const Radius.circular(Dimensions.radiusDefault),
                                    dashPattern: const [8, 4],
                                    strokeWidth: 1,
                                    color: Get.isDarkMode ? Colors.white.withValues(alpha: 0.2) : const Color(0xFFE5E5E5),
                                    child: Container(
                                      height: 120,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Get.isDarkMode ? Colors.white.withValues(alpha: 0.05) : const Color(0xFFFAFAFA),
                                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const SizedBox(width: Dimensions.paddingSizeSmall),
                                          CustomAssetImageWidget(Images.uploadIcon, height: 40, width: 40, color: Get.isDarkMode ? Colors.grey : null),
                                          const SizedBox(width: Dimensions.paddingSizeSmall),
                                          RichText(
                                            textAlign: TextAlign.center,
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: 'click_to_upload'.tr,
                                                  style: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Colors.blue),
                                                ),
                                                const TextSpan(text: '\n'),
                                                TextSpan(
                                                  text: 'or_drag_and_drop'.tr,
                                                  style: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.7)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ) : Padding(
                                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge),
                                child: DottedBorder(
                                  borderType: BorderType.RRect,
                                  radius: const Radius.circular(Dimensions.radiusDefault),
                                  dashPattern: const [8, 4],
                                  strokeWidth: 1,
                                  color: const Color(0xFFE5E5E5),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: Stack(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault),
                                          height: 120,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFFAFAFA),
                                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                          ),
                                          child: Row(
                                            children: [
                                              Flexible(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Builder(
                                                      builder: (context) {
                                                        final filePath = authController.tinFiles![0].paths[0];
                                                        final fileName = filePath!.split('/').last.toLowerCase();

                                                        if (fileName.endsWith('.pdf')) {
                                                          // Show PDF preview
                                                          return Row(
                                                            children: [
                                                              const Icon(Icons.picture_as_pdf, size: 40, color: Colors.red),
                                                              const SizedBox(width: 10),
                                                              Expanded(
                                                                child: Text(
                                                                  fileName,
                                                                  overflow: TextOverflow.ellipsis,
                                                                ),
                                                              ),
                                                              const SizedBox(width: 35),
                                                            ],
                                                          );
                                                        } else if (fileName.endsWith('.doc') || fileName.endsWith('.docx')) {
                                                          // Show Word document preview
                                                          return Row(
                                                            children: [
                                                              const Icon(Icons.description, size: 40, color: Colors.blue),
                                                              const SizedBox(width: 10),
                                                              Expanded(
                                                                child: Text(
                                                                  fileName,
                                                                  overflow: TextOverflow.ellipsis,
                                                                ),
                                                              ),
                                                              const SizedBox(width: 35),
                                                            ],
                                                          );
                                                        } else {
                                                          // Show generic file preview
                                                          return Row(
                                                            children: [
                                                              const Icon(Icons.insert_drive_file, size: 40, color: Colors.grey),
                                                              const SizedBox(width: 10),
                                                              Expanded(
                                                                child: Text(
                                                                  fileName,
                                                                  overflow: TextOverflow.ellipsis,
                                                                ),
                                                              ),
                                                              const SizedBox(width: 35),
                                                            ],
                                                          );
                                                        }
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          right: 0,
                                          top: 0,
                                          child: InkWell(
                                            onTap: () {
                                              authController.removeFile(0);
                                            },
                                            child: const Padding(
                                              padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                                              child: Icon(Icons.delete_forever, color: Colors.red),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              /*SizedBox(
                                height: 150, width: double.infinity,
                                child: GridView.builder(
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 1, mainAxisExtent: 150,
                                    mainAxisSpacing: 10, crossAxisSpacing: 10,
                                  ),
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount: 1,
                                  itemBuilder: (context, index) {
                                    if (index == authController.tinFiles?.length) {
                                      return InkWell(
                                        onTap: () {
                                          authController.pickFiles();
                                        },
                                        child: DottedBorder(
                                          borderType: BorderType.RRect,
                                          radius: const Radius.circular(Dimensions.radiusDefault),
                                          dashPattern: const [8, 4],
                                          strokeWidth: 1,
                                          color: Get.isDarkMode ? Colors.white.withValues(alpha: 0.2) : const Color(0xFFE5E5E5),
                                          child: Container(
                                            height: 150,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: Get.isDarkMode ? Colors.white.withValues(alpha: 0.05) : const Color(0xFFFAFAFA),
                                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                const SizedBox(width: Dimensions.paddingSizeSmall),
                                                CustomAssetImageWidget(Images.uploadIcon, height: 40, width: 40, color: Get.isDarkMode ? Colors.grey : null),
                                                const SizedBox(width: Dimensions.paddingSizeSmall),
                                                RichText(
                                                  textAlign: TextAlign.center,
                                                  text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: 'click_to_upload'.tr,
                                                        style: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Colors.blue),
                                                      ),
                                                      const TextSpan(text: '\n'),
                                                      TextSpan(
                                                        text: 'or_drag_and_drop'.tr,
                                                        style: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.7)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                    return DottedBorder(
                                      borderType: BorderType.RRect,
                                      radius: const Radius.circular(Dimensions.radiusDefault),
                                      dashPattern: const [8, 4],
                                      strokeWidth: 1,
                                      color: const Color(0xFFE5E5E5),
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: Stack(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault),
                                              height: 150,
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFFAFAFA),
                                                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                              ),
                                              child: Row(
                                                children: [
                                                  Flexible(
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Builder(
                                                          builder: (context) {
                                                            final filePath = authController.tinFiles![index].paths[0];
                                                            final fileName = filePath!.split('/').last.toLowerCase();

                                                            if (fileName.endsWith('.pdf')) {
                                                              // Show PDF preview
                                                              return Row(
                                                                children: [
                                                                  const Icon(Icons.picture_as_pdf, size: 40, color: Colors.red),
                                                                  const SizedBox(width: 10),
                                                                  Expanded(
                                                                    child: Text(
                                                                      fileName,
                                                                      overflow: TextOverflow.ellipsis,
                                                                    ),
                                                                  ),
                                                                  const SizedBox(width: 35),
                                                                ],
                                                              );
                                                            } else if (fileName.endsWith('.doc') || fileName.endsWith('.docx')) {
                                                              // Show Word document preview
                                                              return Row(
                                                                children: [
                                                                  const Icon(Icons.description, size: 40, color: Colors.blue),
                                                                  const SizedBox(width: 10),
                                                                  Expanded(
                                                                    child: Text(
                                                                      fileName,
                                                                      overflow: TextOverflow.ellipsis,
                                                                    ),
                                                                  ),
                                                                  const SizedBox(width: 35),
                                                                ],
                                                              );
                                                            } else {
                                                              // Show generic file preview
                                                              return Row(
                                                                children: [
                                                                  const Icon(Icons.insert_drive_file, size: 40, color: Colors.grey),
                                                                  const SizedBox(width: 10),
                                                                  Expanded(
                                                                    child: Text(
                                                                      fileName,
                                                                      overflow: TextOverflow.ellipsis,
                                                                    ),
                                                                  ),
                                                                  const SizedBox(width: 35),
                                                                ],
                                                              );
                                                            }
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Positioned(
                                              right: 0,
                                              top: 0,
                                              child: InkWell(
                                                onTap: () {
                                                  authController.removeFile(index);
                                                },
                                                child: const Padding(
                                                  padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                                                  child: Icon(Icons.delete_forever, color: Colors.red),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );

                                  },
                                ),
                              ),*/

                            ]),
                          ),

                        ]),
                      ),
                    ),

                    Visibility(
                      visible: authController.storeStatus == 0.6,
                      child: Form(
                        key: _formKeySecond,
                        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [

                          Row(children: [
                            Text('owner_info'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                            const SizedBox(width: Dimensions.paddingSizeSmall),

                            CustomToolTip(
                              message: 'this_info_will_need_for_vendor_app_and_panel_login'.tr,
                              preferredDirection: AxisDirection.down,
                              iconColor: Theme.of(context).textTheme.bodyLarge!.color?.withValues(alpha: 0.7),
                            ),
                          ]),
                          const SizedBox(height: Dimensions.paddingSizeDefault),

                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                              boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.1), spreadRadius: 1, blurRadius: 10, offset: const Offset(0, 1))],
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeDefault),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                              CustomTextFieldWidget(
                                hintText: 'write_first_name'.tr,
                                controller: _fNameController,
                                focusNode: _fNameFocus,
                                nextFocus: _lNameFocus,
                                inputType: TextInputType.name,
                                capitalization: TextCapitalization.words,
                                prefixIcon: CupertinoIcons.person_crop_circle_fill,
                                iconSize: 25,
                                required: true,
                                labelText: 'first_name'.tr,
                                validator: (value) => ValidateCheck.validateEmptyText(value, "first_name_field_is_required".tr),
                              ),
                              const SizedBox(height: Dimensions.paddingSizeExtremeLarge),

                              CustomTextFieldWidget(
                                hintText: 'write_last_name'.tr,
                                controller: _lNameController,
                                focusNode: _lNameFocus,
                                nextFocus: _phoneFocus,
                                prefixIcon: CupertinoIcons.person_crop_circle_fill,
                                iconSize: 25,
                                inputType: TextInputType.name,
                                capitalization: TextCapitalization.words,
                                required: true,
                                labelText: 'last_name'.tr,
                                validator: (value) => ValidateCheck.validateEmptyText(value, "last_name_field_is_required".tr),
                              ),
                              const SizedBox(height: Dimensions.paddingSizeExtremeLarge),

                              CustomTextFieldWidget(
                                hintText: 'enter_phone_number'.tr,
                                controller: _phoneController,
                                focusNode: _phoneFocus,
                                nextFocus: _emailFocus,
                                inputType: TextInputType.phone,
                                isPhone: true,
                                onCountryChanged: (CountryCode countryCode) {
                                  _countryDialCode = countryCode.dialCode;
                                },
                                countryDialCode: _countryDialCode != null ? CountryCode.fromCountryCode(Get.find<SplashController>().configModel!.country!).code
                                    : Get.find<LocalizationController>().locale.countryCode,
                                required: true,
                                labelText: 'phone'.tr,
                                validator: (value) => ValidateCheck.validateEmptyText(value, null),
                              ),
                              const SizedBox(height: Dimensions.paddingSizeExtremeLarge),

                              CustomTextFieldWidget(
                                hintText: 'write_email'.tr,
                                controller: _emailController,
                                focusNode: _emailFocus,
                                nextFocus: _passwordFocus,
                                inputType: TextInputType.emailAddress,
                                prefixIcon: Icons.email,
                                iconSize: 25,
                                required: true,
                                labelText: 'email'.tr,
                                validator: (value) => ValidateCheck.validateEmail(value),
                              ),
                              const SizedBox(height: Dimensions.paddingSizeExtremeLarge),

                              Column(children: [
                                CustomTextFieldWidget(
                                  hintText: '8+characters'.tr,
                                  controller: _passwordController,
                                  focusNode: _passwordFocus,
                                  nextFocus: _confirmPasswordFocus,
                                  inputType: TextInputType.visiblePassword,
                                  prefixIcon: Icons.lock,
                                  iconSize: 25,
                                  isPassword: true,
                                  onChanged: (value){
                                    if(value != null && value.isNotEmpty){
                                      if(!authController.showPassView){
                                        authController.showHidePass();
                                      }
                                      authController.validPassCheck(value);
                                    }else{
                                      if(authController.showPassView){
                                        authController.showHidePass();
                                      }
                                    }
                                  },
                                  required: true,
                                  labelText: 'password'.tr,
                                  validator: (value) => ValidateCheck.validateEmptyText(value, "password_field_is_required".tr),
                                ),
                                authController.showPassView ? const PassViewWidget() : const SizedBox(),

                              ]),
                              const SizedBox(height: Dimensions.paddingSizeExtremeLarge),

                              CustomTextFieldWidget(
                                hintText: '8+characters'.tr,
                                controller: _confirmPasswordController,
                                focusNode: _confirmPasswordFocus,
                                inputType: TextInputType.visiblePassword,
                                inputAction: TextInputAction.done,
                                prefixIcon: Icons.lock,
                                iconSize: 25,
                                isPassword: true,
                                required: true,
                                labelText: 'confirm_password'.tr,
                                validator: (value) => ValidateCheck.validateConfirmPassword(value, _passwordController.text),
                              ),
                              // const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                            ]),
                          ),

                        ]),
                      ),
                    ),

                    Visibility(
                      visible: authController.storeStatus == 0.9,
                      child: Column(children: [

                        Padding(
                          padding: const EdgeInsets.only(top: Dimensions.paddingSizeLarge, bottom: Dimensions.paddingSizeExtremeLarge),
                          child: Center(child: Text('choose_your_business_plan'.tr, style: robotoBold)),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                          child: Row(children: [

                            Get.find<SplashController>().configModel!.commissionBusinessModel != 0 ? Expanded(
                              child: BaseCardWidget(authController: authController, title: 'commission_base'.tr,
                                index: 0, onTap: ()=> authController.setBusiness(0),
                              ),
                            ) : const SizedBox(),
                            const SizedBox(width: Dimensions.paddingSizeDefault),

                            Get.find<SplashController>().configModel!.subscriptionBusinessModel != 0 ? Expanded(
                              child: BaseCardWidget(authController: authController, title: 'subscription_base'.tr,
                                index: 1, onTap: ()=> authController.setBusiness(1),
                              ),
                            ) : const SizedBox(),

                          ]),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                        authController.businessIndex == 0 ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                          child: Text(
                            "${'vendor_will_pay'.tr} ${Get.find<SplashController>().configModel!.adminCommission}% ${'commission_to'.tr} ${Get.find<SplashController>().configModel!.businessName} ${'from_each_order_You_will_get_access_of_all'.tr}",
                            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.7)), textAlign: TextAlign.justify, textScaler: const TextScaler.linear(1.1),
                          ),
                        ) : Column(children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                            child: Text(
                              'run_vendor_by_purchasing_subscription_packages'.tr,
                              style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.7)), textAlign: TextAlign.justify, textScaler: const TextScaler.linear(1.1),
                            ),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeLarge),

                          SizedBox(
                            height: 440,
                            child: authController.packageModel != null ? authController.packageModel!.packages!.isNotEmpty ? Swiper(
                              itemCount: authController.packageModel!.packages!.length,
                              viewportFraction: 0.65,
                              itemBuilder: (context, index) {

                                Packages package = authController.packageModel!.packages![index];

                                bool isRentalModule = addressController.moduleList != null && addressController.selectedModuleIndex != -1 &&
                                    addressController.moduleList![addressController.selectedModuleIndex!].moduleType == 'rental';

                                return PackageCardWidget(
                                  currentIndex: authController.activeSubscriptionIndex == index ? index : null,
                                  package: package, isRental: isRentalModule,
                                );
                              },
                              onIndexChanged: (index) {
                                authController.selectSubscriptionCard(index);
                              },

                            ) : Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('no_package_available'.tr, style: robotoMedium),
                                ]),
                            ) : const Center(child: CircularProgressIndicator()),
                          ),

                        ]),

                      ]),
                    ),

                  ]),
                ),
              ),

              SafeArea(
                child: !authController.isLoading ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)],
                  ),
                  child: CustomButtonWidget(
                    buttonText: 'submit'.tr,
                    margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    onPressed: () {
                      bool defaultNameNull = false;
                      bool defaultAddressNull = false;
                      for(int index=0; index<_languageList.length; index++) {
                        if(_languageList[index].key == 'en') {
                          if (_nameController[index].text.trim().isEmpty) {
                            defaultNameNull = true;
                          }
                          if(_addressController[index].text.trim().isEmpty){
                            defaultAddressNull = true;
                          }
                          break;
                        }
                      }
                      String tin = _tinNumberController.text.trim();
                      String minTime = authController.storeMinTime;
                      String maxTime = authController.storeMaxTime;
                      String fName = _fNameController.text.trim();
                      String lName = _lNameController.text.trim();
                      String phone = _phoneController.text.trim();
                      String email = _emailController.text.trim();
                      String password = _passwordController.text.trim();
                      String confirmPassword = _confirmPasswordController.text.trim();
                      String phoneWithCountryCode = _countryDialCode! + phone;
                      bool valid = false;
                      bool isRentalModule = addressController.moduleList != null && addressController.selectedModuleIndex != -1 &&
                        addressController.moduleList![addressController.selectedModuleIndex!].moduleType == 'rental';

                      try {
                        double.parse(maxTime);
                        double.parse(minTime);
                        valid = true;
                      } on FormatException {
                        valid = false;
                      }

                      if(authController.storeStatus == 0.1 || authController.storeStatus == 0.6){
                        if(authController.storeStatus == 0.1){
                          if(_formKeyLogin!.currentState!.validate()){
                            if(defaultNameNull) {
                              showCustomSnackBar('enter_vendor_name'.tr);
                            }else if(authController.pickedLogo == null) {
                              showCustomSnackBar('select_vendor_logo'.tr);
                            }else if(authController.pickedCover == null) {
                              showCustomSnackBar('select_vendor_cover_photo'.tr);
                            }else if(addressController.selectedModuleIndex == -1) {
                              showCustomSnackBar('please_select_module_first'.tr);
                            }else if(isRentalModule && addressController.pickupZoneIdList.isEmpty) {
                              showCustomSnackBar('please_select_pickup_zone'.tr);
                            }else if(defaultAddressNull) {
                              showCustomSnackBar('enter_vendor_address'.tr);
                            }else if(addressController.selectedZoneIndex == -1) {
                              showCustomSnackBar('please_select_zone'.tr);
                            }else if(tin.isEmpty) {
                              showCustomSnackBar('enter_tin'.tr);
                            }else if(authController.tinExpireDate == null || authController.tinExpireDate!.isEmpty) {
                              showCustomSnackBar('select_tin_expire_date'.tr);
                            }else if(authController.tinFiles == null || authController.tinFiles!.isEmpty) {
                              showCustomSnackBar('upload_tin_certificate'.tr);
                            }else if(minTime.isEmpty) {
                              showCustomSnackBar('enter_minimum_delivery_time'.tr);
                            }else if(maxTime.isEmpty) {
                              showCustomSnackBar('enter_maximum_delivery_time'.tr);
                            }else if(!valid) {
                              showCustomSnackBar('please_enter_the_max_min_delivery_time'.tr);
                            }else if(valid && double.parse(minTime) > double.parse(maxTime)) {
                              showCustomSnackBar('maximum_delivery_time_can_not_be_smaller_then_minimum_delivery_time'.tr);
                            }else if(addressController.restaurantLocation == null) {
                              showCustomSnackBar('set_vendor_location'.tr);
                            }else{
                              _scrollController.jumpTo(_scrollController.position.minScrollExtent);
                              authController.storeStatusChange(0.6);
                              firstTime = true;
                            }
                          }
                        }else if(authController.storeStatus == 0.6){
                          if(_formKeySecond!.currentState!.validate()){
                            if(fName.isEmpty) {
                              showCustomSnackBar('enter_your_first_name'.tr);
                            }else if(lName.isEmpty) {
                              showCustomSnackBar('enter_your_last_name'.tr);
                            }else if(phone.isEmpty) {
                              showCustomSnackBar('enter_phone_number'.tr);
                            }else if(email.isEmpty) {
                              showCustomSnackBar('enter_email_address'.tr);
                            }else if(!GetUtils.isEmail(email)) {
                              showCustomSnackBar('enter_a_valid_email_address'.tr);
                            }else if(password.isEmpty) {
                              showCustomSnackBar('enter_password'.tr);
                            }else if(password.length < 6) {
                              showCustomSnackBar('password_should_be'.tr);
                            }else if(password != confirmPassword) {
                              showCustomSnackBar('confirm_password_does_not_matched'.tr);
                            }else {
                              _scrollController.jumpTo(_scrollController.position.minScrollExtent);
                              authController.storeStatusChange(0.9);
                            }
                          }
                        }else{
                          authController.storeStatusChange(0.9);
                        }
                      }else{
                        List<Translation> translation = [];
                        for(int index=0; index<_languageList.length; index++) {
                          translation.add(Translation(
                            locale: _languageList[index].key, key: 'name',
                            value: _nameController[index].text.trim().isNotEmpty ? _nameController[index].text.trim()
                                : _nameController[0].text.trim(),
                          ));
                          translation.add(Translation(
                            locale: _languageList[index].key, key: 'address',
                            value: _addressController[index].text.trim().isNotEmpty ? _addressController[index].text.trim()
                                : _addressController[0].text.trim(),
                          ));
                        }

                        Map<String, String> data = {};

                        data.addAll(StoreBodyModel(
                          translation: jsonEncode(translation), minDeliveryTime: minTime,
                          maxDeliveryTime: maxTime, lat: addressController.restaurantLocation!.latitude.toString(), email: email,
                          lng: addressController.restaurantLocation!.longitude.toString(), fName: fName, lName: lName, phone: phoneWithCountryCode,
                          password: password, zoneId: addressController.zoneList![addressController.selectedZoneIndex!].id.toString(),
                          moduleId: addressController.moduleList![addressController.selectedModuleIndex!].id.toString(),
                          deliveryTimeType: authController.deliveryTimeTypeList[authController.deliveryTimeTypeIndex],
                          businessPlan: authController.businessIndex == 0 ? 'commission' : 'subscription',
                          packageId: authController.packageModel!.packages != null && authController.packageModel!.packages!.isNotEmpty ? authController.packageModel!.packages![authController.activeSubscriptionIndex].id!.toString() : '',
                          pickUpZoneIds: addressController.pickupZoneIdList.map((e) => e.toString()).toList(),
                          tin: tin, tinExpireDate: authController.tinExpireDate,
                        ).toJson());

                        authController.registerStore(data);
                      }

                    },
                  ),
                ) : const Center(child: CircularProgressIndicator()),
              ),

            ]),
          ),
        );
      });
    });
  }

  Future<void> _showBackPressedDialogue(String title) async {
    Get.dialog(ConfirmationDialogWidget(icon: Images.support,
      title: title,
      description: 'are_you_sure_to_go_back'.tr, isLogOut: true,
      onYesPressed: () => Get.offAllNamed(RouteHelper.getSignInRoute()),
    ), useSafeArea: false);
  }

}
