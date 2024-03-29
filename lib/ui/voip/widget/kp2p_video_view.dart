import 'package:app_core/helper/kwebrtc_helper.dart';
import 'package:app_core/ui/widget/kuser_avatar.dart';
import 'package:app_core/value/kstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class KP2PVideoView extends StatefulWidget {
  final RTCVideoRenderer localRenderer;
  final Map<String, RTCVideoRenderer> remoteRenderers;
  final bool isRemoteCameraEnabled;
  final bool isRemoteMicEnabled;
  final Function? onLocalVideoTap;
  final Function? onRemoteVideoTap;
  final String refAvatarUrl;
  final String refName;
  final KWebRTCCallType type;

  const KP2PVideoView({
    required this.localRenderer,
    required this.remoteRenderers,
    required this.refName,
    required this.refAvatarUrl,
    this.type = KWebRTCCallType.video,
    this.isRemoteCameraEnabled = false,
    this.isRemoteMicEnabled = false,
    this.onLocalVideoTap,
    this.onRemoteVideoTap,
  });

  @override
  State<StatefulWidget> createState() => _P2PVideoViewState();
}

class _P2PVideoViewState extends State<KP2PVideoView> {
  KWebRTCCallType get type => widget.type;

  void _onLocalVideoTap() => this.widget.onLocalVideoTap?.call();

  void _onRemoteVideoTap() => this.widget.onRemoteVideoTap?.call();

  double? get localAspectRatio {
    final ratio = widget.localRenderer.videoHeight.toDouble() /
        widget.localRenderer.videoWidth.toDouble();
    return ratio.isNaN ? null : ratio;
  }

  @override
  void initState() {
    super.initState();

    widget.localRenderer.onResize = onVideoResize;
    widget.remoteRenderers.forEach((_, rr) => rr.onResize = onVideoResize);
  }

  void onVideoResize() => !mounted ? null : setState(() {});

  @override
  Widget build(BuildContext context) {
    final local = this.localAspectRatio == null
        ? Container()
        : ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: MediaQuery.of(context).size.height / 4,
              color: KStyles.extraDarkGrey,
              child: AspectRatio(
                aspectRatio: this.localAspectRatio!,
                child: InkWell(
                  child: RTCVideoView(widget.localRenderer),
                  onTap: _onLocalVideoTap,
                ),
              ),
            ),
          );

    final remoteVideo = widget.remoteRenderers.length == 1
        ? Container(
            color: KStyles.black,
            child: RTCVideoView(
              widget.remoteRenderers.values.first,
              objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
            ),
          )
        : Column(
            children: widget.remoteRenderers.keys
                .map(
                  (id) => Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.red),
                        color: KStyles.black,
                      ),
                      child: RTCVideoView(
                        widget.remoteRenderers[id]!,
                        objectFit:
                            RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                      ),
                    ),
                  ),
                )
                .toList(),
          );

    final remoteVideoOffIcon = CircleAvatar(
      backgroundColor: KStyles.black,
      child: Icon(
        Icons.videocam_off,
        color: KStyles.white,
        size: 32,
      ),
    );

    final remote = Stack(
      fit: StackFit.expand,
      children: [
        if (widget.isRemoteCameraEnabled) ...[
          InkWell(
            child: remoteVideo,
            onTap: _onRemoteVideoTap,
          ),
        ],
        if (!widget.isRemoteCameraEnabled)
          InkWell(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!widget.isRemoteCameraEnabled) ...[
                    remoteVideoOffIcon,
                    SizedBox(height: 6),
                    Text(
                      "No Video",
                      style: KStyles.largeText.copyWith(color: KStyles.white),
                    ),
                  ]
                ],
              ),
            ),
            onTap: _onRemoteVideoTap,
          ),
      ],
    );

    final body = Container(
      color: KStyles.black,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          if (type == KWebRTCCallType.video) ...[
            remote,
            Align(
              alignment: Alignment.topRight,
              child: SafeArea(
                child: Container(
                  margin: EdgeInsets.all(14),
                  child: local,
                ),
              ),
            )
          ] else ...[
            InkWell(
              child: Container(
                color: KStyles.black,
                child: Center(
                  child: Container(
                    width: 100,
                    child: KUserAvatar(
                      imageURL: widget.refAvatarUrl,
                      initial: widget.refName,
                    ),
                  ),
                ),
              ),
              onTap: _onRemoteVideoTap,
            ),
          ],
        ],
      ),
    );

    return body;
  }
}
