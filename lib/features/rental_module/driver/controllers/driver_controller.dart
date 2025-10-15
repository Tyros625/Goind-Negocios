import 'package:get/get.dart';
import 'package:sixam_mart_store/features/rental_module/driver/domain/services/driver_service_interface.dart';

class DriverController extends GetxController implements GetxService {
  final DriverServiceInterface driverServiceInterface;
  DriverController({required this.driverServiceInterface});
  
}