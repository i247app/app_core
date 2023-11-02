import 'package:app_core/value/kstyles.dart';
import 'package:app_core/helper/kwebrtc_helper.dart';
import 'package:flutter/material.dart';

class KPeerButtonView extends StatelessWidget {
  final bool isMicEnabled;
  final bool isCameraEnabled;
  final bool isSpeakerEnabled;

  final KWebRTCCallType type;
  final Function(bool)? onMicToggled;
  final Function(bool)? onCameraToggled;
  final Function(bool)? onSpeakerToggled;
  final Function()? onHangUp;
  final Function()? onShowMeetingInfo;

  const KPeerButtonView({
    required this.isMicEnabled,
    required this.isCameraEnabled,
    required this.type,
    this.onCameraToggled,
    this.onMicToggled,
    this.onHangUp,
    this.onShowMeetingInfo,
    required this.isSpeakerEnabled,
    this.onSpeakerToggled,
  });

  @override
  Widget build(BuildContext context) {
    final switchSpeakerBtn = KP2PButton(
      onClick: () => this.onSpeakerToggled?.call(!this.isSpeakerEnabled),
      backgroundColor:
          KStyles.darkGrey.withOpacity(this.isSpeakerEnabled ? 1 : 0.5),
      icon: Icon(this.isSpeakerEnabled ? Icons.volume_up : Icons.volume_off,
          color: KStyles.colorButtonText),
    );

    final toggleMicBtn = KP2PButton(
      onClick: () => this.onMicToggled?.call(!this.isMicEnabled),
      backgroundColor:
          KStyles.darkGrey.withOpacity(this.isMicEnabled ? 1 : 0.5),
      icon: Icon(
        this.isMicEnabled ? Icons.mic : Icons.mic_off,
        color: KStyles.white,
      ),
    );

    final toggleCameraBtn = KP2PButton(
      onClick: () => this.onCameraToggled?.call(!this.isCameraEnabled),
      backgroundColor:
          KStyles.darkGrey.withOpacity(this.isCameraEnabled ? 1 : 0.5),
      icon: Icon(
        this.isCameraEnabled ? Icons.videocam : Icons.videocam_off,
        color: KStyles.white,
      ),
    );

    final hangUpBtn = KP2PButton(
      onClick: this.onHangUp ?? () {},
      backgroundColor: KStyles.colorBGNo,
      icon: Icon(Icons.call_end, color: KStyles.colorButtonText),
    );

    final showMeetingInfoBtn = KP2PButton(
      onClick: this.onShowMeetingInfo ?? () {},
      backgroundColor: KStyles.darkGrey,
      icon: Icon(
        Icons.info_outline_rounded,
        color: KStyles.white,
      ),
    );

    final body = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        if (this.onShowMeetingInfo != null) showMeetingInfoBtn,
        switchSpeakerBtn,
        toggleMicBtn,
        if (this.type == KWebRTCCallType.video) ...[
          toggleCameraBtn,
        ],
        hangUpBtn,
      ],
    );

    return body;
  }
}

class KP2PButton extends StatelessWidget {
  final Color backgroundColor;
  final Icon icon;
  final Function() onClick;

  const KP2PButton({
    required this.backgroundColor,
    required this.icon,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    final body = CircleAvatar(
      minRadius: 32,
      maxRadius: 32,
      backgroundColor: this.backgroundColor,
      child: IconButton(
        onPressed: this.onClick,
        icon: this.icon,
        iconSize: 32,
      ),
    );

    return Expanded(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: body,
        ),
      ),
    );
  }
}
