import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:solana/solana_pay.dart';

import '../../../config.dart';
import '../../../core/amount.dart';
import '../../../core/currency.dart';
import '../../../core/tokens/token.dart';
import '../../../core/tokens/token_list.dart';

part 'payment_request.freezed.dart';

@freezed
class PaymentRequest with _$PaymentRequest {
  const factory PaymentRequest({
    required String id,
    required DateTime created,
    required String label,
    required SolanaPayRequest payRequest,
    required String dynamicLink,
    required PaymentRequestState state,
  }) = _PaymentRequest;
}

@freezed
class PaymentRequestState with _$PaymentRequestState {
  const factory PaymentRequestState.initial() = PaymentRequestInitial;
  const factory PaymentRequestState.completed({
    required String transactionId,
  }) = PaymentRequestCompleted;
  const factory PaymentRequestState.failure() = PaymentRequestFailure;
}

extension SolanaPayRequestExt on SolanaPayRequest {
  Uri toUniversalLink() => Uri.parse(toUrl()).replace(
        scheme: 'https',
        host: solanaPayHost,
      );

  CryptoAmount? cryptoAmount(TokenList tokenList) {
    final amount = this.amount;
    if (amount == null) return null;

    final splToken = this.splToken;
    final token = splToken == null
        ? Token.sol
        : tokenList.findTokenByMint(splToken.toBase58());

    if (token == null) return null;

    final currency = CryptoCurrency(token: token);

    return CryptoAmount(
      cryptoCurrency: currency,
      value: currency.decimalToInt(amount),
    );
  }
}
