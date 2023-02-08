import 'package:espressocash_backend/src/constants.dart';
import 'package:solana/encoder.dart';
import 'package:solana/solana.dart';

/// Creates a transaction that will:
///
/// - create ATA for the [aEscrow] account;
/// - send [amount] from [aSender] ATA to [aEscrow] ATA;
/// - send fee from [aSender] ATA to [platform] ATA;
///
/// Tx will be partially signed by the [platform]. Keep in mind that [aSender]
/// and [platform] should already have the corresponding ATAs for the [mint].
///
/// [commitment] is used for checking the ATA for [aSender] and for retrieving
/// the latest blockhash.
Future<SignedTx> createPaymentTx({
  required Ed25519HDPublicKey aSender,
  required Ed25519HDPublicKey aEscrow,
  required Ed25519HDPublicKey mint,
  required int amount,
  required Ed25519HDKeyPair platform,
  required SolanaClient client,
  required Commitment commitment,
}) async {
  final isNewEscrowAccount =
      await client.rpcClient.getAccountInfo(aEscrow.toBase58()) == null;
  if (!isNewEscrowAccount) {
    throw Exception('Escrow account already exists');
  }

  final senderATAData = await client.getAssociatedTokenAccount(
    owner: aSender,
    mint: mint,
    commitment: commitment,
  );

  if (senderATAData == null) {
    throw Exception('No token account found for sender');
  }

  final ataSender = Ed25519HDPublicKey.fromBase58(senderATAData.pubkey);

  final instructions = <Instruction>[];

  final ataEscrow =
      await findAssociatedTokenAddress(owner: aEscrow, mint: mint);
  final iCreateATA = AssociatedTokenAccountInstruction.createAccount(
    funder: platform.publicKey,
    address: ataEscrow,
    owner: aEscrow,
    mint: mint,
  );

  instructions.add(iCreateATA);

  final iTransferAmount = TokenInstruction.transfer(
    amount: amount,
    source: ataSender,
    destination: ataEscrow,
    owner: aSender,
  );

  instructions.add(iTransferAmount);

  final ataPlatform = await findAssociatedTokenAddress(
    owner: platform.publicKey,
    mint: mint,
  );
  final iTransferFee = TokenInstruction.transfer(
    amount: shareableLinkPaymentFee,
    source: ataSender,
    destination: ataPlatform,
    owner: aSender,
  );

  instructions.add(iTransferFee);

  final message = Message(instructions: instructions);
  final recentBlockhash =
      await client.rpcClient.getRecentBlockhash(commitment: commitment);

  final compiled = message.compile(recentBlockhash: recentBlockhash.blockhash);

  return SignedTx(
    messageBytes: compiled.data,
    signatures: [
      await platform.sign(compiled.data),
      Signature(List.filled(64, 0), publicKey: aSender),
    ],
  );
}
