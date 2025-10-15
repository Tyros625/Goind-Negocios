import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/common/widgets/custom_image_widget.dart';
import 'package:sixam_mart_store/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';

class PreviewProviderPromotionWidget extends StatelessWidget {
  final String? title;
  final String? description;
  final String? validation;
  final String? networkCoverImage;
  final String? pickedCoverImage;
  final String? pickedProfileImage;
  final String? networkProfileImage;
  final bool? isShowRatings;
  final bool? isShowReview;

  const PreviewProviderPromotionWidget({
    super.key,
    this.title,
    this.description,
    this.validation,
    this.networkCoverImage,
    this.pickedCoverImage,
    this.networkProfileImage,
    this.pickedProfileImage,
    this.isShowRatings,
    this.isShowReview
  });

  @override
  Widget build(BuildContext context) {
    return  Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
      insetPadding: const EdgeInsets.all(10),
      clipBehavior: Clip.antiAlias,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          color: Theme.of(context).cardColor,
        ),
        margin: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeLarge),
        child: Column(mainAxisSize:  MainAxisSize.min, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text("ads_preview".tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault)),
            InkWell(
              onTap: ()=> Get.back(),
              child: Icon(Icons.clear, color: Theme.of(context).hintColor, size: 20,),
            )
          ]),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          SizedBox(
            height: Get.size.height * 0.35,
            child: Stack(
              clipBehavior: Clip.none,
              children: [

                Padding(
                  padding: const EdgeInsets.only(bottom: 70),
                  child: AspectRatio(
                    aspectRatio: 16/9,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                          color: Theme.of(context).hintColor.withValues(alpha: 0.1),
                          border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.2)),
                        ),
                        padding: const EdgeInsets.only(bottom: 25),
                        child: pickedCoverImage != null && pickedCoverImage!.isNotEmpty
                            ? Image.file(File(pickedCoverImage!), fit: BoxFit.cover)
                            : networkCoverImage != null && networkCoverImage!.isNotEmpty ? CustomImageWidget(
                          image: networkCoverImage!,
                          fit: BoxFit.cover,
                        ) : const SizedBox(),
                      ),
                    ),
                  ),
                ),

                Positioned(
                  right: 10, top: Get.size.height * 0.14,
                  child: (isShowRatings != null && isShowRatings!) || (isShowReview != null && isShowReview!) ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                      color: Theme.of(context).primaryColor,
                      border: Border.all(color: Theme.of(context).cardColor),
                      boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
                    ),
                    padding: const EdgeInsets.all(3),
                    child: Row(children: [
                      isShowRatings != null && isShowRatings! ? Row(children: [
                        Icon(Icons.star, color: Theme.of(context).cardColor, size: 16),
                        const SizedBox(width: 2),
                        Text('${Get.find<ProfileController>().profileModel!.stores![0].avgRating ?? 0.0}', style: robotoMedium.copyWith(color: Theme.of(context).cardColor))
                      ]) : const SizedBox(),
                      const SizedBox(width: 5),

                      isShowReview != null && isShowReview! ? Text(
                        '(${Get.find<ProfileController>().profileModel!.stores![0].ratingCount ?? 0}+)',
                        style: robotoRegular.copyWith(color: Theme.of(context).cardColor),
                      ) : const SizedBox(),
                    ]),
                  ) : const SizedBox(),
                ),

                Positioned(bottom: 0, left: 0, right: 0, child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(Dimensions.radiusLarge), bottomRight: Radius.circular(Dimensions.radiusLarge)),
                    color: Theme.of(context).cardColor,
                    boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
                  ),
                  padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  child: Row(children: [

                    SizedBox(
                      height: 60, width: 60,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge * 2),
                        child: networkProfileImage != null && networkProfileImage!.isNotEmpty ? CustomImageWidget(
                          image: networkProfileImage!,
                          fit: BoxFit.cover,
                        ) : pickedProfileImage != null && pickedProfileImage!.isNotEmpty ? Image.file(File(pickedProfileImage!), fit: BoxFit.cover)
                            : Container(color: Theme.of(context).hintColor.withValues(alpha: 0.2)),
                      ),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeDefault),

                    Expanded(
                      child: Column( crossAxisAlignment: CrossAxisAlignment.start, children: [
                        title == null || title!.isEmpty ? Container(
                          height: 17, width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                            color: Theme.of(context).hintColor.withValues(alpha: 0.1),
                          ),
                        ) : Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Expanded(
                            child: Text(title!, maxLines: 1, overflow: TextOverflow.ellipsis,
                              style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge),
                            ),
                          ),
                          const SizedBox(width: Dimensions.paddingSizeDefault),
                          Icon(Icons.favorite_outline, color: Theme.of(context).primaryColor),

                        ]),
                        const SizedBox(height: Dimensions.paddingSizeExtraSmall),


                        description == null || description!.isEmpty ? Container(
                          height: 17, width: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                            color: Theme.of(context).hintColor.withValues(alpha: 0.1),
                          ),
                        ): Text(description!, maxLines: 2, overflow: TextOverflow.ellipsis, style: robotoRegular.copyWith(
                          color: Theme.of(context).hintColor,
                        )),
                        const SizedBox(height: Dimensions.paddingSizeDefault),
                      ]),
                    ),
                  ]),
                ))
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
