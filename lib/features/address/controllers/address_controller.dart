import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:sixam_mart_store/features/address/domain/models/address_model.dart';
import 'package:sixam_mart_store/features/auth/domain/models/module_model.dart';
import 'package:sixam_mart_store/features/address/domain/models/prediction_model.dart';
import 'package:sixam_mart_store/features/address/domain/models/zone_model.dart';
import 'package:sixam_mart_store/features/address/domain/models/zone_response_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/features/address/domain/services/address_service_interface.dart';
import 'package:sixam_mart_store/features/splash/controllers/splash_controller.dart';

class AddressController extends GetxController implements GetxService {
  final AddressServiceInterface addressServiceInterface;
  AddressController({required this.addressServiceInterface});

  int? _selectedZoneIndex = -1;
  int? get selectedZoneIndex => _selectedZoneIndex;

  List<ZoneModel>? _zoneList;
  List<ZoneModel>? get zoneList => _zoneList;

  List<int>? _zoneIds;
  List<int>? get zoneIds => _zoneIds;

  LatLng? _restaurantLocation;
  LatLng? get restaurantLocation => _restaurantLocation;

  String? _storeAddress;
  String? get storeAddress => _storeAddress;

  List<ModuleModel>? _moduleList;
  List<ModuleModel>? get moduleList => _moduleList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<PredictionModel> _predictionList = [];
  List<PredictionModel> get predictionList => _predictionList;

  Position _pickPosition = Position(longitude: 0, latitude: 0, timestamp: DateTime.now(), accuracy: 1, altitude: 1, heading: 1, speed: 1, speedAccuracy: 1, altitudeAccuracy: 1, headingAccuracy: 1);
  Position get pickPosition => _pickPosition;

  String? _pickAddress = '';
  String? get pickAddress => _pickAddress;

  bool _loading = false;
  bool get loading => _loading;

  bool _inZone = false;
  bool get inZone => _inZone;

  int _zoneID = 0;
  int get zoneID => _zoneID;

  int? _selectedModuleIndex = -1;
  int? get selectedModuleIndex => _selectedModuleIndex;

  Future<void> getZoneList() async {
    _selectedZoneIndex = 0;
    _restaurantLocation = null;
    _zoneIds = null;
    List<ZoneModel>? zoneList = await addressServiceInterface.getZoneList();
    if (zoneList != null) {
      _zoneList = [];
      _zoneList!.addAll(zoneList);
      await getModules(_zoneList![0].id);
    }
    update();
  }

  Future<void> setZoneIndex(int? index) async {
    _selectedZoneIndex = index;
    _moduleList = null;
    _selectedModuleIndex = -1;
    update();
    await getModules(zoneList![selectedZoneIndex!].id);
    update();
  }

  Future<void> getModules(int? zoneId) async {
    List<ModuleModel>? moduleList = await addressServiceInterface.getModules(zoneId);
    if (moduleList != null) {
      _moduleList = [];
      _moduleList!.addAll(moduleList);
    }
    update();
  }

  void selectModuleIndex(int? index) {
    _selectedModuleIndex = index;
    update();
  }

  void setLocation(LatLng location, {bool forStoreRegistration = false, int? zoneId}) async{

    ZoneResponseModel response = await getZone(location.latitude.toString(), location.longitude.toString(), false);

    if(zoneId != null) {
      _inZone = await addressServiceInterface.checkInZone(location.latitude.toString(), location.longitude.toString(), zoneId);
    }

    _storeAddress = await getAddressFromGeocode(LatLng(location.latitude, location.longitude));
    //_restaurantLocation = addressServiceInterface.setRestaurantLocation(response, location);
    //_zoneIds = addressServiceInterface.setZoneIds(response);
    //_selectedZoneIndex = addressServiceInterface.setSelectedZoneIndex(response, _zoneIds, _selectedZoneIndex, _zoneList);

    if(response.isSuccess && response.zoneIds.isNotEmpty) {
      _restaurantLocation = location;
      _zoneIds = response.zoneIds;
      for(int index = 0; index < zoneList!.length; index++) {
        if(zoneIds!.contains(zoneList![index].id)) {
          if(!forStoreRegistration) {
            _selectedZoneIndex = index;
          }
          break;
        }
      }
    }else {
      _restaurantLocation = null;
      _zoneIds = null;
    }
    update();
  }

  Future<String> getAddressFromGeocode(LatLng latLng) async {
    String address = await addressServiceInterface.getAddressFromGeocode(latLng);
    return address;
  }

  Future<List<PredictionModel>> searchLocation(BuildContext context, String text) async {
    if(text.isNotEmpty) {
      List<PredictionModel> predictionList = await addressServiceInterface.searchLocation(text);
      if(predictionList.isNotEmpty) {
        _predictionList = [];
        _predictionList.addAll(predictionList);
      }
    }
    return _predictionList;
  }

