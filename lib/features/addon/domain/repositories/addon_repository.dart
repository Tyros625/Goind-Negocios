import 'dart:convert';
import 'package:get/get.dart';
import 'package:sixam_mart_store/api/api_client.dart';
import 'package:sixam_mart_store/features/addon/domain/repositories/addon_repository_interface.dart';
import 'package:sixam_mart_store/features/addon/models/addon_category_model.dart';
import 'package:sixam_mart_store/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart_store/features/store/domain/models/item_model.dart';
import 'package:sixam_mart_store/util/app_constants.dart';

class AddonRepository implements AddonRepositoryInterface<AddOns> {
  final ApiClient apiClient;
  AddonRepository({required this.apiClient});

  @override
  Future<bool> add(AddOns addonModel) async {
    Map<String, dynamic> body = {};

    body.addAll({
      'name': addonModel.name,
      'price': addonModel.price,
      'translations': addonModel.translations,
      'addon_category_id': addonModel.addonCategoryId,
    });

    if(Get.find<SplashController>().configModel!.systemTaxType == 'product_wise'){
      body.addAll({'tax_ids': jsonEncode(addonModel.taxVatIds)});
    }

    Response response = await apiClient.postData(AppConstants.addAddonUri, body);
    return (response.statusCode == 200);
  }

  @override
  Future<bool> updateAddon(AddOns addonModel) async {
    Map<String, dynamic> body = {};

    body.addAll({
      'id': addonModel.id,
      'name': addonModel.name,
      'price': addonModel.price,
      'translations': addonModel.translations,
      'addon_category_id': addonModel.addonCategoryId,
    });

    if(Get.find<SplashController>().configModel!.systemTaxType == 'product_wise'){
      body.addAll({'tax_ids': jsonEncode(addonModel.taxVatIds)});
    }

    Response response = await apiClient.putData(AppConstants.updateAddonUri, body);
    return (response.statusCode == 200);
  }

  @override
  Future<bool> delete(int? id) async {
    Response response = await apiClient.deleteData('${AppConstants.deleteAddonUri}?id=$id');
    return (response.statusCode == 200);
  }

  @override
  Future<List<AddOns>?> getList() async {
    List<AddOns>? addonList;
    Response response = await apiClient.getData(AppConstants.addonUri);
    if(response.statusCode == 200) {
      addonList = [];
      response.body.forEach((addon) {
        addonList!.add(AddOns.fromJson(addon));
      });
    }
    return addonList;
  }

  @override
  Future<List<AddonCategoryModel>?> getAddonCategory({required int moduleId}) async{
    List<AddonCategoryModel>? addonCategoryList;
    Response response = await apiClient.getData('${AppConstants.addonCategoryList}?module_id=$moduleId');

    if(response.statusCode == 200){
      addonCategoryList = [];
      response.body.forEach((addon) {
        addonCategoryList!.add(AddonCategoryModel.fromJson(addon));
      });
    }
    return addonCategoryList;
  }

  @override
  Future get(int? id) {
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body) {
    throw UnimplementedError();
  }

}