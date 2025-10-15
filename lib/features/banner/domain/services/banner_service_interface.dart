import 'package:image_picker/image_picker.dart';
import 'package:sixam_mart_store/features/banner/domain/models/store_banner_list_model.dart';

abstract class BannerServiceInterface {
  Future<bool> addBanner({required StoreBannerListModel? banner, required XFile image});
  Future<List<StoreBannerListModel>?> getBannerList();
  Future<bool> deleteBanner(int? bannerID);
  Future<bool> updateBanner({required StoreBannerListModel? banner, XFile? image});
  Future<StoreBannerListModel?> getBannerDetails(int id);
}