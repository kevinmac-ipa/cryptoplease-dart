import 'package:decimal/decimal.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../amount.dart';
import '../currency.dart';
import '../tokens/token.dart';
import 'bl/repository.dart';

extension ConversionRates on BuildContext {
  Decimal? watchConversionRate({
    required Token from,
    required FiatCurrency to,
  }) =>
      watch<ConversionRatesRepository>()
          .readRate(CryptoCurrency(token: from), to: to);

  Decimal? readConversionRate({
    required Token from,
    required FiatCurrency to,
  }) =>
      read<ConversionRatesRepository>()
          .readRate(CryptoCurrency(token: from), to: to);

  Amount? convertToFiat({
    required FiatCurrency fiatCurrency,
    required Token token,
    required int amount,
  }) {
    final conversionRate = readConversionRate(from: token, to: fiatCurrency);
    if (conversionRate == null) {
      return null;
    }

    final tokenAmount = Amount.fromToken(value: amount, token: token);

    return tokenAmount.convert(
      rate: conversionRate,
      to: fiatCurrency,
    );
  }
}
