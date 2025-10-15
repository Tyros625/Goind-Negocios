class CheckProductLimitModel {
  int? disableItemCount;
  double? backAmount;
  int? days;

  CheckProductLimitModel({this.disableItemCount, this.backAmount, this.days});

  CheckProductLimitModel.fromJson(Map<String, dynamic> json) {
    disableItemCount = json['disable_item_count'];
    backAmount = json['back_amount']?.toDouble();
    days = json['days'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['disable_item_count'] = disableItemCount;
    data['back_amount'] = backAmount;
    data['days'] = days;
    return data;
  }
}
