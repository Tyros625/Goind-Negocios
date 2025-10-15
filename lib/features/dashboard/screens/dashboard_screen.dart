import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:sixam_mart_store/features/auth/controllers/auth_controller.dart';
import 'package:sixam_mart_store/features/dashboard/widgets/out_of_stock_warning_bottom_sheet.dart';
import 'package:sixam_mart_store/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart_store/features/subscription/controllers/subscription_controller.dart';
import 'package:sixam_mart_store/features/disbursement/helper/disbursement_helper.dart';
import 'package:sixam_mart_store/features/rental_module/home/screens/taxi_home_screen.dart';
import 'package:sixam_mart_store/features/rental_module/menu/screens/taxi_menu_screen.dart';
import 'package:sixam_mart_store/features/rental_module/provider/screens/provider_screen.dart';
import 'package:sixam_mart_store/features/rental_module/trips/screens/trip_history_screen.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/features/payment/screens/wallet_screen.dart';
import 'package:sixam_mart_store/features/dashboard/widgets/bottom_nav_item_widget.dart';
import 'package:sixam_mart_store/features/home/screens/home_screen.dart';
import 'package:sixam_mart_store/features/menu/screens/menu_screen.dart';
import 'package:sixam_mart_store/features/order/screens/order_history_screen.dart';
import 'package:sixam_mart_store/features/store/screens/store_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class DashboardScreen extends StatefulWidget {
  final int pageIndex;
  const DashboardScreen({super.key, required this.pageIndex});

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  PageController? _pageController;
  int _pageIndex = 0;
  late List<Widget> _screens;
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
  DisbursementHelper disbursementHelper = DisbursementHelper();
  bool _canExit = false;

  @override
  void initState() {
    super.initState();
    AuthController authController = Get.find<AuthController>();

    _pageIndex = widget.pageIndex;
    _pageController = PageController(initialPage: widget.pageIndex);

    _screens = [
      authController.getModuleType() == 'rental' ? const TaxiHomeScreen() : const HomeScreen(),
      authController.getModuleType() == 'rental' ? const TripHistoryScreen() : const OrderHistoryScreen(),
      authController.getModuleType() == 'rental' ? const ProviderScreen() : const StoreScreen(),
      const WalletScreen(),
      Container(),
    ];

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {});
    });

    showDisbursementWarningMessage();

    if(Get.find<SubscriptionController>().isTrialEndModalShown){
      Get.find<SubscriptionController>().trialEndBottomSheet();
    }

    outOfStockBottomSheet();

  }

  showDisbursementWarningMessage() async{
    disbursementHelper.enableDisbursementWarningMessage(true);
  }

  Future<void> outOfStockBottomSheet() async {
    Future.delayed(const Duration(seconds: 1), () {
      if(Get.find<ProfileController>().profileModel != null && Get.find<ProfileController>().profileModel!.outOfStockCount! > 0 && Get.find<ProfileController>().showLowStockWarning) {
        showModalBottomSheet(
          context: Get.context!, isScrollControlled: true, backgroundColor: Colors.transparent,
          builder: (con) => const OutOfStockWarningBottomSheet(),
        ).then((v) {
          Get.find<ProfileController>().hideLowStockWarning();
        });
      }
    });
  }



  @override
  Widget build(BuildContext context) {

    bool keyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async{
        if(_pageIndex != 0) {
          _setPage(0);
        }else {
          if(_canExit) {
            if (GetPlatform.isAndroid) {
              SystemNavigator.pop();
            } else if (GetPlatform.isIOS) {
              exit(0);
            }
          }
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('back_press_again_to_exit'.tr, style: const TextStyle(color: Colors.white)),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
            margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          ));
          _canExit = true;

          Timer(const Duration(seconds: 2), () {
            _canExit = false;
          });
        }
      },
      child: SafeArea(
        top: false,
        child: Scaffold(

          floatingActionButton: !GetPlatform.isMobile || keyboardVisible ? null : Container(
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).cardColor, width: 5),
              shape: BoxShape.circle,
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)],
            ),
            child: FloatingActionButton(
              backgroundColor:Theme.of(context).primaryColor,
              onPressed: () {
                _setPage(2);
              },
              child: Image.asset(
                Get.find<AuthController>().getModuleType() == 'rental' ? Images.taxiHome : Images.restaurant,
                height: 20, width: 20,
                color: Theme.of(context).cardColor,
              ),
            ),
          ),
          floatingActionButtonLocation: !GetPlatform.isMobile ? null : FloatingActionButtonLocation.centerDocked,

          bottomNavigationBar: !GetPlatform.isMobile ? const SizedBox() : Container(
            height: 65,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusLarge)),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)],
            ),
            child: Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
              child: Row(children: [
                BottomNavItemWidget(
                  title: 'home'.tr,
                  selectedIcon: Images.homeSelect,
                  unSelectedIcon: Images.homeUnselect,
                  isSelected: _pageIndex == 0,
                  onTap: () => _setPage(0),
                ),
                BottomNavItemWidget(
                  title: Get.find<AuthController>().getModuleType() == 'rental' ? 'trips'.tr : 'orders'.tr,
                  selectedIcon: Images.orderSelect,
                  unSelectedIcon: Images.orderUnselect,
                  isSelected: _pageIndex == 1,
                  onTap: () => _setPage(1),
                ),
                const Expanded(child: SizedBox()),
                BottomNavItemWidget(
                  title: 'wallet'.tr,
                  selectedIcon: Images.walletSelect,
                  unSelectedIcon: Images.walletUnSelect,
                  isSelected: _pageIndex == 3,
                  onTap: () => _setPage(3),
                ),
                BottomNavItemWidget(
                  title: 'menu'.tr,
                  selectedIcon: Images.menu,
                  unSelectedIcon: Images.menu,
                  isSelected: _pageIndex == 4,
                  onTap: () {
                    Get.bottomSheet(Get.find<AuthController>().getModuleType() == 'rental' ? const TaxiMenuScreen() : const MenuScreen(), backgroundColor: Colors.transparent, isScrollControlled: true);
                  }
                ),
              ]),
            ),
          ),
          body: PageView.builder(
            controller: _pageController,
            itemCount: _screens.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return _screens[index];
            },
          ),
        ),
      ),
    );
  }

  void _setPage(int pageIndex) {
    if (!Get.find<SubscriptionController>().isTrialEndModalShown) {
      Get.find<SubscriptionController>().trialEndBottomSheet().then((trialEnd) {
        if (trialEnd) {
          setState(() {
            _pageController!.jumpToPage(pageIndex);
            _pageIndex = pageIndex;
          });
        } else {
          Get.find<SubscriptionController>().setTrialEndModalShown(true);
        }
      });
    }
  }
}
