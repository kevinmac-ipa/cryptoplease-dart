import 'package:pigeon/pigeon.dart';

@HostApi()
abstract class ApiLocalAssociationScenario {
  @async
  void create(int id);

  @async
  void start(int id);

  @async
  void close(int id);

  @async
  void startActivityForResult(int id, String? uriPrefix);

  @async
  GetCapabilitiesResultDto getCapabilities(int id);

  @async
  AuthorizationResultDto authorize(
    int id,
    String? identityUri,
    String? iconUri,
    String? identityName,
    String? cluster,
  );

  @async
  AuthorizationResultDto reauthorize(
    int id,
    String? identityUri,
    String? iconUri,
    String? identityName,
    String authToken,
  );

  @async
  void deauthorize(int id, String authToken);

  @async
  SignPayloadsResultDto signTransactions(int id, List<Uint8List> transactions);

  @async
  SignPayloadsResultDto signMessages(
    int id,
    List<Uint8List> messages,
    List<Uint8List> addresses,
  );

  @async
  SignAndSendTransactionsResultDto signAndSendTransactions(
    int id,
    List<Uint8List> transactions,
    int? minContextSlot,
  );
}

class GetCapabilitiesResultDto {
  GetCapabilitiesResultDto({
    required this.supportsCloneAuthorization,
    required this.supportsSignAndSendTransactions,
    required this.maxTransactionsPerSigningRequest,
    required this.maxMessagesPerSigningRequest,
  });

  final bool supportsCloneAuthorization;
  final bool supportsSignAndSendTransactions;
  final int maxTransactionsPerSigningRequest;
  final int maxMessagesPerSigningRequest;
}

class AuthorizationResultDto {
  AuthorizationResultDto({
    required this.authToken,
    required this.publicKey,
    required this.accountLabel,
    required this.walletUriBase,
  });

  final String authToken;
  final Uint8List publicKey;
  final String? accountLabel;
  final String? walletUriBase;
}

class SignPayloadsResultDto {
  SignPayloadsResultDto({
    required this.signedPayloads,
  });

  final List<Uint8List?> signedPayloads;
}

class SignAndSendTransactionsResultDto {
  SignAndSendTransactionsResultDto({
    required this.signatures,
  });

  final List<Uint8List?> signatures;
}
