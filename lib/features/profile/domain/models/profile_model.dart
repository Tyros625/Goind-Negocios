import 'package:sixam_mart_store/features/store/domain/models/item_model.dart';

class ProfileModel {
  int? id;
  String? fName;
  String? lName;
  String? phone;
  String? email;
  String? createdAt;
  String? updatedAt;
  String? bankName;
  String? branch;
  String? holderName;
  String? accountNo;
  String? imageFullUrl;
  int? orderCount;
  int? todaysOrderCount;
  int? thisWeekOrderCount;
  int? thisMonthOrderCount;
  int? memberSinceDays;
  double? cashInHands;
  double? balance;
  double? totalEarning;
  double? todaysEarning;
  double? thisWeekEarning;
  double? thisMonthEarning;
  List<Store>? stores;
  List<String>? roles;
  EmployeeInfo? employeeInfo;
  List<Translation>? translations;
  double? withdrawAbleBalance;
  double? payableBalance;
  bool? adjustable;
  bool? overFlowWarning;
  bool? overFlowBlockWarning;
  double? pendingWithdraw;
  double? alreadyWithdrawn;
  String? dynamicBalanceType;
  double? dynamicBalance;
  bool? showPayNowButton;
  Subscription? subscription;
  SubscriptionOtherData? subscriptionOtherData;
  bool? subscriptionTransactions;
  int? outOfStockCount;

  ProfileModel({
    this.id,
    this.fName,
    this.lName,
    this.phone,
    this.email,
    this.createdAt,
    this.updatedAt,
    this.bankName,
    this.branch,
    this.holderName,
    this.accountNo,
    this.imageFullUrl,
    this.orderCount,
    this.todaysOrderCount,
    this.thisWeekOrderCount,
    this.thisMonthOrderCount,
    this.memberSinceDays,
    this.cashInHands,
    this.balance,
    this.totalEarning,
    this.todaysEarning,
    this.thisWeekEarning,
    this.thisMonthEarning,
    this.stores,
    this.roles,
    this.employeeInfo,
    this.translations,
    this.withdrawAbleBalance,
    this.payableBalance,
    this.adjustable,
    this.overFlowWarning,
    this.overFlowBlockWarning,
    this.pendingWithdraw,
    this.alreadyWithdrawn,
    this.dynamicBalanceType,
    this.dynamicBalance,
    this.showPayNowButton,
    this.subscription,
    this.subscriptionOtherData,
    this.subscriptionTransactions,
    this.outOfStockCount,
  });

  ProfileModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fName = json['f_name'];
    lName = json['l_name'];
    phone = json['phone'];
    email = json['email'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    bankName = json['bank_name'];
    branch = json['branch'];
    holderName = json['holder_name'];
    accountNo = json['account_no'];
    imageFullUrl = json['image_full_url'];
    orderCount = json['order_count'];
    todaysOrderCount = json['todays_order_count'];
    thisWeekOrderCount = json['this_week_order_count'];
    thisMonthOrderCount = json['this_month_order_count'];
    memberSinceDays = json['member_since_days'];
    cashInHands = json['cash_in_hands']?.toDouble();
    balance = json['balance']?.toDouble();
    totalEarning = json['total_earning']?.toDouble();
    todaysEarning = json['todays_earning']?.toDouble();
    thisWeekEarning = json['this_week_earning']?.toDouble();
    thisMonthEarning = json['this_month_earning']?.toDouble();
    if (json['stores'] != null) {
      stores = [];
      json['stores'].forEach((v) {
        stores!.add(Store.fromJson(v));
      });
    }
    if (json['roles'] != null) {
      roles = [];
      json['roles'].forEach((v) => roles!.add(v));
    }
    if (json['employee_info'] != null) {
      employeeInfo = EmployeeInfo.fromJson(json['employee_info']);
    }
    if (json['translations'] != null) {
      translations = [];
      json['translations'].forEach((v) {
        translations!.add(Translation.fromJson(v));
      });
    }
    withdrawAbleBalance = json['withdraw_able_balance']?.toDouble();
    payableBalance = json['Payable_Balance']?.toDouble();
    adjustable = json['adjust_able'];
    overFlowWarning = json['over_flow_warning'];
    overFlowBlockWarning = json['over_flow_block_warning'];
    pendingWithdraw = json['pending_withdraw']?.toDouble();
    alreadyWithdrawn = json['total_withdrawn']?.toDouble();
    dynamicBalanceType = json['dynamic_balance_type'];
    dynamicBalance = json['dynamic_balance']?.toDouble();
    showPayNowButton = json['show_pay_now_button'];
    if (json['subscription'] != null) {
      subscription = Subscription.fromJson(json['subscription']);
    }
    subscriptionOtherData = json['subscription_other_data'] != null ? SubscriptionOtherData.fromJson(json['subscription_other_data']) : null;
    subscriptionTransactions = json['subscription_transactions'] ?? false;
    outOfStockCount = json['out_of_stock_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['f_name'] = fName;
    data['l_name'] = lName;
    data['phone'] = phone;
    data['email'] = email;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['bank_name'] = bankName;
    data['branch'] = branch;
    data['holder_name'] = holderName;
    data['account_no'] = accountNo;
    data['image_full_url'] = imageFullUrl;
    data['order_count'] = orderCount;
    data['todays_order_count'] = todaysOrderCount;
    data['this_week_order_count'] = thisWeekOrderCount;
    data['this_month_order_count'] = thisMonthOrderCount;
    data['member_since_days'] = memberSinceDays;
    data['cash_in_hands'] = cashInHands;
    data['balance'] = balance;
    data['total_earning'] = totalEarning;
    data['todays_earning'] = todaysEarning;
    data['this_week_earning'] = thisWeekEarning;
    data['this_month_earning'] = thisMonthEarning;
    if (stores != null) {
      data['stores'] = stores!.map((v) => v.toJson()).toList();
    }
    data['employee_info'] = employeeInfo;
    if (translations != null) {
      data['translations'] = translations!.map((v) => v.toJson()).toList();
    }
    data['withdraw_able_balance'] = withdrawAbleBalance;
    data['Payable_Balance'] = payableBalance;
    data['adjust_able'] = adjustable;
    data['over_flow_warning'] = overFlowWarning;
    data['over_flow_block_warning'] = overFlowBlockWarning;
    data['pending_withdraw'] = pendingWithdraw;
    data['total_withdrawn'] = alreadyWithdrawn;
    data['dynamic_balance_type'] = dynamicBalanceType;
    data['dynamic_balance'] = dynamicBalance;
    data['show_pay_now_button'] = showPayNowButton;
    data['subscription_transactions'] = subscriptionTransactions;
    data['out_of_stock_count'] = outOfStockCount;
    return data;
  }
}

class Store {
  int? id;
  String? name;
  String? phone;
  String? email;
  String? logoFullUrl;
  String? latitude;
  String? longitude;
  String? address;
  double? minimumOrder;
  double? comission;
  bool? scheduleOrder;
  String? currency;
  String? createdAt;
  String? updatedAt;
  bool? freeDelivery;
  String? coverPhotoFullUrl;
  bool? delivery;
  bool? takeAway;
  double? tax;
  bool? reviewsSection;
  bool? itemSection;
  double? avgRating;
  int? ratingCount;
  bool? active;
  bool? gstStatus;
  String? gstCode;
  int? selfDeliverySystem;
  bool? posSystem;
  double? minimumShippingCharge;
  double? maximumShippingCharge;
  double? perKmShippingCharge;
  String? deliveryTime;
  int? veg;
  int? nonVeg;
  int? orderPlaceToScheduleInterval;
  Module? module;
  Discount? discount;
  List<Schedules>? schedules;
  bool? prescriptionStatus;
  bool? cutlery;
  String? metaTitle;
  String? metaDescription;
  String? metaKeyWord;
  String? metaImageFullUrl;
  String? announcementMessage;
  String? storeBusinessModel;
  int? isAnnouncementActive;
  bool? extraPackagingStatus;
  double? extraPackagingAmount;
  bool? isHalalActive;
  double? minimumStockForWarning;

