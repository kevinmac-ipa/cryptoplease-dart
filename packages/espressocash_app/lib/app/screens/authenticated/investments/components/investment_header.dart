import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../../../core/amount.dart';
import '../../../../../core/balances/presentation/watch_balance.dart';
import '../../../../../core/currency.dart';
import '../../../../../core/presentation/format_amount.dart';
import '../../../../../core/tokens/token.dart';
import '../../../../../features/ramp/widgets/ramp_buttons.dart';
import '../../../../../l10n/device_locale.dart';
import '../../../../../l10n/l10n.dart';
import '../../../../../routes.gr.dart';
import '../../../../../ui/colors.dart';
import '../../../../../ui/info_icon.dart';
import '../../../../../ui/token_icon.dart';

class InvestmentHeader extends StatelessWidget {
  const InvestmentHeader({super.key});

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: const BoxDecoration(
          color: Color(0xff2D2B2C),
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: Column(
          children: const [
            _Info(),
            _Balance(),
            Divider(color: Color(0xff4B4B4B), height: 8),
            Padding(
              padding: EdgeInsets.only(bottom: 16, top: 8.0),
              child: RampButtons(),
            ),
          ],
        ),
      );
}

class _Info extends StatefulWidget {
  const _Info();

  @override
  State<_Info> createState() => _InfoState();
}

class _InfoState extends State<_Info> {
  bool _showMore = false;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
        child: SizedBox(
          height: 55,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!_showMore)
                Expanded(
                  child: Text(
                    context.l10n.cryptoCashBalance,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.2,
                    ),
                  ),
                )
              else
                Expanded(
                  child: Text(
                    context.l10n.usdcInfo,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              const SizedBox(width: 8),
              _InfoIcon(
                onTap: () {
                  setState(() => _showMore = !_showMore);
                },
                isTapped: _showMore,
              ),
            ],
          ),
        ),
      );
}

class _InfoIcon extends StatelessWidget {
  const _InfoIcon({
    required this.onTap,
    required this.isTapped,
  });
  final VoidCallback onTap;
  final bool isTapped;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        child: Container(
          height: 28,
          width: 28,
          padding: const EdgeInsets.all(5),
          decoration: ShapeDecoration(
            shape: const CircleBorder(),
            color: isTapped ? const Color(0xff737273) : CpColors.yellowColor,
          ),
          child: const CpInfoIcon(
            iconColor: Color(0xff2D2B2C),
          ),
        ),
      );
}

class _Balance extends StatelessWidget {
  const _Balance();

  @override
  Widget build(BuildContext context) {
    const token = Token.usdc;

    final locale = DeviceLocale.localeOf(context);
    final converted = context.watchUserFiatBalance(token);
    final amount = converted ?? Amount.zero(currency: Currency.usd);
    final formattedAmount = amount.format(locale);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        onTap: () => context.router.push(TokenDetailsRoute(token: token)),
        leading: const CpTokenIcon(token: token, size: 36),
        horizontalTitleGap: 8,
        title: Text(
          token.name,
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 15,
            color: Colors.white,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Text(
          formattedAmount,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 50,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
