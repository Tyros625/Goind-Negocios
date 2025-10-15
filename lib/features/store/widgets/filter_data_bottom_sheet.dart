import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/common/widgets/custom_button_widget.dart';
import 'package:sixam_mart_store/features/store/controllers/store_controller.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';

class FilterDataBottomSheet extends StatelessWidget {
  const FilterDataBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StoreController>(builder: (storeController) {
      return Container(
        width: context.width,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(Dimensions.radiusExtraLarge),
            topRight: Radius.circular(Dimensions.radiusExtraLarge),
          ),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const SizedBox(height: Dimensions.paddingSizeLarge),
          Container(
            height: 5, width: 50,
            decoration: BoxDecoration(
              color: Theme.of(context).hintColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeLarge),

          Text('filter_data'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),

          Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('foods_type'.tr, style: robotoBold),
              const SizedBox(height: Dimensions.paddingSizeDefault),

              ...storeController.itemTypeList.map((type) {
                return FilterButton(
                  title: type == 'all' ? 'all_foods'.tr : type == 'veg' ? 'veg_foods'.tr : 'non_veg_foods'.tr,
                  isSelected: storeController.type == type,
                  onTap: () {
                    storeController.updateSelectedFoodType(type);
                  },
                );
              }),
              const SizedBox(height: 30),

              Row(children: [
                !storeController.isFilterClearLoading ? Expanded(
                  child: CustomButtonWidget(
                    buttonText: 'clear_filter'.tr,
                    color: Theme.of(context).hintColor.withValues(alpha: 0.5),
                    textColor: Theme.of(context).textTheme.bodyLarge!.color,
                    onPressed: () {
                      storeController.updateSelectedFoodType('all');
                      storeController.applyFilters(isClearFilter: true);
                    },
                  ),
                ) : const Expanded(child: Center(child: CircularProgressIndicator())),
                const SizedBox(width: Dimensions.paddingSizeDefault),

                !storeController.isLoading ? Expanded(
                  child: CustomButtonWidget(
                    color: Theme.of(context).primaryColor,
                    buttonText: 'filter'.tr,
                    onPressed: () {
                      storeController.applyFilters();
                    },
                  ),
                ) : const Expanded(child: Center(child: CircularProgressIndicator())),
              ]),
            ]),
          ),
        ]),
      );
    });
  }
}

class FilterButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final Function onTap;
  const FilterButton({super.key, required this.title, this.isSelected = false, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: robotoRegular),
          Radio(
            value: isSelected,
            groupValue: true,
            onChanged: (bool? value) {
              onTap();
            },
          ),
        ],
      ),
    );
  }
}
