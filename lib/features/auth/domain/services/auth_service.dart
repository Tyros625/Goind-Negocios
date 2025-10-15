import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sixam_mart_store/api/api_client.dart';
import 'package:sixam_mart_store/common/models/response_model.dart';
import 'package:sixam_mart_store/features/auth/domain/repositories/auth_repository_interface.dart';
import 'package:sixam_mart_store/features/auth/domain/services/auth_service_interface.dart';
import 'package:sixam_mart_store/features/business/domain/models/package_model.dart';
import 'package:sixam_mart_store/features/business/screens/subscription_payment_screen.dart';
import 'package:sixam_mart_store/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart_store/features/rental_module/profile/controllers/taxi_profile_controller.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';

class AuthService implements AuthServiceInterface {
  final AuthRepositoryInterface authRepositoryInterface;
  AuthService({required this.authRepositoryInterface});

  @override
  Future<Response> login(String? email, String password, String type) async {
    return await authRepositoryInterface.login(email, password, type);
  }

  @override
  Future<Response> registerRestaurant(Map<String, String> data, XFile? logo, XFile? cover, List<MultipartDocument> tinFiles) async {
    return await authRepositoryInterface.registerRestaurant(data, logo, cover, tinFiles);
  }

  @override
  Future<Response> updateToken() async {
    return await authRepositoryInterface.updateToken();
  }

  @override
  Future<bool> saveUserToken(String token, String zoneTopic, String type) async {
    return await authRepositoryInterface.saveUserToken(token, zoneTopic, type);
  }

  @override
  String getUserToken() {
    return authRepositoryInterface.getUserToken();
  }

  @override
  bool isLoggedIn() {
    return authRepositoryInterface.isLoggedIn();
  }

  @override
  Future<bool> clearSharedData() async {
    return await authRepositoryInterface.clearSharedData();
  }

  @override
  Future<void> saveUserNumberAndPassword(String number, String password, String type) async {
    return await authRepositoryInterface.saveUserNumberAndPassword(number, password, type);
  }

  @override
  String getUserNumber() {
    return authRepositoryInterface.getUserNumber();
  }

  @override
  String getUserPassword() {
    return authRepositoryInterface.getUserPassword();
  }

  @override
  String getUserType() {
    return authRepositoryInterface.getUserType();
  }

  @override
  bool isNotificationActive() {
    return authRepositoryInterface.isNotificationActive();
  }

  @override
  Future<void> setNotificationActive(bool isActive) async{
    return await authRepositoryInterface.setNotificationActive(isActive);
  }

  @override
  Future<bool> clearUserNumberAndPassword() async {
    return await authRepositoryInterface.clearUserNumberAndPassword();
  }

  @override
  Future<bool> toggleStoreClosedStatus() async {
    return await authRepositoryInterface.toggleStoreClosedStatus();
  }

  @override
  Future<bool> saveIsStoreRegistration(bool status) async {
    return await authRepositoryInterface.saveIsStoreRegistration(status);
  }

  @override
  bool getIsStoreRegistration() {
    return authRepositoryInterface.getIsStoreRegistration();
  }

  @override
  Future<ResponseModel?> manageLogin(Response response, String type) async {
    ResponseModel? responseModel;
    if (response.statusCode == 200) {

      String? moduleType = response.body['module_type'];
      setModuleType(moduleType ?? '');

      if(response.body['subscribed'] != null){
        int? storeId = response.body['subscribed']['store_id'];
        int? packageId = response.body['subscribed']['package_id'];

        if(packageId == null) {

          saveUserToken(response.body['subscribed']['token'], response.body['subscribed']['zone_wise_topic'], type);
          await updateToken();
          moduleType == 'rental' ? await Get.find<TaxiProfileController>().getProfile() : await Get.find<ProfileController>().getProfile();

          Get.toNamed(RouteHelper.getMySubscriptionRoute(fromNotification: true));
        } else {
          Get.to(()=> SubscriptionPaymentScreen(storeId: storeId!, packageId: packageId));
          responseModel = ResponseModel(false, 'please_select_payment_method'.tr);
        }
      }else{
        saveUserToken(response.body['token'], response.body['zone_wise_topic'], type);
        await updateToken();
        moduleType == 'rental' ? Get.find<TaxiProfileController>().getProfile() : Get.find<ProfileController>().getProfile();
        responseModel = ResponseModel(true, 'successful');
      }
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    return responseModel;
  }

  @override
  Future<PackageModel?> getPackageList({int? moduleId}) async {
    return await authRepositoryInterface.getPackageList(moduleId: moduleId);
  }

  @override
  String getModuleType() {
    return authRepositoryInterface.getModuleType();
  }

  @override
  void setModuleType(String type) {
    authRepositoryInterface.setModuleType(type);
  }

}