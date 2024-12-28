import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'video_provider.dart';

class AnimatedButtonChest extends StatelessWidget {
  final double width;
  final double height;

  const AnimatedButtonChest({
    Key? key,
    this.width = 100,
    this.height = 100,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final videoProvider = Provider.of<VideoProvider>(context);
    return GestureDetector(
      onTap: () {
        videoProvider.loadRewardedAd();
        if (videoProvider.rewardedAd == null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Iklan belum dimuat. Coba lagi nanti.')));
          return;
        } else {
          videoProvider.setSession(2);
          videoProvider.triggerDialogAfterDelay(context);
        }
      },
      child: videoProvider.controller.value.isInitialized
          ? Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: AspectRatio(
                  aspectRatio: videoProvider.controller.value.aspectRatio,
                  child: VideoPlayer(videoProvider.controller),
                ),
              ),
            )
          : Container(
              width: width,
              height: height,
              color: Colors.black,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
    );
  }
}
