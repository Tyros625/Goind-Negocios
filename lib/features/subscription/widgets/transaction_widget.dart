import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/common/widgets/custom_bottom_sheet_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:sixam_mart_store/features/subscription/controllers/subscription_controller.dart';
import 'package:sixam_mart_store/features/subscription/domain/models/subscription_transaction_model.dart';
import 'package:sixam_mart_store/features/subscription/widgets/transaction_details_bottom_sheet.dart';
import 'package:sixam_mart_store/helper/date_converter_helper.dart';
import 'package:sixam_mart_store/helper/price_converter_helper.dart';
import 'package:sixam_mart_store/helper/string_extensions.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';

class TransactionWidget extends StatefulWidget {
  const TransactionWidget({super.key});

  @override
  State<TransactionWidget> createState() => _TransactionWidgetState();
}

class _TransactionWidgetState extends State<TransactionWidget> {

  final TextEditingController _searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent
          && Get.find<SubscriptionController>().transactions != null
          && !Get.find<SubscriptionController>().isLoading) {
        int pageSize = (Get.find<SubscriptionController>().pageSize! / 10).ceil();
        if (Get.find<SubscriptionController>().offset < pageSize) {
          Get.find<SubscriptionController>().setOffset(Get.find<SubscriptionController>().offset+1);
          debugPrint('end of the page');
          Get.find<SubscriptionController>().showBottomLoader();
          Get.find<SubscriptionController>().getSubscriptionTransactionList(
            offset: Get.find<SubscriptionController>().offset.toString(),
            from: Get.find<SubscriptionController>().from, to: Get.find<SubscriptionController>().to,
            searchText: Get.find<SubscriptionController>().searchText,
          );
        }
      }
    });
  }

  Future<void> _onRefresh() async {
    Get.find<SubscriptionController>().initSetDate();
    Get.find<SubscriptionController>().setOffset(1);

    await Get.find<SubscriptionController>().getSubscriptionTransactionList(
      offset: Get.find<SubscriptionController>().offset.toString(),
      from: Get.find<SubscriptionController>().from, to: Get.find<SubscriptionController>().to,
      searchText: Get.find<SubscriptionController>().searchText,
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SubscriptionController>(builder: (subscriptionController) {
      return Column(children: [

        Padding(
          padding: const EdgeInsets.only(
            top: Dimensions.paddingSizeLarge, left: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeDefault, bottom: Dimensions.paddingSizeSmall,
          ),
          child: Row(children: [

            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: '${'search'.tr}...',
                  hintStyle: robotoRegular.copyWith(color: Theme.of(context).disabledColor),
                  contentPadding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Theme.of(context).disabledColor.withValues(alpha: 0.4)),
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Theme.of(context).disabledColor.withValues(alpha: 0.4)),
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(subscriptionController.searchMode ? Icons.clear : CupertinoIcons.search, color: Theme.of(context).disabledColor),
                    onPressed: (){
                      if(!subscriptionController.searchMode){
                        if(_searchController.text.isNotEmpty){
                          subscriptionController.setSearchText(offset: '1', from: subscriptionController.from, to: subscriptionController.to, searchText: _searchController.text);
                        }else{
                          showCustomSnackBar('your_search_box_is_empty'.tr);
                        }
                      }else if(subscriptionController.searchMode){
                        _searchController.text = '';
                        subscriptionController.setSearchText(offset: '1', from: subscriptionController.from, to: subscriptionController.to, searchText: _searchController.text);
                      }
                    },
                  ),
                ),
                onSubmitted: (value){
                  if(value.isNotEmpty){
                    subscriptionController.setSearchText(offset: '1', from: subscriptionController.from, to: subscriptionController.to, searchText: value);
                  }else{
                    showCustomSnackBar('your_search_box_is_empty'.tr);
                  }
                },
              ),
            ),
            const SizedBox(width: Dimensions.paddingSizeSmall),

            InkWell(
              onTap: () => subscriptionController.showDatePicker(context),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  border: Border.all(color: Theme.of(context).disabledColor.withValues(alpha: 0.4)),
                ),
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall + 3),
                child: Icon(Icons.calendar_today_outlined, color: Theme.of(context).disabledColor, size: 20),
              ),
            ),

          ]),
        ),

        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text('from'.tr, style: robotoMedium.copyWith(color: Theme.of(context).disabledColor)),
          const SizedBox(width: Dimensions.fontSizeExtraSmall),

          Container(
            padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
            ),
            child: Text(DateConverterHelper.convertDateToDate(subscriptionController.from!), style: robotoMedium),
          ),
          const SizedBox(width: 5),

          Text('to'.tr, style: robotoMedium.copyWith(color: Theme.of(context).disabledColor)),
          const SizedBox(width: 5),

          Container(
            padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
            ),
            child: Text(DateConverterHelper.convertDateToDate(subscriptionController.to!), style: robotoMedium),
          ),

        ]),

        Expanded(
          child: RefreshIndicator(
            onRefresh: _onRefresh,
            child: subscriptionController.transactions != null ? subscriptionController.transactions!.isNotEmpty ? ListView.builder(
              controller: scrollController,
              shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: subscriptionController.transactions?.length,
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              itemBuilder: (context, index) {

                Transactions transactions = subscriptionController.transactions![index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
                  child: InkWell(
                    onTap: () {
                      showCustomBottomSheet(
                        child: TransactionDetailsBottomSheet(transactions: transactions),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                        boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.2), spreadRadius: 1, blurRadius: 10, offset: const Offset(0, 1))],
                      ),
                      child: Column(children: [

                        Container(
                          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor.withValues(alpha: 0.8),
                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(Dimensions.radiusSmall), topRight: Radius.circular(Dimensions.radiusSmall)),
                            boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.1), spreadRadius: 1, blurRadius: 5, offset: const Offset(0, 1))],
                          ),
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                            Row(children: [
                              Text('${'transaction_id'.tr} # ', style: robotoRegular),
                              Text(transactions.id!, style: robotoBold),
                            ]),

                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                              decoration: BoxDecoration(
                                color: transactions.planType == 'renew' ? Theme.of(context).primaryColor.withValues(alpha: 0.1) : transactions.planType == 'new_plan' ? Colors.blue.withValues(alpha: 0.1) : Colors.deepOrange.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                              ),
                              child: Text(
                                transactions.planType == 'renew' ? 'renewed'.tr : transactions.planType == 'new_plan' ? 'migrated'.tr : transactions.planType == 'free_trial' ? 'free_trial'.tr : 'purchased'.tr,
                                style: robotoMedium.copyWith(
                                  fontSize: Dimensions.fontSizeSmall,
                                  color: transactions.planType == 'renew' ? Theme.of(context).primaryColor : transactions.planType == 'new_plan' ? Colors.blue : Colors.deepOrange.withValues(alpha: 0.9),
                                ),
                              ),
                            ),

                          ]),
                        ),

                        Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                            Text(DateConverterHelper.utcToDateTime(transactions.createdAt!), style: robotoRegular.copyWith(color: Theme.of(context).disabledColor)),
                            const SizedBox(width: Dimensions.paddingSizeDefault),

                            Flexible(child: Text(transactions.package?.packageName ?? '', style: robotoRegular.copyWith(color: Theme.of(context).disabledColor), overflow: TextOverflow.ellipsis, maxLines: 1)),

                          ]),
                        ),

                        Padding(padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeDefault, bottom: Dimensions.paddingSizeDefault),
                          child: Row(children: [

                            Text('${'paid_by'.tr} - ', style: robotoRegular),
                            SizedBox(
                              width: context.width * 0.5,
                              child: Text(transactions.paymentMethod?.replaceAll('_', ' ').toTitleCase() ?? '', style: robotoMedium.copyWith(color: Colors.blue)),
                            ),

                            const Spacer(),


                            Text(PriceConverterHelper.convertPrice(transactions.paidAmount), style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),

                          ]),
                        ),

                      ]),
                    ),
                  ),
                );
              },
            ) : SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: context.height * 0.6,
                child: Center(child: Text('no_transaction_found'.tr, style: robotoMedium)),
              ),
            ) : SizedBox(
              height: context.height * 0.6,
              child: const Center(child: CircularProgressIndicator()),
            ),
          ),
        ),

      ]);
    });
  }
}
