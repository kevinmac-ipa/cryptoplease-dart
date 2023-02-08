import 'package:flutter/material.dart';

import '../gen/assets.gen.dart';
import 'colors.dart';

class CpInfoIcon extends StatelessWidget {
  const CpInfoIcon({
    Key? key,
    this.iconColor = CpColors.backgroundAccentColor,
  }) : super(key: key);
  final Color iconColor;

  @override
  Widget build(BuildContext context) => Assets.icons.info.svg(
        color: iconColor,
        height: 20,
      );
}
