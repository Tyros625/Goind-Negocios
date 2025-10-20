import 'dart:convert';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sixam_mart_store/features/advertisement/controllers/advertisement_controller.dart';
import 'package:sixam_mart_store/features/auth/controllers/auth_controller.dart';
import 'package:sixam_mart_store/features/chat/controllers/chat_controller.dart';
import 'package:sixam_mart_store/features/dashboard/screens/dashboard_screen.dart';
import 'package:sixam_mart_store/features/notification/controllers/notification_controller.dart';
import 'package:sixam_mart_store/features/order/controllers/order_controller.dart';
import 'package:sixam_mart_store/features/notification/domain/models/notification_body_model.dart';
import 'package:sixam_mart_store/features/order/screens/invoice_print_screen.dart';
import 'package:sixam_mart_store/features/rental_module/chat/controllers/taxi_chat_controller.dart';
import 'package:sixam_mart_store/features/rental_module/chat/screens/taxi_chat_screen.dart';
import 'package:sixam_mart_store/features/rental_module/trips/controllers/trip_controller.dart';
import 'package:sixam_mart_store/features/rental_module/trips/screens/trip_details_screen.dart';
import 'package:sixam_mart_store/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart_store/helper/invoice_print_helper.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';
import 'package:sixam_mart_store/main.dart';
import 'package:sixam_mart_store/util/app_constants.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:sixam_mart_store/features/dashboard/widgets/new_request_dialog_widget.dart';
import 'package:sixam_mart_store/util/dimensions.dart';

class NotificationHelper {

