import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:sixam_mart_store/api/api_client.dart';
import 'package:sixam_mart_store/common/models/config_model.dart';
import 'package:sixam_mart_store/common/widgets/custom_bottom_sheet_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:sixam_mart_store/features/advertisement/domain/services/advertisement_service_interface.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/features/advertisement/enums/ads_type.dart';
import 'package:sixam_mart_store/features/advertisement/models/ads_details_model.dart';
import 'package:sixam_mart_store/features/advertisement/models/advertisement_model.dart';
import 'package:sixam_mart_store/features/advertisement/models/popup_menu_model.dart';
import 'package:sixam_mart_store/features/advertisement/widgets/ads_create_success_bottom_sheet.dart';
import 'package:sixam_mart_store/features/store/domain/models/item_model.dart';
import 'package:sixam_mart_store/helper/date_converter_helper.dart';
import 'package:sixam_mart_store/helper/image_size_checker.dart';
import 'package:sixam_mart_store/util/app_constants.dart';
import 'package:video_player/video_player.dart';

class AdvertisementController extends GetxController implements GetxService {
  final AdvertisementServiceInterface advertisementServiceInterface;
  AdvertisementController({required this.advertisementServiceInterface});

  final List<String> _adsTypes = ['video_promotion', "store_promotion"];
  List<String> get adsTypes => _adsTypes;

  String _selectedAdsType = AdsType.video_promotion.name;
  String get selectedAdsType => _selectedAdsType;

  XFile? _pickedVideoFile;
  XFile? get pickedVideoFile => _pickedVideoFile;

  List<String> _offsetList = [];

  int _offset = 1;
  int get offset => _offset;

  String _type = 'all';
  String get type => _type;

  int? _pageSize;
  int? get pageSize => _pageSize;

  AdvertisementModel? advertisementModel;

  List<Adds>? _advertisementList;
  List<Adds>? get advertisementList => _advertisementList;

  final List<String> _statusList = ['all', 'pending', 'running', 'approved', 'expired', 'denied', 'paused'];
  List<String> get statusList => _statusList;

  AdsDetailsModel? _adsDetailsModel;
  AdsDetailsModel? get advertisementDetailsModel => _adsDetailsModel;

  VideoPlayerController? videoPlayerController;

  bool _isVideoValid = true;
  bool get isVideoValid => _isVideoValid;

  String? _networkVideoFile;
  String? get networkVideoFile => _networkVideoFile;

  DateTimeRange? dateTimeRange;

  bool _isProfileImageValid = true;
  bool get isProfileImageValid => _isProfileImageValid;

  bool _isCoverImageValid = true;
  bool get isCoverImageValid => _isCoverImageValid;

  bool _isRatingsChecked = false;
  bool get isRatingsChecked => _isRatingsChecked;


  bool _isReviewChecked = false;
  bool get isReviewChecked => _isReviewChecked;

  XFile? _pickedProfileImage;
  XFile? get pickedProfileImage => _pickedProfileImage;

  String? _networkProfileImage;
  String? get networkProfileImage => _networkProfileImage;

  XFile? _pickedCoverImage;
  XFile? get pickedCoverImage => _pickedCoverImage;

  String? _networkCoverImage;
  String? get networkCoverImage => _networkCoverImage;

  int _statusIndex = 0;
  int get statusIndex => _statusIndex;

  bool _isLoading = false;
  bool get isLoading => _isLoading;


  TextEditingController? noteController = TextEditingController();
  final GlobalKey<FormState> noteFormKey = GlobalKey<FormState>();

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  @override
  void dispose() {
    videoPlayerController?.dispose();
    super.dispose();
  }

  void setType(String type) {
    _type = type;
  }

  void setStatusIndex(int index, {bool willUpdate = true}) {
    _statusIndex = index;
    if(willUpdate) {
      update();
    }
  }

  void setOffset(int offset) {
    _offset = offset;
  }

  void showBottomLoader() {
    _isLoading = true;
    update();
  }

  void setAdsType({required String type, bool shouldUpdate = true}) {
    _selectedAdsType = type;
    if(shouldUpdate){
      update();
    }
  }

