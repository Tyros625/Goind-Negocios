class UpdateStatusBodyModel {
  String? token;
  int? orderId;
  String? status;
  String? otp;
  String? processingTime;
  String method = 'put';
  String? reason;
  double? amountReceived;
  double? changeAmount;

  UpdateStatusBodyModel({this.token, this.orderId, this.status, this.otp, this.reason, this.processingTime, this.amountReceived, this.changeAmount});

  UpdateStatusBodyModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    orderId = json['order_id'];
    status = json['status'];
    otp = json['otp'];
    processingTime = json['processing_time'];
    status = json['_method'];
    reason = json['reason'];
    amountReceived = json['amount_received']?.toDouble();
    changeAmount = json['change_amount']?.toDouble();
  }

  Map<String, String> toJson() {
    final Map<String, String> data = <String, String>{};
    data['token'] = token ?? '';
    data['order_id'] = orderId.toString();
    data['status'] = status!;
    data['otp'] = otp ?? '';
    data['processing_time'] = processingTime ?? '';
    data['_method'] = method;
    if(reason != '' && reason != null) {
      data['reason'] = reason!;
    }
    if(amountReceived != null) {
      data['amount_received'] = amountReceived.toString();
    }
    if(changeAmount != null) {
      data['change_amount'] = changeAmount.toString();
    }
    return data;
  }
}