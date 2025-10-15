import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/common/widgets/custom_dropdown_widget.dart';
import 'package:sixam_mart_store/features/address/controllers/address_controller.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';

class ZoneSelectionWidget extends StatelessWidget {
  final AddressController addressController;
  final List<DropdownItem<int>> zoneList;
  final Function() callBack;
  const ZoneSelectionWidget({super.key, required this.addressController, required this.zoneList, required this.callBack});

  @override
  Widget build(BuildContext context) {

    return addressController.zoneIds != null ? Stack(clipBehavior: Clip.none, children: [

      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          color: Theme.of(context).cardColor,
          border: Border.all(color: Theme.of(context).disabledColor, width: 0.3),
        ),
        child: CustomDropdown<int>(
          onChange: (int? value, int index) {
            addressController.setZoneIndex(value);
            callBack();
          },
          dropdownButtonStyle: DropdownButtonStyle(
            height: 50,
            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall, horizontal: Dimensions.paddingSizeExtraSmall),
            primaryColor: Theme.of(context).textTheme.bodyLarge!.color,
          ),
          iconColor: Theme.of(context).disabledColor,
          dropdownStyle: DropdownStyle(
            elevation: 10,
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
          ),
          items: zoneList,
          child: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(addressController.selectedZoneIndex == -1 ? 'select_zone'.tr : addressController.zoneList![addressController.selectedZoneIndex!].name.toString()),
          ),
        ),
      ),

      Positioned(
        left: 10, top: -15,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
          ),
          padding: const EdgeInsets.all(5),
          child: Text('select_zone'.tr, style: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeDefault)),
        ),
      ),

    ]) : Center(child: Text('service_not_available_in_this_area'.tr));
  }
}