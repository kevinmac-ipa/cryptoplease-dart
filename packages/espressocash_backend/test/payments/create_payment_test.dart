import 'package:espressocash_backend/src/constants.dart';
import 'package:espressocash_backend/src/payments/create_payment.dart';
import 'package:solana/solana.dart';
import 'package:test/test.dart';

import '../config.dart';
import 'utils.dart';

Future<void> main() async {
  final client = createTestSolanaClient();

  /// Initial token amount for the sender after creation.
  const senderInitialAmount = 500000;

  const transferAmount = 300000;

  /// Creates sender system account and ATA, minting [senderInitialAmount] to
  /// the ATA. System account won't have any SOL, since sender is not paying any
  /// fees in SOL.

  test('creates payment', () async {
    final data = await createTestData(
      client: client,
      senderInitialAmount: senderInitialAmount,
    );
    final sender = data.sender;
    final platform = data.platform;
    final mint = data.mint;

    // Sender creates an escrow account and keeps its private key. Sender
    // doesn't transfer private key for the escrow account to the system.
    final escrow = await Ed25519HDKeyPair.random();

    final tx = await createPaymentTx(
      aSender: sender.publicKey,
      aEscrow: escrow.publicKey,
      mint: mint,
      amount: transferAmount,
      client: client,
      platform: platform,
      commitment: Commitment.confirmed,
    );

    // Sender has to resign the transaction with their private key. The tx is
    // already partially signed by the platform.
    final resignedTx = await sender.resign(tx);

    final signature = await client.rpcClient.sendTransaction(
      resignedTx.encode(),
      preflightCommitment: Commitment.confirmed,
    );

    await client.waitForSignatureStatus(
      signature,
      status: Commitment.confirmed,
    );

    expect(
      await client.getMintBalance(sender.publicKey, mint: mint),
      senderInitialAmount - transferAmount - shareableLinkPaymentFee,
    );
    expect(
      await client.getMintBalance(escrow.publicKey, mint: mint),
      transferAmount,
    );
    expect(
      await client.getMintBalance(platform.publicKey, mint: mint),
      shareableLinkPaymentFee,
    );
  });

  test('fails without resigning', () async {
    final data = await createTestData(
      client: client,
      senderInitialAmount: senderInitialAmount,
    );
    final sender = data.sender;
    final platform = data.platform;
    final mint = data.mint;

    final escrow = await Ed25519HDKeyPair.random();

    final tx = await createPaymentTx(
      aSender: sender.publicKey,
      aEscrow: escrow.publicKey,
      mint: mint,
      amount: transferAmount,
      client: client,
      platform: platform,
      commitment: Commitment.confirmed,
    );

    final signature = client.rpcClient.sendTransaction(
      tx.encode(),
      preflightCommitment: Commitment.confirmed,
    );

    expect(signature, throwsA(isA<JsonRpcException>()));
  });
}
