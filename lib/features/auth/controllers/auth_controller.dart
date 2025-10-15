import 'package:file_picker/file_picker.dart';
import 'package:sixam_mart_store/api/api_client.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:sixam_mart_store/features/business/controllers/business_controller.dart';
import 'package:sixam_mart_store/features/business/domain/models/package_model.dart';
import 'package:sixam_mart_store/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart_store/features/profile/domain/models/profile_model.dart';
import 'package:sixam_mart_store/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart_store/common/models/response_model.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sixam_mart_store/features/auth/domain/services/auth_service_interface.dart';
import 'package:sixam_mart_store/features/rental_module/profile/controllers/taxi_profile_controller.dart';
import 'package:sixam_mart_store/helper/date_converter_helper.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';

class AuthController extends GetxController implements GetxService {
  final AuthServiceInterface authServiceInterface;
  AuthController({required this.authServiceInterface}){
    _notification = authServiceInterface.isNotificationActive();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _notification = true;
  bool get notification => _notification;

  XFile? _pickedLogo;
  XFile? get pickedLogo => _pickedLogo;

  XFile? _pickedCover;
  XFile? get pickedCover => _pickedCover;

  final List<String?> _deliveryTimeTypeList = ['minute', 'hours', 'days'];
  List<String?> get deliveryTimeTypeList => _deliveryTimeTypeList;

  int _deliveryTimeTypeIndex = 0;
  int get deliveryTimeTypeIndex => _deliveryTimeTypeIndex;

  int _vendorTypeIndex = 0;
  int get vendorTypeIndex => _vendorTypeIndex;

  bool _lengthCheck = false;
  bool get lengthCheck => _lengthCheck;

  bool _numberCheck = false;
  bool get numberCheck => _numberCheck;

  bool _uppercaseCheck = false;
  bool get uppercaseCheck => _uppercaseCheck;

  bool _lowercaseCheck = false;
  bool get lowercaseCheck => _lowercaseCheck;

  bool _spatialCheck = false;
  bool get spatialCheck => _spatialCheck;

  double _storeStatus = 0.1;
  double get storeStatus => _storeStatus;

  String _storeMinTime = '--';
  String get storeMinTime => _storeMinTime;

  String _storeMaxTime = '--';
  String get storeMaxTime => _storeMaxTime;

  String _storeTimeUnit = 'minute';
  String get storeTimeUnit => _storeTimeUnit;

  bool _showPassView = false;
  bool get showPassView => _showPassView;

  bool _isActiveRememberMe = false;
  bool get isActiveRememberMe => _isActiveRememberMe;

  ProfileModel? _profileModel;
  ProfileModel? get profileModel => _profileModel;

  String? _subscriptionType;
  String? get subscriptionType => _subscriptionType;

  String? _expiredToken;
  String? get expiredToken => _expiredToken;

  bool _notificationLoading = false;
  bool get notificationLoading => _notificationLoading;

  final List<FilePickerResult> _tinFiles = [];
  List<FilePickerResult>? get tinFiles => _tinFiles;

  String? _tinExpireDate;
  String? get tinExpireDate => _tinExpireDate;

  Future<ResponseModel?> login(String? email, String password, String type) async {
    _isLoading = true;
    update();
    Response response = await authServiceInterface.login(email, password, type);
    ResponseModel? responseModel = await authServiceInterface.manageLogin(response, type);
    _isLoading = false;
    update();
    return responseModel;
  }

  void pickImageForReg(bool isLogo, bool isRemove) async {
    if(isRemove) {
      _pickedLogo = null;
      _pickedCover = null;
    }else {
      if (isLogo) {
        _pickedLogo = await ImagePicker().pickImage(source: ImageSource.gallery);
      } else {
        _pickedCover = await ImagePicker().pickImage(source: ImageSource.gallery);
      }
      update();
    }
  }

  Future<void> updateToken() async {
    await authServiceInterface.updateToken();
  }


  void toggleRememberMe() {
    _isActiveRememberMe = !_isActiveRememberMe;
    update();
  }

  bool isLoggedIn() {
    return authServiceInterface.isLoggedIn();
  }

  void storeStatusChange(double value, {bool isUpdate = true}){
    _storeStatus = value;
    if(isUpdate) {
      update();
    }
  }

  void minTimeChange(String time){
    _storeMinTime = time;
    update();
  }

  void maxTimeChange(String time){
    _storeMaxTime = time;
    update();
  }

  void timeUnitChange(String unit){
    _storeTimeUnit = unit;
    update();
  }

  void changeVendorType(int index, {bool isUpdate = true}){
    _vendorTypeIndex = index;
    if(isUpdate) {
      update();
    }
  }

  Future<bool> clearSharedData() async {
    Get.find<SplashController>().setModule(null, null);
    return await authServiceInterface.clearSharedData();
  }

  void saveUserNumberAndPassword(String number, String password, String type) {
    authServiceInterface.saveUserNumberAndPassword(number, password, type);
  }

  String getUserNumber() {
    return authServiceInterface.getUserNumber();
  }
  String getUserPassword() {
    return authServiceInterface.getUserPassword();
  }
  String getUserType() {
    return authServiceInterface.getUserType();
  }

  Future<bool> clearUserNumberAndPassword() async {
    return authServiceInterface.clearUserNumberAndPassword();
  }

  String getUserToken() {
    return authServiceInterface.getUserToken();
  }

  Future<bool> setNotificationActive(bool isActive) async {
    _notificationLoading = true;
    update();
    _notification = isActive;
    await authServiceInterface.setNotificationActive(isActive);
    _notificationLoading = false;
    update();
    return _notification;
  }


  Future<void> toggleStoreClosedStatus() async {
    bool isSuccess = await authServiceInterface.toggleStoreClosedStatus();
    if (isSuccess) {
      if(getModuleType() == 'rental'){
        await Get.find<TaxiProfileController>().getProfile();
      }else{
        Get.find<ProfileController>().getProfile();
      }
    }
    update();
  }

  Future<void> registerStore(Map<String, String> data) async {
    _isLoading = true;
    update();

    List<FilePickerResult> tinFiles = [];

    for (FilePickerResult element in _tinFiles) {
      tinFiles.add(element);
    }

    List<MultipartDocument> document = [];
    for (FilePickerResult result in tinFiles) {
      document.add(MultipartDocument('tin_certificate_image', result));
    }

    Response response = await authServiceInterface.registerRestaurant(data, _pickedLogo, _pickedCover, document);

    if(response.statusCode == 200){
      int? storeId = response.body['store_id'];
      int? packageId = response.body['package_id'];

      if(packageId == null) {
        Get.find<BusinessController>().submitBusinessPlan(storeId: storeId!, packageId: null);
      }else{
        Get.toNamed(RouteHelper.getSubscriptionPaymentRoute(storeId: storeId, packageId: packageId));
      }
    }

    _isLoading = false;
    update();
  }

  void setDeliveryTimeTypeIndex(String? type, bool notify) {
    _deliveryTimeTypeIndex = _deliveryTimeTypeList.indexOf(type);
    if(notify) {
      update();
    }
  }

  void showHidePass({bool isUpdate = true}){
    _showPassView = ! _showPassView;
    if(isUpdate) {
      update();
    }
  }

  void validPassCheck(String pass, {bool isUpdate = true}){
    _lengthCheck = false;
    _numberCheck = false;
    _uppercaseCheck = false;
    _lowercaseCheck = false;
    _spatialCheck = false;

    if(pass.length > 7){
      _lengthCheck = true;
    }
    if(pass.contains(RegExp(r'[a-z]'))){
      _lowercaseCheck = true;
    }
    if(pass.contains(RegExp(r'[A-Z]'))){
      _uppercaseCheck = true;
    }
    if(pass.contains(RegExp(r'[ .!@#$&*~^%]'))){
      _spatialCheck = true;
    }
    if(pass.contains(RegExp(r'[\d+]'))){
      _numberCheck = true;
    }
    if(isUpdate) {
      update();
    }
  }

  Future<bool> saveIsStoreRegistrationSharedPref(bool status) async {
    return await authServiceInterface.saveIsStoreRegistration(status);
  }

  bool getIsStoreRegistrationSharedPref() {
    return authServiceInterface.getIsStoreRegistration();
  }

  String _businessPlanStatus = 'business';
  String get businessPlanStatus => _businessPlanStatus;

  int _paymentIndex = 0;
  int get paymentIndex => _paymentIndex;

  int _businessIndex = 0;
  int get businessIndex => _businessIndex;

  int _activeSubscriptionIndex = 0;
  int get activeSubscriptionIndex => _activeSubscriptionIndex;

  bool _isFirstTime = true;
  bool get isFirstTime => _isFirstTime;

  PackageModel? _packageModel;
  PackageModel? get packageModel => _packageModel;

  void changeFirstTimeStatus() {
    _isFirstTime = !_isFirstTime;
  }

  void resetBusiness(){
    _businessIndex = (Get.find<SplashController>().configModel!.commissionBusinessModel == 0) ? 1 : 0;
    _activeSubscriptionIndex = 0;
    _businessPlanStatus = 'business';
    _isFirstTime = true;
    _paymentIndex = Get.find<SplashController>().configModel!.subscriptionFreeTrialStatus! ? 0 : 1;
  }

  Future<void> getPackageList({bool isUpdate = true, int? moduleId}) async {
    _packageModel = await authServiceInterface.getPackageList(moduleId: moduleId);
    if(isUpdate) {
      update();
    }
  }

  void setBusiness(int business){
    _activeSubscriptionIndex = 0;
    _businessIndex = business;
    update();
  }

  void setBusinessStatus(String status){
    _businessPlanStatus = status;
    update();
  }

  void selectSubscriptionCard(int index){
    _activeSubscriptionIndex = index;
    update();
  }

  String getModuleType() {
    return authServiceInterface.getModuleType();
  }

  void setModuleType(String type){
    authServiceInterface.setModuleType(type);
  }

  Future<void> pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
      allowMultiple: false,
    );

    if (result != null && result.files.isNotEmpty) {
      for (var file in result.files) {
        if (file.size > 2000000) {
          showCustomSnackBar('please_upload_lower_size_file'.tr);
        } else {
          _tinFiles.add(result);
        }
      }
      update();
    }
  }

  void removeFile(int index) {
    _tinFiles.removeAt(index);
    update();
  }

  Future<void> setTinExpireDate(DateTime dateTime) async {
    _tinExpireDate = DateConverterHelper.dateTimeForCoupon(dateTime);
    update();
  }

  void resetData(){
    _tinExpireDate = null;
    _tinFiles.clear();
    _storeMinTime = '--';
    _storeMaxTime = '--';
    _storeTimeUnit = 'minute';
  }

}