  static Future<void> initialize(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInitialize = const AndroidInitializationSettings('notification_icon');
    var iOSInitialize = const DarwinInitializationSettings();
    var initializationsSettings = InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation < AndroidFlutterLocalNotificationsPlugin>()!.requestNotificationsPermission();
    flutterLocalNotificationsPlugin.initialize(initializationsSettings, onDidReceiveNotificationResponse: (NotificationResponse load) async{
      try{
        if(load.payload!.isNotEmpty){
          NotificationBodyModel payload = NotificationBodyModel.fromJson(jsonDecode(load.payload!));

          final Map<NotificationType, Function> notificationActions = {
            NotificationType.order: () {
              if(Get.find<AuthController>().getModuleType() == 'rental'){
                Get.to(()=> TripDetailsScreen(tripId: payload.orderId!, fromNotification: true));
              }else{
                Get.toNamed(RouteHelper.getOrderDetailsRoute(payload.orderId, fromNotification: true));
              }
            },
            NotificationType.advertisement: () => Get.toNamed(RouteHelper.getAdvertisementDetailsScreen(advertisementId: payload.advertisementId, fromNotification: true)),
            NotificationType.block: () => Get.offAllNamed(RouteHelper.getSignInRoute()),
            NotificationType.unblock: () => Get.offAllNamed(RouteHelper.getSignInRoute()),
            NotificationType.withdraw: () => Get.to(const DashboardScreen(pageIndex: 3)),
            NotificationType.campaign: () => Get.toNamed(RouteHelper.getCampaignDetailsRoute(id: payload.campaignId, fromNotification: true)),
            NotificationType.message: () {
              if(Get.find<AuthController>().getModuleType() == 'rental'){
                Get.to(()=> TaxiChatScreen(notificationBody: payload, conversationId: payload.conversationId, fromNotification: true));
              }else{
                Get.toNamed(RouteHelper.getChatRoute(notificationBody: payload, conversationId: payload.conversationId, fromNotification: true));
              }
            },
            NotificationType.subscription: () => Get.toNamed(RouteHelper.getMySubscriptionRoute(fromNotification: true)),
            NotificationType.product_approve: () => Get.offAll(const DashboardScreen(pageIndex: 2)),
            NotificationType.product_rejected: () => Get.toNamed(RouteHelper.getPendingItemRoute(fromNotification: true)),
            NotificationType.general: () => Get.toNamed(RouteHelper.getNotificationRoute(fromNotification: true)),
          };

          notificationActions[payload.notificationType]?.call();
        }
      }catch(_){}
      return;
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint("onMessage message type:${message.data['type']}");
      debugPrint("onMessage message :${message.data}");

      if(message.data['type'] == 'message' && (Get.currentRoute.startsWith(RouteHelper.chatScreen) || Get.currentRoute.startsWith('/TaxiChatScreen'))) {
        if(Get.find<AuthController>().getModuleType() == 'rental'){
          if(Get.find<AuthController>().isLoggedIn()) {
            Get.find<TaxiChatController>().getConversationList(1);
            if(Get.find<TaxiChatController>().messageModel!.conversation!.id.toString() == message.data['conversation_id'].toString()) {
              Get.find<TaxiChatController>().getMessages(
                1, NotificationBodyModel(
                notificationType: NotificationType.message,
                customerId: message.data['sender_type'] == AppConstants.user ? 0 : null,
                deliveryManId: message.data['sender_type'] == AppConstants.deliveryMan ? 0 : null,
              ),
                null, int.parse(message.data['conversation_id'].toString()),
              );
            }else {
              NotificationHelper.showNotification(message, flutterLocalNotificationsPlugin);
            }
          }
        }else{
          if(Get.find<AuthController>().isLoggedIn()) {
            Get.find<ChatController>().getConversationList(1);
            if(Get.find<ChatController>().messageModel!.conversation!.id.toString() == message.data['conversation_id'].toString()) {
              Get.find<ChatController>().getMessages(
                1, NotificationBodyModel(
                notificationType: NotificationType.message,
                customerId: message.data['sender_type'] == AppConstants.user ? 0 : null,
                deliveryManId: message.data['sender_type'] == AppConstants.deliveryMan ? 0 : null,
              ),
                null, int.parse(message.data['conversation_id'].toString()),
              );
            }else {
              NotificationHelper.showNotification(message, flutterLocalNotificationsPlugin);
            }
          }
        }
      }else if(message.data['type'] == 'message' && (Get.currentRoute.startsWith(RouteHelper.conversationListScreen) || Get.currentRoute.startsWith('/TaxiConversationScreen'))) {
        if(Get.find<AuthController>().getModuleType() == 'rental'){
          if(Get.find<AuthController>().isLoggedIn()) {
            Get.find<TaxiChatController>().getConversationList(1);
          }
          NotificationHelper.showNotification(message, flutterLocalNotificationsPlugin);
        }else{
          if(Get.find<AuthController>().isLoggedIn()) {
            Get.find<ChatController>().getConversationList(1);
          }
          NotificationHelper.showNotification(message, flutterLocalNotificationsPlugin);
        }
      }else {
        NotificationHelper.showNotification(message, flutterLocalNotificationsPlugin);

        if (message.data['type'] == 'new_order' || message.data['title'] == 'New order placed') {
          if(Get.find<AuthController>().getModuleType() == 'rental'){
            TripController tripController = Get.find<TripController>();
            tripController.getTripList(status: 'pending', offset: '1');
            tripController.getTripList(status: 'confirmed', offset: '1');
            tripController.getTripList(status: 'ongoing', offset: '1');
          }else{
            Get.find<OrderController>().getPaginatedOrders(1, true);
            Get.find<OrderController>().getCurrentOrders();

            _handleAutoPrintForConfirmedOrder(int.parse(message.data['order_id']));
          }

          // Get.find<OrderController>().getOrderDetails(int.parse(message.data['order_id'])).then((value) async{
          //
          //   await Get.find<OrderController>().getOrderItemsDetails(int.parse(message.data['order_id']));
          //   final SplashController splashController = Get.find();
          //   final OrderController orderController = Get.find();
          //
          //   String? savedMacAddress = splashController.getBluetoothAddress();
          //   bool currentlyConnectedInSavedPrinter = false;
          //   OrderModel? order = orderController.orderModel;
          //   bool isPrescriptionOrder = false;
          //   double dmTips = 0.0;
          //   if(order?.orderType == 'delivery') {
          //     dmTips = order?.dmTips ?? 0.0;
          //     isPrescriptionOrder = order?.prescriptionOrder ?? false;
          //   }
          //
          //   if(savedMacAddress?.isNotEmpty ?? false){
          //     currentlyConnectedInSavedPrinter = await InvoicePrintHelper.checkConnectionStatus();
          //   }
          //
          //   allowPermission().then((access) {
          //
          //     print('----(Order Details)----${orderController.orderDetailsModel.toString()}');
          //     print('-----(Order)----${order?.toJson().toString()}');
          //
          //     Get.back();
          //     Get.dialog(Dialog(
          //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
          //       insetPadding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          //       child: InVoicePrintScreen(
          //         order : order,
          //         dmTips: dmTips,
          //         isPrescriptionOrder: isPrescriptionOrder,
          //         orderDetails: orderController.orderDetailsModel,
          //         currentlyConnectedInSavedPrinter : currentlyConnectedInSavedPrinter,
          //       ),
          //     ));
          //   });
          //
          // });

        }else if(message.data['type'] == 'advertisement') {
          Get.find<AdvertisementController>().getAdvertisementList('1', 'all');
        }
        Get.find<NotificationController>().getNotificationList();
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint("onOpenApp message type:${message.data['type']}");
      debugPrint("onOpenApp message :${message.data}");

      try{
        NotificationBodyModel notificationBody = convertNotification(message.data);

        final Map<NotificationType, Function> notificationActions = {
          NotificationType.order: () {
            if(Get.find<AuthController>().getModuleType() == 'rental'){
              Get.to(()=> TripDetailsScreen(tripId: int.parse(message.data['order_id']), fromNotification: true));
            }else{
              Get.toNamed(RouteHelper.getOrderDetailsRoute(int.parse(message.data['order_id']), fromNotification: true));
            }
          },
          NotificationType.advertisement: () => Get.toNamed(RouteHelper.getAdvertisementDetailsScreen(advertisementId:  notificationBody.advertisementId, fromNotification: true)),
          NotificationType.block: () => Get.offAllNamed(RouteHelper.getSignInRoute()),
          NotificationType.unblock: () => Get.offAllNamed(RouteHelper.getSignInRoute()),
          NotificationType.withdraw: () => Get.to(const DashboardScreen(pageIndex: 3)),
          NotificationType.campaign: () => Get.toNamed(RouteHelper.getCampaignDetailsRoute(id: notificationBody.campaignId, fromNotification: true)),
          NotificationType.message: () {
            if(Get.find<AuthController>().getModuleType() == 'rental'){
              Get.to(()=> TaxiChatScreen(notificationBody: notificationBody, conversationId: notificationBody.conversationId, fromNotification: true));
            }else{
              Get.toNamed(RouteHelper.getChatRoute(notificationBody: notificationBody, conversationId: notificationBody.conversationId, fromNotification: true));
            }
          },
          NotificationType.subscription: () => Get.toNamed(RouteHelper.getMySubscriptionRoute(fromNotification: true)),
          NotificationType.product_approve: () => Get.offAll(const DashboardScreen(pageIndex: 2)),
          NotificationType.product_rejected: () => Get.toNamed(RouteHelper.getPendingItemRoute(fromNotification: true)),
          NotificationType.general: () => Get.toNamed(RouteHelper.getNotificationRoute(fromNotification: true)),
        };

        notificationActions[notificationBody.notificationType]?.call();
      }catch (_){}
    });
  }

  static Future<void> _handleAutoPrintForConfirmedOrder(int orderId) async {
    await Get.find<OrderController>().getOrderDetails(orderId);
    final orderController = Get.find<OrderController>();
    final order = orderController.orderModel;

    if (order == null) return;

    bool shouldAutoPrint = false;

    if (order.paymentStatus == 'partially_paid' && order.orderStatus == 'confirmed' && order.paymentMethod == 'partial_payment') {
      shouldAutoPrint = true;
    } else if((order.paymentStatus == 'unpaid' || order.paymentStatus == 'paid') && order.orderStatus == 'confirmed'){
      shouldAutoPrint = true;
    }

    if (shouldAutoPrint) {
      // Don't show dialog, directly trigger auto-print
      await orderController.getOrderItemsDetails(orderId);
      _triggerAutoPrint(order, orderController);
    } else {
      // Show dialog for pending orders (cash on delivery)
      Get.dialog(NewRequestDialogWidget(orderId: orderId));
    }
  }

  static Future<void> _triggerAutoPrint(order, OrderController orderController) async {
    final SplashController splashController = Get.find();
    String? savedMacAddress = splashController.getBluetoothAddress();
    bool currentlyConnectedInSavedPrinter = false;

    bool isPrescriptionOrder = false;
    double dmTips = 0.0;
    if (order?.orderType == 'delivery') {
      dmTips = order?.dmTips ?? 0.0;
      isPrescriptionOrder = order?.prescriptionOrder ?? false;
    }

    if (savedMacAddress?.isNotEmpty ?? false) {
      currentlyConnectedInSavedPrinter = await InvoicePrintHelper.checkConnectionStatus();
    }

    await _allowPermission().then((access) {
      if (access) {
        Get.dialog(Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
          insetPadding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          child: InVoicePrintScreen(
            order: order,
            dmTips: dmTips,
            isPrescriptionOrder: isPrescriptionOrder,
            orderDetails: orderController.orderDetailsModel,
            currentlyConnectedInSavedPrinter: currentlyConnectedInSavedPrinter,
          ),
        ));
      }
    });
  }

