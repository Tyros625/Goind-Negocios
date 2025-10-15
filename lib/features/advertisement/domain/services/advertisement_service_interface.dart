import 'package:get/get_connect/http/src/response/response.dart';
import 'package:sixam_mart_store/api/api_client.dart';
import 'package:sixam_mart_store/features/advertisement/models/ads_details_model.dart';
import 'package:sixam_mart_store/features/advertisement/models/advertisement_model.dart';

abstract class AdvertisementServiceInterface {
  Future<Response> submitNewAdvertisement(Map<String, String> body, List<MultipartBody> selectedFile);
  Future<Response> copyAddAdvertisement(Map<String, String> body, List<MultipartBody> selectedFile);
  Future<AdvertisementModel?> getAdvertisementList(String offset, String type);
  Future<AdsDetailsModel?> getAdvertisementDetails ({required int id});
  Future<Response> editAdvertisement({required String id, required Map<String, String> body, List<MultipartBody>? selectedFile});
  Future<bool> deleteAdvertisement({required int id});
  Future<bool> changeAdvertisementStatus({required String note, required String status, required int id});
}