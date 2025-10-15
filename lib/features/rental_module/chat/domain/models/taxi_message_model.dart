import 'package:sixam_mart_store/features/chat/domain/models/conversation_model.dart';

class TaxiMessageModel {
  Conversation? conversation;

  TaxiMessageModel({this.conversation});

  TaxiMessageModel.fromJson(Map<String, dynamic> json) {
    conversation = json['conversation'] != null ? Conversation.fromJson(json['conversation']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (conversation != null) {
      data['conversation'] = conversation!.toJson();
    }
    return data;
  }
}