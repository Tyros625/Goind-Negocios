import 'dart:convert';
import 'package:sixam_mart_store/common/controllers/theme_controller.dart';
import 'package:sixam_mart_store/api/api_client.dart';
import 'package:sixam_mart_store/features/addon/controllers/addon_controller.dart';
import 'package:sixam_mart_store/features/addon/domain/repositories/addon_repository.dart';
import 'package:sixam_mart_store/features/addon/domain/repositories/addon_repository_interface.dart';
import 'package:sixam_mart_store/features/addon/domain/services/addon_service.dart';
import 'package:sixam_mart_store/features/addon/domain/services/addon_service_interface.dart';
import 'package:sixam_mart_store/features/address/controllers/address_controller.dart';
import 'package:sixam_mart_store/features/address/domain/repositories/address_repository.dart';
import 'package:sixam_mart_store/features/address/domain/repositories/address_repository_interface.dart';
import 'package:sixam_mart_store/features/address/domain/services/address_service.dart';
import 'package:sixam_mart_store/features/address/domain/services/address_service_interface.dart';
import 'package:sixam_mart_store/features/advertisement/controllers/advertisement_controller.dart';
import 'package:sixam_mart_store/features/advertisement/domain/repositories/advertisement_repository.dart';
import 'package:sixam_mart_store/features/advertisement/domain/repositories/advertisement_repository_interface.dart';
import 'package:sixam_mart_store/features/advertisement/domain/services/advertisement_service.dart';
import 'package:sixam_mart_store/features/advertisement/domain/services/advertisement_service_interface.dart';
import 'package:sixam_mart_store/features/auth/controllers/auth_controller.dart';
import 'package:sixam_mart_store/features/auth/domain/repositories/auth_repository.dart';
import 'package:sixam_mart_store/features/auth/domain/repositories/auth_repository_interface.dart';
import 'package:sixam_mart_store/features/auth/domain/services/auth_service.dart';
import 'package:sixam_mart_store/features/auth/domain/services/auth_service_interface.dart';
import 'package:sixam_mart_store/features/banner/controllers/banner_controller.dart';
import 'package:sixam_mart_store/features/banner/domain/repositories/banner_repository.dart';
import 'package:sixam_mart_store/features/banner/domain/repositories/banner_repository_interface.dart';
import 'package:sixam_mart_store/features/banner/domain/services/banner_service.dart';
import 'package:sixam_mart_store/features/banner/domain/services/banner_service_interface.dart';
import 'package:sixam_mart_store/features/business/controllers/business_controller.dart';
import 'package:sixam_mart_store/features/business/domain/repositories/business_repo.dart';
import 'package:sixam_mart_store/features/business/domain/repositories/business_repo_interface.dart';
import 'package:sixam_mart_store/features/business/domain/services/business_service.dart';
import 'package:sixam_mart_store/features/business/domain/services/business_service_interface.dart';
import 'package:sixam_mart_store/features/campaign/controllers/campaign_controller.dart';
import 'package:sixam_mart_store/features/campaign/domain/repositories/campaign_repository.dart';
import 'package:sixam_mart_store/features/campaign/domain/repositories/campaign_repository_interface.dart';
import 'package:sixam_mart_store/features/campaign/domain/services/campaign_service.dart';
import 'package:sixam_mart_store/features/campaign/domain/services/campaign_service_interface.dart';
import 'package:sixam_mart_store/features/category/controllers/category_controller.dart';
import 'package:sixam_mart_store/features/category/domain/repositories/category_repository.dart';
import 'package:sixam_mart_store/features/category/domain/repositories/category_repository_interface.dart';
import 'package:sixam_mart_store/features/category/domain/services/category_service.dart';
import 'package:sixam_mart_store/features/category/domain/services/category_service_interface.dart';
import 'package:sixam_mart_store/features/chat/controllers/chat_controller.dart';
import 'package:sixam_mart_store/features/chat/domain/repositories/chat_repository.dart';
import 'package:sixam_mart_store/features/chat/domain/repositories/chat_repository_interface.dart';
import 'package:sixam_mart_store/features/chat/domain/services/chat_service.dart';
import 'package:sixam_mart_store/features/chat/domain/services/chat_service_interface.dart';
import 'package:sixam_mart_store/features/coupon/controllers/coupon_controller.dart';
import 'package:sixam_mart_store/features/coupon/domain/repositories/coupon_repository.dart';
import 'package:sixam_mart_store/features/coupon/domain/repositories/coupon_repository_interface.dart';
import 'package:sixam_mart_store/features/coupon/domain/services/coupon_service.dart';
import 'package:sixam_mart_store/features/coupon/domain/services/coupon_service_interface.dart';
import 'package:sixam_mart_store/features/deliveryman/controllers/deliveryman_controller.dart';
import 'package:sixam_mart_store/features/deliveryman/domain/repositories/deliveryman_repository.dart';
import 'package:sixam_mart_store/features/deliveryman/domain/repositories/deliveryman_repository_interface.dart';
import 'package:sixam_mart_store/features/deliveryman/domain/services/deliveryman_service.dart';
import 'package:sixam_mart_store/features/deliveryman/domain/services/deliveryman_service_interface.dart';
import 'package:sixam_mart_store/features/disbursement/controllers/disbursement_controller.dart';
import 'package:sixam_mart_store/features/disbursement/domain/repositories/disbursement_repository.dart';
import 'package:sixam_mart_store/features/disbursement/domain/repositories/disbursement_repository_interface.dart';
import 'package:sixam_mart_store/features/disbursement/domain/services/disbursement_service.dart';
import 'package:sixam_mart_store/features/disbursement/domain/services/disbursement_service_interface.dart';
import 'package:sixam_mart_store/features/forgot_password/controllers/forgot_password_controller.dart';
import 'package:sixam_mart_store/features/forgot_password/domain/repositories/forgot_password_repository.dart';
import 'package:sixam_mart_store/features/forgot_password/domain/repositories/forgot_password_repository_interface.dart';
import 'package:sixam_mart_store/features/forgot_password/domain/services/forgot_password_service.dart';
import 'package:sixam_mart_store/features/forgot_password/domain/services/forgot_password_service_interface.dart';
import 'package:sixam_mart_store/features/html/controllers/html_controller.dart';
import 'package:sixam_mart_store/features/html/domain/repositories/html_repository.dart';
import 'package:sixam_mart_store/features/html/domain/repositories/html_repository_interface.dart';
import 'package:sixam_mart_store/features/html/domain/services/html_service.dart';
import 'package:sixam_mart_store/features/html/domain/services/html_service_interface.dart';
import 'package:sixam_mart_store/features/language/controllers/language_controller.dart';
import 'package:sixam_mart_store/features/language/domain/repositories/language_repository.dart';
import 'package:sixam_mart_store/features/language/domain/repositories/language_repository_interface.dart';
import 'package:sixam_mart_store/features/language/domain/services/language_service.dart';
import 'package:sixam_mart_store/features/language/domain/services/language_service_interface.dart';
import 'package:sixam_mart_store/features/notification/controllers/notification_controller.dart';
import 'package:sixam_mart_store/features/notification/domain/repositories/notification_repository.dart';
import 'package:sixam_mart_store/features/notification/domain/repositories/notification_repository_interface.dart';
import 'package:sixam_mart_store/features/notification/domain/services/notification_service.dart';
import 'package:sixam_mart_store/features/notification/domain/services/notification_service_interface.dart';
import 'package:sixam_mart_store/features/order/controllers/order_controller.dart';
import 'package:sixam_mart_store/features/order/domain/repositories/order_repository.dart';
import 'package:sixam_mart_store/features/order/domain/repositories/order_repository_interface.dart';
import 'package:sixam_mart_store/features/order/domain/services/order_service.dart';
import 'package:sixam_mart_store/features/order/domain/services/order_service_interface.dart';
import 'package:sixam_mart_store/features/payment/controllers/payment_controller.dart';
import 'package:sixam_mart_store/features/payment/domain/repositories/payment_repository.dart';
import 'package:sixam_mart_store/features/payment/domain/repositories/payment_repository_interface.dart';
import 'package:sixam_mart_store/features/payment/domain/services/payment_service.dart';
import 'package:sixam_mart_store/features/payment/domain/services/payment_service_interface.dart';
import 'package:sixam_mart_store/features/pos/controllers/pos_controller.dart';
import 'package:sixam_mart_store/features/pos/domain/repositories/pos_repository.dart';
import 'package:sixam_mart_store/features/pos/domain/repositories/pos_repository_interface.dart';
import 'package:sixam_mart_store/features/pos/domain/services/pos_service.dart';
import 'package:sixam_mart_store/features/pos/domain/services/pos_service_interface.dart';
import 'package:sixam_mart_store/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart_store/features/profile/domain/repositories/profile_repository.dart';
import 'package:sixam_mart_store/features/profile/domain/repositories/profile_repository_interface.dart';
import 'package:sixam_mart_store/features/profile/domain/services/profile_service.dart';
import 'package:sixam_mart_store/features/profile/domain/services/profile_service_interface.dart';
import 'package:sixam_mart_store/features/rental_module/reports/controllers/taxi_report_controller.dart';
import 'package:sixam_mart_store/features/rental_module/reports/domain/repositories/taxi_report_repository.dart';
import 'package:sixam_mart_store/features/rental_module/reports/domain/repositories/taxi_report_repository_interface.dart';
import 'package:sixam_mart_store/features/rental_module/reports/domain/services/taxi_report_service.dart';
import 'package:sixam_mart_store/features/rental_module/reports/domain/services/taxi_report_service_interface.dart';
import 'package:sixam_mart_store/features/reports/controllers/report_controller.dart';
import 'package:sixam_mart_store/features/reports/domain/repositories/report_repository.dart';
import 'package:sixam_mart_store/features/reports/domain/repositories/report_repository_interface.dart';
import 'package:sixam_mart_store/features/reports/domain/services/report_service.dart';
import 'package:sixam_mart_store/features/reports/domain/services/report_service_interface.dart';
import 'package:sixam_mart_store/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart_store/features/splash/domain/repositories/splash_repository.dart';
import 'package:sixam_mart_store/features/splash/domain/repositories/splash_repository_interface.dart';
import 'package:sixam_mart_store/features/splash/domain/services/splash_service.dart';
import 'package:sixam_mart_store/features/splash/domain/services/splash_service_interface.dart';
import 'package:sixam_mart_store/features/store/controllers/store_controller.dart';
import 'package:sixam_mart_store/features/store/domain/repositories/store_repository.dart';
import 'package:sixam_mart_store/features/store/domain/repositories/store_repository_interface.dart';
import 'package:sixam_mart_store/features/store/domain/services/store_service.dart';
import 'package:sixam_mart_store/features/store/domain/services/store_service_interface.dart';
import 'package:sixam_mart_store/features/subscription/controllers/subscription_controller.dart';
import 'package:sixam_mart_store/features/subscription/domain/repositories/subscription_repository.dart';
import 'package:sixam_mart_store/features/subscription/domain/repositories/subscription_repository_interface.dart';
import 'package:sixam_mart_store/features/subscription/domain/services/subscription_service.dart';
import 'package:sixam_mart_store/features/subscription/domain/services/subscription_service_interface.dart';
import 'package:sixam_mart_store/features/rental_module/banner/controllers/taxi_banner_controller.dart';
import 'package:sixam_mart_store/features/rental_module/banner/domain/repositories/taxi_banner_repository.dart';
import 'package:sixam_mart_store/features/rental_module/banner/domain/repositories/taxi_banner_repository_interface.dart';
import 'package:sixam_mart_store/features/rental_module/banner/domain/services/taxi_banner_service.dart';
import 'package:sixam_mart_store/features/rental_module/banner/domain/services/taxi_banner_service_interface.dart';
import 'package:sixam_mart_store/features/rental_module/chat/controllers/taxi_chat_controller.dart';
import 'package:sixam_mart_store/features/rental_module/chat/domain/repositories/taxi_chat_repository.dart';
import 'package:sixam_mart_store/features/rental_module/chat/domain/repositories/taxi_chat_repository_interface.dart';
import 'package:sixam_mart_store/features/rental_module/chat/domain/services/taxi_chat_service.dart';
import 'package:sixam_mart_store/features/rental_module/chat/domain/services/taxi_chat_service_interface.dart';
import 'package:sixam_mart_store/features/rental_module/coupon/controllers/taxi_coupon_controller.dart';
import 'package:sixam_mart_store/features/rental_module/coupon/domain/repositories/taxi_coupon_repository.dart';
import 'package:sixam_mart_store/features/rental_module/coupon/domain/repositories/taxi_coupon_repository_interface.dart';
import 'package:sixam_mart_store/features/rental_module/coupon/domain/services/taxi_coupon_service.dart';
import 'package:sixam_mart_store/features/rental_module/coupon/domain/services/taxi_coupon_service_interface.dart';
import 'package:sixam_mart_store/features/rental_module/driver/controllers/driver_controller.dart';
import 'package:sixam_mart_store/features/rental_module/driver/domain/repositories/driver_repository.dart';
import 'package:sixam_mart_store/features/rental_module/driver/domain/repositories/driver_repository_interface.dart';
import 'package:sixam_mart_store/features/rental_module/driver/domain/services/driver_service.dart';
import 'package:sixam_mart_store/features/rental_module/driver/domain/services/driver_service_interface.dart';
import 'package:sixam_mart_store/features/rental_module/profile/controllers/taxi_profile_controller.dart';
import 'package:sixam_mart_store/features/rental_module/profile/domain/repositories/taxi_profile_repository.dart';
import 'package:sixam_mart_store/features/rental_module/profile/domain/repositories/taxi_profile_repository_interface.dart';
import 'package:sixam_mart_store/features/rental_module/profile/domain/services/taxi_profile_service.dart';
import 'package:sixam_mart_store/features/rental_module/profile/domain/services/taxi_profile_service_interface.dart';
import 'package:sixam_mart_store/features/rental_module/provider/controllers/provider_controller.dart';
import 'package:sixam_mart_store/features/rental_module/provider/domain/repositories/provider_repository.dart';
import 'package:sixam_mart_store/features/rental_module/provider/domain/repositories/provider_repository_interface.dart';
import 'package:sixam_mart_store/features/rental_module/provider/domain/services/provider_service.dart';
import 'package:sixam_mart_store/features/rental_module/provider/domain/services/provider_service_interface.dart';
import 'package:sixam_mart_store/features/rental_module/trips/controllers/trip_controller.dart';
import 'package:sixam_mart_store/features/rental_module/trips/domain/repositories/trip_repository.dart';
import 'package:sixam_mart_store/features/rental_module/trips/domain/repositories/trip_repository_interface.dart';
import 'package:sixam_mart_store/features/rental_module/trips/domain/services/trip_service.dart';
import 'package:sixam_mart_store/features/rental_module/trips/domain/services/trip_service_interface.dart';
import 'package:sixam_mart_store/util/app_constants.dart';
import 'package:sixam_mart_store/features/language/domain/models/language_model.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

