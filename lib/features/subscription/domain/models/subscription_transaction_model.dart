class SubscriptionTransactionModel {
  int? totalSize;
  int? limit;
  String? offset;
  List<Transactions>? transactions;

  SubscriptionTransactionModel({
    this.totalSize,
    this.limit,
    this.offset,
    this.transactions,
  });

  SubscriptionTransactionModel.fromJson(Map<String, dynamic> json) {
    totalSize = json['total_size'];
    limit = json['limit'];
    offset = json['offset'];
    if (json['transactions'] != null) {
      transactions = <Transactions>[];
      json['transactions'].forEach((v) {
        transactions!.add(Transactions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_size'] = totalSize;
    data['limit'] = limit;
    data['offset'] = offset;
    if (transactions != null) {
      data['transactions'] = transactions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Transactions {
  String? id;
  int? packageId;
  int? storeId;
  int? storeSubscriptionId;
  double? price;
  int? validity;
  String? paymentMethod;
  String? paymentStatus;
  String? reference;
  double? paidAmount;
  double? discount;
  PackageDetails? packageDetails;
  String? createdBy;
  int? isTrial;
  int? transactionStatus;
  String? planType;
  String? createdAt;
  String? updatedAt;
  Store? store;
  Package? package;

  Transactions({
    this.id,
    this.packageId,
    this.storeId,
    this.storeSubscriptionId,
    this.price,
    this.validity,
    this.paymentMethod,
    this.paymentStatus,
    this.reference,
    this.paidAmount,
    this.discount,
    this.packageDetails,
    this.createdBy,
    this.isTrial,
    this.transactionStatus,
    this.planType,
    this.createdAt,
    this.updatedAt,
    this.store,
    this.package,
  });

  Transactions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    packageId = json['package_id'];
    storeId = json['store_id'];
    storeSubscriptionId = json['store_subscription_id'];
    price = json['price']?.toDouble();
    validity = json['validity'];
    paymentMethod = json['payment_method'];
    paymentStatus = json['payment_status'];
    reference = json['reference'];
    paidAmount = json['paid_amount']?.toDouble();
    discount = json['discount']?.toDouble();
    packageDetails = json['package_details'] != null ? PackageDetails.fromJson(json['package_details']) : null;
    createdBy = json['created_by'];
    isTrial = json['is_trial'];
    transactionStatus = json['transaction_status'];
    planType = json['plan_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    store = json['store'] != null ? Store.fromJson(json['store']) : null;
    package = json['package'] != null ? Package.fromJson(json['package']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['package_id'] = packageId;
    data['store_id'] = storeId;
    data['store_subscription_id'] = storeSubscriptionId;
    data['price'] = price;
    data['validity'] = validity;
    data['payment_method'] = paymentMethod;
    data['payment_status'] = paymentStatus;
    data['reference'] = reference;
    data['paid_amount'] = paidAmount;
    data['discount'] = discount;
    if (packageDetails != null) {
      data['package_details'] = packageDetails!.toJson();
    }
    data['created_by'] = createdBy;
    data['is_trial'] = isTrial;
    data['transaction_status'] = transactionStatus;
    data['plan_type'] = planType;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (store != null) {
      data['store'] = store!.toJson();
    }
    if (package != null) {
      data['package'] = package!.toJson();
    }
    return data;
  }
}

class PackageDetails {
  int? pos;
  int? review;
  int? selfDelivery;
  int? chat;
  int? mobileApp;
  String? maxOrder;
  String? maxProduct;

  PackageDetails({
    this.pos,
    this.review,
    this.selfDelivery,
    this.chat,
    this.mobileApp,
    this.maxOrder,
    this.maxProduct,
  });

  PackageDetails.fromJson(Map<String, dynamic> json) {
    pos = json['pos'];
    review = json['review'];
    selfDelivery = json['self_delivery'];
    chat = json['chat'];
    mobileApp = json['mobile_app'];
    maxOrder = json['max_order'];
    maxProduct = json['max_product'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pos'] = pos;
    data['review'] = review;
    data['self_delivery'] = selfDelivery;
    data['chat'] = chat;
    data['mobile_app'] = mobileApp;
    data['max_order'] = maxOrder;
    data['max_product'] = maxProduct;
    return data;
  }
}

class Store {
  int? id;
  String? name;
  bool? gstStatus;
  String? gstCode;
  List<Translations>? translations;

  Store({
    this.id,
    this.name,
    this.gstStatus,
    this.gstCode,
    this.translations,
  });

  Store.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    gstStatus = json['gst_status'];
    gstCode = json['gst_code'];
    if (json['translations'] != null) {
      translations = <Translations>[];
      json['translations'].forEach((v) {
        translations!.add(Translations.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['gst_status'] = gstStatus;
    data['gst_code'] = gstCode;
    if (translations != null) {
      data['translations'] = translations!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Translations {
  int? id;
  String? translationableType;
  int? translationableId;
  String? locale;
  String? key;
  String? value;
  String? createdAt;
  String? updatedAt;

  Translations({
    this.id,
    this.translationableType,
    this.translationableId,
    this.locale,
    this.key,
    this.value,
    this.createdAt,
    this.updatedAt,
  });

  Translations.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    translationableType = json['translationable_type'];
    translationableId = json['translationable_id'];
    locale = json['locale'];
    key = json['key'];
    value = json['value'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['translationable_type'] = translationableType;
    data['translationable_id'] = translationableId;
    data['locale'] = locale;
    data['key'] = key;
    data['value'] = value;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Package {
  int? id;
  String? packageName;
  List<Translations>? translations;

  Package({
    this.id,
    this.packageName,
    this.translations,
  });

  Package.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    packageName = json['package_name'];
    if (json['translations'] != null) {
      translations = <Translations>[];
      json['translations'].forEach((v) {
        translations!.add(Translations.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['package_name'] = packageName;
    if (translations != null) {
      data['translations'] = translations!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
