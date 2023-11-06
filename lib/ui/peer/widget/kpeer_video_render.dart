import 'package:app_core/helper/kstring_helper.dart';
import 'package:app_core/ui/widget/kuser_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';

class KPeerVideoRender extends StatelessWidget {
  final RTCVideoRenderer videoRenderer;
  final double containerWidth;
  final double containerHeight;
  final int peerCount;
  final bool isAudioEnable;
  final bool isVideoEnable;
  final String displayName;
  final bool isLocal;

  KPeerVideoRender({
    Key? key,
    required this.videoRenderer,
    required this.containerWidth,
    required this.containerHeight,
    required this.peerCount,
    required this.isAudioEnable,
    required this.isVideoEnable,
    required this.displayName,
    required this.isLocal,
  }) : super(key: key);

  MediaStreamTrack? get videoTrack =>
      (videoRenderer.srcObject
          ?.getVideoTracks()
          .length ?? 0) > 0 ? videoRenderer.srcObject
          ?.getVideoTracks()
          .first : null;

  double get calculatedHeight {
    double height = containerHeight;

    if (peerCount >= 2) {
      height = containerHeight / 2;
    }

    if (peerCount > 4) {
      height = containerHeight / 3;
    }

    return height;
  }

  double get calculatedWidth {
    double width = containerWidth;

    if (peerCount > 2) {
      width = containerWidth / 2;
    }

    return width;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: calculatedWidth,
      height: calculatedHeight,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: isVideoEnable
                          ? RTCVideoView(
                        videoRenderer,
                        key: Key('${videoRenderer.srcObject!.id}'),
                        mirror: isLocal,
                        objectFit: RTCVideoViewObjectFit
                            .RTCVideoViewObjectFitCover,
                      )
                          : Container(
                        color: Colors.black,
                        child: Center(
                          child: KUserAvatar(
                            initial: displayName
                                .split(' ')
                                .map((e) => "${e}".capitalizeFirst)
                                .join(''),
                            size: calculatedWidth / 3,
                            backgroundColor: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (!isAudioEnable)
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Icon(
                          Icons.mic_off_outlined,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  if (KStringHelper.isExist(displayName))
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          displayName,
                          style:
                          Theme
                              .of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                            fontWeight: FontWeight.w600,
                            shadows: <Shadow>[
                              Shadow(
                                offset: Offset(0.0, 0.0),
                                blurRadius: 4.0,
                                color: Colors.black,
                              ),
                            ],
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
