import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/common/widgets/custom_button_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_image_widget.dart';
import 'package:sixam_mart_store/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart_store/features/store/domain/models/review_model.dart';
import 'package:sixam_mart_store/helper/date_converter_helper.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';

class ReviewCardWidget extends StatelessWidget {
  final ReviewModel review;
  const ReviewCardWidget({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
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
              Text('${'review_id'.tr} # ', style: robotoRegular),
              Text(review.reviewId != null ? review.reviewId.toString() : '', style: robotoBold),
            ]),

            Text(DateConverterHelper.utcToDateTime(review.createdAt!), style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor)),

          ]),
        ),

        Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: Row(children: [

            ClipRRect(
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              child: CustomImageWidget(
                image: '${review.itemImageFullUrl}',
                height: 60, width: 60, fit: BoxFit.cover,
                placeholder: Images.placeholder,
              ),
            ),
            const SizedBox(width: Dimensions.paddingSizeDefault),

            Expanded(
              child: Text(review.itemName ?? '', style: robotoBold, overflow: TextOverflow.ellipsis, maxLines: 1),
            ),
            const SizedBox(width: Dimensions.paddingSizeDefault),

            Get.find<SplashController>().configModel!.storeReviewReply ?? false ? CustomButtonWidget(
              onPressed: () => Get.toNamed(RouteHelper.getReviewReplyRoute(isGiveReply: review.reply != null ? false : true, review: review,  storeReviewReplyStatus: Get.find<SplashController>().configModel!.storeReviewReply!)),
              width: 95, height: 40,
              radius: 8,
              fontWeight: FontWeight.w500,
              fontSize: Dimensions.fontSizeDefault,
              buttonText: review.reply != null ? 'view_reply'.tr : 'give_reply'.tr,
              color: review.reply != null ? Theme.of(context).primaryColor.withValues(alpha: 0.1) : Theme.of(context).primaryColor,
              isViewReply: review.reply != null,
            ) : CustomButtonWidget(
              onPressed: () => Get.toNamed(RouteHelper.getReviewReplyRoute(isGiveReply: review.reply != null ? false : true, review: review, storeReviewReplyStatus: Get.find<SplashController>().configModel!.storeReviewReply!)),
              width: 95, height: 40,
              radius: 8,
              fontWeight: FontWeight.w500,
              fontSize: Dimensions.fontSizeDefault,
              buttonText: 'view'.tr,
              color: Theme.of(context).primaryColor,
            ),

          ]),
        ),

        Divider(height: 0, thickness: 1, color: Theme.of(context).disabledColor.withValues(alpha: 0.2)),

        Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            Text('reviewer'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor)),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

              Text(review.customerName ?? '', style: robotoBold),

              Text(review.customerPhone ?? '', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor)),

            ]),

          ]),
        ),

      ]),
    );
  }
}