Future<Map<String, Map<String, String>>> init() async {

  /// Core
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut(() => sharedPreferences);
  Get.lazyPut(() => ApiClient(appBaseUrl: AppConstants.baseUrl, sharedPreferences: Get.find()));

  ///Repository Interface
  AuthRepositoryInterface authRepositoryInterface = AuthRepository(apiClient: Get.find(), sharedPreferences: Get.find());
  Get.lazyPut(() => authRepositoryInterface);

  BusinessRepoInterface businessRepoInterface = BusinessRepo(apiClient: Get.find());
  Get.lazyPut(() => businessRepoInterface);

  AddonRepositoryInterface addonRepositoryInterface = AddonRepository(apiClient: Get.find());
  Get.lazyPut(() => addonRepositoryInterface);

  BannerRepositoryInterface bannerRepositoryInterface = BannerRepository(apiClient: Get.find());
  Get.lazyPut(() => bannerRepositoryInterface);

  CampaignRepositoryInterface campaignRepositoryInterface = CampaignRepository(apiClient: Get.find());
  Get.lazyPut(() => campaignRepositoryInterface);

  CategoryRepositoryInterface categoryRepositoryInterface = CategoryRepository(apiClient: Get.find());
  Get.lazyPut(() => categoryRepositoryInterface);

  SplashRepositoryInterface splashRepositoryInterface = SplashRepository(sharedPreferences: Get.find(), apiClient: Get.find());
  Get.lazyPut(() => splashRepositoryInterface);

  HtmlRepositoryInterface htmlRepositoryInterface = HtmlRepository(apiClient: Get.find());
  Get.lazyPut(() => htmlRepositoryInterface);

  ReportRepositoryInterface reportRepositoryInterface = ReportRepository(apiClient: Get.find());
  Get.lazyPut(() => reportRepositoryInterface);

  CouponRepositoryInterface couponRepositoryInterface = CouponRepository(apiClient: Get.find());
  Get.lazyPut(() => couponRepositoryInterface);

  DeliverymanRepositoryInterface deliverymanRepositoryInterface = DeliverymanRepository(apiClient: Get.find());
  Get.lazyPut(() => deliverymanRepositoryInterface);

  DisbursementRepositoryInterface disbursementRepositoryInterface = DisbursementRepository(apiClient: Get.find());
  Get.lazyPut(() => disbursementRepositoryInterface);

  ForgotPasswordRepositoryInterface forgotPasswordRepositoryInterface = ForgotPasswordRepository(apiClient: Get.find(), sharedPreferences: Get.find());
  Get.lazyPut(() => forgotPasswordRepositoryInterface);

  LanguageRepositoryInterface languageRepositoryInterface = LanguageRepository(apiClient: Get.find(), sharedPreferences: Get.find());
  Get.lazyPut(() => languageRepositoryInterface);

  NotificationRepositoryInterface notificationRepositoryInterface = NotificationRepository(apiClient: Get.find(), sharedPreferences: Get.find());
  Get.lazyPut(() => notificationRepositoryInterface);

  PaymentRepositoryInterface paymentRepositoryInterface = PaymentRepository(apiClient: Get.find(), sharedPreferences: Get.find());
  Get.lazyPut(() => paymentRepositoryInterface);

  ProfileRepositoryInterface profileRepositoryInterface = ProfileRepository(apiClient: Get.find(), sharedPreferences: Get.find());
  Get.lazyPut(() => profileRepositoryInterface);

  AddressRepositoryInterface addressRepositoryInterface = AddressRepository(apiClient: Get.find(), sharedPreferences: Get.find());
  Get.lazyPut(() => addressRepositoryInterface);

  ChatRepositoryInterface chatRepositoryInterface = ChatRepository(apiClient: Get.find(), sharedPreferences: Get.find());
  Get.lazyPut(() => chatRepositoryInterface);

  OrderRepositoryInterface orderRepositoryInterface = OrderRepository(apiClient: Get.find(), sharedPreferences: Get.find());
  Get.lazyPut(() => orderRepositoryInterface);

  StoreRepositoryInterface storeRepositoryInterface = StoreRepository(apiClient: Get.find());
  Get.lazyPut(() => storeRepositoryInterface);

  PosRepositoryInterface posRepositoryInterface = PosRepository(apiClient: Get.find());
  Get.lazyPut(() => posRepositoryInterface);

  SubscriptionRepositoryInterface subscriptionRepositoryInterface = SubscriptionRepository(apiClient: Get.find());
  Get.lazyPut(() => subscriptionRepositoryInterface);

  AdvertisementRepositoryInterface advertisementRepositoryInterface = AdvertisementRepository(apiClient: Get.find());
  Get.lazyPut(() => advertisementRepositoryInterface);

  ///Taxi module Repositories
  ProviderRepositoryInterface providerRepositoryInterface = ProviderRepository(apiClient: Get.find());
  Get.lazyPut(() => providerRepositoryInterface);

  TaxiBannerRepositoryInterface taxiBannerRepositoryInterface = TaxiBannerRepository(apiClient: Get.find());
  Get.lazyPut(() => taxiBannerRepositoryInterface);

  TaxiCouponRepositoryInterface taxiCouponRepositoryInterface = TaxiCouponRepository(apiClient: Get.find());
  Get.lazyPut(() => taxiCouponRepositoryInterface);

  TaxiProfileRepositoryInterface taxiProfileRepositoryInterface = TaxiProfileRepository(apiClient: Get.find(), sharedPreferences: Get.find());
  Get.lazyPut(() => taxiProfileRepositoryInterface);

  DriverRepositoryInterface driverRepositoryInterface = DriverRepository(apiClient: Get.find());
  Get.lazyPut(() => driverRepositoryInterface);

  TripRepositoryInterface tripRepositoryInterface = TripRepository(apiClient: Get.find());
  Get.lazyPut(() => tripRepositoryInterface);

  TaxiChatRepositoryInterface taxiChatRepositoryInterface = TaxiChatRepository(apiClient: Get.find(), sharedPreferences: Get.find());
  Get.lazyPut(() => taxiChatRepositoryInterface);

  TaxiReportRepositoryInterface taxiReportRepositoryInterface  = TaxiReportRepository(apiClient: Get.find());
  Get.lazyPut(() => taxiReportRepositoryInterface);

  /// Service Interface
  AuthServiceInterface authServiceInterface = AuthService(authRepositoryInterface: Get.find());
  Get.lazyPut(() => authServiceInterface);

  BusinessServiceInterface businessServiceInterface = BusinessService(businessRepoInterface: Get.find());
  Get.lazyPut(() => businessServiceInterface);

  AddonServiceInterface addonServiceInterface = AddonService(addonRepositoryInterface: Get.find());
  Get.lazyPut(() => addonServiceInterface);

  BannerServiceInterface bannerServiceInterface = BannerService(bannerRepositoryInterface: Get.find());
  Get.lazyPut(() => bannerServiceInterface);

  CampaignServiceInterface campaignServiceInterface = CampaignService(campaignRepositoryInterface: Get.find());
  Get.lazyPut(() => campaignServiceInterface);

  CategoryServiceInterface categoryServiceInterface = CategoryService(categoryRepositoryInterface: Get.find());
  Get.lazyPut(() => categoryServiceInterface);

  SplashServiceInterface splashServiceInterface = SplashService(splashRepositoryInterface: Get.find());
  Get.lazyPut(() => splashServiceInterface);

  HtmlServiceInterface htmlServiceInterface = HtmlService(htmlRepositoryInterface: Get.find());
  Get.lazyPut(() => htmlServiceInterface);

  ReportServiceInterface reportServiceInterface = ReportService(reportRepositoryInterface: Get.find());
  Get.lazyPut(() => reportServiceInterface);

  CouponServiceInterface couponServiceInterface = CouponService(couponRepositoryInterface: Get.find());
  Get.lazyPut(() => couponServiceInterface);

  DeliverymanServiceInterface deliverymanServiceInterface = DeliverymanService(deliverymanRepositoryInterface: Get.find());
  Get.lazyPut(() => deliverymanServiceInterface);

  DisbursementServiceInterface disbursementServiceInterface = DisbursementService(disbursementRepositoryInterface: Get.find());
  Get.lazyPut(() => disbursementServiceInterface);

  ForgotPasswordServiceInterface forgotPasswordServiceInterface = ForgotPasswordService(forgotPasswordRepositoryInterface: Get.find());
  Get.lazyPut(() => forgotPasswordServiceInterface);

  LanguageServiceInterface languageServiceInterface = LanguageService(languageRepositoryInterface: Get.find());
  Get.lazyPut(() => languageServiceInterface);

  NotificationServiceInterface notificationServiceInterface = NotificationService(notificationRepositoryInterface: Get.find());
  Get.lazyPut(() => notificationServiceInterface);

  PaymentServiceInterface paymentServiceInterface = PaymentService(paymentRepositoryInterface: Get.find());
  Get.lazyPut(() => paymentServiceInterface);

  ProfileServiceInterface profileServiceInterface = ProfileService(profileRepositoryInterface: Get.find());
  Get.lazyPut(() => profileServiceInterface);

  AddressServiceInterface addressServiceInterface = AddressService(addressRepositoryInterface: Get.find());
  Get.lazyPut(() => addressServiceInterface);

  ChatServiceInterface chatServiceInterface = ChatService(chatRepositoryInterface: Get.find());
  Get.lazyPut(() => chatServiceInterface);

  OrderServiceInterface orderServiceInterface = OrderService(orderRepositoryInterface: Get.find());
  Get.lazyPut(() => orderServiceInterface);

  StoreServiceInterface storeServiceInterface = StoreService(storeRepositoryInterface: Get.find());
  Get.lazyPut(() => storeServiceInterface);

  PosServiceInterface posServiceInterface = PosService(posRepositoryInterface: Get.find());
  Get.lazyPut(() => posServiceInterface);

  SubscriptionServiceInterface subscriptionServiceInterface = SubscriptionService(subscriptionRepositoryInterface: Get.find());
  Get.lazyPut(() => subscriptionServiceInterface);

  AdvertisementServiceInterface advertisementServiceInterface = AdvertisementService(advertisementRepositoryInterface: Get.find());
  Get.lazyPut(() => advertisementServiceInterface);

  ///Taxi module Services
  ProviderServiceInterface providerServiceInterface = ProviderService(providerRepositoryInterface: Get.find());
  Get.lazyPut(() => providerServiceInterface);

  TaxiBannerServiceInterface taxiBannerServiceInterface = TaxiBannerService(taxiBannerRepositoryInterface: Get.find());
  Get.lazyPut(() => taxiBannerServiceInterface);

  TaxiCouponServiceInterface taxiCouponServiceInterface = TaxiCouponService(taxiCouponRepositoryInterface:  Get.find());
  Get.lazyPut(() => taxiCouponServiceInterface);

  TaxiProfileServiceInterface taxiProfileServiceInterface = TaxiProfileService(taxiProfileRepositoryInterface: Get.find());
  Get.lazyPut(() => taxiProfileServiceInterface);

  DriverServiceInterface driverServiceInterface = DriverService(driverRepositoryInterface: Get.find());
  Get.lazyPut(() => driverServiceInterface);

  TripServiceInterface tripServiceInterface = TripService(tripRepositoryInterface: Get.find());
  Get.lazyPut(() => tripServiceInterface);

  TaxiChatServiceInterface taxiChatServiceInterface = TaxiChatService(chatRepositoryInterface: Get.find());
  Get.lazyPut(() => taxiChatServiceInterface);

  TaxiReportServiceInterface taxiReportServiceInterface = TaxiReportService(reportRepositoryInterface: Get.find());
  Get.lazyPut(() => taxiReportServiceInterface);

  /// Controller
  Get.lazyPut(() => AuthController(authServiceInterface: Get.find()));
  Get.lazyPut(() => BusinessController(businessServiceInterface: Get.find()));
  Get.lazyPut(() => AddonController(addonServiceInterface: Get.find()));
  Get.lazyPut(() => BannerController(bannerServiceInterface: Get.find()));
  Get.lazyPut(() => CampaignController(campaignServiceInterface: Get.find()));
  Get.lazyPut(() => CategoryController(categoryServiceInterface: Get.find()));
  Get.lazyPut(() => SplashController(splashServiceInterface: Get.find()));
  Get.lazyPut(() => HtmlController(htmlServiceInterface: Get.find()));
  Get.lazyPut(() => ReportController(reportServiceInterface: Get.find()));
  Get.lazyPut(() => CouponController(couponServiceInterface: Get.find()));
  Get.lazyPut(() => DeliveryManController(deliverymanServiceInterface: Get.find()));
  Get.lazyPut(() => DisbursementController(disbursementServiceInterface: Get.find()));
  Get.lazyPut(() => ForgotPasswordController(forgotPasswordServiceInterface: Get.find()));
  Get.lazyPut(() => LocalizationController(languageServiceInterface: Get.find()));
  Get.lazyPut(() => NotificationController(notificationServiceInterface: Get.find()));
  Get.lazyPut(() => PaymentController(paymentServiceInterface: Get.find()));
  Get.lazyPut(() => ProfileController(profileServiceInterface: Get.find()));
  Get.lazyPut(() => AddressController(addressServiceInterface: Get.find()));
  Get.lazyPut(() => ThemeController(sharedPreferences: Get.find()));
  Get.lazyPut(() => ChatController(chatServiceInterface: Get.find()));
  Get.lazyPut(() => OrderController(orderServiceInterface: Get.find()));
  Get.lazyPut(() => StoreController(storeServiceInterface: Get.find()));
  Get.lazyPut(() => PosController(posServiceInterface: Get.find()));
  Get.lazyPut(() => SubscriptionController(subscriptionServiceInterface: Get.find()));
  Get.lazyPut(() => AdvertisementController(advertisementServiceInterface: Get.find()));

  ///Taxi module Controllers
  Get.lazyPut(() => ProviderController(providerServiceInterface: Get.find()));
  Get.lazyPut(() => TaxiBannerController(taxiBannerServiceInterface: Get.find()));
  Get.lazyPut(() => TaxiCouponController(taxiCouponServiceInterface: Get.find()));
  Get.lazyPut(() => TaxiProfileController(taxiProfileServiceInterface: Get.find()));
  Get.lazyPut(() => DriverController(driverServiceInterface: Get.find()));
  Get.lazyPut(() => TripController(tripServiceInterface: Get.find()));
  Get.lazyPut(() => TaxiChatController(chatServiceInterface: Get.find()));
  Get.lazyPut(() => TaxiReportController(reportServiceInterface: Get.find()));

  /// Retrieving localized data
  Map<String, Map<String, String>> languages = {};
  for(LanguageModel languageModel in AppConstants.languages) {
    String jsonStringValues =  await rootBundle.loadString('assets/language/${languageModel.languageCode}.json');
    Map<String, dynamic> mappedJson = jsonDecode(jsonStringValues);
    Map<String, String> json = {};
    mappedJson.forEach((key, value) {
      json[key] = value.toString();
    });
    languages['${languageModel.languageCode}_${languageModel.countryCode}'] = json;
  }
  return languages;
}