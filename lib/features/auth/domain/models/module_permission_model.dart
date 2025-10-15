class ModulePermissionModel {
  bool? dashboard;
  bool? profile;
  bool? order;
  bool? pos;
  bool? item;
  bool? addon;
  bool? category;
  bool? campaign;
  bool? coupon;
  bool? banner;
  bool? advertisement;
  bool? advertisementList;
  bool? deliveryman;
  bool? deliverymanList;
  bool? wallet;
  bool? walletMethod;
  bool? role;
  bool? employee;
  bool? expenseReport;
  bool? disbursementReport;
  bool? vatReport;
  bool? storeSetup;
  bool? notificationSetup;
  bool? myShop;
  bool? businessPlan;
  bool? reviews;
  bool? chat;

  ModulePermissionModel({
    this.dashboard,
    this.profile,
    this.order,
    this.pos,
    this.item,
    this.addon,
    this.category,
    this.campaign,
    this.coupon,
    this.banner,
    this.advertisement,
    this.advertisementList,
    this.deliveryman,
    this.deliverymanList,
    this.wallet,
    this.walletMethod,
    this.role,
    this.employee,
    this.expenseReport,
    this.disbursementReport,
    this.vatReport,
    this.storeSetup,
    this.notificationSetup,
    this.myShop,
    this.businessPlan,
    this.reviews,
    this.chat,
  });

  ModulePermissionModel.fromJson(Map<String, dynamic> json) {
    dashboard = json['dashboard'];
    profile = json['profile'];
    order = json['order'];
    pos = json['pos'];
    item = json['item'];
    addon = json['addon'];
    category = json['category'];
    campaign = json['campaign'];
    coupon = json['coupon'];
    banner = json['banner'];
    advertisement = json['advertisement'];
    advertisementList = json['advertisement_list'];
    deliveryman = json['deliveryman'];
    deliverymanList = json['deliveryman_list'];
    wallet = json['wallet'];
    walletMethod = json['wallet_method'];
    role = json['role'];
    employee = json['employee'];
    expenseReport = json['expense_report'];
    disbursementReport = json['disbursement_report'];
    vatReport = json['vat_report'];
    storeSetup = json['store_setup'];
    notificationSetup = json['notification_setup'];
    myShop = json['my_shop'];
    businessPlan = json['business_plan'];
    reviews = json['reviews'];
    chat = json['chat'];
  }

  Map<String, bool?> toJson() {
    final Map<String, bool?> data = <String, bool?>{};
    data['dashboard'] = dashboard;
    data['profile'] = profile;
    data['order'] = order;
    data['pos'] = pos;
    data['item'] = item;
    data['addon'] = addon;
    data['category'] = category;
    data['campaign'] = campaign;
    data['coupon'] = coupon;
    data['banner'] = banner;
    data['advertisement'] = advertisement;
    data['advertisement_list'] = advertisementList;
    data['deliveryman'] = deliveryman;
    data['deliveryman_list'] = deliverymanList;
    data['wallet'] = wallet;
    data['wallet_method'] = walletMethod;
    data['role'] = role;
    data['employee'] = employee;
    data['expense_report'] = expenseReport;
    data['disbursement_report'] = disbursementReport;
    data['vat_report'] = vatReport;
    data['store_setup'] = storeSetup;
    data['notification_setup'] = notificationSetup;
    data['my_shop'] = myShop;
    data['business_plan'] = businessPlan;
    data['reviews'] = reviews;
    data['chat'] = chat;
    return data;
  }
}
