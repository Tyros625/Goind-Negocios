import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:flutter/material.dart';

class ItemShimmerWidget extends StatelessWidget {
  final bool isEnabled;
  final bool hasDivider;
  const ItemShimmerWidget({super.key, required this.isEnabled, required this.hasDivider});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2, spreadRadius: 0)],
      ),
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
      child: Row(children: [

        Shimmer(
          child: Container(
            width: 90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              color: Theme.of(context).shadowColor,
            ),
          ),
        ),
        const SizedBox(width: Dimensions.paddingSizeSmall),

        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Shimmer(child: Container(height: 15, width: double.maxFinite, color: Theme.of(context).shadowColor)),
            Shimmer(child: Container(height: 10, width: 120, color: Theme.of(context).shadowColor)),
            Shimmer(child: Container(height: 12, width: 70, color: Theme.of(context).shadowColor)),
            Shimmer(child: Container(height: 10, width: 120, color: Theme.of(context).shadowColor)),
          ]),
        ),
        const SizedBox(width: 15),

        Row(children: [
          Icon(Icons.add_circle, size: 25, color: Theme.of(context).shadowColor),
          Icon(Icons.edit, size: 25, color: Theme.of(context).shadowColor),
          Icon(Icons.delete,  size: 25, color: Theme.of(context).shadowColor),
        ]),

      ]),
    );
  }
}