  void initializeAdvertisementValues(AdsDetailsModel adsDetailsModel){
    resetAllValues();
    setAdsType(type: adsDetailsModel.addType ?? "", shouldUpdate: false);
    _networkProfileImage = adsDetailsModel.profileImageFullUrl;
    _networkCoverImage = adsDetailsModel.coverImageFullUrl;
    _networkVideoFile = adsDetailsModel.videoAttachmentFullUrl;
    _isReviewChecked = adsDetailsModel.isReviewActive == 1;
    _isRatingsChecked = adsDetailsModel.isRatingActive == 1;
    if(_networkVideoFile != null){
      initializeVideoPlayerForNetwork();
    }
  }

  void pickVideoFile(bool isRemove) async {
    if(isRemove) {
      _pickedVideoFile = null;
      _networkVideoFile = null;
      if( videoPlayerController != null && videoPlayerController!.value.isInitialized){
        videoPlayerController!.dispose();
      }
      update();
    } else {
      _networkVideoFile = null;
      _pickedVideoFile = await ImagePicker().pickVideo(source: ImageSource.gallery);
      if(_pickedVideoFile != null){
        double videoSize = await ImageSize.getImageSizeFromXFile(_pickedVideoFile!);
        if(videoSize > AppConstants.limitOfPickedVideoSizeInMB){
          _pickedVideoFile = null;
          _isVideoValid = false;
          showCustomSnackBar("video_size_greater_than".tr);
          update();
        }else{
          _isVideoValid = true;
          update();
          initializeVideoPlayerForPicked();
        }

      }
    }

  }

  void initializeVideoPlayerForPicked() {
    if( videoPlayerController != null && videoPlayerController!.value.isInitialized){
      videoPlayerController!.dispose();
    }
    videoPlayerController = VideoPlayerController.file(File(_pickedVideoFile!.path))
      ..initialize().then((_) {
        update();
      });
  }

