import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:sixam_mart_store/features/splash/controllers/splash_controller.dart';


class InvoicePrintHelper{

  static Future<bool> checkConnectionStatus() async{
    final SplashController splashController = Get.find();
    String? savedMacAddress = splashController.getBluetoothAddress();

    bool currentlyConnectedInSavedPrinter = false;

    if(savedMacAddress?.isNotEmpty ?? false){
      try {
        bool connectionStatus = await PrintBluetoothThermal.connectionStatus;
        if(connectionStatus){
          currentlyConnectedInSavedPrinter = true;
        } else {
          try {
            bool testConnection = await PrintBluetoothThermal.connect(macPrinterAddress: savedMacAddress!);
            if(testConnection) {
              currentlyConnectedInSavedPrinter = true;
            }
          } catch (e) {
            print('Connection test failed: $e');
          }
        }
      } catch (e) {
        currentlyConnectedInSavedPrinter = false;
      }
    }

    return currentlyConnectedInSavedPrinter;
  }

  static Future<bool> attemptReconnection(String macAddress) async {
    try {
      bool reconnected = await PrintBluetoothThermal.connect(macPrinterAddress: macAddress);
      return reconnected;
    } catch (e) {
      return false;
    }
  }

}