  Store({
    this.id,
    this.name,
    this.phone,
    this.email,
    this.logoFullUrl,
    this.latitude,
    this.longitude,
    this.address,
    this.minimumOrder,
    this.comission,
    this.scheduleOrder,
    this.currency,
    this.createdAt,
    this.updatedAt,
    this.freeDelivery,
    this.coverPhotoFullUrl,
    this.delivery,
    this.takeAway,
    this.tax,
    this.reviewsSection,
    this.itemSection,
    this.avgRating,
    this.ratingCount,
    this.active,
    this.gstStatus,
    this.gstCode,
    this.selfDeliverySystem,
    this.posSystem,
    this.minimumShippingCharge,
    this.maximumShippingCharge,
    this.perKmShippingCharge,
    this.deliveryTime,
    this.veg,
    this.nonVeg,
    this.orderPlaceToScheduleInterval,
    this.module,
    this.discount,
    this.schedules,
    this.prescriptionStatus,
    this.cutlery,
    this.metaTitle,
    this.metaDescription,
    this.metaKeyWord,
    this.metaImageFullUrl,
    this.announcementMessage,
    this.storeBusinessModel,
    this.isAnnouncementActive,
    this.extraPackagingStatus,
    this.extraPackagingAmount,
    this.isHalalActive,
    this.minimumStockForWarning,
  });

  Store.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    logoFullUrl = json['logo_full_url'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    address = json['address'];
    minimumOrder = json['minimum_order']?.toDouble();
    comission = json['comission']?.toDouble();
    scheduleOrder = json['schedule_order'];
    currency = json['currency'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    freeDelivery = json['free_delivery'];
    coverPhotoFullUrl = json['cover_photo_full_url'];
    delivery = json['delivery'];
    takeAway = json['take_away'];
    tax = json['tax']?.toDouble();
    reviewsSection = json['reviews_section'];
    itemSection = json['item_section'];
    avgRating = json['avg_rating']?.toDouble();
    ratingCount = json['rating_count'];
    active = json['active'];
    gstStatus = json['gst_status'];
    gstCode = json['gst_code'];
    selfDeliverySystem = json['self_delivery_system'];
    posSystem = json['pos_system'];
    minimumShippingCharge = json['minimum_shipping_charge'] != null ? json['minimum_shipping_charge']?.toDouble() : 0.0;
    maximumShippingCharge = json['maximum_shipping_charge']?.toDouble();
    perKmShippingCharge = json['per_km_shipping_charge'] != null ? json['per_km_shipping_charge']?.toDouble() : 0.0;
    deliveryTime = json['delivery_time'];
    veg = json['veg'];
    nonVeg = json['non_veg'];
    orderPlaceToScheduleInterval = json['order_place_to_schedule_interval'];
    module = json['module'] != null ? Module.fromJson(json['module']) : null;
    discount = json['discount'] != null ? Discount.fromJson(json['discount']) : null;
    if (json['schedules'] != null) {
      schedules = <Schedules>[];
      json['schedules'].forEach((v) {
        schedules!.add(Schedules.fromJson(v));
      });
    }
    prescriptionStatus = json['prescription_order'];
    cutlery = json['cutlery'];
    metaTitle = json['meta_title'];
    metaDescription = json['meta_description'];
    metaKeyWord = json['meta_key_word'];
    metaImageFullUrl = json['meta_image_full_url'];
    announcementMessage = json['announcement_message'];
    storeBusinessModel = json['store_business_model'];
    isAnnouncementActive = json['announcement'];
    extraPackagingStatus = json['extra_packaging_status'] ?? false;
    extraPackagingAmount = json['extra_packaging_amount']?.toDouble();
    isHalalActive = json['halal_tag_status'] ?? false;
    minimumStockForWarning = json['minimum_stock_for_warning']?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['phone'] = phone;
    data['email'] = email;
    data['logo_full_url'] = logoFullUrl;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['address'] = address;
    data['minimum_order'] = minimumOrder;
    data['comission'] = comission;
    data['schedule_order'] = scheduleOrder;
    data['currency'] = currency;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['free_delivery'] = freeDelivery;
    data['cover_photo_full_url'] = coverPhotoFullUrl;
    data['delivery'] = delivery;
    data['take_away'] = takeAway;
    data['tax'] = tax;
    data['reviews_section'] = reviewsSection;
    data['item_section'] = itemSection;
    data['avg_rating'] = avgRating;
    data['rating_count '] = ratingCount;
    data['active'] = active;
    data['gst_status'] = gstStatus;
    data['gst_code'] = gstCode;
    data['self_delivery_system'] = selfDeliverySystem;
    data['pos_system'] = posSystem;
    data['minimum_shipping_charge'] = minimumShippingCharge;
    data['maximum_shipping_charge'] = maximumShippingCharge;
    data['per_km_shipping_charge'] = perKmShippingCharge;
    data['delivery_time'] = deliveryTime;
    data['veg'] = veg;
    data['non_veg'] = nonVeg;
    data['order_place_to_schedule_interval'] = orderPlaceToScheduleInterval;
    if (module != null) {
      data['module'] = module!.toJson();
    }
    if (discount != null) {
      data['discount'] = discount!.toJson();
    }
    if (schedules != null) {
      data['schedules'] = schedules!.map((v) => v.toJson()).toList();
    }
    data['prescription_order'] = prescriptionStatus;
    data['cutlery'] = cutlery;
    data['meta_title'] = metaTitle;
    data['meta_description'] = metaDescription;
    data['meta_key_word'] = metaKeyWord;
    data['meta_image_full_url'] = metaImageFullUrl;
    data['announcement_message'] = announcementMessage;
    data['store_business_model'] = storeBusinessModel;
    data['announcement'] = isAnnouncementActive;
    data['extra_packaging_status'] = extraPackagingStatus;
    data['extra_packaging_amount'] = extraPackagingAmount;
    data['halal_tag_status'] = isHalalActive;
    data['minimum_stock_for_warning'] = minimumStockForWarning;
    return data;
  }
}

class EmployeeInfo {
  int? id;
  String? fName;
  String? lName;
  String? phone;
  String? email;
  String? imageFullUrl;
  int? employeeRoleId;
  int? storeId;

