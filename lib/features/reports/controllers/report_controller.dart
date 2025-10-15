import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart_store/features/reports/domain/models/expense_model.dart';
import 'package:sixam_mart_store/features/reports/domain/models/tax_report_model.dart';
import 'package:sixam_mart_store/features/reports/domain/services/report_service_interface.dart';
import 'package:sixam_mart_store/helper/date_converter_helper.dart';

class ReportController extends GetxController implements GetxService {
  final ReportServiceInterface reportServiceInterface;
  ReportController({required this.reportServiceInterface});

  int? _pageSize;
  int? get pageSize => _pageSize;
  
  List<String> _offsetList = [];
  
  int _offset = 1;
  int get offset => _offset;
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  List<Expense>? _expenses;
  List<Expense>? get expenses => _expenses;
  
  late DateTimeRange _selectedDateRange;
  
  String? _from;
  String? get from => _from;
  
  String? _to;
  String? get to => _to;
  
  String? _searchText;
  String? get searchText => _searchText;
  
  bool _searchMode = false;
  bool get searchMode => _searchMode;

  TaxReportModel? _taxReportModel;
  TaxReportModel? get taxReportModel => _taxReportModel;

  List<Orders>? _orders;
  List<Orders>? get orders => _orders;

  void initSetDate(){
    _from = DateConverterHelper.dateTimeForCoupon(DateTime.now().subtract(const Duration(days: 30)));
    _to = DateConverterHelper.dateTimeForCoupon(DateTime.now());
    _searchText = '';
  }

  void initTaxReportDate(){
    _from = DateConverterHelper.dateTimeForTax(DateTime.now().subtract(const Duration(days: 30)));
    _to = DateConverterHelper.dateTimeForTax(DateTime.now());
  }

  void setSearchText({required String offset, required String? from, required String? to, required String searchText}){
    _searchText = searchText;
    _searchMode = !_searchMode;
    getExpenseList(offset: offset.toString(), from: from, to: to, searchText: searchText);
  }

  Future<void> getExpenseList({required String offset, required String? from, required String? to, required String? searchText}) async {

    if(offset == '1') {
      _offsetList = [];
      _offset = 1;
      _expenses = null;
      update();
    }
    if (!_offsetList.contains(offset)) {
      _offsetList.add(offset);

      ExpenseBodyModel? expenseModel = await reportServiceInterface.getExpenseList(
        offset: int.parse(offset), from: from, to: to,
        restaurantId: Get.find<ProfileController>().profileModel!.stores![0].id, searchText: searchText,
      );
      if (expenseModel != null) {
        if (offset == '1') {
          _expenses = [];
        }
        _expenses!.addAll(expenseModel.expense!);
        _pageSize = expenseModel.totalSize;
        _isLoading = false;
        update();
      }
    }else {
      if(isLoading) {
        _isLoading = false;
        update();
      }
    }
  }

  void setOffset(int offset) {
    _offset = offset;
  }

  void showBottomLoader() {
    _isLoading = true;
    update();
  }

  void showDatePicker(BuildContext context, {required bool isTaxReport}) async {
    final DateTimeRange? result = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      currentDate: DateTime.now(),
      saveText: 'Done',
    );

    if (result != null) {
      _selectedDateRange = result;

      if(isTaxReport){
        _from = DateConverterHelper.dateTimeForTax(_selectedDateRange.start);
        _to = DateConverterHelper.dateTimeForTax(_selectedDateRange.end);
      }else{
        _from = _selectedDateRange.start.toString().split(' ')[0];
        _to = _selectedDateRange.end.toString().split(' ')[0];
      }

      update();

      if(isTaxReport){
        getTaxReport(offset: '1', from: _from, to: _to);
      }else{
        getExpenseList(offset: '1', from: _from, to: _to, searchText: searchText);
      }

      debugPrint('===$from / ===$to');
    }
  }

  Future<void> getTaxReport({required String offset, required String? from, required String? to}) async {

    if(offset == '1') {
      _offsetList = [];
      _offset = 1;
      _orders = null;
      update();
    }
    if (!_offsetList.contains(offset)) {
      _offsetList.add(offset);

      TaxReportModel? taxReportModel = await reportServiceInterface.getTaxReport(offset: int.parse(offset), from: from, to: to);
      if (taxReportModel != null) {
        if (offset == '1') {
          _orders = [];
        }
        _taxReportModel = taxReportModel;
        _orders!.addAll(taxReportModel.orders!);
        _pageSize = taxReportModel.totalSize;
        _isLoading = false;
        update();
      }
    }else {
      if(isLoading) {
        _isLoading = false;
        update();
      }
    }
  }
  
}