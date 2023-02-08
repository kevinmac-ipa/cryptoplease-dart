import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../../../core/presentation/format_amount.dart';
import '../../../../../../core/tokens/token_list.dart';
import '../../../../../../di.dart';
import '../../../../../../l10n/l10n.dart';
import '../../../../../../ui/rounded_rectangle.dart';
import '../../../../models/payment_request.dart';

class ShareQrCode extends StatelessWidget {
  const ShareQrCode({
    Key? key,
    required this.paymentRequest,
  }) : super(key: key);

  final PaymentRequest paymentRequest;

  @override
  Widget build(BuildContext context) {
    final tokenlist = sl<TokenList>();

    final amount = paymentRequest.payRequest
        .cryptoAmount(tokenlist)
        ?.formatWithFiat(context);

    final qrData = paymentRequest.payRequest.toUrl();

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Column(
        children: [
          _Subtitle(text: context.l10n.sharePaymentRequestQrCodeDescription),
          _QrCodeWrapper(amount: amount, qrData: qrData),
        ],
      ),
    );
  }
}

class _QrCodeWrapper extends StatelessWidget {
  const _QrCodeWrapper({
    Key? key,
    required this.amount,
    required this.qrData,
  }) : super(key: key);

  final String? amount;
  final String qrData;

  @override
  Widget build(BuildContext context) {
    final amount = this.amount;

    return Flexible(
      child: CpRoundedRectangle(
        scrollable: false,
        margin: const EdgeInsets.symmetric(vertical: 16),
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 42),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (amount != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: Text(
                  amount,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            Flexible(
              child: QrImage(
                data: qrData,
                padding: EdgeInsets.zero,
                foregroundColor: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _Subtitle extends StatelessWidget {
  const _Subtitle({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
        ),
      );
}
