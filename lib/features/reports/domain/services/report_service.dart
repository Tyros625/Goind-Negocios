import 'package:sixam_mart_store/features/reports/domain/models/expense_model.dart';
import 'package:sixam_mart_store/features/reports/domain/models/tax_report_model.dart';
import 'package:sixam_mart_store/features/reports/domain/repositories/report_repository_interface.dart';
import 'package:sixam_mart_store/features/reports/domain/services/report_service_interface.dart';

class ReportService implements ReportServiceInterface {
  final ReportRepositoryInterface reportRepositoryInterface;
  ReportService({required this.reportRepositoryInterface});

  @override
  Future<ExpenseBodyModel?> getExpenseList({required int offset, required int? restaurantId, required String? from, required String? to,  required String? searchText}) async {
    return await reportRepositoryInterface.getExpenseList(offset: offset, restaurantId: restaurantId, from: from, to: to, searchText: searchText);
  }

  @override
  Future<TaxReportModel?> getTaxReport({required int offset, required String? from, required String? to}) async {
    return await reportRepositoryInterface.getTaxReport(offset: offset, from: from, to: to);
  }

}