  Future<Position> setSuggestedLocation(String? placeID, String? address, GoogleMapController? mapController) async {
    _isLoading = true;
    update();

    LatLng latLng = const LatLng(0, 0);
    Response response = await addressServiceInterface.getPlaceDetails(placeID);

    if(response.statusCode == 200) {
      final data = response.body;
      final location = data['location'];
      final double lat = location['latitude'];
      final double lng = location['longitude'];
      latLng = LatLng(lat, lng);
    }

    _pickPosition = Position(
      latitude: latLng.latitude, longitude: latLng.longitude,
      timestamp: DateTime.now(), accuracy: 1, altitude: 1, heading: 1, speed: 1, speedAccuracy: 1, altitudeAccuracy: 1, headingAccuracy: 1,
    );

    _pickAddress = address;

    if(mapController != null) {
      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: latLng, zoom: 16)));
    }
    _isLoading = false;
    update();
    return _pickPosition;
  }

  Future<ZoneResponseModel> getZone(String lat, String long, bool markerLoad, {bool updateInAddress = false}) async {
    if(markerLoad) {
      _loading = true;
    }else {
      _isLoading = true;
    }

    if(!updateInAddress){
      update();
    }
    ZoneResponseModel responseModel;
    Response response = await addressServiceInterface.getZone(lat, long);
    if(response.statusCode == 200) {
      _inZone = true;
      _zoneID = int.parse(jsonDecode(response.body['zone_id'])[0].toString());
      List<int> zoneIds = [];
      jsonDecode(response.body['zone_id']).forEach((zoneId){
        zoneIds.add(int.parse(zoneId.toString()));
      });
      responseModel = ZoneResponseModel(true, '' , zoneIds);

    }else {
      _inZone = false;
      responseModel = ZoneResponseModel(false, response.statusText, []);
    }
    if(markerLoad) {
      _loading = false;
    }else {
      _isLoading = false;
    }
    update();
    return responseModel;
  }

  Future<bool> saveUserAddress(AddressModel address) async {
    String userAddress = jsonEncode(address.toJson());
    return await addressServiceInterface.saveUserAddress(userAddress, address.zoneIds);
  }

  AddressModel? getUserAddress() {
    AddressModel? addressModel;
    try {
      addressModel = AddressModel.fromJson(jsonDecode(addressServiceInterface.getUserAddress()!));
    }catch(e) {
      debugPrint('Address Not Found In SharedPreference:$e');
    }
    return addressModel;
  }

  Future<AddressModel> getCurrentLocation({GoogleMapController? mapController, LatLng? defaultLatLng, bool notify = true}) async {
    _loading = true;
    if(notify) {
      update();
    }
    AddressModel addressModel;
    Position myPosition = await addressServiceInterface.getPosition(defaultLatLng, LatLng(
      double.parse(Get.find<SplashController>().configModel!.defaultLocation!.lat ?? '0'),
      double.parse(Get.find<SplashController>().configModel!.defaultLocation!.lng ?? '0'),
    ));
    _pickPosition = myPosition;

    addressServiceInterface.handleMapAnimation(mapController, myPosition);
    String addressFromGeocode = await getAddressFromGeocode(LatLng(myPosition.latitude, myPosition.longitude));
    _pickAddress = addressFromGeocode;
    ZoneResponseModel responseModel = await getZone(myPosition.latitude.toString(), myPosition.longitude.toString(), true);

    addressModel = AddressModel(
      latitude: myPosition.latitude.toString(), longitude: myPosition.longitude.toString(), addressType: 'others',
      zoneId: responseModel.isSuccess ? responseModel.zoneIds[0] : 0, zoneIds: responseModel.zoneIds,
      address: addressFromGeocode,
    );
    _loading = false;
    update();
    return addressModel;
  }

  String? _selectedPickupZone;
  String? get selectedPickupZone => _selectedPickupZone;

  final List<String> _pickupZoneList = [];
  List<String> get pickupZoneList => _pickupZoneList;

  final List<int> _pickupZoneIdList = [];
  List<int> get pickupZoneIdList => _pickupZoneIdList;

  void setSelectedPickupZone(String? zone, int? zoneId) {
    if (zone != null && zoneId != null) {
      if (_pickupZoneList.contains(zone) || _pickupZoneIdList.contains(zoneId)) {
        showCustomSnackBar('zone_already_added_please_select_another'.tr);
      } else {
        _selectedPickupZone = zone;
        _pickupZoneList.add(zone);
        _pickupZoneIdList.add(zoneId);
        update();
      }
    }
  }

  void removePickupZone(String zone, int zoneId) {
    _selectedPickupZone = null;
    _pickupZoneList.remove(zone);
    _pickupZoneIdList.remove(zoneId);
    update();
  }

  void clearPickupZone() {
    _selectedModuleIndex = -1;
    _selectedPickupZone = null;
    _pickupZoneList.clear();
    _pickupZoneIdList.clear();
  }

  void preloadPickupZones({required List<String> pickupZoneList}) {
    _pickupZoneList.clear();
    _pickupZoneIdList.clear();
    for (String id in pickupZoneList) {
      final ZoneModel? zone = zoneList?.firstWhereOrNull((zone) => zone.id == int.parse(id));
      if (zone != null) {
        _pickupZoneList.add(zone.name!);
        _pickupZoneIdList.add(zone.id!);
      }
    }
    update();
  }

}