import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/common/models/response_model.dart';
import 'package:sixam_mart_store/common/widgets/custom_bottom_sheet_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:sixam_mart_store/features/auth/controllers/auth_controller.dart';
import 'package:sixam_mart_store/features/business/domain/models/package_model.dart';
import 'package:sixam_mart_store/features/subscription/domain/models/check_product_limit_model.dart';
import 'package:sixam_mart_store/features/subscription/widgets/renew_subscription_plan_bottom_sheet.dart';
import 'package:sixam_mart_store/features/subscription/widgets/subscription_dialog_widget.dart';
import 'package:sixam_mart_store/features/subscription/widgets/trial_end_bottomsheet.dart';
import 'package:sixam_mart_store/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart_store/features/profile/domain/models/profile_model.dart';
import 'package:sixam_mart_store/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart_store/features/subscription/domain/models/subscription_transaction_model.dart';
import 'package:sixam_mart_store/features/subscription/domain/services/subscription_service_interface.dart';
import 'package:sixam_mart_store/features/rental_module/profile/controllers/taxi_profile_controller.dart';
import 'package:sixam_mart_store/helper/date_converter_helper.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';
import 'package:sixam_mart_store/util/images.dart';

class SubscriptionController extends GetxController implements GetxService {
  final SubscriptionServiceInterface subscriptionServiceInterface;
  SubscriptionController({required this.subscriptionServiceInterface});

  int _activeSubscriptionIndex = -1;
  int get activeSubscriptionIndex => _activeSubscriptionIndex;

  String _renewStatus = 'packages';
  String get renewStatus => _renewStatus;

  bool? _isActivePackage;
  bool? get isActivePackage => _isActivePackage;

  String? _expiredToken;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Packages>? _packageList;
  List<Packages>? get packageList => _packageList;


  bool _showSubscriptionAlertDialog = true;
  bool get showSubscriptionAlertDialog => _showSubscriptionAlertDialog;

  int _paymentIndex = 0;
  int get paymentIndex => _paymentIndex;

  ProfileModel? _profileModel;
  ProfileModel? get profileModel => _profileModel;

  String? _digitalPaymentName;
  String? get digitalPaymentName => _digitalPaymentName;

  bool _isSelect = false;
  bool get isSelect => _isSelect;

  int? _pageSize;
  int? get pageSize => _pageSize;

  List<String> _offsetList = [];

  int _offset = 1;
  int get offset => _offset;

  List<Transactions>? _transactions;
  List<Transactions>? get transactions => _transactions;

  late DateTimeRange _selectedDateRange;

  String? _from;
  String? get from => _from;

  String? _to;
  String? get to => _to;

  String? _searchText;
  String? get searchText => _searchText;

  bool _searchMode = false;
  bool get searchMode => _searchMode;

  bool _isDigitalPaymentSelect = false;
  bool get isDigitalPaymentSelect => _isDigitalPaymentSelect;

  bool _isTrialEndModalShown = false;
  bool get isTrialEndModalShown => _isTrialEndModalShown;

  void isSelectChange(bool status){
    _isSelect = status;
    update();
  }

  void changeDigitalPaymentName(String? name, {bool canUpdate = true}){
    _digitalPaymentName = name;
    _isDigitalPaymentSelect = true;
    if(canUpdate) {
      update();
    }
  }

  void selectSubscriptionCard(int index){
    _activeSubscriptionIndex = index;
    update();
  }

  void renewChangePackage(String statusPackage){
    _renewStatus = statusPackage;
    update();
  }

  void initializeRenew(){
    _renewStatus = 'packages';
    _isActivePackage = true;
    _paymentIndex = 0;
  }

  void activePackage(bool status){
    _isActivePackage = status;
    update();
  }

  void setPaymentIndex(int index){
    _paymentIndex = index;
    update();
  }

  void showAlert({bool willUpdate = false}){
    _showSubscriptionAlertDialog = !_showSubscriptionAlertDialog;
    if(willUpdate){
      update();
    }
  }

  void closeAlertDialog(){
    if(_showSubscriptionAlertDialog) {
      _showSubscriptionAlertDialog = !_showSubscriptionAlertDialog;
      update();
    }
  }

