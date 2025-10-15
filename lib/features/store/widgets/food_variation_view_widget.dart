import 'package:flutter/cupertino.dart';
import 'package:sixam_mart_store/common/widgets/label_widget.dart';
import 'package:sixam_mart_store/features/store/controllers/store_controller.dart';
import 'package:sixam_mart_store/features/store/domain/models/item_model.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/common/widgets/custom_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FoodVariationViewWidget extends StatefulWidget {
  final StoreController storeController;
  final Item? item;
  const FoodVariationViewWidget({super.key, required this.storeController, required this.item});

  @override
  State<FoodVariationViewWidget> createState() => _FoodVariationViewWidgetState();
}

class _FoodVariationViewWidgetState extends State<FoodVariationViewWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

      Row(
        children: [
          Text('food_variation'.tr, style: robotoBold),
          Text(' (${'optional'.tr})', style: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall)),
        ],
      ),
      const SizedBox(height: Dimensions.paddingSizeSmall),

      widget.storeController.variationList!.isNotEmpty ? ListView.builder(
        itemCount: widget.storeController.variationList!.length,
        shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemBuilder: (context, index){
          return Container(
            margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall + 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault - 2),
              color: Theme.of(context).cardColor,
              boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
            ),
            child: Column(children: [

              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('${'variation'.tr} ${index + 1}', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault)),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                  Row(children: [

                    SizedBox(
                      height: 24, width: 24,
                      child: Checkbox(
                        activeColor: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
                        value: widget.storeController.variationList![index].required,
                        onChanged: (value){
                          widget.storeController.setVariationRequired(index);
                        },
                      ),
                    ),
                    const SizedBox(width: 5),

                    Text('required_this_variation'.tr, style: robotoRegular.copyWith(color: Theme.of(context).hintColor)),

                  ]),

                ]),
                const Spacer(),

                InkWell(
                  onTap: () => widget.storeController.removeVariation(index),
                  child: Container(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall + 2),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.error,
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    ),
                    child: Icon(CupertinoIcons.delete, size: 20, color: Theme.of(context).cardColor),
                  ),
                ),

              ]),
              const SizedBox(height: Dimensions.paddingSizeDefault),

              CustomTextFieldWidget(
                hintText: 'variation_name'.tr,
                labelText: 'variation_name'.tr,
                controller: widget.storeController.variationList![index].nameController,
              ),
              const SizedBox(height: Dimensions.paddingSizeExtraLarge),

              LabelWidget(
                labelText: 'options_selection_type'.tr,
                child: Row(children: [

                  Expanded(
                    child: Row(children: [

                      Radio(
                        value: true,
                        groupValue: widget.storeController.variationList![index].isSingle,
                        onChanged: (bool? value){
                          widget.storeController.changeSelectVariationType(index);
                        },
                        fillColor: WidgetStateProperty.all<Color>(
                          widget.storeController.variationList![index].isSingle ? Theme.of(context).primaryColor : Theme.of(context).disabledColor,
                        ),
                      ),

                      Text(
                        'single_selection'.tr, style: robotoMedium.copyWith(
                        fontSize: Dimensions.fontSizeSmall, color: widget.storeController.variationList![index].isSingle ? Theme.of(context).textTheme.bodyLarge?.color : Theme.of(context).disabledColor),
                      ),

                    ]),
                  ),

                  Expanded(
                    child: Row(children: [

                      Radio(
                        value: false,
                        groupValue: widget.storeController.variationList![index].isSingle,
                        onChanged: (bool? value){
                          widget.storeController.changeSelectVariationType(index);
                        },
                        fillColor: WidgetStateProperty.all<Color>(
                          widget.storeController.variationList![index].isSingle ? Theme.of(context).disabledColor : Theme.of(context).primaryColor,
                        ),
                      ),

                      Text(
                        'multi_selection'.tr, style: robotoMedium.copyWith(
                         fontSize: Dimensions.fontSizeSmall, color: widget.storeController.variationList![index].isSingle ? Theme.of(context).disabledColor : Theme.of(context).textTheme.bodyLarge?.color),
                      ),

                    ]),
                  ),

                ]),
              ),
              SizedBox(height: !widget.storeController.variationList![index].isSingle ? Dimensions.paddingSizeExtraLarge : 0),

              Visibility(
                visible: !widget.storeController.variationList![index].isSingle,
                child: Row(children: [
                  Flexible(child: CustomTextFieldWidget(
                    hintText: 'min_selection'.tr,
                    labelText: 'min_selection'.tr,
                    inputType: TextInputType.number,
                    isNumber: true,
                    controller: widget.storeController.variationList![index].minController,
                  )),
                  const SizedBox(width: Dimensions.paddingSizeSmall),

                  Flexible(child: CustomTextFieldWidget(
                    hintText: 'max_selection'.tr,
                    labelText: 'max_selection'.tr,
                    inputType: TextInputType.number,
                    isNumber: true,
                    controller: widget.storeController.variationList![index].maxController,
                  )),
                ]),
              ),
              const SizedBox(height: Dimensions.paddingSizeExtraLarge),

              ListView.builder(
                itemCount: widget.storeController.variationList![index].options!.length,
                shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemBuilder: (context, i) {
                  return Stack(clipBehavior: Clip.none, children: [
                    Container(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeExtraLarge),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault - 2),
                        color: Theme.of(context).disabledColor.withValues(alpha: 0.08),
                      ),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('selection_option'.tr, style: robotoMedium),
                        const SizedBox(height: Dimensions.paddingSizeDefault),

                        CustomTextFieldWidget(
                          hintText: 'option_name'.tr,
                          labelText: 'option_name'.tr,
                          controller: widget.storeController.variationList![index].options![i].optionNameController,
                        ),
                        const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                        CustomTextFieldWidget(
                          hintText: 'additional_price'.tr,
                          labelText: 'additional_price'.tr,
                          isAmount: true,
                          controller: widget.storeController.variationList![index].options![i].optionPriceController,
                          inputType: TextInputType.number,
                          inputAction: TextInputAction.done,
                        ),
                      ]),
                    ),

                    widget.storeController.variationList![index].options!.length > 1 ? Positioned(
                      top: -10, right: -10,
                      child: InkWell(
                        onTap: () {
                          widget.storeController.removeOptionVariation(index, i);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
                            shape: BoxShape.circle,
                            border: Border.all(color: Theme.of(context).colorScheme.error.withValues(alpha: 0.5), width: 0.5),
                          ),
                          child: Icon(Icons.close, size: 20, color: Theme.of(context).colorScheme.error),
                        ),
                      ),
                    ) : const SizedBox(),
                    
                  ]);
                },
              ),

              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () {
                    widget.storeController.addOptionVariation(index);
                  },
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.add, size: 20, color: Theme.of(context).primaryColor),
                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                    Text('new_option'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).primaryColor)),
                  ]),
                ),
              ),

            ]),
          );
        },
      ) : const SizedBox(),

      widget.storeController.variationList!.isNotEmpty ? InkWell(
        onTap: () {
          widget.storeController.addVariation();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
          decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
          child: Text('new_variation'.tr, style: robotoMedium.copyWith(color: Theme.of(context).cardColor, fontSize: Dimensions.fontSizeDefault)),
        ),
      ) : Container(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
        ),
        child: InkWell(
          onTap: () {
            widget.storeController.addVariation();
          },
          child: Container(
            width: context.width,
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeLarge),
            decoration: BoxDecoration(color: Theme.of(context).disabledColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
            child: Column(children: [

              const Icon(Icons.add, size: 24),

              Text('add_variation'.tr, style: robotoRegular.copyWith(color: Theme.of(context).disabledColor)),

            ]),
          ),
        ),
      ),

      const SizedBox(height: Dimensions.paddingSizeLarge),

    ]);
  }
}