import 'package:sixam_mart_store/interface/repository_interface.dart';

abstract class SplashRepositoryInterface implements RepositoryInterface {
  Future<dynamic> getConfigData();
  Future<bool> initSharedData();
  bool showIntro();
  void setIntro(bool intro);
  Future<bool> removeSharedData();
  int? getPaperSize();
  Future<void> setPaperSize(int? paperSize);
  Future<void> setBluetoothAddress(String? address);
  String? getBluetoothAddress();
}