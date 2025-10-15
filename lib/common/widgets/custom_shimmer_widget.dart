import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sixam_mart_store/util/dimensions.dart';

class CustomShimmerWidget extends StatelessWidget {
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  const CustomShimmerWidget({super.key, this.height, this.width, this.padding, this.margin});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(Dimensions.radiusSmall + 2),
      child: Shimmer(
        child: Container(
          width: width, height: height,
          padding: padding, margin: margin,
          decoration: BoxDecoration(
            color: Theme.of(context).shadowColor,
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall + 2),
          ),
        ),
      ),
    );
  }
}
