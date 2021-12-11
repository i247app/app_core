import 'package:app_core/ui/kicon/kicon_manager.dart';
import 'package:flutter/material.dart';

class KIcon extends StatelessWidget {
  final dynamic iconID;
  final Color? color;

  double get width => 32;

  double get height => 32;

  const KIcon(this.iconID, {this.color});

  Widget buildRaw(ctx) => getProvider(ctx)!.resource.runtimeType == IconData
      ? Icon(
          getProvider(ctx)!.resource,
          color: this.color,
        )
      : Image.asset(
          getProvider(ctx)!.resource,
          fit: BoxFit.contain,
        );

  KIconProvider? getProvider(ctx) => KIconManager.of(ctx).iconSet[this.iconID];

  @override
  Widget build(BuildContext context) {
    final raw = getProvider(context) == null
        ? Icon(
            Icons.error,
            color: this.color,
          )
        : buildRaw(context);

    final body = Container(
      // width: this.width,
      // height: this.height,
      child: raw,
    );

    return body;
  }
}
