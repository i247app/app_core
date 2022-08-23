import 'package:app_core/value/kstyles.dart';
import 'package:app_core/helper/kwebrtc_helper.dart';
import 'package:flutter/material.dart';

class KP2PButtonView extends StatelessWidget {
  final bool isMicEnabled;
  final bool isCameraEnabled;
  final bool isSpeakerEnabled;

  final KWebRTCCallType type;
  final Function(bool)? onMicToggled;
  final Function(bool)? onCameraToggled;
  final Function()? onHangUp;
  final Function(bool)? onSpeakerToggled;

  const KP2PButtonView({
    required this.isMicEnabled,
    required this.isCameraEnabled,
    required this.type,
    required this.isSpeakerEnabled,
    this.onSpeakerToggled,
    this.onCameraToggled,
    this.onMicToggled,
    this.onHangUp,
  });

  @override
  Widget build(BuildContext context) {
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

    final switchSpeakerBtn = KP2PButton(
      onClick: () => this.onSpeakerToggled?.call(!this.isSpeakerEnabled),
      backgroundColor:
          KStyles.darkGrey.withOpacity(this.isSpeakerEnabled ? 1 : 0.5),
      icon: Icon(this.isSpeakerEnabled ? Icons.volume_up : Icons.volume_off,
          color: KStyles.colorButtonText),
    );

    final hangUpBtn = KP2PButton(
      onClick: this.onHangUp ?? () {},
      backgroundColor: KStyles.colorBGNo,
      icon: Icon(Icons.call_end, color: KStyles.colorButtonText),
    );

    final body = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
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

    return body;
  }
}
