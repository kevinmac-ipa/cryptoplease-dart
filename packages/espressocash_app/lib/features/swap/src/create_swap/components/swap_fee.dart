import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/amount.dart';
import '../../../../../core/conversion_rates/amount_ext.dart';
import '../../../../../core/conversion_rates/bl/repository.dart';
import '../../../../../core/currency.dart';
import '../../../../../core/presentation/format_amount.dart';
import '../../../../../l10n/device_locale.dart';
import '../../../../../l10n/l10n.dart';

class SwapFee extends StatelessWidget {
  const SwapFee({
    Key? key,
    required this.amount,
  }) : super(key: key);

  final CryptoAmount amount;

  @override
  Widget build(BuildContext context) {
    final locale = DeviceLocale.localeOf(context);
    final fiatAmount = amount.toFiatAmount(
      Currency.usd,
      ratesRepository: context.read<ConversionRatesRepository>(),
    );
    final formatted = (fiatAmount ?? amount).format(locale);

    return Text(
      context.l10n.feeAmount(formatted),
      style: const TextStyle(fontSize: 15),
    );
  }
}
