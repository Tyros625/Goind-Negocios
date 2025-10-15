import 'package:flutter/foundation.dart';
import 'package:sixam_mart_store/common/models/response_model.dart';
import 'package:sixam_mart_store/features/auth/controllers/auth_controller.dart';
import 'package:sixam_mart_store/features/auth/domain/models/module_permission_model.dart';
import 'package:sixam_mart_store/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart_store/features/profile/domain/models/profile_model.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sixam_mart_store/features/profile/domain/services/profile_service_interface.dart';

class ProfileController extends GetxController implements GetxService {
  final ProfileServiceInterface profileServiceInterface;
  ProfileController({required this.profileServiceInterface});

  ProfileModel? _profileModel;
  ProfileModel? get profileModel => _profileModel;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  XFile? _pickedFile;
  XFile? get pickedFile => _pickedFile;

  ModulePermissionModel? _modulePermissionBody;
  ModulePermissionModel? get modulePermission => _modulePermissionBody;

  bool _trialWidgetNotShow = false;
  bool get trialWidgetNotShow => _trialWidgetNotShow;

  bool _showLowStockWarning = true;
  bool get showLowStockWarning => _showLowStockWarning;

  bool _backgroundNotification = true;
  bool get backgroundNotification => _backgroundNotification;

  void hideLowStockWarning(){
    _showLowStockWarning = !_showLowStockWarning;
  }

  Future<void> getProfile() async {
    ProfileModel? profileModel = await profileServiceInterface.getProfileInfo();
    if (profileModel != null) {
      _profileModel = profileModel;
      Get.find<SplashController>().setModule(_profileModel!.stores![0].module!.id, _profileModel!.stores![0].module!.moduleType);
      profileServiceInterface.updateHeader(_profileModel!.stores![0].module!.id);
      _allowModulePermission(_profileModel?.roles);
    }
    update();
  }

  Future<bool> updateUserInfo(ProfileModel updateUserModel, String token) async {
    _isLoading = true;
    update();
    bool isSuccess = await profileServiceInterface.updateProfile(updateUserModel, _pickedFile, token);
    _isLoading = false;
    if (isSuccess) {
      await getProfile();
      Get.back();
      showCustomSnackBar('profile_updated_successfully'.tr, isError: false);
    }
    update();
    return isSuccess;
  }

  void pickImage() async {
    XFile? picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if(picked != null) {
      _pickedFile = picked;
    }
    update();
  }

  Future deleteVendor() async {
    _isLoading = true;
    update();
    ResponseModel responseModel = await profileServiceInterface.deleteVendor();
    _isLoading = false;
    if (responseModel.isSuccess) {
      showCustomSnackBar(responseModel.message, isError: false);
      Get.find<AuthController>().clearSharedData();
      Get.offAllNamed(RouteHelper.getSignInRoute());
    }else{
      Get.back();
      showCustomSnackBar(responseModel.message, isError: true);
    }
  }

  void _allowModulePermission(List<String>? roles) {
    debugPrint('---permission--->> $roles');
    if (roles != null && roles.isNotEmpty) {
      List<String> module = roles;
      if (kDebugMode) {
        print(module);
      }
      _modulePermissionBody = ModulePermissionModel(
        dashboard: module.contains('dashboard'),
        profile: module.contains('profile'),
        order: module.contains('order'),
        pos: module.contains('pos'),
        item: module.contains('item'),
        addon: module.contains('addon'),
        category: module.contains('category'),
        campaign: module.contains('campaign'),
        coupon: module.contains('coupon'),
        banner: module.contains('banner'),
        advertisement: module.contains('advertisement'),
        advertisementList: module.contains('advertisement_list'),
        deliveryman: module.contains('deliveryman'),
        deliverymanList: module.contains('deliveryman_list'),
        wallet: module.contains('wallet'),
        walletMethod: module.contains('wallet_method'),
        role: module.contains('role'),
        employee: module.contains('employee'),
        expenseReport: module.contains('expense_report'),
        disbursementReport: module.contains('disbursement_report'),
        vatReport: module.contains('vat_report'),
        storeSetup: module.contains('store_setup'),
        notificationSetup: module.contains('notification_setup'),
        myShop: module.contains('my_shop'),
        businessPlan: module.contains('business_plan'),
        reviews: module.contains('reviews'),
        chat: module.contains('chat'),
      );
    } else {
      _modulePermissionBody = ModulePermissionModel(
        dashboard: true, profile: true, order: true, pos: true, item: true, addon: true, category: true, campaign: true, coupon: true, banner: true,
        advertisement: true, advertisementList: true, deliveryman: true, deliverymanList: true, wallet: true, walletMethod: true, role: true,
        employee: true, expenseReport: true, disbursementReport: true, vatReport: true, storeSetup: true, notificationSetup: true,
        myShop: true, businessPlan: true, reviews: true, chat: true,
      );
    }
  }

  void initData() {
    _pickedFile = null;
  }

  Future<bool> trialWidgetShow({required String route}) async {
    const Set<String> routesToHideWidget = {
      RouteHelper.mySubscription, 'show-dialog', RouteHelper.success, RouteHelper.payment, RouteHelper.signIn,
    };
    _trialWidgetNotShow = routesToHideWidget.contains(route);
    Future.delayed(const Duration(milliseconds: 500), () {
      update();
    });
    return _trialWidgetNotShow;
  }

  void initTrialWidgetNotShow(){
    _trialWidgetNotShow = false;
  }

  void setBackgroundNotificationActive(bool isActive) {
    _backgroundNotification = isActive;
    update();
  }

}