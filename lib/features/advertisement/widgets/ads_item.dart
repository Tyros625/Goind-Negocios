import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/common/widgets/custom_asset_image_widget.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';

class AdsCard extends StatelessWidget {
  final String img;
  final String title;
  final String subTitle;
  final TextStyle? subtitleTextStyle;
  final MainAxisAlignment mainAxisAlignment;
  const AdsCard({super.key, required this.img, required this.title, required this.subTitle, this.mainAxisAlignment = MainAxisAlignment.start,  this.subtitleTextStyle});
  
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomAssetImageWidget(img, height: 15, width: 15),
        const SizedBox(width:Dimensions.paddingSizeSmall),

        Expanded(
          child: Row(
            mainAxisAlignment: mainAxisAlignment,
            children: [
              Flexible(
                child: Text(title.tr,
                  style: robotoRegular.copyWith(
                    fontSize: Dimensions.fontSizeSmall + 1,
                    color:Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.65),
                  ),
                  maxLines: 2, overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(subTitle,
                style: subtitleTextStyle ?? robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeSmall + 1,
                  color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.65),
                ),
                maxLines: 2, overflow: TextOverflow.ellipsis, textDirection: TextDirection.ltr,
              ),
            ],
          ),
        ),
      ],
    );
  }
}