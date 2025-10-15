import 'package:sixam_mart_store/features/addon/models/addon_category_model.dart';
import 'package:sixam_mart_store/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart_store/features/store/domain/models/item_model.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/features/addon/domain/services/addon_service_interface.dart';

class AddonController extends GetxController implements GetxService {
  final AddonServiceInterface addonServiceInterface;
  AddonController({required this.addonServiceInterface});

  List<AddOns>? _addonList;
  List<AddOns>? get addonList => _addonList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<AddonCategoryModel>? _addonCategoryList;
  List<AddonCategoryModel>? get addonCategoryList => _addonCategoryList;

  String? _addonCategoryName;
  String? get addonCategoryName => _addonCategoryName;

  int? _addonCategoryId;
  int? get addonCategoryId => _addonCategoryId;

  Future<List<int?>> getAddonList() async {
    List<AddOns>? addonList = await addonServiceInterface.getAddonList();
    List<int?> addonsIds = [];
    if(addonList != null) {
      _addonList = [];
      _addonList!.addAll(addonList);
      addonsIds.addAll(addonServiceInterface.prepareAddonIds(addonList));
    }
    update();
    return addonsIds;
  }

  Future<void> addAddon(AddOns addonModel) async {
    _isLoading = true;
    update();
    bool isSuccess = await addonServiceInterface.addAddon(addonModel);
    if(isSuccess) {
      Get.back();
      showCustomSnackBar('addon_added_successfully'.tr, isError: false);
      getAddonList();
    }
    _isLoading = false;
    update();
  }

  Future<void> updateAddon(AddOns addonModel) async {
    _isLoading = true;
    update();
    bool isSuccess = await addonServiceInterface.updateAddon(addonModel);
    if(isSuccess) {
      Get.back();
      showCustomSnackBar('addon_updated_successfully'.tr, isError: false);
      getAddonList();
    }
    _isLoading = false;
    update();
  }

  Future<void> deleteAddon(int? addonID) async {
    _isLoading = true;
    update();
    bool isSuccess = await addonServiceInterface.deleteAddon(addonID);
    if(isSuccess) {
      Get.back();
      showCustomSnackBar('addon_removed_successfully'.tr, isError: false);
      getAddonList();
    }
    _isLoading = false;
    update();
  }

  Future<void> getAddonCategoryList() async {
    List<AddonCategoryModel>? addonCategoryList = await addonServiceInterface.getAddonCategory(moduleId: Get.find<ProfileController>().profileModel!.stores![0].module!.id!);
    if(addonCategoryList != null) {
      _addonCategoryList = [];
      _addonCategoryList!.addAll(addonCategoryList);
    }
    update();
  }

  void setAddonCategoryName(String? name) {
    _addonCategoryName = name;
    update();
  }

  void setAddonCategoryId(int? id) {
    _addonCategoryId = id;
    update();
  }

  void setAddonCategory(int? id){
    _addonCategoryId = id;
    _addonCategoryName = _addonCategoryList?.firstWhere((category) => category.id == id, orElse: () => AddonCategoryModel(id: id, name: '')).name;
  }

  void resetAddonCategory() {
    _addonCategoryName = null;
    _addonCategoryId = null;
  }

}