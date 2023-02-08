import 'package:flutter/material.dart';

import 'colors.dart';

class CpBackgroundGradient extends StatelessWidget {
  const CpBackgroundGradient({
    Key? key,
    this.child,
  }) : super(key: key);

  final Widget? child;

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: const BoxDecoration(gradient: bgGradient),
        child: child,
      );
}