  static Future<bool> _allowPermission() async {
    if (!await _requestAndCheckPermission(Permission.location)) {
      return false;
    }
    if (!await _requestAndCheckPermission(Permission.bluetooth)) {
      return false;
    }
    if (!await _requestAndCheckPermission(Permission.bluetoothConnect)) {
      return false;
    }
    if (!await _requestAndCheckPermission(Permission.bluetoothScan)) {
      return false;
    }
    return true;
  }

  static Future<bool> _requestAndCheckPermission(Permission permission) async {
    await permission.request();
    var status = await permission.status;
    return !status.isDenied;
  }

  static Future<void> showNotification(RemoteMessage message, FlutterLocalNotificationsPlugin fln) async {
    if(!GetPlatform.isIOS) {
      String? title;
      String? body;
      String? image;
      NotificationBodyModel notificationBody = convertNotification(message.data);

      title = message.data['title'];
      body = message.data['body'];
      image = (message.data['image'] != null && message.data['image'].isNotEmpty) ? message.data['image'].startsWith('http') ? message.data['image']
        : '${AppConstants.baseUrl}/storage/app/public/notification/${message.data['image']}' : null;

      if(image != null && image.isNotEmpty) {
        try{
          await showBigPictureNotificationHiddenLargeIcon(title, body, notificationBody, image, fln);
        }catch(e) {
          await showBigTextNotification(title, body!, notificationBody, fln);
        }
      }else {
        await showBigTextNotification(title, body!, notificationBody, fln);
      }
    }
  }

