import 'package:get/get_connect/http/src/response/response.dart';
import 'package:sixam_mart_store/features/subscription/domain/models/check_product_limit_model.dart';
import 'package:sixam_mart_store/features/subscription/domain/models/subscription_transaction_model.dart';

abstract class SubscriptionServiceInterface {
  Future<dynamic> renewBusinessPlan(Map<String, String> body, Map<String, String>? headers);
  Future<SubscriptionTransactionModel?> getSubscriptionTransactionList({required int offset, required int? restaurantId, required String? from, required String? to,  required String? searchText});
  Future<Response> cancelSubscription(Map<String, String> body);
  Future<CheckProductLimitModel?> getProductLimit({required int storeId, required int packageId});
}