  void initializeVideoPlayerForNetwork() {
    if( videoPlayerController != null && videoPlayerController!.value.isInitialized){
      videoPlayerController!.dispose();
    }

    videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(networkVideoFile ?? ""))
      ..initialize().then((_) {
        update();
      });
  }

  void toggleReviewChecked(){
    _isReviewChecked = !_isReviewChecked;
    update();
  }


  void toggleRatingChecked(){
    _isRatingsChecked = !_isRatingsChecked;
    update();
  }

  void pickProfileImage(bool isRemove) async {
    if(isRemove){
      _pickedProfileImage = null;
      _networkProfileImage = null;
    } else {
      _networkProfileImage = null;
      _pickedProfileImage = await ImagePicker().pickImage(source: ImageSource.gallery);
      if(_pickedProfileImage != null) {
        double imageSize = await ImageSize.getImageSizeFromXFile(_pickedProfileImage!);
        if (imageSize > AppConstants.maxSizeOfASingleFile) {
          _pickedProfileImage = null;
          showCustomSnackBar("profile_size_greater_than".tr);
        } else {
          _isProfileImageValid = true;
        }
      }
    }
    update();
  }

  void pickCoverImage(bool isRemove) async {
    if(isRemove) {
      _pickedCoverImage = null;
      _networkCoverImage = null;
    } else {
      _networkCoverImage = null;
      _pickedCoverImage = await ImagePicker().pickImage(source: ImageSource.gallery);
      double imageSize = await ImageSize.getImageSizeFromXFile(_pickedCoverImage!);
      if(imageSize > AppConstants.maxSizeOfASingleFile){
        _pickedCoverImage =null;
        showCustomSnackBar("cover_image_size_greater_than".tr);
      } else {
        _isCoverImageValid = true;
      }
    }
    update();
  }

  bool validateTimeRange(TextEditingController? timeRange){
    bool isBefore = false;
    if(timeRange != null) {
      List<String> parts = timeRange.text.split('-');
      String formattedString = parts[1].removeAllWhitespace;
      DateTime networkStartDate;
      try{
        networkStartDate = DateFormat("MM/dd/yyyy").parse(formattedString).toLocal();
      } catch(e) {
        networkStartDate = DateFormat('d MMM,y').parse(formattedString).toLocal();
      }

      DateTime todayDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
      isBefore = networkStartDate.isBefore(todayDate);
    }
    return isBefore;
  }

  void checkFileValidation () {
    if(selectedAdsType == AdsType.video_promotion.name) {
      if(_pickedVideoFile == null && _networkVideoFile == null) {
        _isVideoValid = false;
      } else {
        _isVideoValid = true;
      }
    } else {
      if(_pickedProfileImage == null && _networkProfileImage == null) {
        _isProfileImageValid = false;
      } else {
        _isProfileImageValid = true;
      }
      if(_pickedCoverImage == null && _networkCoverImage == null){
        _isCoverImageValid = false;
      } else {
        _isCoverImageValid = true;
      }
    }
    update();
  }

  void resetAllValues({bool shouldUpdate = false}){
    // _isEditScreen = false;
    // _selectedAdsType = "video_promotion";
    _selectedAdsType = AdsType.video_promotion.name;
    _pickedVideoFile = null;
    videoPlayerController = null;
    // validationController?.text = '';
    // descriptionController!.text = '';
    // titleController!.text = '';
    _pickedProfileImage = null;
    _pickedCoverImage = null;
    _isCoverImageValid = true;
    _isVideoValid = true;
    // _isLogoValid = true;
    _networkVideoFile = null;
    _networkCoverImage = null;
    _networkProfileImage = null;
    _isRatingsChecked = false;
    _isReviewChecked = false;
    dateTimeRange = null;
    // noteController?.text = '';
    if(shouldUpdate){
      update();
    }
  }

  Future<void> submitNewAdvertisement({List<TextEditingController>? titleController, List<TextEditingController>? descriptionController, List<Language>? languageList}) async{
    _isLoading = true;
    update();

    List<MultipartBody> selectedFiles = [];
    if(selectedAdsType == AdsType.store_promotion.name){
      selectedFiles.add(MultipartBody('profile_image', _pickedProfileImage!));
      selectedFiles.add(MultipartBody('cover_image', _pickedCoverImage!));
    } else {
      selectedFiles.add(MultipartBody('video_attachment', _pickedVideoFile!));
    }

    Map<String, String> body = {
      'advertisement_type': selectedAdsType,
      'dates': "${DateConverterHelper.stringToMDY(dateTimeRange?.start.toString() ?? "")} - ${DateConverterHelper.stringToMDY(dateTimeRange?.end.toString() ?? "")}",
      'is_rating_active': isReviewChecked ? "1" : "0",
      'is_review_active': isRatingsChecked ? "1" : "0",
    };
    List<Translation> translations = [];
    for(int index=0; index<languageList!.length; index++) {
      translations.add(Translation(
        locale: languageList[index].key, key: 'title',
        value: titleController![index].text.trim().isNotEmpty ? titleController[index].text.trim()
            : titleController[0].text.trim(),
      ));
      translations.add(Translation(
        locale: languageList[index].key, key: 'description',
        value: descriptionController![index].text.trim().isNotEmpty ? descriptionController[index].text.trim()
            : descriptionController[0].text.trim(),
      ));
    }
    body['translations'] = jsonEncode(translations.map((v) => v.toJson()).toList());


    Response response = await advertisementServiceInterface.submitNewAdvertisement(body, selectedFiles);
    if(response.statusCode == 200){
      getAdvertisementList('1', _type);
      Get.back();
      Future.delayed(const Duration(milliseconds: 800), () {
        showCustomBottomSheet(child: const AdsCreateSuccessBottomSheet());
      });
    }else{
      showCustomSnackBar(response.statusText, isError: true);
    }
    _isLoading = false;
    update();
  }

  Future<void> copyAddAdvertisement({required int adsId, List<TextEditingController>? titleController, List<TextEditingController>? descriptionController, List<Language>? languageList}) async{
    _isLoading = true;
    update();

    List<MultipartBody> selectedFiles = [];
    if(selectedAdsType == AdsType.store_promotion.name){
      selectedFiles.add(MultipartBody('profile_image', _pickedProfileImage));
      selectedFiles.add(MultipartBody('cover_image', _pickedCoverImage));
    } else {
      selectedFiles.add(MultipartBody('video_attachment', _pickedVideoFile));
    }

    Map<String, String> body = {
      'id': adsId.toString(),
      'advertisement_type': selectedAdsType,
      // 'dates': '07/19/2024 - 07/24/2024',
      'dates': "${DateConverterHelper.stringToMDY(dateTimeRange?.start.toString() ?? "")} - ${DateConverterHelper.stringToMDY(dateTimeRange?.end.toString() ?? "")}",
      'is_rating_active': isReviewChecked ? "1" : "0",
      'is_review_active': isRatingsChecked ? "1" : "0",
    };
    List<Translation> translations = [];
    for(int index=0; index<languageList!.length; index++) {
      translations.add(Translation(
        locale: languageList[index].key, key: 'title',
        value: titleController![index].text.trim().isNotEmpty ? titleController[index].text.trim()
            : titleController[0].text.trim(),
      ));
      translations.add(Translation(
        locale: languageList[index].key, key: 'description',
        value: descriptionController![index].text.trim().isNotEmpty ? descriptionController[index].text.trim()
            : descriptionController[0].text.trim(),
      ));
    }
    body['translations'] = jsonEncode(translations.map((v) => v.toJson()).toList());


    Response response = await advertisementServiceInterface.copyAddAdvertisement(body, selectedFiles);
    if(response.statusCode == 200){
      getAdvertisementList('1', _type);
      Get.back();
      Future.delayed(const Duration(milliseconds: 800), () {
        showCustomBottomSheet(child: const AdsCreateSuccessBottomSheet());
      });
    }else{
      showCustomSnackBar(response.statusText, isError: true);
    }
    _isLoading = false;
    update();
  }

  Future<void> editAdvertisement(AdsDetailsModel advertisementData, {required bool isFromDetailsPage, required TextEditingController validationController, List<TextEditingController>? titleController, List<TextEditingController>? descriptionController, List<Language>? languageList}) async {
    _isLoading = true;
    update();

    List<MultipartBody> selectedFiles = [];
    if(selectedAdsType == AdsType.store_promotion.name){
      if(_pickedProfileImage != null){
        selectedFiles.add(MultipartBody('profile_image', _pickedProfileImage!));
      }
      if(_pickedCoverImage != null){
        selectedFiles.add(MultipartBody('cover_image', _pickedCoverImage!));
      }
    }else if (selectedAdsType == 'video_promotion'){
      if(_pickedVideoFile != null){
        selectedFiles.add(MultipartBody('video_attachment',_pickedVideoFile!));
      }
    }

    Map<String, String> body = {
      'id': advertisementData.id.toString(),
      'advertisement_type': selectedAdsType,
      'dates': validationController.text,
      'is_rating_active': isReviewChecked ? "1" : "0",
      'is_review_active': isRatingsChecked ? "1" : "0",
    };

    List<Translation> translations = [];
    for(int index=0; index<languageList!.length; index++) {
      translations.add(Translation(
        locale: languageList[index].key, key: 'title',
        value: titleController![index].text.trim().isNotEmpty ? titleController[index].text.trim()
            : titleController[0].text.trim(),
      ));
      translations.add(Translation(
        locale: languageList[index].key, key: 'description',
        value: descriptionController![index].text.trim().isNotEmpty ? descriptionController[index].text.trim()
            : descriptionController[0].text.trim(),
      ));
    }
    body['translations'] = jsonEncode(translations.map((v) => v.toJson()).toList());


    Response response = await advertisementServiceInterface.editAdvertisement(id: advertisementData.id.toString(), body: body, selectedFile: selectedFiles);
    if(response.statusCode == 200){
      await getAdvertisementList('1', _type);
      await getAdvertisementDetails(id: advertisementData.id!);
      if(isFromDetailsPage){
        Get.back();
      }
    }

    _isLoading = false;
    update();

  }

  Future<bool> deleteAdvertisement(int id) async{
    _isLoading = true;
    update();
    bool? success = await advertisementServiceInterface.deleteAdvertisement(id: id);
    if(success) {
      await getAdvertisementList('1', _type);
    } else {
      showCustomSnackBar('advertisement_not_deleted'.tr);
    }
    _isLoading = false;
    update();
    return success;
  }

  Future<void> getAdvertisementList(String offset, String type) async {
    if(offset == '1') {
      _offsetList = [];
      _offset = 1;
      _type = type;
      _advertisementList = null;
      update();
    }
    if (!_offsetList.contains(offset)) {
      _offsetList.add(offset);
      advertisementModel = await advertisementServiceInterface.getAdvertisementList(offset, _type);
      if (advertisementModel != null) {
        if (offset == '1') {
          _advertisementList = [];
        }
        _advertisementList!.addAll(advertisementModel!.adds!);
        _pageSize = advertisementModel!.totalSize;
        _isLoading = false;
        update();
      }
    } else {
      if(isLoading) {
        _isLoading = false;
        update();
      }
    }
  }

  Future<AdsDetailsModel?> getAdvertisementDetails({required int id}) async {

    _adsDetailsModel = null;
    AdsDetailsModel? adsDetailsModel = await advertisementServiceInterface.getAdvertisementDetails(id: id);
    if(adsDetailsModel != null) {
      _adsDetailsModel = adsDetailsModel;
    }
    update();
    return _adsDetailsModel;
  }

  List<PopupMenuModel> getPopupMenuList(String status , int active) {
    bool isExpired = (status == "approved" && active == 0);
    bool isRunning = (status == "approved" && active == 1);
    bool isApproved = (status == "approved" && active == 2);
    if(status == "pending"){
      return [
        PopupMenuModel(title: "view_ads", icon: Icons.remove_red_eye_sharp),
        PopupMenuModel(title: "edit_ads", icon: Icons.edit),
        PopupMenuModel(title: "copy_ads", icon: Icons.restore),
        PopupMenuModel(title: "delete_ads", icon: Icons.delete),
      ];
    } else if(isApproved){
      return [
        PopupMenuModel(title: "view_ads", icon: Icons.remove_red_eye_sharp),
        PopupMenuModel(title: "edit_ads", icon: Icons.edit),
        PopupMenuModel(title: "copy_ads", icon: Icons.restore),
        PopupMenuModel(title: "delete_ads", icon: Icons.delete),
      ];
    } else if(isRunning){
      return [
        PopupMenuModel(title: "view_ads", icon: Icons.remove_red_eye_sharp),
        PopupMenuModel(title: "edit_ads", icon: Icons.edit),
        PopupMenuModel(title: "pause_ads", icon: Icons.pause_circle),
        PopupMenuModel(title: "copy_ads", icon: Icons.restore),
        PopupMenuModel(title: "delete_ads", icon: Icons.delete),
      ];
    } else if(isExpired || status == 'denied'){
      return [
        PopupMenuModel(title: "view_ads", icon: Icons.remove_red_eye_sharp),
        PopupMenuModel(title: "edit_and_resubmit_ads", icon: Icons.edit),
        PopupMenuModel(title: "copy_ads", icon: Icons.restore),
        PopupMenuModel(title: "delete_ads", icon: Icons.delete),
      ];
    } else if (status == 'paused'){
      return [
        PopupMenuModel(title: "view_ads", icon: Icons.remove_red_eye_sharp),
        PopupMenuModel(title: "edit_ads", icon: Icons.edit),
        PopupMenuModel(title: "resume_ads", icon: Icons.play_arrow_rounded),
        PopupMenuModel(title: "copy_ads", icon: Icons.restore),
        PopupMenuModel(title: "delete_ads", icon: Icons.delete),
      ];
    } else if (status == 'resumed'){
      return [
        PopupMenuModel(title: "view_ads", icon: Icons.remove_red_eye_sharp),
        PopupMenuModel(title: "edit_ads", icon: Icons.edit),
        PopupMenuModel(title: "pause_ads", icon: Icons.pause_circle),
        PopupMenuModel(title: "copy_ads", icon: Icons.restore),
        PopupMenuModel(title: "delete_ads", icon: Icons.delete),
      ];
    } else if (status == 'canceled'){
      return [
        PopupMenuModel(title: "view_ads", icon: Icons.remove_red_eye_sharp),
        PopupMenuModel(title: "edit_ads", icon: Icons.edit),
        PopupMenuModel(title: "copy_ads", icon: Icons.restore),
        PopupMenuModel(title: "delete_ads", icon: Icons.delete),
      ];
    }
    return [];
  }

  Future<bool> changeAdvertisementStatus({required String status, required int id}) async {
    _isLoading = true;
    update();
    bool success = await advertisementServiceInterface.changeAdvertisementStatus(note: noteController!.text.trim(), status: status, id: id);
    if(success) {
      await getAdvertisementList('1', _type);
    }
    _isLoading = false;
    update();
    return success;
  }

}