  Future<ResponseModel?> renewBusinessPlan({required String storeId, required bool isCommission}) async {
    _isLoading = true;
    update();
    int? packageId = _packageList![_activeSubscriptionIndex].id;
    Map<String, String> body = {
      'package_id' : packageId.toString(),
      'store_id': storeId,
      'type': _isActivePackage! ? 'renew' : 'payment',
      'payment_type': _paymentIndex == 0 ? 'wallet' : 'pay_now',
      'payment_method': _paymentIndex == 0 ? 'wallet' : _digitalPaymentName ?? '',
      'payment_gateway': _paymentIndex == 0 ? 'wallet' : _digitalPaymentName ?? '',
      'business_plan': isCommission ? 'commission' : 'subscription',
      'callback': RouteHelper.success,
    };
    Map<String, String>? header;
    if(_expiredToken != null){
      header = {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $_expiredToken'
      };
    }
    Response response = await subscriptionServiceInterface.renewBusinessPlan(body, header);
    ResponseModel? responseModel;
    if (response.statusCode == 200) {
      if(response.body['redirect_link'] != null) {
        String redirectUrl = response.body['redirect_link'];
        Get.back();
        Get.toNamed(RouteHelper.getPaymentRoute(digitalPaymentName, redirectUrl,  null, false, null));
      } else {
        _renewStatus = 'packages';
        if(Get.find<AuthController>().getModuleType() == 'rental'){
          await Get.find<TaxiProfileController>().getProfile();
        }
        await Get.find<ProfileController>().getProfile();
        getProfile(Get.find<ProfileController>().profileModel);
        Get.back();
        Get.back();
        showCustomSnackBar(response.body['store_business_model'] == 'commission' ? 'successfully_switched_to_commission_based_plan'.tr : 'subscription_payment_successfully'.tr, isError: false);
      }
    }else {
      if(response.statusCode == 403) {
        showCustomSnackBar('you_have_not_sufficient_balance_on_you_wallet_please_add_money_to_your_wallet_to_purchase_the_packages'.tr, isError: true);
      }else {
        showCustomSnackBar(response.body['errors']['message'], isError: true);
      }
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<void> cancelSubscription(int storeId, int subscriptionId) async {
    _isLoading = true;
    update();
    Response response = await subscriptionServiceInterface.cancelSubscription({'store_id' : '$storeId', 'subscription_id': '$subscriptionId'});
    if(response.statusCode == 200) {
      if(Get.find<AuthController>().getModuleType() == 'rental'){
        await Get.find<TaxiProfileController>().getProfile();
      }
      await Get.find<ProfileController>().getProfile();
      await getProfile(Get.find<ProfileController>().profileModel);
      Get.back();
      showCustomSnackBar('subscription_cancel_successfully'.tr, isError: false);
    }
    _isLoading = false;
    update();
  }

  Future<void> getPackageList() async {
    if(Get.find<AuthController>().packageModel == null || Get.find<AuthController>().packageModel!.packages!.isEmpty) {
      await Get.find<AuthController>().getPackageList(moduleId: Get.find<ProfileController>().profileModel!.stores![0].module?.id);
    }
    _packageList = [];
    if(Get.find<SplashController>().configModel?.commissionBusinessModel == 1){
      _packageList!.add(Packages(
        id: -1,
        packageName: 'commission_base'.tr,
        price: Get.find<SplashController>().configModel!.adminCommission,
        description: "${'vendor_will_pay'.tr} ${Get.find<SplashController>().configModel!.adminCommission}% ${'commission_to'.tr} ${Get.find<SplashController>().configModel!.businessName} ${'from_each_order_You_will_get_access_of_all'.tr}",
      ));
    }
    for (var package in Get.find<AuthController>().packageModel!.packages!) {
      _packageList!.add(package);
    }

    Future.delayed(const Duration(milliseconds: 800), () => update());
  }

  Future<void> getProfile(ProfileModel? proModel) async {
    _profileModel = proModel;
  }

  void initSetDate(){
    _from = DateConverterHelper.dateTimeForCoupon(DateTime.now().subtract(const Duration(days: 30)));
    _to = DateConverterHelper.dateTimeForCoupon(DateTime.now());
    _searchText = '';
  }

  void setSearchText({required String offset, required String? from, required String? to, required String searchText}){
    _searchText = searchText;
    _searchMode = !_searchMode;
    getSubscriptionTransactionList(offset: offset.toString(), from: from, to: to, searchText: searchText);
  }

  Future<void> getSubscriptionTransactionList({required String offset, required String? from, required String? to, required String? searchText}) async {

    if(offset == '1') {
      _offsetList = [];
      _offset = 1;
      _transactions = null;
      update();
    }
    if (!_offsetList.contains(offset)) {
      _offsetList.add(offset);

      SubscriptionTransactionModel? subscriptionTransactionModel = await subscriptionServiceInterface.getSubscriptionTransactionList(
        offset: int.parse(offset), from: from, to: to,
        restaurantId: Get.find<ProfileController>().profileModel!.stores![0].id, searchText: searchText,
      );
      if (subscriptionTransactionModel != null) {
        if (offset == '1') {
          _transactions = [];
        }
        _transactions!.addAll(subscriptionTransactionModel.transactions!);
        _pageSize = subscriptionTransactionModel.totalSize;
        _isLoading = false;
        update();
      }
    }else {
      if(isLoading) {
        _isLoading = false;
        update();
      }
    }
  }

  void setOffset(int offset) {
    _offset = offset;
  }

  void showBottomLoader() {
    _isLoading = true;
    update();
  }

  void showDatePicker(BuildContext context) async {
    final DateTimeRange? result = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      currentDate: DateTime.now(),
      saveText: 'Done',
    );

    if (result != null) {
      _selectedDateRange = result;

      _from = _selectedDateRange.start.toString().split(' ')[0];
      _to = _selectedDateRange.end.toString().split(' ')[0];
      update();
      getSubscriptionTransactionList(offset: '1', from: _from, to: _to, searchText: searchText);
    }
  }

  Future<bool> trialEndBottomSheet() async {
    if(Get.find<ProfileController>().profileModel != null && Get.find<ProfileController>().profileModel!.stores![0].storeBusinessModel != 'commission' && Get.find<ProfileController>().profileModel!.subscription?.status == 0) {
      Future.delayed(const Duration(seconds: 1), () {
        showModalBottomSheet(
          context: Get.context!, isScrollControlled: true, backgroundColor: Colors.transparent,
          builder: (con) => TrialEndBottomSheet(isTrial: Get.find<ProfileController>().profileModel!.subscription?.isTrial == 1),
        ).whenComplete(() {
          _isTrialEndModalShown = false;
          update();
        });
      });
      return false;
    } else {
      return true;
    }
  }

  void setTrialEndModalShown(bool status) {
    _isTrialEndModalShown = status;
    update();
  }

  Future<void> getProductLimit({required int storeId, required int packageId, required Packages package, required Packages activePackage})async {
    _isLoading = true;
    update();

    CheckProductLimitModel? checkProductLimitModel = await subscriptionServiceInterface.getProductLimit(storeId: storeId, packageId: packageId);

    if(checkProductLimitModel != null) {
      if(checkProductLimitModel.disableItemCount == null || checkProductLimitModel.disableItemCount == 0) {
        showCustomBottomSheet(
          child: RenewSubscriptionPlanBottomSheet(
            isRenew: false,
            package: package,
            activePackage: activePackage,
            checkProductLimitModel: checkProductLimitModel,
          ),
        );
      } else {
        Get.dialog(SubscriptionDialogWidget(
          icon: Images.support,
          title: 'are_you_sure_you_want_to_switch_to_this_plan'.tr,
          description: '${'you_are_about_to_downgrade_your_plan_after_subscribing_to_this_plan_your_oldest'.tr} ${checkProductLimitModel.disableItemCount} ${'items_will_be_inactivated'.tr}',
          onYesPressed: () {
            Get.back();

            showCustomBottomSheet(
              child: RenewSubscriptionPlanBottomSheet(
                isRenew: false,
                package: package,
                activePackage: activePackage,
                checkProductLimitModel: checkProductLimitModel,
              ),
            );
          },
        ), useSafeArea: false);
      }
    }

    _isLoading = false;
    update();
  }

}