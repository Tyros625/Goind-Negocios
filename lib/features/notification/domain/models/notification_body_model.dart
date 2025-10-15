enum NotificationType{
  message,
  order,
  general,
  advertisement,
  block,
  unblock,
  subscription,
  //ignore: constant_identifier_names
  product_approve,
  //ignore: constant_identifier_names
  product_rejected,
  withdraw,
  campaign,
}

class NotificationBodyModel {
  NotificationType? notificationType;
  int? orderId;
  int? customerId;
  int? deliveryManId;
  int? conversationId;
  String? type;
  int? advertisementId;
  int? campaignId;

  NotificationBodyModel({
    this.notificationType,
    this.orderId,
    this.customerId,
    this.deliveryManId,
    this.conversationId,
    this.type,
    this.advertisementId,
    this.campaignId,
  });

  NotificationBodyModel.fromJson(Map<String, dynamic> json) {
    notificationType = convertToEnum(json['order_notification']);
    orderId = json['order_id'];
    customerId = json['customer_id'];
    deliveryManId = json['delivery_man_id'];
    conversationId = json['conversation_id'];
    type = json['type'];
    advertisementId = json['advertisement_id'];
    campaignId = json['data_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_notification'] = notificationType.toString();
    data['order_id'] = orderId;
    data['customer_id'] = customerId;
    data['delivery_man_id'] = deliveryManId;
    data['conversation_id'] = conversationId;
    data['type'] = type;
    data['advertisement_id'] = advertisementId;
    data['data_id'] = campaignId;
    return data;
  }

  NotificationType convertToEnum(String? enumString) {
    final Map<String, NotificationType> enumMap = {
      NotificationType.general.toString(): NotificationType.general,
      NotificationType.order.toString(): NotificationType.order,
      NotificationType.message.toString(): NotificationType.message,
      NotificationType.advertisement.toString(): NotificationType.advertisement,
      NotificationType.block.toString(): NotificationType.block,
      NotificationType.unblock.toString(): NotificationType.unblock,
      NotificationType.subscription.toString(): NotificationType.subscription,
      NotificationType.product_approve.toString(): NotificationType.product_approve,
      NotificationType.product_rejected.toString(): NotificationType.product_rejected,
      NotificationType.withdraw.toString(): NotificationType.withdraw,
      NotificationType.campaign.toString(): NotificationType.campaign,
    };

    return enumMap[enumString] ?? NotificationType.general;
  }

}