  EmployeeInfo({
    this.id,
    this.fName,
    this.lName,
    this.phone,
    this.email,
    this.imageFullUrl,
    this.employeeRoleId,
    this.storeId,
  });

  EmployeeInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fName = json['f_name'];
    lName = json['l_name'];
    phone = json['phone'];
    email = json['email'];
    imageFullUrl = json['image_full_url'];
    employeeRoleId = json['employee_role_id'];
    storeId = json['store_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['f_name'] = fName;
    data['l_name'] = lName;
    data['phone'] = phone;
    data['email'] = email;
    data['image_full_url'] = imageFullUrl;
    data['employee_role_id'] = employeeRoleId;
    data['store_id'] = storeId;
    return data;
  }
}

class Discount {
  int? id;
  String? startDate;
  String? endDate;
  String? startTime;
  String? endTime;
  double? minPurchase;
  double? maxDiscount;
  double? discount;
  String? discountType;
  int? storeId;
  String? createdAt;
  String? updatedAt;

  Discount({
    this.id,
    this.startDate,
    this.endDate,
    this.startTime,
    this.endTime,
    this.minPurchase,
    this.maxDiscount,
    this.discount,
    this.discountType,
    this.storeId,
    this.createdAt,
    this.updatedAt,
  });

  Discount.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    minPurchase = json['min_purchase']?.toDouble();
    maxDiscount = json['max_discount']?.toDouble();
    discount = json['discount']?.toDouble();
    discountType = json['discount_type'];
    storeId = json['store_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['min_purchase'] = minPurchase;
    data['max_discount'] = maxDiscount;
    data['discount'] = discount;
    data['discount_type'] = discountType;
    data['store_id'] = storeId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Schedules {
  int? id;
  int? storeId;
  int? day;
  String? openingTime;
  String? closingTime;

  Schedules({
    this.id,
    this.storeId,
    this.day,
    this.openingTime,
    this.closingTime,
  });

  Schedules.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    storeId = json['store_id'];
    day = json['day'];
    openingTime = json['opening_time'].substring(0, 5);
    closingTime = json['closing_time'].substring(0, 5);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['store_id'] = storeId;
    data['day'] = day;
    data['opening_time'] = openingTime;
    data['closing_time'] = closingTime;
    return data;
  }
}

class Module {
  int? id;
  String? moduleName;
  String? moduleType;
  String? thumbnail;
  String? status;
  int? storesCount;
  String? createdAt;
  String? updatedAt;

  Module({
    this.id,
    this.moduleName,
    this.moduleType,
    this.thumbnail,
    this.status,
    this.storesCount,
    this.createdAt,
    this.updatedAt,
  });

