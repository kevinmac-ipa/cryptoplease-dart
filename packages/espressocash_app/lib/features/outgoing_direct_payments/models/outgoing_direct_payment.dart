import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:solana/encoder.dart';
import 'package:solana/solana.dart';

import '../../../core/amount.dart';
import '../../../core/transactions/tx_sender.dart';

part 'outgoing_direct_payment.freezed.dart';

@freezed
class OutgoingDirectPayment with _$OutgoingDirectPayment {
  const factory OutgoingDirectPayment({
    required String id,
    required Ed25519HDPublicKey receiver,
    required CryptoAmount amount,
    required DateTime created,
    required ODPStatus status,
    Ed25519HDPublicKey? reference,
  }) = _OutgoingDirectPayment;
}

@freezed
class ODPStatus with _$ODPStatus {
  const factory ODPStatus.txCreated(SignedTx tx) = ODPStatusTxCreated;
  const factory ODPStatus.txSent(SignedTx tx) = ODPStatusTxSent;
  const factory ODPStatus.success({required String txId}) = ODPStatusSuccess;
  const factory ODPStatus.txFailure({TxFailureReason? reason}) =
      ODPStatusTxFailure;
  const factory ODPStatus.txSendFailure(SignedTx tx) = ODPStatusTxSendFailure;
  const factory ODPStatus.txWaitFailure(SignedTx tx) = ODPStatusTxWaitFailure;
}
