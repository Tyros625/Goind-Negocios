import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/util/styles.dart';

class DottedVideoBorder extends StatelessWidget {
  final Function() onTap;
  final String? text;
  final bool showErrorBorder;
  const DottedVideoBorder({super.key, required this.onTap, this.showErrorBorder = false, this.text});


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: DottedBorder(
        dashPattern: const [8, 4],
        strokeWidth: 1,
        borderType: BorderType.RRect,
        color: showErrorBorder ? Theme.of(context).colorScheme.error : Theme.of(context).primaryColor,
        radius: const Radius.circular(10),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.cloud_upload_rounded,
                color: showErrorBorder ? Theme.of(context).colorScheme.error : Theme.of(context).disabledColor,
                size: 30,
              ),
              const SizedBox(height: 5,),
              Text(text ?? "upload_file".tr, textAlign: TextAlign.center,
                style: robotoMedium.copyWith(fontSize: 12,
                  color: showErrorBorder ? Theme.of(context).colorScheme.error : Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