  static Future<void> showTextNotification(String title, String body, NotificationBodyModel notificationBody, FlutterLocalNotificationsPlugin fln) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      '6ammart', AppConstants.appName, playSound: true,
      importance: Importance.max, priority: Priority.max, sound: RawResourceAndroidNotificationSound('notification'),
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(0, title, body, platformChannelSpecifics, payload: jsonEncode(notificationBody.toJson()));
  }

  static Future<void> showBigTextNotification(String? title, String body, NotificationBodyModel notificationBody, FlutterLocalNotificationsPlugin fln) async {
    BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
      body, htmlFormatBigText: true,
      contentTitle: title, htmlFormatContentTitle: true,
    );
    AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      '6ammart', AppConstants.appName, importance: Importance.max,
      styleInformation: bigTextStyleInformation, priority: Priority.max, playSound: true,
      sound: const RawResourceAndroidNotificationSound('notification'),
    );
    NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(0, title, body, platformChannelSpecifics, payload: jsonEncode(notificationBody.toJson()));
  }

  static Future<void> showBigPictureNotificationHiddenLargeIcon(String? title, String? body, NotificationBodyModel notificationBody, String image, FlutterLocalNotificationsPlugin fln) async {
    final String largeIconPath = await _downloadAndSaveFile(image, 'largeIcon');
    final String bigPicturePath = await _downloadAndSaveFile(image, 'bigPicture');
    final BigPictureStyleInformation bigPictureStyleInformation = BigPictureStyleInformation(
      FilePathAndroidBitmap(bigPicturePath), hideExpandedLargeIcon: true,
      contentTitle: title, htmlFormatContentTitle: true,
      summaryText: body, htmlFormatSummaryText: true,
    );
    final AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      '6ammart', AppConstants.appName,
      largeIcon: FilePathAndroidBitmap(largeIconPath), priority: Priority.max, playSound: true,
      styleInformation: bigPictureStyleInformation, importance: Importance.max,
      sound: const RawResourceAndroidNotificationSound('notification'),
    );
    final NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(0, title, body, platformChannelSpecifics, payload: jsonEncode(notificationBody.toJson()));
  }

  static Future<String> _downloadAndSaveFile(String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  static NotificationBodyModel convertNotification(Map<String, dynamic> data) {
    final type = data['type'];

    switch (type) {
      case 'advertisement':
        return NotificationBodyModel(notificationType: NotificationType.advertisement, advertisementId: int.tryParse(data['advertisement_id']));
      case 'block':
        return NotificationBodyModel(notificationType: NotificationType.block);
      case 'unblock':
        return NotificationBodyModel(notificationType: NotificationType.unblock);
      case 'withdraw':
        return NotificationBodyModel(notificationType: NotificationType.withdraw);
      case 'product_approve':
        return NotificationBodyModel(notificationType: NotificationType.product_approve);
      case 'product_rejected':
      return NotificationBodyModel(notificationType: NotificationType.product_rejected);
      case 'campaign':
        return NotificationBodyModel(notificationType: NotificationType.campaign, campaignId: int.tryParse(data['data_id']));
      case 'subscription':
      return NotificationBodyModel(notificationType: NotificationType.subscription);
      case 'new_order':
      case 'New order placed':
      case 'order_status':
        return _handleOrderNotification(data);
      case 'message':
        return _handleMessageNotification(data);
      default:
        return NotificationBodyModel(notificationType: NotificationType.general);
    }
  }

  static NotificationBodyModel _handleOrderNotification(Map<String, dynamic> data) {
    final orderId = data['order_id'];
    return NotificationBodyModel(
      orderId: int.tryParse(orderId) ?? 0,
      notificationType: NotificationType.order,
    );
  }

  static NotificationBodyModel _handleMessageNotification(Map<String, dynamic> data) {
    final orderId = data['order_id'];
    final conversationId = data['conversation_id'];
    final senderType = data['sender_type'];

    return NotificationBodyModel(
      orderId: orderId != null && orderId.isNotEmpty ? int.tryParse(orderId) : null,
      conversationId: conversationId != null && conversationId.isNotEmpty ? int.tryParse(conversationId) : null,
      notificationType: NotificationType.message,
      type: senderType == AppConstants.deliveryMan ? AppConstants.deliveryMan : AppConstants.customer,
    );
  }

}

