import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/common/widgets/custom_button_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_text_field_widget.dart';
import 'package:sixam_mart_store/features/store/controllers/store_controller.dart';
import 'package:sixam_mart_store/features/store/domain/models/item_model.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';

class UpdateStockBottomSheet extends StatefulWidget {
  final Item item;
  final Function(bool success) onSuccess;
  const UpdateStockBottomSheet({super.key, required this.item, required this.onSuccess});

  @override
  State<UpdateStockBottomSheet> createState() => _UpdateStockBottomSheetState();
}

class _UpdateStockBottomSheetState extends State<UpdateStockBottomSheet> {

  TextEditingController mainStockController = TextEditingController();
  late List<TextEditingController> variationStockControllers;
  late List<TextEditingController> priceControllers;

  int totalStock = 0;

  @override
  void initState() {
    super.initState();
    totalStock = widget.item.stock ?? 0;

    mainStockController.text = totalStock.toString();
    variationStockControllers = widget.item.variations!.map((variation) => TextEditingController(
      text: variation.stock.toString(),
    )).toList();
    priceControllers = widget.item.variations!.map((variation) => TextEditingController(
      text: variation.price.toString(),
    )).toList();
  }

  void _setTotalStock() {
    totalStock = 0;
    for (TextEditingController stockController in variationStockControllers) {
      totalStock = stockController.text.trim().isNotEmpty ? totalStock + int.parse(stockController.text.trim()) : totalStock;
    }
    mainStockController.text = totalStock.toString();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width,
      constraints: BoxConstraints(maxHeight: context.height * 0.8, minHeight: 0.3),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(Dimensions.radiusExtraLarge), topRight: Radius.circular(Dimensions.radiusExtraLarge),
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

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: Dimensions.paddingSizeDefault),

            Text(widget.item.name ?? '', style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge)),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            Text('total_quantity'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            CustomTextFieldWidget(
              hintText: 'enter_stock'.tr,
              controller: mainStockController,
              inputType: TextInputType.number,
              isNumber: true,
              isEnabled: variationStockControllers.isEmpty,
            ),
          ]),
        ),
        SizedBox(height: variationStockControllers.isNotEmpty ? Dimensions.paddingSizeDefault : Dimensions.paddingSizeExtraLarge),

        variationStockControllers.isNotEmpty ? Flexible(
          child: SingleChildScrollView(
            child: Container(
              width: context.width,
              padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
              margin: const EdgeInsets.all(Dimensions.paddingSizeLarge),
              decoration: BoxDecoration(
                color: Theme.of(context).hintColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                Row(children: [
                  Expanded(flex: 3, child: Text('variation'.tr, style: robotoMedium)),

                  Expanded(flex: 3, child: Text('price'.tr, style: robotoMedium)),
                  const SizedBox(width: Dimensions.paddingSizeSmall),

                  Expanded(flex: 3, child: Text('stock'.tr, style: robotoMedium)),
                ]),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                ListView.builder(
                  itemCount: variationStockControllers.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 0),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Expanded(flex: 3, child: Text(widget.item.variations![index].type!, style: robotoRegular)),

                          Expanded(
                            flex: 3,
                            child: CustomTextFieldWidget(
                              hintText: 'enter_price'.tr,
                              controller: priceControllers[index],
                              inputType: TextInputType.number,
                              isAmount: true,
                            ),
                          ),
                          const SizedBox(width: Dimensions.paddingSizeSmall),

                          Expanded(
                            flex: 3,
                            child: CustomTextFieldWidget(
                              hintText: 'enter_stock'.tr,
                              controller: variationStockControllers[index],
                              inputType: TextInputType.number,
                              isNumber: true,
                              onChanged: (String text) => _setTotalStock(),
                            ),
                          ),
                          // const Divider(),
                        ]),
                        const SizedBox(height: Dimensions.paddingSizeSmall),

                      ]),
                    );
                  },
                ),

              ]),
            ),
          ),
        ) : const SizedBox(),

        Container(
          padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
          ),
          child: Row(children: [

            Expanded(
              child: CustomButtonWidget(
                buttonText: 'cancel'.tr,
                color: Theme.of(context).disabledColor.withValues(alpha: 0.4),
                textColor: Theme.of(context).textTheme.bodyLarge!.color,
                onPressed: () {
                  Get.back();
                },
              ),
            ),
            const SizedBox(width: Dimensions.paddingSizeDefault),

            Expanded(
              child: GetBuilder<StoreController>(
                builder: (storeController) {
                  return !storeController.isLoading ? CustomButtonWidget(
                    color: Theme.of(context).primaryColor,
                    buttonText: 'update'.tr,
                    onPressed: () {
                      if(mainStockController.text == '0' || variationStockControllers.any((element) => element.text == '0')){
                        showCustomSnackBar('stock_cannot_be_zero'.tr);
                      }else{
                        _updateStock(storeController);
                      }
                    },
                  ) : const Center(child: CircularProgressIndicator());
                }
              ),
            ),
          ]),
        ),

      ]),
    );
  }

  void _updateStock(StoreController storeController) {
    Map<String, String> data = {};
    data.addAll({"_method": 'put'});
    data.addAll({"product_id": widget.item.id.toString()});
    data.addAll({"current_stock": mainStockController.text.trim()});
    for (var variation in widget.item.variations!) {
      data.addAll({"price_${widget.item.variations!.indexOf(variation)}_${variation.type}": priceControllers[widget.item.variations!.indexOf(variation)].text.trim()});
    }
    List<String> types = [];
    for (var variation in widget.item.variations!) {
      types.add(variation.type!);
    }
    data.addAll({"type": jsonEncode(types)});
    for (var variation in widget.item.variations!) {
      data.addAll({"stock_${widget.item.variations!.indexOf(variation)}_${variation.type}": variationStockControllers[widget.item.variations!.indexOf(variation)].text.trim()});
    }

    storeController.stockUpdate(data, widget.item.id!).then((isSuccess) {
      widget.onSuccess(isSuccess);
    });
  }

}
