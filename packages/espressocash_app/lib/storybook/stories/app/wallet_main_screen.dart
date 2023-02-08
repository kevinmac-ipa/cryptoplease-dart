import 'package:storybook_flutter/storybook_flutter.dart';

import '../../../app/screens/authenticated/wallet_flow/wallet_main_screen.dart';
import '../../../core/amount.dart';
import '../../../core/currency.dart';
import '../../../ui/theme.dart';
import 'app_wrapper.dart';

final appWalletMainScreen = Story(
  name: 'App/WalletMainScreen',
  builder: (context) => AppWrapper(
    child: CpTheme.dark(
      child: WalletMainScreen(
        onScan: () {},
        onAmountChanged: (_) {},
        onRequest: () {},
        onPay: () {},
        amount: const CryptoAmount(value: 0, cryptoCurrency: Currency.usdc),
      ),
    ),
  ),
);
