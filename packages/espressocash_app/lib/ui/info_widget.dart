import 'package:flutter/material.dart';

import 'colors.dart';
import 'info_icon.dart';
import 'rounded_rectangle.dart';

class CpInfoWidget extends StatelessWidget {
  const CpInfoWidget({
    Key? key,
    required this.message,
    this.padding = const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
  }) : super(key: key);

  final Widget message;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) => CpRoundedRectangle(
        backgroundColor: CpColors.backgroundAccentColor,
        padding: padding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 8),
              child: CircleAvatar(
                maxRadius: 14,
                backgroundColor: CpColors.yellowColor,
                child: CpInfoIcon(),
              ),
            ),
            Flexible(
              child: DefaultTextStyle.merge(
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w500,
                ),
                child: message,
              ),
            ),
          ],
        ),
      );
}
