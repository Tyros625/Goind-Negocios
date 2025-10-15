import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/common/models/config_model.dart';
import 'package:sixam_mart_store/common/widgets/custom_app_bar_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_asset_image_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_button_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_dropdown_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_text_field_widget.dart';
import 'package:sixam_mart_store/features/advertisement/controllers/advertisement_controller.dart';
import 'package:sixam_mart_store/features/advertisement/enums/ads_type.dart';
import 'package:sixam_mart_store/features/advertisement/models/ads_details_model.dart';
import 'package:sixam_mart_store/features/advertisement/widgets/create_advertisement_video_view_shimmer.dart';
import 'package:sixam_mart_store/features/advertisement/widgets/custom_check_box.dart';
import 'package:sixam_mart_store/features/advertisement/widgets/dotted_video_border.dart';
import 'package:sixam_mart_store/features/advertisement/widgets/preview_profile_promotion_widget.dart';
import 'package:sixam_mart_store/features/advertisement/widgets/preview_video_dialog_widget.dart';
import 'package:sixam_mart_store/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart_store/helper/date_converter_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:video_player/video_player.dart';

class CreateAdvertisementScreen extends StatefulWidget {
  final AdsDetailsModel? adsDetailsModel;
  final bool? fromCopy;
  const CreateAdvertisementScreen({super.key, this.adsDetailsModel, this.fromCopy = false});

  @override
  State<CreateAdvertisementScreen> createState() => _CreateAdvertisementScreenState();
}

class _CreateAdvertisementScreenState extends State<CreateAdvertisementScreen> with SingleTickerProviderStateMixin {
  List<DropdownItem<int>> promotionList = [];
  TextEditingController? validationController = TextEditingController();
  List<TextEditingController> titleController = [];
  List<TextEditingController> descriptionController = [];

  final FocusNode _validationFocus = FocusNode();
  final List<FocusNode> _titleFocus = [];
  final List<FocusNode> _descriptionFocus = [];
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TabController? multiLanguageTabController;

  final List<Language>? _languageList = Get.find<SplashController>().configModel!.language;
  List<Widget> tabList = [];

  @override
  void initState() {
    super.initState();

    _getPromotionList();
    multiLanguageTabController = TabController(length: _languageList!.length, initialIndex: 0, vsync: this);

    for (var language in _languageList) {
      titleController.add(TextEditingController());
      descriptionController.add(TextEditingController());
      _titleFocus.add(FocusNode());
      _descriptionFocus.add(FocusNode());
      tabList.add(Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
        child: Tab(text: "${language.value}"),
      ));
    }

