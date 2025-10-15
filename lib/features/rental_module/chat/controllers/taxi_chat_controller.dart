import 'package:get/get.dart';
import 'package:sixam_mart_store/features/chat/domain/models/conversation_model.dart';
import 'package:sixam_mart_store/features/notification/domain/models/notification_body_model.dart';
import 'package:sixam_mart_store/features/rental_module/chat/domain/models/taxi_message_model.dart';
import 'package:sixam_mart_store/features/rental_module/chat/domain/services/taxi_chat_service_interface.dart';

class TaxiChatController extends GetxController implements GetxService {
  final TaxiChatServiceInterface chatServiceInterface;
  TaxiChatController({required this.chatServiceInterface});

  TaxiMessageModel? _messageModel;
  TaxiMessageModel? get messageModel => _messageModel;

  Future<void> getConversationList(int offset) async {}

  Future<void> getMessages(int offset, NotificationBodyModel notificationBody, User? user, int? conversationID, {bool firstLoad = false}) async {}
}