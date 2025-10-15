import 'package:sixam_mart_store/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart_store/helper/date_converter_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomTimePickerWidget extends StatefulWidget {
  final String title;
  final String? time;
  final Function(String?) onTimeChanged;
  const CustomTimePickerWidget({super.key, required this.title, required this.time, required this.onTimeChanged});

  @override
  State<CustomTimePickerWidget> createState() => _CustomTimePickerWidgetState();
}

class _CustomTimePickerWidgetState extends State<CustomTimePickerWidget> {
  String? _myTime;

  @override
  void initState() {
    super.initState();

    _myTime = widget.time;
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

      InkWell(
        onTap: () async {
          TimeOfDay? time = await showTimePicker(
            context: context, initialTime: TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute),
            builder: (BuildContext context, Widget? child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  alwaysUse24HourFormat: Get.find<SplashController>().configModel!.timeformat == '24',
                ),
                child: child!,
              );
            },
          );
          if(time != null) {
            setState(() {
              _myTime = DateConverterHelper.convertTimeToTime(DateTime(DateTime.now().year, 1, 1, time.hour, time.minute));
            });
            widget.onTimeChanged(_myTime);
          }
        },
        child: Stack(clipBehavior: Clip.none, children: [

          Container(
            height: 50,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              border: Border.all(color: Theme.of(context).disabledColor, width: 0.5),
            ),
            padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeSmall),
            child: Row(children: [

              Expanded(child: Text(
                _myTime != null ? DateConverterHelper.convertStringTimeToTime(_myTime!) : ' - -  : - - ${'min'.tr}', style: robotoRegular.copyWith(color: _myTime != null ? Theme.of(context).textTheme.bodyLarge?.color : Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeDefault),
              )),

              Icon(Icons.access_time_filled, size: 20, color: Theme.of(context).primaryColor),

            ]),
          ),

          Positioned(
            left: 10, top: -15,
            child: Container(
              decoration: BoxDecoration(color: Theme.of(context).cardColor),
              padding: const EdgeInsets.all(5),
              child: Text(widget.title, style: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall)),
            ),
          ),

        ]),
      ),

    ]);
  }
}