    if(widget.adsDetailsModel != null) {
      _editSetup();
    } else {
      clearTitleDescription();
      Get.find<AdvertisementController>().resetAllValues();
    }



  }

  void _editSetup() {
    titleController[0].text = widget.adsDetailsModel?.title ?? "";
    descriptionController[0].text = widget.adsDetailsModel?.description ?? "";
    validationController?.text = "${DateConverterHelper.stringToMDY(widget.adsDetailsModel?.startDate ??"")} - ${DateConverterHelper.stringToMDY(widget.adsDetailsModel?.endDate ??"")}";

    for(int index = 1; index < _languageList!.length ; index ++){
      widget.adsDetailsModel?.translations?.forEach((element){
        if(element.locale == _languageList[index].key && element.key == "title"){
          titleController[index].text = element.value ?? "";
        } else if(element.locale == _languageList[index].key && element.key == "description"){
          descriptionController[index].text = element.value ?? "";
        }
      });
    }
    Get.find<AdvertisementController>().initializeAdvertisementValues(widget.adsDetailsModel!);
    Get.find<AdvertisementController>().dateTimeRange = DateTimeRange(
        start: DateConverterHelper.isoUtcStringToLocalDateOnly(widget.adsDetailsModel?.startDate ??""),
        end: DateConverterHelper.isoUtcStringToLocalDateOnly(widget.adsDetailsModel?.endDate ??""),
    );
  }

  void _getPromotionList() {
    for(int i=0; i<Get.find<AdvertisementController>().adsTypes.length; i++) {
      promotionList.add(DropdownItem<int>(value: i, child: SizedBox(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(Get.find<AdvertisementController>().adsTypes[i].tr),
        ),
      )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdvertisementController>(
      builder: (adsController) {
        return Scaffold(
          appBar: CustomAppBarWidget(title: widget.adsDetailsModel != null ? widget.fromCopy! ? 'new_advertisement'.tr
              : 'update_advertisement'.tr : 'new_advertisement'.tr),
          body: Column(children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('category_info'.tr, style: robotoMedium),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
                    ),
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    child: Form(
                      key: formKey,
                      child: Column(children: [
                        const SizedBox(height: Dimensions.paddingSizeSmall),

                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                            color: Theme.of(context).cardColor,
                            border: Border.all(color: Theme.of(context).disabledColor, width: 0.5),
                          ),
                          child: CustomDropdown<int>(
                            onChange: (int? value, int index) {
                              adsController.setAdsType(type: adsController.adsTypes[index]);
                            },
                            dropdownButtonStyle: DropdownButtonStyle(
                              height: 45,
                              padding: const EdgeInsets.symmetric(
                                vertical: Dimensions.paddingSizeExtraSmall,
                                horizontal: Dimensions.paddingSizeExtraSmall,
                              ),
                              primaryColor: Theme.of(context).textTheme.bodyLarge!.color,
                            ),
                            dropdownStyle: DropdownStyle(
                              elevation: 10,
                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                              padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                            ),
                            items: promotionList,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Text(adsController.selectedAdsType.tr),
                            ),
                          ),
                        ),

                        const SizedBox(height: Dimensions.paddingSizeExtremeLarge),

                        InkWell(
                          onTap:()async{

                            DateTimeRange? dateTimeRange = await showDateRangePicker(
                              //locale: Get.find<LocalizationController>().locale,
                                initialEntryMode: DatePickerEntryMode.calendar,
                                context: context,
                                firstDate: DateTime.now(),
                                lastDate: DateTime(3000),
                                currentDate: DateTime.now()
                            );

                            if(dateTimeRange != null){
                              adsController.dateTimeRange = dateTimeRange;
                              validationController?.text = modifyDateRange(dateTimeRange);
                            }
                            setState(() {});
                          },
                          child: CustomTextFieldWidget(
                            inputType: TextInputType.text,
                            controller: validationController,
                            hintText: "validity".tr,
                            labelText: "validity".tr,
                            focusNode: _validationFocus,
                            capitalization: TextCapitalization.sentences,
                            inputAction: TextInputAction.done,
                            isEnabled : false,
                            hideEnableText: true,
                            suffixChild: Icon(Icons.date_range_rounded, color: Theme.of(context).disabledColor.withValues(alpha: 0.5)),
                            validator: (value) {
                              if(value == null || value.isEmpty) {
                                return "enter_validity".tr;
                              } else if (value.isNotEmpty) {
                                if(widget.adsDetailsModel != null) {
                                  bool isNotValidTimeRange = adsController.validateTimeRange(validationController);
                                  if(isNotValidTimeRange) {
                                    return "enter_a_valid_date_range".tr;
                                  }
                                }
                              }
                              return null;

                            },
                          ),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeExtremeLarge),

                        Column(children: [
                          SizedBox(
                            height: 40,
                            child: TabBar(
                              tabAlignment: TabAlignment.start,
                              controller: multiLanguageTabController,
                              unselectedLabelColor:Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.5),
                              indicatorColor: Theme.of(context).primaryColor,
                              labelColor: Theme.of(context).textTheme.bodyMedium!.color,
                              labelStyle: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                              labelPadding: EdgeInsets.zero,
                              unselectedLabelStyle: robotoRegular,
                              isScrollable : true,
                              dividerHeight: 0.2,
                              dividerColor: Theme.of(context).disabledColor.withValues(alpha: 0.5),
                              tabs: tabList,
                              onTap: (int ? value) {
                                setState(() {});
                              },
                            ),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeDefault),

                          CustomTextFieldWidget(
                            hintText: "${'title'.tr} (${_languageList![multiLanguageTabController!.index].value})".tr,
                            labelText: "${'title'.tr} (${_languageList[multiLanguageTabController!.index].value})".tr,
                            inputType: TextInputType.text,
                            controller: titleController[multiLanguageTabController!.index],
                            capitalization: TextCapitalization.sentences,
                            focusNode: _titleFocus[multiLanguageTabController!.index],
                            nextFocus: multiLanguageTabController!.index != _languageList.length - 1 ? _descriptionFocus[multiLanguageTabController!.index] : _descriptionFocus[0],
                            validator: (value) => (value == null || value.isEmpty) ? "enter_title".tr : null,
                          ),
                          const SizedBox(height: Dimensions.paddingSizeLarge),

                          CustomTextFieldWidget(
                            hintText: "${'description'.tr} ${_languageList[multiLanguageTabController!.index].value}".tr,
                            labelText: '${'description'.tr.replaceAll(":", "")}(${_languageList[multiLanguageTabController!.index].value})',
                            inputType: TextInputType.text,
                            controller: descriptionController[multiLanguageTabController!.index],
                            capitalization: TextCapitalization.sentences,
                            focusNode: _descriptionFocus[multiLanguageTabController!.index],
                            inputAction: multiLanguageTabController!.index != _languageList.length - 1 ? TextInputAction.next : TextInputAction.done,
                            maxLines: 2,
                            maxLength: 100,
                            validator: (value) => (value == null || value.isEmpty) ? "enter_description".tr : null,
                          ),
                        ]),

                        const SizedBox(height: Dimensions.paddingSizeLarge),
                      ]),
                    ),
                  ),

                  adsController.selectedAdsType == AdsType.store_promotion.name ? const SizedBox(height: Dimensions.paddingSizeLarge): const SizedBox(),

                  adsController.selectedAdsType == AdsType.store_promotion.name
                      ? Text('show_review_ratings'.tr, style: robotoMedium)
                      : const SizedBox(),
                  adsController.selectedAdsType == AdsType.store_promotion.name ? const SizedBox(height: Dimensions.paddingSizeSmall): const SizedBox(),

                  adsController.selectedAdsType == AdsType.store_promotion.name ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
                    ),
                    child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [

                      CustomCheckBox(
                        value: adsController.isReviewChecked,
                        title: 'review'.tr,
                        onTap: ()=> adsController.toggleReviewChecked(),
                      ),
                      SizedBox(width: Get.size.width * 0.08),


                      CustomCheckBox(
                        value: adsController.isRatingsChecked,
                        title: 'rating'.tr,
                        onTap: ()=> adsController.toggleRatingChecked(),
                      ),

                    ]),
                  ): const SizedBox(),

                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  Text('upload_files'.tr, style: robotoMedium),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
                    ),
                    padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault, horizontal: Dimensions.paddingSizeLarge),
                    child: Column(children: [

                      adsController.selectedAdsType == AdsType.video_promotion.name ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                        adsController.pickedVideoFile == null && adsController.networkVideoFile == null ? AspectRatio(
                          aspectRatio: 16/8,
                          child: DottedVideoBorder(
                            showErrorBorder: !adsController.isVideoValid,
                            text: 'click_to_upload_ads_video'.tr,
                            onTap: () => adsController.pickVideoFile(false),
                          ),
                        ) : adsController.videoPlayerController!.value.isInitialized ? Stack(
                          alignment: Alignment.center,
                          children: [
                            AspectRatio(
                              aspectRatio: adsController.videoPlayerController!.value.aspectRatio,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                child: VideoPlayer(adsController.videoPlayerController!),
                              ),
                            ),

                            Positioned(
                              top: 10, right: 10,
                              child: Container(
                                padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall - 5),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                ),
                                child: InkWell(
                                  onTap: (){
                                    adsController.pickVideoFile(true);
                                  },
                                  child: Icon(Icons.close, color: Theme.of(context).colorScheme.error),
                                ),
                              ),
                            ),

                            FloatingActionButton.small(
                              backgroundColor: Colors.grey,
                              onPressed: () {
                                setState(() {
                                  adsController.videoPlayerController!.value.isPlaying
                                      ? adsController.videoPlayerController!.pause()
                                      : adsController.videoPlayerController!.play();
                                });
                              },
                              child: Icon(
                                adsController.videoPlayerController!.value.isPlaying ? Icons.pause : Icons.play_arrow,
                              ),
                            )
                          ],
                        ) : const CreateAdvertisementVideoViewShimmer(),

                        !adsController.isVideoValid ? Padding(
                          padding: const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall),
                          child: Text("enter_video".tr,
                            overflow: TextOverflow.ellipsis,
                            style: robotoRegular.copyWith(color: Theme.of(context).colorScheme.error, fontSize: Dimensions.fontSizeSmall),
                          ),
                        ) : const SizedBox(),

                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                            child: Text(
                              'video_ratio_text'.tr,
                              textAlign: TextAlign.center,
                              style: robotoRegular.copyWith(color: Theme.of(context).disabledColor),
                            ),
                          ),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeDefault),


                      ]) : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                        Center(
                          child: Stack(children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                              child: adsController.pickedProfileImage != null ? Image.file(
                                File(adsController.pickedProfileImage!.path),
                                fit: BoxFit.cover, height: 150, width: 150,
                              ) : adsController.networkProfileImage != null ? Image.network(
                                adsController.networkProfileImage!, width: 150, height: 150, fit: BoxFit.cover,
                              ) : SizedBox(
                                height: 150, width: 150,
                                child: DottedVideoBorder(
                                  showErrorBorder: !adsController.isProfileImageValid,
                                  text: 'click_to_upload_profile_image'.tr,
                                  onTap: () => adsController.pickProfileImage(false),
                                ),
                              ),
                            ),

                            adsController.pickedProfileImage != null || adsController.networkProfileImage != null ? Positioned(
                              top: -10, right: -10,
                              child: IconButton(
                                onPressed: () => adsController.pickProfileImage(true),
                                icon: const Icon(Icons.highlight_remove_rounded, color: Colors.red, size: 25),
                              ),
                            ) : const SizedBox(),
                          ]),
                        ),

                        !adsController.isProfileImageValid ? Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall),
                            child: Text("enter_profile_image".tr,
                              overflow: TextOverflow.ellipsis,
                              style: robotoRegular.copyWith(color: Theme.of(context).colorScheme.error, fontSize: Dimensions.fontSizeSmall),
                            ),
                          ),
                        ) : const SizedBox(),

                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                            child: Text(
                              'profile_ratio_text'.tr,
                              textAlign: TextAlign.center,
                              style: robotoRegular.copyWith(color: Theme.of(context).disabledColor),
                            ),
                          ),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeLarge),

                        AspectRatio(
                          aspectRatio: 20/9,
                          child: Stack(children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                              child: adsController.pickedCoverImage != null ? Image.file(
                                File(adsController.pickedCoverImage!.path),
                                fit: BoxFit.cover, height: double.infinity, width: double.infinity,
                              ) : adsController.networkCoverImage != null ? Image.network(
                              adsController.networkCoverImage!, width: double.infinity, height: double.infinity, fit: BoxFit.cover,
                              ) : SizedBox(
                                height: double.infinity, width: double.infinity,
                                child: DottedVideoBorder(
                                  showErrorBorder: !adsController.isCoverImageValid,
                                  text: 'click_to_upload_cover_image'.tr,
                                  onTap: () => adsController.pickCoverImage(false),
                                ),
                              ),
                            ),

                            adsController.pickedCoverImage != null || adsController.networkCoverImage != null ? Positioned(
                              top: -10, right: -10,
                              child: IconButton(
                                onPressed: () => adsController.pickCoverImage(true),
                                icon: const Icon(Icons.highlight_remove_rounded, color: Colors.red, size: 25),
                              ),
                            ) : const SizedBox(),
                          ]),
                        ),

                        !adsController.isCoverImageValid ? Padding(
                          padding: const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall),
                          child: Text("enter_cover_image".tr,
                            overflow: TextOverflow.ellipsis,
                            style: robotoRegular.copyWith(color: Theme.of(context).colorScheme.error, fontSize: Dimensions.fontSizeSmall),
                          ),
                        ) : const SizedBox(),

                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                            child: Text(
                              'cover_ratio_text'.tr,
                              textAlign: TextAlign.center,
                              style: robotoRegular.copyWith(color: Theme.of(context).disabledColor),
                            ),
                          ),
                        ),


                      ]),


                    ]),
                  ),
                ]),
              ),
            ),

            SafeArea(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
                ),
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                child: Row(children: [

                  Expanded(
                    child: CustomButtonWidget(
                      buttonText: 'reset'.tr,
                      color: Theme.of(context).disabledColor,
                      onPressed: () async {
                        await clearTitleDescription();
                        adsController.resetAllValues(shouldUpdate: true);

                        if(widget.adsDetailsModel != null) {
                          _editSetup();
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeSmall),

                  Expanded(
                    child: CustomButtonWidget(
                      buttonText: widget.adsDetailsModel != null && !widget.fromCopy! ? 'update_ads'.tr : 'create_ads'.tr,
                      isLoading: adsController.isLoading,
                      onPressed: (){
                        adsController.checkFileValidation();

                        if(widget.adsDetailsModel != null){
                          if(adsController.selectedAdsType == AdsType.video_promotion.name) {
                            if(formKey.currentState!.validate() && adsController.isVideoValid) {
                              if(widget.fromCopy!) {
                                adsController.copyAddAdvertisement(adsId: widget.adsDetailsModel!.id!, titleController: titleController, descriptionController: descriptionController, languageList: _languageList);
                              } else {
                                adsController.editAdvertisement(widget.adsDetailsModel!, isFromDetailsPage: true, validationController: validationController!, titleController: titleController, descriptionController: descriptionController, languageList: _languageList);
                              }
                            }
                          } else {
                            if(formKey.currentState!.validate() && adsController.isCoverImageValid && adsController.isProfileImageValid){
                              if(widget.fromCopy!){
                                adsController.copyAddAdvertisement(adsId: widget.adsDetailsModel!.id!, titleController: titleController, descriptionController: descriptionController, languageList: _languageList);
                              }else{
                                adsController.editAdvertisement(widget.adsDetailsModel!, isFromDetailsPage: true, validationController: validationController!, titleController: titleController, descriptionController: descriptionController, languageList: _languageList);
                              }
                            }
                          }
                        } else {
                          if(adsController.selectedAdsType == AdsType.video_promotion.name) {
                            if(formKey.currentState!.validate() && adsController.isVideoValid){
                              adsController.submitNewAdvertisement(titleController: titleController, descriptionController: descriptionController, languageList: _languageList);
                            }
                          } else {
                            if(formKey.currentState!.validate() && adsController.isCoverImageValid && adsController.isProfileImageValid){
                              adsController.submitNewAdvertisement(titleController: titleController, descriptionController: descriptionController, languageList: _languageList);
                            }
                          }
                        }

                      },
                    ),
                  ),
                ]),
              ),
            ),

          ]),

          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 80),
            child: FloatingActionButton(
              backgroundColor: Colors.transparent,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  const CustomAssetImageWidget(Images.previewImage, height: 100, width: 100),

                  Positioned(
                    bottom: -7, left: -3, right: -3,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        color: Theme.of(context).primaryColor,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      child: Row(children: [
                        Icon(Icons.remove_red_eye_outlined, size: 14, color: Theme.of(context).cardColor),
                        const SizedBox(width: 2),
                        Text('preview'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall)),
                      ]),
                    ),
                  )
                ],
              ),
              onPressed: (){
                if(adsController.pickedVideoFile != null && adsController.videoPlayerController!.value.isInitialized){
                  adsController.videoPlayerController!.pause();
                }

                Get.dialog(adsController.selectedAdsType == AdsType.video_promotion.name ? PreviewVideoDialogWidget(
                  title: titleController[0].text,
                  description: descriptionController[0].text,
                ) : PreviewProviderPromotionWidget(
                title: titleController[0].text,
                  description: descriptionController[0].text,
                  validation: validationController?.text,
                  pickedCoverImage: adsController.pickedCoverImage?.path,
                  networkCoverImage: adsController.networkCoverImage,
                  pickedProfileImage: adsController.pickedProfileImage?.path,
                  networkProfileImage: adsController.networkProfileImage,
                  isShowRatings: adsController.isRatingsChecked,
                  isShowReview: adsController.isReviewChecked,
                ), barrierDismissible: true, useSafeArea: true);

              },

            ),
          ),
        );
      }
    );
  }

  String modifyDateRange(DateTimeRange? dateTimeRange){
    String firstDate = DateConverterHelper.stringToMDY(dateTimeRange?.start.toString() ?? "");
    String lastDate = DateConverterHelper.stringToMDY(dateTimeRange?.end.toString() ?? "");
    return "$firstDate - $lastDate";
  }

  Future<void> clearTitleDescription() async {
    validationController?.text = '';

    for(int index = 0; index < _languageList!.length ; index ++){
      titleController[index].text = "";
      descriptionController[index].text = "";
    }
  }
}
