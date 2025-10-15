import 'package:sixam_mart_store/features/rental_module/reports/domain/repositories/taxi_report_repository_interface.dart';
import 'package:sixam_mart_store/features/rental_module/reports/domain/services/taxi_report_service_interface.dart';

class TaxiReportService implements TaxiReportServiceInterface {
  final TaxiReportRepositoryInterface reportRepositoryInterface;
  TaxiReportService({required this.reportRepositoryInterface});

}