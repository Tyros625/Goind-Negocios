import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/features/advertisement/controllers/advertisement_controller.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:video_player/video_player.dart';

class PreviewVideoDialogWidget extends StatelessWidget {
  final String? title;
  final String? description;

  const PreviewVideoDialogWidget({super.key, this.title, this.description});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
      insetPadding: const EdgeInsets.all(10),
      clipBehavior: Clip.antiAlias,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      child: GetBuilder<AdvertisementController>(
        builder: (advertisementController) {
          return Padding(padding: const EdgeInsets.only(bottom: 100),
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  color: Theme.of(context).cardColor,
                ),
                margin: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeLarge),
                child:  Column(mainAxisSize:  MainAxisSize.min, children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                    Text("ads_preview".tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault)),

                    InkWell(
                      onTap: ()=> Get.back(),
                      child: Icon(Icons.clear, color: Theme.of(context).hintColor, size: 20,),
                    ),
                  ]),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  SizedBox(
                    height: Get.size.height * 0.35,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        advertisementController.videoPlayerController != null && advertisementController.videoPlayerController!.value.isInitialized ?
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            AspectRatio(
                              aspectRatio: 16/9,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                child: VideoPlayer(advertisementController.videoPlayerController!),
                              ),
                            ),


                            FloatingActionButton.small(
                              backgroundColor: Theme.of(context).disabledColor,
                              onPressed: (){
                                // setState(() {
                                //   advertisementController.videoPlayerController!.value.isPlaying
                                //       ? advertisementController.videoPlayerController!.pause()
                                //       : advertisementController.videoPlayerController!.play();
                                // });
                              },
                              child: Icon(
                                advertisementController.videoPlayerController!.value.isPlaying ? Icons.pause : Icons.play_arrow,
                                color: Theme.of(context).cardColor,
                              ),
                            )
                          ],
                        ) : Padding(padding: const EdgeInsets.only(bottom: 50),
                          child: AspectRatio(
                            aspectRatio: 16/9,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                                color: Theme.of(context).hintColor.withValues(alpha: 0.1),
                                border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.2))
                              ),
                              padding: const EdgeInsets.only(bottom: 25),
                              child: const Center(child: Icon(Icons.play_circle, color: Colors.white,size: 45,),),
                            ),
                          ),
                        ),

                        Positioned(bottom: 0, left: 0, right: 0, child: Container(
                          width: Get.width,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(Dimensions.radiusLarge), bottomRight: Radius.circular(Dimensions.radiusLarge)),
                            color: Theme.of(context).cardColor,
                            boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
                          ),
                          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                            title == null || title!.isEmpty? Container(
                              height: 17, width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                color: Theme.of(context).hintColor.withValues(alpha: 0.1),
                              ),
                            ) : Text(title!,
                              maxLines: 1,
                              style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: Dimensions.paddingSizeSmall),

                            Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                              Expanded(
                                flex: 4,
                                child: Column( crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  description == null || description!.isEmpty ? Container(
                                    height: 17, width: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                      color: Theme.of(context).hintColor.withValues(alpha: 0.1),
                                    ),
                                  ): Text(
                                    description!,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: robotoRegular.copyWith(color: Theme.of(context).hintColor),
                                  ),

                                  const SizedBox(height: Dimensions.paddingSizeExtraSmall,),

                                  description == null || description!.isEmpty ? Container(
                                    height: 17, width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                      color: Theme.of(context).hintColor.withValues(alpha: 0.1),
                                    ),
                                  ): const SizedBox()
                                ]),
                              ),

                              const SizedBox(width: Dimensions.paddingSizeLarge),

                              Expanded(
                                child: InkWell(
                                  onTap: () => Get.back(),
                                  child: Container(
                                    margin: const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall),
                                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeSmall),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    child: Icon(Icons.arrow_forward_rounded, size: 20, color: Colors.white.withValues(alpha: 0.8),),
                                  ),
                                ),
                              )
                            ]),
                          ]),
                        ))
                      ],
                    ),
                  ),
                ]),
              ),
            ),
          );
        }
      ),
    );
  }
}
