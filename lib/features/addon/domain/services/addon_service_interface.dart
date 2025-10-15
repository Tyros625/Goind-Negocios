import 'package:sixam_mart_store/features/addon/models/addon_category_model.dart';
import 'package:sixam_mart_store/features/store/domain/models/item_model.dart';

abstract class AddonServiceInterface {
  Future<List<AddOns>?> getAddonList();
  Future<bool> addAddon(AddOns addonModel);
  Future<bool> updateAddon(AddOns addonModel);
  Future<bool> deleteAddon(int? addonID);
  List<int?> prepareAddonIds(List<AddOns> addonList);
  Future<List<AddonCategoryModel>?> getAddonCategory({required int moduleId});
}