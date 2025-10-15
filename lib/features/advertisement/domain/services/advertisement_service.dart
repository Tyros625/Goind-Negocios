import 'package:get/get_connect/http/src/response/response.dart';
import 'package:sixam_mart_store/api/api_client.dart';
import 'package:sixam_mart_store/features/advertisement/domain/repositories/advertisement_repository_interface.dart';
import 'package:sixam_mart_store/features/advertisement/domain/services/advertisement_service_interface.dart';
import 'package:sixam_mart_store/features/advertisement/models/ads_details_model.dart';
import 'package:sixam_mart_store/features/advertisement/models/advertisement_model.dart';

class AdvertisementService implements AdvertisementServiceInterface {
  final AdvertisementRepositoryInterface advertisementRepositoryInterface;
  AdvertisementService({required this.advertisementRepositoryInterface});

  @override
  Future<Response> submitNewAdvertisement(Map<String, String> body, List<MultipartBody> selectedFile) async{
    return await advertisementRepositoryInterface.submitNewAdvertisement(body, selectedFile);
  }

  @override
  Future<Response> copyAddAdvertisement(Map<String, String> body, List<MultipartBody> selectedFile) async {
    return await advertisementRepositoryInterface.copyAddAdvertisement(body, selectedFile);
  }

  @override
  Future<AdvertisementModel?> getAdvertisementList(String offset, String type) async {
    return await advertisementRepositoryInterface.getAdvertisementList(offset, type);
  }

  @override
  Future<AdsDetailsModel?> getAdvertisementDetails ({required int id}) async {
    return await advertisementRepositoryInterface.get(id);
  }

  @override
  Future<Response> editAdvertisement({required String id, required Map<String, String> body, List<MultipartBody>? selectedFile}) async {
    return await advertisementRepositoryInterface.editAdvertisement(id: id, body: body, selectedFile: selectedFile);
  }

  @override
  Future<bool> deleteAdvertisement({required int id}) async {
    return await advertisementRepositoryInterface.delete(id);
  }

  @override
  Future<bool> changeAdvertisementStatus({required String note, required String status, required int id}) async{
    return await advertisementRepositoryInterface.changeAdvertisementStatus(note: note, status: status, id: id);
  }

}