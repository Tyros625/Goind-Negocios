import 'package:get/get.dart';
import 'package:sixam_mart_store/features/rental_module/reports/domain/services/taxi_report_service_interface.dart';

class TaxiReportController extends GetxController implements GetxService {
  final TaxiReportServiceInterface reportServiceInterface;
  TaxiReportController({required this.reportServiceInterface});
  
}