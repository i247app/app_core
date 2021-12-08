import 'package:app_core/value/kstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class KP2PVideoView extends StatefulWidget {
  final RTCVideoRenderer localRenderer;
  final Map<String, RTCVideoRenderer> remoteRenderers;
  final bool isRemoteCameraEnabled;
  final bool isRemoteMicEnabled;
  final Function? onLocalVideoTap;
  final Function? onRemoteVideoTap;

  const KP2PVideoView({
    required this.localRenderer,
    required this.remoteRenderers,
    this.isRemoteCameraEnabled = false,
    this.isRemoteMicEnabled = false,
    this.onLocalVideoTap,
    this.onRemoteVideoTap,
  });

  @override
  State<StatefulWidget> createState() => _KP2PVideoViewState();
}

class _KP2PVideoViewState extends State<KP2PVideoView> {
  double? get localAspectRatio {
    final ratio = widget.localRenderer.videoHeight.toDouble() /
        widget.localRenderer.videoWidth.toDouble();
    return ratio.isNaN ? null : ratio;
  }

  Iterable<RTCVideoRenderer> get validRemoteRenderers =>
      widget.remoteRenderers.values.where((rr) => rr.srcObject != null);

  bool get showLocalVideo =>
      localAspectRatio != null && widget.localRenderer.srcObject != null;

  @override
  void initState() {
    super.initState();

    widget.localRenderer.onResize = onVideoResize;
    widget.remoteRenderers.forEach((_, rr) => rr.onResize = onVideoResize);
  }

  void _onLocalVideoTap() => widget.onLocalVideoTap?.call();

  void _onRemoteVideoTap() => widget.onRemoteVideoTap?.call();

  void onVideoResize() => !mounted ? null : setState(() {});

  @override
  Widget build(BuildContext context) {
    final local = !showLocalVideo
        ? Container()
        : ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: MediaQuery.of(context).size.height / 4,
              color: KStyles.extraDarkGrey,
              child: AspectRatio(
                aspectRatio: localAspectRatio!,
                child: InkWell(
                  child: RTCVideoView(widget.localRenderer),
                  onTap: _onLocalVideoTap,
                ),
              ),
            ),
          );

    final remoteVideo = validRemoteRenderers.length == 1
        ? Container(
            color: KStyles.black,
            child: RTCVideoView(
              validRemoteRenderers.first,
              objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
            ),
          )
        : Column(
            children: validRemoteRenderers
                .map(
                  (rr) => Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.red),
                        color: KStyles.black,
                      ),
                      child: RTCVideoView(
                        rr,
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
          remote,
          Align(
            alignment: Alignment.topRight,
            child: SafeArea(
              child: Container(
                margin: EdgeInsets.all(14),
                child: local,
              ),
            ),
          ),
        ],
      ),
    );

    return body;
  }
}
