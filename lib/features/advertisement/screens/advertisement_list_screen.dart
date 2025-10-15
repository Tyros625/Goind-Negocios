import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/common/widgets/custom_app_bar_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_bottom_sheet_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_loader_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:sixam_mart_store/features/advertisement/controllers/advertisement_controller.dart';
import 'package:sixam_mart_store/features/advertisement/models/ads_details_model.dart';
import 'package:sixam_mart_store/features/advertisement/models/advertisement_model.dart';
import 'package:sixam_mart_store/features/advertisement/models/popup_menu_model.dart';
import 'package:sixam_mart_store/features/advertisement/screens/create_advertisement_screen.dart';
import 'package:sixam_mart_store/features/advertisement/widgets/confirmation_bottom_sheet.dart';
import 'package:sixam_mart_store/features/advertisement/widgets/empty_ads_view.dart';
import 'package:sixam_mart_store/helper/date_converter_helper.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';
import 'package:sixam_mart_store/helper/string_extensions.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';

class AdvertisementListScreen extends StatefulWidget {
  const AdvertisementListScreen({super.key});
  @override
  State<AdvertisementListScreen> createState() => _AdvertisementListScreenState();
}

class _AdvertisementListScreenState extends State<AdvertisementListScreen>{

  // bool? isDataAvailable = false;
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    Get.find<AdvertisementController>().setStatusIndex(0, willUpdate: false);
    Get.find<AdvertisementController>().getAdvertisementList('1', 'all');
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent
          && Get.find<AdvertisementController>().advertisementList != null
          && !Get.find<AdvertisementController>().isLoading) {
        int pageSize = (Get.find<AdvertisementController>().pageSize! / 10).ceil();
        if (Get.find<AdvertisementController>().offset < pageSize) {
          Get.find<AdvertisementController>().setOffset(Get.find<AdvertisementController>().offset+1);
          Get.find<AdvertisementController>().showBottomLoader();
          Get.find<AdvertisementController>().getAdvertisementList(
            Get.find<AdvertisementController>().offset.toString(), Get.find<AdvertisementController>().type,
          );
        }
      }
    });
  }


  @override
  Widget build(BuildContext context) {

    return GetBuilder<AdvertisementController>(
      builder: (advertisementController) {
        List<int> count = [];
        if(advertisementController.advertisementModel != null) {
          count.add(advertisementController.advertisementModel!.all!);
          count.add(advertisementController.advertisementModel!.pending!);
          count.add(advertisementController.advertisementModel!.running!);
          count.add(advertisementController.advertisementModel!.approved!);
          count.add(advertisementController.advertisementModel!.expired!);
          count.add(advertisementController.advertisementModel!.denied!);
          count.add(advertisementController.advertisementModel!.paused!);
        }

        bool isTabShow = false;

        for(int i=0; i<count.length; i++){
          if(count[i] > 0){
            isTabShow = true;
            break;
          }else{
            isTabShow = false;
          }
        }

        return Scaffold(
          appBar: CustomAppBarWidget(title: 'advertisement_list'.tr),
          body: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              color: Theme.of(context).cardColor,
              //boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
            ),
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: Column(children: [
              isTabShow ? SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: advertisementController.statusList.length,
                  itemBuilder: (context, index) {
                    return statusWidget(
                      adsController: advertisementController, title: advertisementController.statusList[index].tr,
                      index: index, count: count,
                    );
                  },
                ),
              ) : const SizedBox(),
              isTabShow ? const SizedBox(height: Dimensions.paddingSizeSmall) : const SizedBox(),

              Expanded(
                child: advertisementController.advertisementList != null ? advertisementController.advertisementList!.isNotEmpty
                    ? advertisementListWidget(advertisementController, advertisementController.advertisementList)
                    : EmptyAdsView(counts: count)
                    : const Center(child: CircularProgressIndicator()),
              ),
            ]),
          ),

          floatingActionButton: advertisementController.advertisementList != null && advertisementController.advertisementList!.isNotEmpty ? FloatingActionButton(
            elevation: 0,
            backgroundColor: Theme.of(context).primaryColor,
            onPressed: () {
              Get.find<AdvertisementController>().resetAllValues();
              Get.toNamed(RouteHelper.getCreateAdvertisementRoute());
            },
            child: const Icon(Icons.add),
          ) : null,

        );
      }
    );
  }

  Widget advertisementListWidget(AdvertisementController adsController, List<Adds>? advertisementList) {
    return GetBuilder<AdvertisementController>(
      builder: (adsController) {
        return Column(children: [
          const SizedBox(height: Dimensions.paddingSizeSmall),

          Expanded(
            child: ListView.builder(
              itemCount: advertisementList!.length,
                controller: scrollController,
                itemBuilder: (context, index) {
                String status = advertisementList[index].status == 'approved' && advertisementList[index].active == 1 ? 'running'
                    : advertisementList[index].status == 'approved' && advertisementList[index].active == 0 ? 'expired'
                    : advertisementList[index].status!;
              return InkWell(
                onTap: () {
                  Get.toNamed(RouteHelper.getAdvertisementDetailsScreen(advertisementId: advertisementList[index].id));
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    color: Theme.of(context).cardColor,
                    border: Border.all(color: Theme.of(context).disabledColor.withValues(alpha: 0.3)),
                    // boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
                  ),
                  child: Column(children: [

                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).disabledColor.withValues(alpha: 0.1),
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusDefault)),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeDefault),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Row(children: [
                              Text('ads_id'.tr, style: robotoMedium),
                              Text(' # ${advertisementList[index].id}', style: robotoBold),
                              const SizedBox(width: 5),

                              Container(
                                decoration: BoxDecoration(
                                  color: status == 'approved' ? Colors.green.withValues(alpha: 0.2)
                                      : status == 'running' ? Colors.indigo.withValues(alpha: 0.2)
                                      : status == 'expired' ? Theme.of(context).disabledColor.withValues(alpha: 0.2)
                                      : status == 'denied' ? Colors.red.withValues(alpha: 0.2)
                                      : status == 'paused' ? Colors.orange.withValues(alpha: 0.2)
                                      : Colors.blue.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 3, horizontal: Dimensions.paddingSizeExtraSmall),
                                child: Text(
                                  status.tr,
                                  style: robotoRegular.copyWith(
                                    fontSize: Dimensions.fontSizeSmall,
                                    color: status == 'approved' ? Colors.green
                                        : status == 'running' ? Colors.indigo
                                        : status == 'expired' ? Theme.of(context).disabledColor
                                        : status == 'denied' ? Colors.red
                                        : status == 'paused' ? Colors.orange
                                        : Colors.blue,
                                  ),
                                ),
                              ),
                            ]),

                            Text(advertisementList[index].addType!.tr.replaceAll('_', ' ').toTitleCase(), style: robotoRegular.copyWith(color: Theme.of(context).disabledColor)),
                          ]),


                          PopupMenuButton<PopupMenuModel>(
                            shape: RoundedRectangleBorder(
                              borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
                              side: BorderSide(color: Theme.of(context).hintColor.withValues(alpha: 0.1)),
                            ),
                            itemBuilder: (BuildContext context) {
                              return adsController.getPopupMenuList(advertisementList[index].status!, advertisementList[index].active??0).map((PopupMenuModel option) {
                                return PopupMenuItem<PopupMenuModel>(
                                  onTap: () async {

                                    if(option.title == "edit_ads"){
                                      Get.dialog(const CustomLoaderWidget());
                                      adsController.getAdvertisementDetails(id: advertisementList[index].id!).then((AdsDetailsModel? adsDetailsModel) {
                                        Get.back();
                                        if(adsDetailsModel != null) {
                                          Get.to(()=> CreateAdvertisementScreen(adsDetailsModel: adsDetailsModel));
                                        }
                                      });
                                    }

                                    else if(option.title == "edit_and_resubmit_ads"){
                                      Get.dialog(const CustomLoaderWidget());
                                      adsController.getAdvertisementDetails(id: advertisementList[index].id!).then((AdsDetailsModel? adsDetailsModel) {
                                        Get.back();
                                        if(adsDetailsModel != null) {
                                          Get.to(()=> CreateAdvertisementScreen(adsDetailsModel: adsDetailsModel));
                                        }
                                      });
                                    }

                                    else if (option.title == 'view_ads'){
                                      Get.toNamed(RouteHelper.getAdvertisementDetailsScreen(advertisementId: advertisementList[index].id));
                                    }

                                    else if(option.title == "delete_ads"){
                                      status == 'running' ? showCustomBottomSheet(child: ConfirmationBottomSheet(
                                        image: Images.cautionDialogIcon, title: "can't_delete_dialog_title",
                                        description: "can't_delete_dialog_description", status: option.title,
                                        confirmButtonText: "okay",
                                        isShowNotNowButton: false,
                                        yesButtonPressed: () async{
                                          Get.back();
                                        },
                                      )) : showCustomBottomSheet(child: ConfirmationBottomSheet(
                                        image: Images.deleteDialogIcon, title: "confirm_delete_dialog_title",
                                        description: "confirm_delete_dialog_description", status: option.title,
                                        yesButtonPressed: () async {
                                          adsController.deleteAdvertisement(advertisementList[index].id!).then((success) {
                                            if(success) {
                                              Get.back();
                                              showCustomSnackBar('advertisement_deleted_successfully'.tr, isError: false);
                                            }
                                          });
                                        },
                                      ));
                                    }

                                    else if(option.title == 'pause_ads'){
                                      Get.bottomSheet(ConfirmationBottomSheet(
                                        image: Images.pauseDialogIcon, title: "pause_dialog_title",
                                        description: "pause_dialog_description", status: option.title,
                                        yesButtonPressed: () async{
                                          if(adsController.noteFormKey.currentState!.validate()){
                                            await Get.find<AdvertisementController>().changeAdvertisementStatus(id: advertisementList[index].id!, status: 'paused').then((success) {
                                              if(success) {
                                                Get.back();
                                                showCustomSnackBar('advertisement_paused_successfully'.tr, isError: false);
                                              }
                                            });
                                          }
                                        },
                                      ), isScrollControlled: true);
                                    }

                                    else if(option.title == 'resume_ads'){
                                      showCustomBottomSheet(child: ConfirmationBottomSheet(
                                        image: Images.resumeDialogIcon, title: "resume_dialog_title",
                                        description: "resume_dialog_description", status: option.title, yesTestColor: Theme.of(context).primaryColor,
                                        yesButtonPressed: () async{
                                          await adsController.changeAdvertisementStatus(id: advertisementList[index].id!, status: 'approved').then((success) {
                                            if(success) {
                                              Get.back();
                                              showCustomSnackBar('advertisement_resume_successfully'.tr, isError: false);
                                            }
                                          });
                                        },),
                                      );
                                    }

                                    else if(option.title == 'copy_ads'){
                                      Get.dialog(const CustomLoaderWidget());
                                      adsController.getAdvertisementDetails(id: advertisementList[index].id!).then((AdsDetailsModel? adsDetailsModel) {
                                        Get.back();
                                        if(adsDetailsModel != null) {
                                          Get.to(()=> CreateAdvertisementScreen(adsDetailsModel: adsDetailsModel, fromCopy: true));
                                        }
                                      });
                                      // Get.to(()=>CreateAdvertisementScreen(isEditScreen: true, advertisementData: advertisementData, isForResubmit: true));
                                    }
                                  },
                                  value: option,
                                  height: 40,
                                  child: Row(
                                    children: [
                                      const SizedBox(width: Dimensions.paddingSizeExtraSmall,),
                                      Icon(option.icon, size: Dimensions.fontSizeLarge,),
                                      const SizedBox(width: Dimensions.paddingSizeSmall,),
                                      Text(option.title.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                                    ],
                                  ),
                                );
                              }).toList();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                border: Border.all(color: Theme.of(context).disabledColor),
                              ),
                              padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                              child: const Icon(Icons.more_vert_sharp),
                            ),
                          ),

                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                          Text(
                            '${'ads_placed'.tr}: ${DateConverterHelper.dateTimeStringForDisbursement(advertisementList[index].createdAt!)}',
                            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeSmall),

                          Text(
                            '${'duration'.tr} : ${DateConverterHelper.convertDateToDate(advertisementList[index].startDate!)} - ${DateConverterHelper.convertDateToDate(advertisementList[index].endDate!)}',
                            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                          ),

                        ])),

                        InkWell(
                          onTap: () {
                            Get.toNamed(RouteHelper.getAdvertisementDetailsScreen(advertisementId: advertisementList[index].id));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                            ),
                            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                            child: Icon(Icons.arrow_forward_outlined, size: 16, color: Theme.of(context).cardColor),
                          ),
                        )

                      ]),
                    ),

                    // hasDivider ? Divider(color: Theme.of(context).disabledColor) : const SizedBox(),

                  ]),
                ),
              );
            }),
          ),

          adsController.isLoading ? Center(child: Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
          )) : const SizedBox(),
        ]);
      }
    );
  }

  Widget statusWidget({required AdvertisementController adsController, required String title, required int index, required List<int> count}) {
    bool isSelected = adsController.statusIndex == index;
    int adsCount = 0;
    try{
      adsCount = count[index];
    } catch(e) {
      adsCount = 0;
    }
    return InkWell(
      onTap: () {
        adsController.setStatusIndex(index);
        adsController.setType(adsController.statusList[index]);
        adsController.setOffset(1);
        adsController.getAdvertisementList(adsController.offset.toString(), adsController.type);
      },
      child: Row(children: [

        Container(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).disabledColor.withValues(alpha: 0.3),
          ),
          alignment: Alignment.center,
          child: Row(
            children: [
              Text(
                title,
                maxLines: 1, overflow: TextOverflow.ellipsis,
                style: robotoMedium.copyWith(
                  fontSize: Dimensions.fontSizeSmall,
                  color: isSelected ? Theme.of(context).cardColor : Theme.of(context).textTheme.bodyLarge!.color,
                ),
              ),

              Container(
                margin: const EdgeInsets.only(left: Dimensions.paddingSizeExtraSmall),
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall, vertical: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  color: isSelected ? Theme.of(context).cardColor.withValues(alpha: 0.2) : Theme.of(context).cardColor.withValues(alpha: 0.4),
                ),
                child: Text(
                  adsCount.toString(),
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: robotoMedium.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                    color: isSelected ? Theme.of(context).cardColor : Theme.of(context).textTheme.bodyLarge!.color,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: Dimensions.paddingSizeSmall),

      ]),
    );
  }
}

