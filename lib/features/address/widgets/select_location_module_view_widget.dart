import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sixam_mart_store/common/widgets/custom_asset_image_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_text_field_widget.dart';
import 'package:sixam_mart_store/features/address/controllers/address_controller.dart';
import 'package:sixam_mart_store/features/address/domain/models/zone_model.dart';
import 'package:sixam_mart_store/features/address/widgets/permission_dialog_widget.dart';
import 'package:sixam_mart_store/features/address/widgets/pickup_zone_widget.dart';
import 'package:sixam_mart_store/features/address/widgets/zone_selection_widget.dart';
import 'package:sixam_mart_store/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart_store/helper/validate_check.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/common/widgets/custom_app_bar_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_button_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_dropdown_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:sixam_mart_store/features/address/widgets/location_search_dialog_widget.dart';
import 'package:sixam_mart_store/features/address/widgets/module_view_widget.dart';

class SelectLocationAndModuleViewWidget extends StatefulWidget {
  final bool fromView;
  final GoogleMapController? mapController;
  final TextEditingController? addressController;
  final FocusNode? addressFocus;
  const SelectLocationAndModuleViewWidget({super.key, required this.fromView, this.mapController, this.addressController, this.addressFocus});

  @override
  State<SelectLocationAndModuleViewWidget> createState() => _SelectLocationAndModuleViewWidgetState();
}

class _SelectLocationAndModuleViewWidgetState extends State<SelectLocationAndModuleViewWidget> {

