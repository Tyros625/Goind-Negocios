import 'package:sixam_mart_store/features/category/domain/models/category_model.dart';
import 'package:sixam_mart_store/features/store/domain/models/item_model.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/features/category/domain/services/category_service_interface.dart';

class CategoryController extends GetxController implements GetxService {
  final CategoryServiceInterface categoryServiceInterface;

  CategoryController({required this.categoryServiceInterface});

  List<CategoryModel>? _categoryList;
  List<CategoryModel>? get categoryList => _categoryList;

  List<CategoryModel>? _subCategoryList;
  List<CategoryModel>? get subCategoryList => _subCategoryList;

  int? _categoryIndex;
  int? get categoryIndex => _categoryIndex;

  int? _subCategoryIndex;
  int? get subCategoryIndex => _subCategoryIndex;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  int? _pageSize;
  int? get pageSize => _pageSize;

  List<String> _offsetList = [];

  int _offset = 1;
  int get offset => _offset;

  List<Item>? _itemList;
  List<Item>? get itemList => _itemList;

  int? _selectedSubCategoryId;
  int? get selectedSubCategoryId => _selectedSubCategoryId;

  int? _isSubCategory = 0;
  int? get isSubCategory => _isSubCategory;

  int? _selectedSubCategoryIndex = 0;
  int? get selectedSubCategoryIndex => _selectedSubCategoryIndex;

  Future<void> getCategoryList(Item? item) async {
    _categoryList = null;
    //update();
    List<CategoryModel>? fetchedCategoryList = await categoryServiceInterface.getCategoryList();
    if (fetchedCategoryList != null) {
      _categoryList = fetchedCategoryList;
      _categoryIndex = categoryServiceInterface.categoryIndex(_categoryList, item);
      if (item != null && item.categoryIds != null && item.categoryIds!.isNotEmpty) {
        await getSubCategoryList(int.parse(item.categoryIds![0].id!), item);
      }
    }
    update();
  }

  Future<void> getSubCategoryList(int? categoryID, Item? item) async {
    _subCategoryList = null;
    //update();
    if (categoryID != 0) {
      List<CategoryModel>? fetchedSubCategoryList = await categoryServiceInterface.getSubCategoryList(categoryID);
      if (fetchedSubCategoryList != null) {
        _subCategoryList = fetchedSubCategoryList;
        _subCategoryIndex = categoryServiceInterface.subCategoryIndex(_subCategoryList, item);
      }
    }
    update();
  }

  void setCategoryIndex(int index, bool notify) {
    _categoryIndex = index;
    if (notify) {
      update();
    }
  }

  void setSubCategoryIndex(int index, bool notify) {
    _subCategoryIndex = index;
    if (notify) {
      update();
    }
  }

  void setSelectedSubCategoryIndex(int? index, bool notify) {
    _selectedSubCategoryIndex = index;
    if (notify) {
      update();
    }
  }

  void setSelectedSubCategoryId(int? subCategoryId) {
    _selectedSubCategoryId = subCategoryId;
    _isSubCategory = 1;
    if( _selectedSubCategoryId != null) {
      getCategoryItemList(offset: '1', id: _selectedSubCategoryId!);
    }
    update();
  }

  void clearSelectedSubCategoryId() {
    _selectedSubCategoryId = null;
    _isSubCategory = 0;
  }

  Future<void> getCategoryItemList({required String offset, required int id, bool willUpdate = true}) async {
    if(offset == '1') {
      _offsetList = [];
      _offset = 1;
      _itemList = null;
      if(willUpdate) {
        update();
      }
    }
    if (!_offsetList.contains(offset)) {
      _offsetList.add(offset);
      ItemModel? itemModel = await categoryServiceInterface.getCategoryItemList(offset: offset, id: id, isSubCategory: _isSubCategory!);
      if (itemModel != null) {
        if (offset == '1') {
          _itemList = [];
        }
        _itemList!.addAll(itemModel.items!);
        _pageSize = itemModel.totalSize;
        _isLoading = false;
        update();
      }
    } else {
      if(isLoading) {
        _isLoading = false;
        update();
      }
    }
  }

  void showBottomLoader() {
    _isLoading = true;
    update();
  }

  void setOffset(int offset) {
    _offset = offset;
  }

}
