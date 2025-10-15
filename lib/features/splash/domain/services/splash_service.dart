import 'package:get/get.dart';
import 'package:sixam_mart_store/features/splash/domain/repositories/splash_repository_interface.dart';
import 'package:sixam_mart_store/features/splash/domain/services/splash_service_interface.dart';

class SplashService implements SplashServiceInterface {
  final SplashRepositoryInterface splashRepositoryInterface;
  SplashService({required this.splashRepositoryInterface});

  @override
  Future<Response> getConfigData() async {
    return await splashRepositoryInterface.getConfigData();
  }

  @override
  Future<bool> initSharedData() {
    return splashRepositoryInterface.initSharedData();
  }

  @override
  bool showIntro() {
    return splashRepositoryInterface.showIntro();
  }

  @override
  void setIntro(bool intro) {
    splashRepositoryInterface.setIntro(intro);
  }

  @override
  Future<bool> removeSharedData() {
    return splashRepositoryInterface.removeSharedData();
  }

  @override
  int? getPaperSize() {
    return splashRepositoryInterface.getPaperSize();
  }

  @override
  String? getBluetoothAddress() {
    return splashRepositoryInterface.getBluetoothAddress();
  }

  @override
  Future<void> setBluetoothAddress(String? address) async {
    await splashRepositoryInterface.setBluetoothAddress(address);
  }

  @override
  Future<void> setPaperSize(int? paperSize) async {
    await splashRepositoryInterface.setPaperSize(paperSize);
  }

}