import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';

import '../../../../core/amount.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../l10n/device_locale.dart';
import '../../../../l10n/l10n.dart';
import '../../../../ui/amount_keypad/amount_keypad.dart';
import '../../../../ui/amount_with_equivalent.dart';
import '../../../../ui/button.dart';
import '../../../../ui/navigation_bar/navigation_bar.dart';
import '../../../../ui/number_formatter.dart';
import '../../../../ui/tab_bar.dart';
import '../../../../ui/usdc_info.dart';

class WalletMainScreen extends StatefulWidget {
  const WalletMainScreen({
    super.key,
    required this.onScan,
    required this.onAmountChanged,
    required this.onRequest,
    required this.onPay,
    required this.amount,
    this.shakeKey,
    this.error = '',
  });

  final VoidCallback onScan;
  final VoidCallback onRequest;
  final VoidCallback onPay;
  final ValueSetter<Decimal> onAmountChanged;
  final CryptoAmount amount;
  final Key? shakeKey;
  final String error;

  @override
  State<WalletMainScreen> createState() => _ScreenState();
}

class _ScreenState extends State<WalletMainScreen> {
  late final TextEditingController _amountController;
  TabController? _tabController;

  WalletOperation _action = WalletOperation.pay;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    _amountController.addListener(_updateValue);
  }

  @override
  void dispose() {
    _amountController.removeListener(_updateValue);
    _tabController?.removeListener(_handleTabUpdate);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant WalletMainScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    final newAmount = widget.amount.decimal;
    final locale = DeviceLocale.localeOf(context);
    final currentAmount = _amountController.text.toDecimalOrZero(locale);
    if (newAmount != oldWidget.amount.decimal && newAmount != currentAmount) {
      _amountController.text = newAmount.toString();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _tabController?.removeListener(_handleTabUpdate);
    _tabController = DefaultTabController.of(context)
      ..addListener(_handleTabUpdate);
    _updateAction();
  }

  void _updateValue() {
    final locale = DeviceLocale.localeOf(context);
    final amount = _amountController.text.toDecimalOrZero(locale);
    widget.onAmountChanged(amount);
  }

  void _handleTabUpdate() => setState(_updateAction);

  void _updateAction() {
    final tab = _tabController?.index ?? 0;

    _action = WalletOperation.values[tab];
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: _QrScannerAppBar(onQrScanner: widget.onScan),
      body: Column(
        children: [
          const SizedBox(height: 24),
          AmountWithEquivalent(
            inputController: _amountController,
            token: widget.amount.cryptoCurrency.token,
            collapsed: false,
            shakeKey: widget.shakeKey,
            error: widget.error,
          ),
          const SizedBox(height: 8),
          UsdcInfoWidget(
            isSmall: height < 700,
          ),
          Flexible(
            child: LayoutBuilder(
              builder: (context, constraints) => AmountKeypad(
                height: constraints.maxHeight,
                width: width,
                controller: _amountController,
                maxDecimals: 2,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: CpButton(
              text: _action.buttonLabel(context),
              minWidth: width,
              onPressed: () {
                switch (_action) {
                  case WalletOperation.pay:
                    widget.onPay();
                    break;
                  case WalletOperation.request:
                    widget.onRequest();
                    break;
                }
              },
              size: CpButtonSize.big,
            ),
          ),
          const SizedBox(height: cpNavigationBarheight + 24),
        ],
      ),
    );
  }
}

class _QrScannerAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _QrScannerAppBar({
    Key? key,
    required this.onQrScanner,
  }) : super(key: key);

  final VoidCallback onQrScanner;

  @override
  Size get preferredSize => const Size.fromHeight(2 * kToolbarHeight);

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 28, top: 12),
          child: SizedBox(
            height: kToolbarHeight - 10,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox.square(
                    dimension: 26,
                    child: IconButton(
                      onPressed: onQrScanner,
                      icon: Assets.icons.qrScanner.svg(height: 26),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ),
                Align(
                  child: SizedBox(
                    width: 220,
                    child: CpTabBar(
                      tabs: [
                        Tab(text: context.l10n.pay),
                        Tab(text: context.l10n.receive),
                      ],
                      variant: CpTabBarVariant.light,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

extension on WalletOperation {
  String buttonLabel(BuildContext context) {
    switch (this) {
      case WalletOperation.pay:
        return context.l10n.pay;
      case WalletOperation.request:
        return context.l10n.receive;
    }
  }
}

enum WalletOperation { pay, request }