  Module.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    moduleName = json['module_name'];
    moduleType = json['module_type'];
    thumbnail = json['thumbnail'];
    status = json['status'];
    storesCount = json['stores_count'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['module_name'] = moduleName;
    data['module_type'] = moduleType;
    data['thumbnail'] = thumbnail;
    data['status'] = status;
    data['stores_count'] = storesCount;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Subscription {
  int? id;
  int? packageId;
  int? storeId;
  String? expiryDate;
  String? maxOrder;
  String? maxProduct;
  int? pos;
  int? mobileApp;
  int? chat;
  int? review;
  int? selfDelivery;
  int? status;
  int? isTrial;
  int? totalPackageRenewed;
  String? createdAt;
  String? updatedAt;
  String? renewedAt;
  int? isCanceled;
  String? canceledBy;
  int? validity;
  Package? package;

  Subscription({
    this.id,
    this.packageId,
    this.storeId,
    this.expiryDate,
    this.maxOrder,
    this.maxProduct,
    this.pos,
    this.mobileApp,
    this.chat,
    this.review,
    this.selfDelivery,
    this.status,
    this.isTrial,
    this.totalPackageRenewed,
    this.createdAt,
    this.updatedAt,
    this.renewedAt,
    this.isCanceled,
    this.canceledBy,
    this.validity,
    this.package,
  });

  Subscription.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    packageId = json['package_id'];
    storeId = json['store_id'];
    expiryDate = json['expiry_date'];
    maxOrder = json['max_order'];
    maxProduct = json['max_product'];
    pos = json['pos'] ?? 0;
    mobileApp = json['mobile_app'] ?? 0;
    chat = json['chat'] ?? 0;
    review = json['review'] ?? 0;
    selfDelivery = json['self_delivery'];
    status = json['status'];
    isTrial = json['is_trial'];
    totalPackageRenewed = json['total_package_renewed'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    renewedAt = json['renewed_at'];
    isCanceled = json['is_canceled'];
    canceledBy = json['canceled_by'];
    validity = json['validity'];
    package = json['package'] != null ? Package.fromJson(json['package']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['package_id'] = packageId;
    data['store_id'] = storeId;
    data['expiry_date'] = expiryDate;
    data['max_order'] = maxOrder;
    data['max_product'] = maxProduct;
    data['pos'] = pos;
    data['mobile_app'] = mobileApp;
    data['chat'] = chat;
    data['review'] = review;
    data['self_delivery'] = selfDelivery;
    data['status'] = status;
    data['total_package_renewed'] = totalPackageRenewed;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['renewed_at'] = renewedAt;
    data['is_canceled'] = isCanceled;
    data['canceled_by'] = canceledBy;
    data['validity'] = validity;
    if (package != null) {
      data['package'] = package!.toJson();
    }
    return data;
  }
}

class Package {
  int? id;
  String? packageName;
  double? price;
  int? validity;
  String? maxOrder;
  String? maxProduct;
  int? pos;
  int? mobileApp;
  int? chat;
  int? review;
  int? selfDelivery;
  int? status;
  int? def;
  String? colour;
  String? text;
  String? createdAt;
  String? updatedAt;

  Package({
    this.id,
    this.packageName,
    this.price,
    this.validity,
    this.maxOrder,
    this.maxProduct,
    this.pos,
    this.mobileApp,
    this.chat,
    this.review,
    this.selfDelivery,
    this.status,
    this.def,
    this.colour,
    this.text,
    this.createdAt,
    this.updatedAt,
  });

  Package.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    packageName = json['package_name'];
    price = json['price']?.toDouble();
    validity = json['validity'];
    maxOrder = json['max_order'];
    maxProduct = json['max_product'];
    pos = json['pos'];
    mobileApp = json['mobile_app'];
    chat = json['chat'];
    review = json['review'];
    selfDelivery = json['self_delivery'];
    status = json['status'];
    def = json['default'];
    colour = json['colour'];
    text = json['text'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['package_name'] = packageName;
    data['price'] = price;
    data['validity'] = validity;
    data['max_order'] = maxOrder;
    data['max_product'] = maxProduct;
    data['pos'] = pos;
    data['mobile_app'] = mobileApp;
    data['chat'] = chat;
    data['review'] = review;
    data['self_delivery'] = selfDelivery;
    data['status'] = status;
    data['default'] = def;
    data['colour'] = colour;
    data['text'] = text;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class SubscriptionOtherData {
  double? totalBill;
  int? maxProductUpload;
  double? pendingBill;

  SubscriptionOtherData({
    this.totalBill,
    this.maxProductUpload,
    this.pendingBill,
  });

  SubscriptionOtherData.fromJson(Map<String, dynamic> json) {
    totalBill = json['total_bill']?.toDouble();
    maxProductUpload = json['max_product_uploads'];
    pendingBill = json['pending_bill']?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_bill'] = totalBill;
    data['max_product_uploads'] = maxProductUpload;
    data['pending_bill'] = pendingBill;
    return data;
  }
}