@pragma('vm:entry-point')
Future<dynamic> myBackgroundMessageHandler(RemoteMessage message) async {
  debugPrint("onBackground: ${message.data}");

  NotificationBodyModel notificationBody = NotificationHelper.convertNotification(message.data);

  if(notificationBody.notificationType == NotificationType.order) {
    FlutterForegroundTask.initCommunicationPort();

    _initService();

    await _startService(notificationBody.orderId.toString());
  } else {
    NotificationHelper.showNotification(message, flutterLocalNotificationsPlugin);
  }
}


@pragma('vm:entry-point')
Future<ServiceRequestResult> _startService(String? orderId) async {
  if (await FlutterForegroundTask.isRunningService) {
    return FlutterForegroundTask.restartService();

  } else {

    return FlutterForegroundTask.startService(
      serviceId: 256,
      notificationTitle: 'You got a new order ($orderId)',
      notificationText: 'Open app and check order details.',
      callback: startCallback,
      // notificationButtons: [
      //   const NotificationButton(id: '1', text: 'Open'),
      // ],
      // notificationInitialRoute: RouteHelper.getOrderDetailsRoute(int.parse(orderId!), fromNotification: true),
    );
  }
}

@pragma('vm:entry-point')
void _initService() {
  FlutterForegroundTask.init(
    androidNotificationOptions: AndroidNotificationOptions(
      channelId: 'stackfood',
      channelName: 'Foreground Service Notification',
      channelDescription: 'This notification appears when the foreground service is running.',
      onlyAlertOnce: false,
    ),
    iosNotificationOptions: const IOSNotificationOptions(
      showNotification: false,
      playSound: false,
    ),
    foregroundTaskOptions: ForegroundTaskOptions(
      eventAction: ForegroundTaskEventAction.repeat(5000),
      autoRunOnBoot: false,
      autoRunOnMyPackageReplaced: false,
      allowWakeLock: true,
      allowWifiLock: true,
    ),
  );
}

