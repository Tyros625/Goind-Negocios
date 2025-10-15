import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:sixam_mart_store/api/api_client.dart';
import 'package:sixam_mart_store/features/banner/domain/models/store_banner_list_model.dart';
import 'package:sixam_mart_store/util/app_constants.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/features/banner/domain/repositories/banner_repository_interface.dart';

class BannerRepository implements BannerRepositoryInterface {
  final ApiClient apiClient;
  BannerRepository({required this.apiClient});

  @override
  Future<bool> addBanner({required StoreBannerListModel? banner, required XFile image}) async {
    Map<String, String> body = {};
    body.addAll({
      'translations': jsonEncode(banner?.translations),
      'default_link': banner?.defaultLink ?? ''
    });
    Response response = await apiClient.postMultipartData(AppConstants.addStoreBannerUri, body, [MultipartBody('image', image)]);
    return (response.statusCode == 200);
  }

  @override
  Future<List<StoreBannerListModel>?> getList() async {
    List<StoreBannerListModel>? storeBannerList;
    Response response = await apiClient.getData(AppConstants.storeBannerUri);
    if(response.statusCode == 200) {
      storeBannerList = [];
      response.body.forEach((item) => storeBannerList!.add(StoreBannerListModel.fromJson(item)));
    }
    return storeBannerList;
  }

  @override
  Future<bool> delete(int? id) async {
    Response response = await apiClient.deleteData('${AppConstants.deleteStoreBannerUri}?id=$id');
    return (response.statusCode == 200);
  }

  @override
  Future<bool> updateBanner({required StoreBannerListModel? banner, XFile? image}) async {
    Map<String, String> body = {};
    body.addAll({
      'translations': jsonEncode(banner?.translations),
      'default_link': banner?.defaultLink ?? '',
      'id' : banner!.id!.toString(),
      '_method' : 'put',
    });
    Response response = await apiClient.postMultipartData(AppConstants.updateStoreBannerUri, body, [MultipartBody('image', image)]);
    return (response.statusCode == 200);
  }

  @override
  Future<StoreBannerListModel?> get(int? id) async {
    StoreBannerListModel? bannersDetails;
    Response response = await apiClient.getData('${AppConstants.storeBannerDetailsUri}/$id');
    if(response.statusCode == 200) {
      bannersDetails = StoreBannerListModel.fromJson(response.body);
    }
    return bannersDetails;
  }

  @override
  Future add(value) {
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body) {
    throw UnimplementedError();
  }

}