  late CameraPosition _cameraPosition;
  Set<Polygon> _polygons = {};
  GoogleMapController? _mapController;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddressController>(builder: (addressController) {

      List<int> zoneIndexList = [];
      List<DropdownItem<int>> zoneList = [];
      if(addressController.zoneList != null && addressController.zoneIds != null) {
        for(int index = 0; index < addressController.zoneList!.length; index++) {
          zoneIndexList.add(index);
          zoneList.add(DropdownItem<int>(value: index, child: SizedBox(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('${addressController.zoneList![index].name}'),
            ),
          )));
        }
      }

      bool isRentalModule = widget.fromView && addressController.moduleList != null && addressController.selectedModuleIndex != -1 &&
          addressController.moduleList![addressController.selectedModuleIndex!].moduleType == 'rental';

      return Container(
        decoration: widget.fromView ? BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)],
        ) : null,
        height: widget.fromView ? null : context.height,
        padding: widget.fromView ? const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeDefault) : EdgeInsets.zero,
        child: SizedBox(child: Padding(
          padding: EdgeInsets.all(widget.fromView ? 0 : Dimensions.paddingSizeSmall),
          child: SingleChildScrollView(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),

              widget.fromView ? ZoneSelectionWidget(addressController: addressController, zoneList: zoneList, callBack: (){
                _setPolygon(addressController.zoneList![addressController.selectedZoneIndex!]);
              }) : const SizedBox(),
              SizedBox(height: widget.fromView ? Dimensions.paddingSizeExtremeLarge : 0),

              widget.fromView ? const ModuleViewWidget() : const SizedBox(),
              SizedBox(height: widget.fromView ? Dimensions.paddingSizeExtremeLarge : 0),

              isRentalModule ? const PickupZoneWidget() : const SizedBox(),
              isRentalModule ? const SizedBox(height: Dimensions.paddingSizeExtremeLarge) : const SizedBox(),

              mapView(addressController),
              SizedBox(height: !widget.fromView ? Dimensions.paddingSizeSmall : 0),

              !widget.fromView ? CustomButtonWidget(
                buttonText: 'set_location'.tr,
                onPressed: () async {
                  try{
                    await widget.mapController!.moveCamera(CameraUpdate.newCameraPosition(_cameraPosition));
                    Get.back();
                  }catch(e){
                    showCustomSnackBar('please_setup_the_marker_in_your_required_location'.tr);
                  }
                },
              ) : const SizedBox(),

              SizedBox(height: widget.fromView ? Dimensions.paddingSizeExtremeLarge : 0),

              widget.fromView ? CustomTextFieldWidget(
                hintText: 'write_store_address'.tr,
                labelText: 'address'.tr,
                controller: widget.addressController,
                focusNode: widget.addressFocus,
                inputAction: TextInputAction.done,
                inputType: TextInputType.text,
                capitalization: TextCapitalization.sentences,
                maxLines: 3,
                required: true,
                validator: (value) => ValidateCheck.validateEmptyText(value, "store_address_field_is_required".tr),
              ) : const SizedBox(),

            ]),
          ),
        )),
      );
    });
  }

  Widget mapView(AddressController addressController) {
    return addressController.zoneList!.isNotEmpty ? Center(
      child: Container(
        height: widget.fromView ? 150 : (context.height * 0.87),
        width: MediaQuery.of(context).size.width,
        decoration: widget.fromView ? BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          border: Border.all(width: 1, color: Theme.of(context).primaryColor),
        ) : null,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          child: Stack(clipBehavior: Clip.none, children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  double.parse(Get.find<SplashController>().configModel!.defaultLocation!.lat ?? '0'),
                  double.parse(Get.find<SplashController>().configModel!.defaultLocation!.lng ?? '0'),
                ), zoom: 16,
              ),
              minMaxZoomPreference: const MinMaxZoomPreference(0, 16),
              zoomControlsEnabled: false,
              compassEnabled: false,
              indoorViewEnabled: true,
              mapToolbarEnabled: false,
              myLocationEnabled: false,
              zoomGesturesEnabled: true,
              polygons: _polygons,
              onCameraIdle: () {
                addressController.setLocation(
                  _cameraPosition.target, forStoreRegistration: true,
                  zoneId: addressController.zoneList![addressController.selectedZoneIndex!].id,
                );
                if(!widget.fromView) {
                  widget.mapController!.moveCamera(CameraUpdate.newCameraPosition(_cameraPosition));
                }
              },
              onCameraMove: ((position) => _cameraPosition = position),
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
                _setPolygon(addressController.zoneList![addressController.selectedZoneIndex!]);
              },
              gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()),
                Factory<PanGestureRecognizer>(() => PanGestureRecognizer()),
                Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer()),
                Factory<TapGestureRecognizer>(() => TapGestureRecognizer()),
                Factory<VerticalDragGestureRecognizer>(() => VerticalDragGestureRecognizer()),
              },
            ),
            const Center(child: CustomAssetImageWidget(Images.pickStoreMarker, height: 50, width: 50)),

            Positioned(
              top: widget.fromView ? 10 : 20, left: widget.fromView ? 10 : 20, right: widget.fromView ? null : 20,
              child: InkWell(
                onTap: () async {
                  var p = await Get.dialog(LocationSearchDialogWidget(mapController: _mapController));
                  Position? position = p;
                  if(position != null) {
                    _cameraPosition = CameraPosition(target: LatLng(position.latitude, position.longitude), zoom: 16);
                    if(!widget.fromView) {
                      widget.mapController!.moveCamera(CameraUpdate.newCameraPosition(_cameraPosition));
                      addressController.setLocation(
                        _cameraPosition.target, forStoreRegistration: true,
                        zoneId: addressController.zoneList![addressController.selectedZoneIndex!].id,
                      );
                    }
                  }
                },
                child: Container(
                  height: widget.fromView ? 30 : 40, width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    color: Theme.of(context).cardColor,
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)],
                  ),
                  padding: const EdgeInsets.only(left: 10),
                  alignment: Alignment.centerLeft,
                  child: Text('search'.tr, style: robotoRegular.copyWith(color: Theme.of(context).hintColor)),
                ),
              ),
            ),

            widget.fromView ? Positioned(
              bottom: 50, right: 0,
              child: InkWell(
                onTap: () {
                  Get.to(Scaffold(
                    appBar: CustomAppBarWidget(title: 'set_your_store_location'.tr),
                    body: SelectLocationAndModuleViewWidget(fromView: false, mapController: _mapController),
                  ));
                },
                child: Container(
                  width: 30, height: 30,
                  margin: const EdgeInsets.only(right: Dimensions.paddingSizeDefault),
                  decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                  child: Icon(Icons.fullscreen, color: Theme.of(context).primaryColor, size: 20),
                ),
              ),
            ) : const SizedBox(),

            Positioned(
              bottom: widget.fromView ? 10 : 210, right: 0,
              child: InkWell(
                onTap: () => _checkPermission(() {
                  addressController.getCurrentLocation(mapController: _mapController);
                }),
                child: Container(
                  padding: EdgeInsets.all(widget.fromView ? Dimensions.paddingSizeExtraSmall : Dimensions.paddingSizeSmall),
                  margin: const EdgeInsets.only(right: Dimensions.paddingSizeDefault),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: Colors.white),
                  child: Icon(Icons.my_location_outlined, color: Theme.of(context).primaryColor, size: widget.fromView ? 20 : 25),
                ),
              ),
            ),

            !widget.fromView ? Positioned(
              bottom: 100, right: 0,
              child: Container(
                margin: const EdgeInsets.only(right: Dimensions.paddingSizeDefault),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  color: Theme.of(context).cardColor,
                ),
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  InkWell(
                    onTap: () async {
                      var currentZoomLevel = await _mapController?.getZoomLevel();
                      currentZoomLevel = (currentZoomLevel! + 1);
                      _mapController?.animateCamera(
                        CameraUpdate.newCameraPosition(
                          CameraPosition(
                            target: _cameraPosition.target,
                            zoom: currentZoomLevel,
                          ),
                        ),
                      );
                    },
                    child: const Icon(Icons.add, size: 25),
                  ),
                  const Divider(),

                  InkWell(
                    onTap: () async {
                      var currentZoomLevel = await _mapController?.getZoomLevel();
                      currentZoomLevel = (currentZoomLevel! - 1);
                      _mapController?.animateCamera(
                        CameraUpdate.newCameraPosition(
                          CameraPosition(
                            target: _cameraPosition.target,
                            zoom: currentZoomLevel,
                          ),
                        ),
                      );
                    },
                    child: const Icon(Icons.remove, size: 25),
                  ),
                ]),
              ),
            ) : const SizedBox(),

            !widget.fromView ? Positioned(
              left: 20, right: 20, bottom: 20,
              child: CustomButtonWidget(
                buttonText: addressController.inZone ? 'set_location'.tr : 'not_in_zone'.tr,
                onPressed: addressController.inZone ? () {
                  try{
                    widget.mapController!.moveCamera(CameraUpdate.newCameraPosition(_cameraPosition));
                    Get.back();
                  } catch(e){
                    showCustomSnackBar('please_setup_the_marker_in_your_required_location'.tr);
                  }
                } : null,
              ),
            ) : const SizedBox(),

          ]),
        ),
      ),
    ) : const SizedBox();
  }

  _setPolygon(ZoneModel zoneModel) {
    List<Polygon> polygonList = [];
    List<LatLng> zoneLatLongList = [];

    zoneModel.formatedCoordinates?.forEach((coordinate) {
      zoneLatLongList.add(LatLng(coordinate.lat!, coordinate.lng!));
    });

    polygonList.add(
      Polygon(
        polygonId: PolygonId('${zoneModel.id!}'),
        points: zoneLatLongList,
        strokeWidth: 2,
        strokeColor: Get.theme.colorScheme.primary,
        fillColor: Get.theme.colorScheme.primary.withValues(alpha: .2),
      ),
    );

    _polygons = HashSet<Polygon>.of(polygonList);

    Future.delayed( const Duration(milliseconds: 500),(){
      _mapController?.animateCamera(CameraUpdate.newLatLngBounds(
        boundsFromLatLngList(zoneLatLongList), 100.5,
      ));
    });

    setState(() {});
  }

  static LatLngBounds boundsFromLatLngList(List<LatLng> list) {
    double? x0, x1, y0, y1;
    for (LatLng latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1!) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1!) y1 = latLng.longitude;
        if (latLng.longitude < y0!) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(northeast: LatLng(x1 ?? 0, y1 ?? 0), southwest: LatLng(x0 ?? 0, y0 ?? 0));
  }

  void _checkPermission(Function onTap) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if(permission == LocationPermission.denied) {
      showCustomSnackBar('you_have_to_allow'.tr);
    }else if(permission == LocationPermission.deniedForever) {
      Get.dialog(const PermissionDialogWidget());
    }else {
      onTap();
    }
  }

}
