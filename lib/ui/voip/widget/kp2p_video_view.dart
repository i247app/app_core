import 'package:app_core/header/kold_styles.dart';
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
  State<StatefulWidget> createState() => _P2PVideoViewState();
}

class _P2PVideoViewState extends State<KP2PVideoView> {
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
              color: KOldStyles.extraDarkGrey,
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
            color: KOldStyles.black,
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
                        color: KOldStyles.black,
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
      backgroundColor: KOldStyles.black,
      child: Icon(
        Icons.videocam_off,
        color: KOldStyles.white,
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
                      style: KOldStyles.largeText.copyWith(color: KOldStyles.white),
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
      color: KOldStyles.black,
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