@pragma('vm:entry-point')
Future<ServiceRequestResult> stopService() async {
  try{
    _audioPlayer.dispose();

  }catch(e) {
    debugPrint('error-----$e');
  }
  return FlutterForegroundTask.stopService();
}

@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(MyTaskHandler());
}


final AudioPlayer _audioPlayer = AudioPlayer();

class MyTaskHandler extends TaskHandler {

  void _playAudio() {
    _audioPlayer.play(AssetSource('notification.mp3'));
  }

  // Called when the task is started.
  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    _playAudio();
  }

  // Called by eventAction in [ForegroundTaskOptions].
  // - nothing() : Not use onRepeatEvent callback.
  // - once() : Call onRepeatEvent only once.
  // - repeat(interval) : Call onRepeatEvent at milliseconds interval.
  @override
  void onRepeatEvent(DateTime timestamp) {
    _playAudio();
  }

  // Called when the task is destroyed.
  @override
  Future<void> onDestroy(DateTime timestamp, bool isTaskRemoved) async {
    stopService();
  }

  // Called when data is sent using [FlutterForegroundTask.sendDataToTask].
  @override
  void onReceiveData(Object data) {
    _playAudio();
  }

  // Called when the notification button is pressed.
  @override
  void onNotificationButtonPressed(String id) {
    debugPrint('onNotificationButtonPressed: $id');
    if (id == '1') {
      FlutterForegroundTask.launchApp('/');
    }
    stopService();
  }

  // Called when the notification itself is pressed.
  //
  // AOS: "android.permission.SYSTEM_ALERT_WINDOW" permission must be granted
  // for this function to be called.
  @override
  void onNotificationPressed() {
    debugPrint('onNotificationPressed');

    FlutterForegroundTask.launchApp('/');
    stopService();
  }

  // Called when the notification itself is dismissed.
  //
  // AOS: only work Android 14+
  // iOS: only work iOS 10+
  @override
  void onNotificationDismissed() {
    FlutterForegroundTask.updateService(
      notificationTitle: 'You got a new order!',
      notificationText: 'Open app and check order details.',
    );
  }
}