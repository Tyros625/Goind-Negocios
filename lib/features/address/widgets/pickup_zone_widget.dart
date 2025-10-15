import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/common/widgets/custom_drop_down_button.dart.dart';
import 'package:sixam_mart_store/features/address/controllers/address_controller.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';

class PickupZoneWidget extends StatelessWidget {
  const PickupZoneWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddressController>(builder: (addressController) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        CustomDropdownButton(
          dropdownMenuItems: addressController.zoneList?.map((e) {
            bool isInPickupZoneList = addressController.pickupZoneList.contains(e.name);
            return DropdownMenuItem<String>(
              value: e.name,
              child: Row(
                children: [
                  Text(e.name!, style: robotoRegular),
                  const Spacer(),
                  if (isInPickupZoneList)
                    const Icon(Icons.check, color: Colors.green),
                ],
              ),
            );
          }).toList(),
          showTitle: false,
          hintText: 'select_pick_zone'.tr,
          onChanged: (String? value) {
            final selectedZone = addressController.zoneList?.firstWhere((zone) => zone.name == value);
            if (selectedZone != null) {
              addressController.setSelectedPickupZone(selectedZone.name, selectedZone.id);
            }
          },
          selectedValue: addressController.selectedPickupZone,
        ),
        SizedBox(height: addressController.pickupZoneList.isNotEmpty ? Dimensions.paddingSizeSmall : 0),

        Wrap(
          children: List.generate(addressController.pickupZoneList.length, (index) {
            final zoneName = addressController.pickupZoneList[index];
            final zoneId = addressController.pickupZoneIdList[index];
            return Padding(
              padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
              child: Stack(clipBehavior: Clip.none, children: [
                FilterChip(
                  label: Text(zoneName),
                  selected: false,
                  onSelected: (bool value) {},
                ),

                Positioned(
                  right: -5,
                  top: 0,
                  child: InkWell(
                    onTap: () {
                      addressController.removePickupZone(zoneName, zoneId);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.red, width: 1),
                      ),
                      child: const Icon(Icons.close, size: 15, color: Colors.red),
                    ),
                  ),
                ),
              ]),
            );
          }),
        ),
      ]);
    });
  }
}