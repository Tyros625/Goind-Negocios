import 'package:sixam_mart_store/features/subscription/domain/models/check_product_limit_model.dart';
import 'package:sixam_mart_store/features/subscription/domain/models/subscription_transaction_model.dart';
import 'package:sixam_mart_store/features/subscription/domain/repositories/subscription_repository_interface.dart';
import 'package:sixam_mart_store/features/subscription/domain/services/subscription_service_interface.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class SubscriptionService implements SubscriptionServiceInterface {
  final SubscriptionRepositoryInterface subscriptionRepositoryInterface;
  SubscriptionService({required this.subscriptionRepositoryInterface});

  @override
  Future<Response> renewBusinessPlan(Map<String, String> body, Map<String, String>? headers) async{
   return await subscriptionRepositoryInterface.renewBusinessPlan(body, headers);
  }

  @override
  Future<SubscriptionTransactionModel?> getSubscriptionTransactionList({required int offset, required int? restaurantId, required String? from, required String? to,  required String? searchText}) async {
    return await subscriptionRepositoryInterface.getSubscriptionTransactionList(offset: offset, restaurantId: restaurantId, from: from, to: to, searchText: searchText);
  }

  @override
  Future<Response> cancelSubscription(Map<String, String> body) async {
    return await subscriptionRepositoryInterface.cancelSubscription(body);
  }

  @override
  Future<CheckProductLimitModel?> getProductLimit({required int storeId, required int packageId})async{
    return await subscriptionRepositoryInterface.getProductLimit(storeId: storeId, packageId: packageId);
  }

}