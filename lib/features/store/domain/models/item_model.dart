import 'package:get/get.dart';
import 'package:sixam_mart_store/features/splash/controllers/splash_controller.dart';

class ItemModel {
  int? _totalSize;
  String? _limit;
  String? _offset;
  List<Item>? _items;

  ItemModel({
    int? totalSize,
    String? limit,
    String? offset,
    List<Item>? items
  }) {
    _totalSize = totalSize;
    _limit = limit;
    _offset = offset;
    _items = items;
  }

  int? get totalSize => _totalSize;
  String? get limit => _limit;
  String? get offset => _offset;
  List<Item>? get items => _items;

  ItemModel.fromJson(Map<String, dynamic> json) {
    _totalSize = json['total_size'];
    _limit = json['limit'].toString();
    _offset = json['offset'];
    if (json['items'] != null) {
      _items = [];
      json['items'].forEach((v) {
        _items!.add(Item.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_size'] = _totalSize;
    data['limit'] = _limit;
    data['offset'] = _offset;
    if (_items != null) {
      data['items'] = _items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Item {
  int? id;
  String? name;
  String? description;
  String? imageFullUrl;
  List<String?>? imagesFullUrl;
  int? categoryId;
  List<CategoryIds>? categoryIds;
  List<Variation>? variations;
  List<FoodVariation>? foodVariations;
  List<AddOns>? addOns;
  List<int?>? attributes;
  List<ChoiceOptions>? choiceOptions;
  double? price;
  double? tax;
  double? discount;
  String? discountType;
  String? availableTimeStarts;
  String? availableTimeEnds;
  int? setMenu;
  int? status;
  int? storeId;
  String? createdAt;
  String? updatedAt;
  String? storeName;
  double? storeDiscount;
  bool? scheduleOrder;
  double? avgRating;
  int? ratingCount;
  int? veg;
  String? unitType;
  int? stock;
  List<Translation>? translations;
  List<Tag>? tags;
  int? recommendedStatus;
  int? organicStatus;
  int? maxOrderQuantity;
  int? itemId;
  int? isPrescriptionRequired;
  int? brandId;
  int? isHalal;
  int? halalTagStatus;
  List<String?>? nutrition;
  List<String?>? allergies;
  List<String?>? genericName;
  int? isBasicMedicine;
  int? conditionId;
  List<NutritionsData>? nutritionsData;
  List<AllergiesData>? allergiesData;
  List<GenericData>? genericNameData;
  List<int>? taxVatIds;
  int? isRejected;
  String? note;
  List<TaxData>? taxData;

  Item({
    this.id,
    this.name,
    this.description,
    this.imageFullUrl,
    this.imagesFullUrl,
    this.categoryId,
    this.categoryIds,
    this.variations,
    this.foodVariations,
    this.addOns,
    this.attributes,
    this.choiceOptions,
    this.price,
    this.tax,
    this.discount,
    this.discountType,
    this.availableTimeStarts,
    this.availableTimeEnds,
    this.setMenu,
    this.status,
    this.storeId,
    this.createdAt,
    this.updatedAt,
    this.storeName,
    this.storeDiscount,
    this.scheduleOrder,
    this.avgRating,
    this.ratingCount,
    this.veg,
    this.unitType,
    this.stock,
    this.translations,
    this.tags,
    this.recommendedStatus,
    this.organicStatus,
    this.maxOrderQuantity,
    this.itemId,
    this.isPrescriptionRequired,
    this.brandId,
    this.isHalal,
    this.halalTagStatus,
    this.nutrition,
    this.allergies,
    this.genericName,
    this.isBasicMedicine,
    this.conditionId,
    this.nutritionsData,
    this.allergiesData,
    this.genericNameData,
    this.taxVatIds,
    this.isRejected,
    this.note,
    this.taxData,
  });

  Item.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    imageFullUrl = json['image_full_url'];
    if(json['images_full_url'] != null){
      imagesFullUrl = [];
      json['images_full_url'].forEach((v) {
        if(v != null) {
          imagesFullUrl!.add(v.toString());
        }
      });
    }
    categoryId = json['category_id'];
    if (json['category_ids'] != null) {
      categoryIds = [];
      json['category_ids'].forEach((v) {
        categoryIds!.add(CategoryIds.fromJson(v));
      });
    }
    if(Get.find<SplashController>().getStoreModuleConfig().newVariation! && json['food_variations'] != null && json['food_variations'] is !String) {
      foodVariations = [];
      json['food_variations'].forEach((v) {
        foodVariations!.add(FoodVariation.fromJson(v));
      });
    }else if(json['variations'] != null) {
      variations = [];
      json['variations'].forEach((v) {
        variations!.add(Variation.fromJson(v));
      });
    }
    if (json['add_ons'] != null) {
      addOns = [];
      json['add_ons'].forEach((v) {
        addOns!.add(AddOns.fromJson(v));
      });
    }
    if(json['attributes'] != null) {
      attributes = [];
      json['attributes'].forEach((attr) => attributes!.add(int.parse(attr.toString())));
    }
    if (json['choice_options'] != null) {
      choiceOptions = [];
      json['choice_options'].forEach((v) {
        choiceOptions!.add(ChoiceOptions.fromJson(v));
      });
    }
    price = json['price']?.toDouble();
    tax = json['tax']?.toDouble();
    discount = json['discount']?.toDouble();
    discountType = json['discount_type'];
    availableTimeStarts = json['available_time_starts'];
    availableTimeEnds = json['available_time_ends'];
    setMenu = json['set_menu'];
    status = json['status'];
    storeId = json['store_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    storeName = json['store_name'];
    storeDiscount = json['store_discount']?.toDouble();
    scheduleOrder = json['schedule_order'];
    avgRating = json['avg_rating']?.toDouble();
    ratingCount = json['rating_count'];
    veg = json['veg'];
    unitType = json['unit_type'];
    stock = json['stock'];
    if (json['translations'] != null && json['translations'].isNotEmpty) {
      translations = [];
      json['translations'].forEach((v) {
        translations!.add(Translation.fromJson(v));
      });
    }else {
      translations = [];
      translations!.add(Translation(id: 0, locale: 'en', key: 'name', value: json['name']));
      translations!.add(Translation(id: 0, locale: 'en', key: 'description', value: json['description']));
    }
    if (json['tags'] != null) {
      tags = [];
      json['tags'].forEach((v) {
        tags!.add(Tag.fromJson(v));
      });
    }
    recommendedStatus = json['recommended'] != null ? int.parse(json['recommended'].toString()) : 0;
    organicStatus = json['organic'];
    maxOrderQuantity = json['maximum_cart_quantity'] != null ? int.parse(json['maximum_cart_quantity'].toString()) : 0;
    itemId = json['item_id'] != null ? int.parse(json['item_id'].toString()) : null;
    isPrescriptionRequired = json['is_prescription_required'] != null ? int.parse(json['is_prescription_required'].toString()) : 0;
    brandId = json['brand_id'];
    isHalal = json['is_halal'];
    halalTagStatus = json['halal_tag_status'];
    if(json['nutritions_name'] != null) {
      nutrition = [];
      for(String v in json['nutritions_name']) {
        nutrition!.add(v);
      }
    }
    if(json['allergies_name'] != null) {
      allergies = [];
      for(String v in json['allergies_name']) {
        allergies!.add(v);
      }
    }
    if(json['generic_name'] != null) {
      genericName = [];
      for(String v in json['generic_name']) {
        genericName!.add(v);
      }
    }
    isBasicMedicine = json['is_basic'];
    conditionId = json['common_condition_id'];

    print('==========model: ${json['nutritions_data']}');
    if (json['nutritions_data'] != null) {
      nutritionsData = <NutritionsData>[];
      json['nutritions_data'].forEach((v) {
        nutritionsData!.add(NutritionsData.fromJson(v));
      });
    }
    if (json['allergies_data'] != null) {
      allergiesData = <AllergiesData>[];
      json['allergies_data'].forEach((v) {
        allergiesData!.add(AllergiesData.fromJson(v));
      });
    }
    if (json['generic_name_data'] != null) {
      genericNameData = <GenericData>[];
      json['generic_name_data'].forEach((v) {
        genericNameData!.add(GenericData.fromJson(v));
      });
    }
    if (json['tax_ids'] != null) {
      taxVatIds = [];
      json['tax_ids'].forEach((v) {
        taxVatIds!.add(int.parse(v.toString()));
      });
    }
    isRejected = json['is_rejected'];
    note = json['note'];
    if (json['tax_data'] != null) {
      taxData = <TaxData>[];
      json['tax_data'].forEach((v) { taxData!.add(TaxData.fromJson(v)); });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['image_full_url'] = imageFullUrl;
    data['images_full_url'] = imagesFullUrl;
    data['category_id'] = categoryId;
    if (categoryIds != null) {
      data['category_ids'] = categoryIds!.map((v) => v.toJson()).toList();
    }
    if(Get.find<SplashController>().getStoreModuleConfig().newVariation! && foodVariations != null) {
      data['food_variations'] = foodVariations!.map((v) => v.toJson()).toList();
    }else if(variations != null) {
      data['variations'] = variations!.map((v) => v.toJson()).toList();
    }
    if (addOns != null) {
      data['add_ons'] = addOns!.map((v) => v.toJson()).toList();
    }
    data['attributes'] = attributes;
    if (choiceOptions != null) {
      data['choice_options'] = choiceOptions!.map((v) => v.toJson()).toList();
    }
    data['price'] = price;
    data['tax'] = tax;
    data['discount'] = discount;
    data['discount_type'] = discountType;
    data['available_time_starts'] = availableTimeStarts;
    data['available_time_ends'] = availableTimeEnds;
    data['set_menu'] = setMenu;
    data['status'] = status;
    data['store_id'] = storeId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['store_name'] = storeName;
    data['store_discount'] = storeDiscount;
    data['schedule_order'] = scheduleOrder;
    data['avg_rating'] = avgRating;
    data['rating_count'] = ratingCount;
    data['veg'] = veg;
    data['unit_type'] = unitType;
    data['stock'] = stock;
    if (translations != null) {
      data['translations'] = translations!.map((v) => v.toJson()).toList();
    }
    if (tags != null) {
      data['tags'] = tags!.map((v) => v.toJson()).toList();
    }
    data['recommended'] = recommendedStatus;
    data['organic'] = organicStatus;
    data['maximum_cart_quantity'] = maxOrderQuantity;
    data['item_id'] = itemId;
    data['is_prescription_required'] = isPrescriptionRequired;
    data['brand_id'] = brandId;
    data['is_halal'] = isHalal;
    data['halal_tag_status'] = halalTagStatus;
    if (nutrition != null) {
      data['nutritions_name'] = nutrition;
    }
    if (allergies != null) {
      data['allergies_name'] = allergies;
    }
    if (genericName != null) {
      data['generic_name'] = genericName;
    }
    data['is_basic'] = isBasicMedicine;
    data['common_condition_id'] = conditionId;
    if (nutritionsData != null) {
      data['nutritions_data'] = nutritionsData!.map((v) => v.toJson()).toList();
    }
    if (allergiesData != null) {
      data['allergies_data'] = allergiesData!.map((v) => v.toJson()).toList();
    }
    if (genericNameData != null) {
      data['generic_name_data'] = genericNameData!.map((v) => v.toJson()).toList();
    }
    if (taxVatIds != null) {
      data['tax_ids'] = taxVatIds!.map((v) => v.toString()).toList();
    }
    data['is_rejected'] = isRejected;
    data['note'] = note;
    if (taxData != null) {
      data['tax_data'] = taxData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CategoryIds {
  String? id;
  int? position;
  String? name;

  CategoryIds({this.id, this.position, this.name});

  CategoryIds.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    position = json['position'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['position'] = position;
    data['name'] = name;
    return data;
  }
}

class Variation {
  String? type;
  double? price;
  int? stock;

  Variation({this.type, this.price, this.stock});

  Variation.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    price = json['price']?.toDouble();
    stock = json['stock'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['price'] = price;
    data['stock'] = stock;
    return data;
  }
}

class AddOns {
  int? id;
  String? name;
  double? price;
  int? status;
  List<Translation>? translations;
  List<int>? taxVatIds;
  int? addonCategoryId;

  AddOns({this.id, this.name, this.price, this.status, this.translations, this.taxVatIds, this.addonCategoryId});

  AddOns.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price']?.toDouble();
    status = json['status'];
    if (json['translations'] != null) {
      translations = [];
      json['translations'].forEach((v) {
        translations!.add(Translation.fromJson(v));
      });
    }
    if (json['tax_ids'] != null) {
      taxVatIds = [];
      json['tax_ids'].forEach((v) {
        taxVatIds!.add(int.parse(v.toString()));
      });
    }
    addonCategoryId = json['addon_category_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['price'] = price;
    data['status'] = status;
    if (translations != null) {
      data['translations'] = translations!.map((v) => v.toJson()).toList();
    }
    if (taxVatIds != null) {
      data['tax_ids'] = taxVatIds!.map((v) => v.toString()).toList();
    }
    data['addon_category_id'] = addonCategoryId;
    return data;
  }
}

class ChoiceOptions {
  String? name;
  String? title;
  List<String>? options;

  ChoiceOptions({this.name, this.title, this.options});

  ChoiceOptions.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    title = json['title'];
    options = json['options'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['title'] = title;
    data['options'] = options;
    return data;
  }
}

class Translation {
  int? id;
  String? locale;
  String? key;
  String? value;

  Translation({this.id, this.locale, this.key, this.value});

  Translation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    locale = json['locale'];
    key = json['key'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['locale'] = locale;
    data['key'] = key;
    data['value'] = value;
    return data;
  }
}

class FoodVariation {
  String? name;
  String? type;
  String? min;
  String? max;
  String? required;
  List<VariationValue>? variationValues;

  FoodVariation({this.name, this.type, this.min, this.max, this.required, this.variationValues});

  FoodVariation.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    type = json['type'];
    min = json['min'].toString();
    max = json['max'].toString();
    required = json['required'];
    if (json['values'] != null) {
      variationValues = [];
      json['values'].forEach((v) {
        variationValues!.add(VariationValue.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['type'] = type;
    data['min'] = min;
    data['max'] = max;
    data['required'] = required;
    if (variationValues != null) {
      data['values'] = variationValues!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VariationValue {
  String? level;
  String? optionPrice;

  VariationValue({this.level, this.optionPrice});

  VariationValue.fromJson(Map<String, dynamic> json) {
    level = json['label'];
    optionPrice = json['optionPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['label'] = level;
    data['optionPrice'] = optionPrice;
    return data;
  }
}

class Tag {
  int? id;
  String? tag;

  Tag({this.id, this.tag});

  Tag.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tag = json['tag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['tag'] = tag;
    return data;
  }
}

class NutritionsData {
  String? nutrition;
  int? id;

  NutritionsData({this.nutrition, this.id});

  NutritionsData.fromJson(Map<String, dynamic> json) {
    nutrition = json['nutrition'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nutrition'] = nutrition;
    data['id'] = id;
    return data;
  }
}

class AllergiesData {
  String? allergy;
  int? id;

  AllergiesData({this.allergy, this.id});

  AllergiesData.fromJson(Map<String, dynamic> json) {
    allergy = json['allergy'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['allergy'] = allergy;
    data['id'] = id;
    return data;
  }
}

class GenericData {
  String? generic;
  int? id;

  GenericData({this.generic, this.id});

  GenericData.fromJson(Map<String, dynamic> json) {
    generic = json['generic'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['generic'] = generic;
    data['id'] = id;
    return data;
  }
}

class TaxData {
  int? id;
  String? name;
  double? taxRate;

  TaxData({this.id, this.name, this.taxRate});

  TaxData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    taxRate = json['tax_rate']?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['tax_rate'] = taxRate;
    return data;
  }
}

