import 'package:flutter/material.dart';
import 'package:sixam_mart_store/features/notification/domain/models/notification_body_model.dart';

class TaxiChatScreen extends StatefulWidget {
  final NotificationBodyModel? notificationBody;
  final int? conversationId;
  final bool fromNotification;
  const TaxiChatScreen({super.key, required this.notificationBody, this.conversationId, this.fromNotification = false});

  @override
  State<TaxiChatScreen> createState() => _TaxiChatScreenState();
}

class _TaxiChatScreenState extends State<TaxiChatScreen> {

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
