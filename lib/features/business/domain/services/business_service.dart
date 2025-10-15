import 'package:get/get.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:sixam_mart_store/features/business/domain/models/business_plan_body.dart';
import 'package:sixam_mart_store/features/business/domain/models/package_model.dart';
import 'package:sixam_mart_store/features/business/domain/repositories/business_repo_interface.dart';
import 'package:sixam_mart_store/features/business/domain/services/business_service_interface.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';

class BusinessService implements BusinessServiceInterface{
  final BusinessRepoInterface businessRepoInterface;
  BusinessService({required this.businessRepoInterface});

  @override
  Future<PackageModel?> getPackageList() async {
    return await businessRepoInterface.getList();
  }

  @override
  Future<String> processesBusinessPlan(String businessPlanStatus, int paymentIndex, int storeId, String? digitalPaymentName, int? selectedPackageId) async {

    String businessPlan = 'subscription';
    int? packageId = selectedPackageId;
    String? payment = paymentIndex == 0 ? 'free_trial' : digitalPaymentName;

    if(paymentIndex == 1 && digitalPaymentName == null) {
      showCustomSnackBar('please_select_payment_method'.tr);
    } else {
      businessPlanStatus = await setUpBusinessPlan(
        BusinessPlanBody(
          businessPlan: businessPlan,
          packageId: packageId.toString(),
          storeId: storeId.toString(),
          payment: payment,
          paymentGateway: payment,
          callBack: paymentIndex == 0 ? '' : RouteHelper.success,
          paymentPlatform: 'app',
          type: 'new_join',
        ),
        digitalPaymentName, businessPlanStatus, storeId, packageId!,
      );
    }
    return businessPlanStatus;
  }

  @override
  Future<String> setUpBusinessPlan(BusinessPlanBody businessPlanBody, String? digitalPaymentName, String businessPlanStatus, int storeId, int? packageId) async {
    Response response = await businessRepoInterface.setUpBusinessPlan(businessPlanBody);
    if (response.statusCode == 200) {
      if(response.body['redirect_link'] != null) {
        String redirectUrl = response.body['redirect_link'];
        Get.back();
        Get.toNamed(RouteHelper.getPaymentRoute(digitalPaymentName, redirectUrl, storeId, true, packageId));
      }else {
        businessPlanStatus = 'complete';
        Get.offAllNamed(RouteHelper.getSubscriptionSuccessRoute(status: 'success', fromSubscription: packageId != null ? true : false, storeId: storeId, packageId: packageId));
      }
    }
    return businessPlanStatus;
  }

}