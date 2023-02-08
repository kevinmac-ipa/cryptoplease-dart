import 'package:flutter/material.dart';

import '../../gen/assets.gen.dart';
import '../colors.dart';

class CpNavigationButton extends StatelessWidget {
  const CpNavigationButton({
    Key? key,
    required this.icon,
    required this.active,
    required this.onPressed,
    this.badge,
  }) : super(key: key);

  final SvgGenImage icon;
  final bool active;
  final VoidCallback onPressed;
  final int? badge;

  @override
  Widget build(BuildContext context) {
    final badge = this.badge;

    return LayoutBuilder(
      builder: (context, constraints) => Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              SizedBox.square(
                dimension: 40,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: icon.svg(
                    color: active ? CpColors.yellowColor : Colors.white,
                  ),
                ),
              ),
              if (badge != null && badge > 0)
                Positioned(
                  top: 15,
                  left: constraints.maxWidth / 2 + 30 / 2,
                  child: _Badge(value: badge),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({Key? key, required this.value}) : super(key: key);

  final int value;

  @override
  Widget build(BuildContext context) => Container(
        width: 15,
        height: 15,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: CpColors.primaryColor,
        ),
        child: Center(
          child: Text(
            value.toString(),
            style: const TextStyle(
              fontSize: 10,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
}
