import 'package:image_picker/image_picker.dart';
import 'package:sixam_mart_store/features/banner/domain/models/store_banner_list_model.dart';
import 'package:sixam_mart_store/interface/repository_interface.dart';

abstract class BannerRepositoryInterface extends RepositoryInterface {
  Future<bool> addBanner({required StoreBannerListModel? banner, required XFile image});
  Future<bool> updateBanner({required StoreBannerListModel? banner, XFile? image});
}