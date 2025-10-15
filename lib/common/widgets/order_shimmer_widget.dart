import 'package:sixam_mart_store/common/widgets/custom_shimmer_widget.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:flutter/material.dart';

class OrderShimmerWidget extends StatelessWidget {
  final bool isEnabled;
  const OrderShimmerWidget({super.key, required this.isEnabled});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomShimmerWidget(height: 15, width: 100),
                  SizedBox(height: Dimensions.paddingSizeExtraSmall),
                  CustomShimmerWidget(height: 10, width: 150),
                ],
              ),
              Icon(
                Icons.keyboard_arrow_right,
                size: 30,
                color: Theme.of(context).disabledColor,
              ),
            ],
          ),
        ),
        Divider(color: Theme.of(context).disabledColor),
      ],
    );
  }
}
