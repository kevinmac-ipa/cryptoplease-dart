import 'package:bip39/bip39.dart' as bip39;
import 'package:bloc_test/bloc_test.dart';
import 'package:espressocash_app/core/accounts/bl/account.dart';
import 'package:espressocash_app/core/accounts/bl/accounts_bloc.dart';
import 'package:espressocash_app/core/accounts/bl/mnemonic.dart';
import 'package:espressocash_app/core/file_manager.dart';
import 'package:espressocash_app/core/wallet.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'accounts_bloc_test.mocks.dart';

@GenerateMocks([FlutterSecureStorage])
Future<void> main() async {
  final storage = MockFlutterSecureStorage();
  final mnemonic = bip39.generateMnemonic();
  final wallet = await createWallet(mnemonic: mnemonic, account: 0);
  final testAccount = MyAccount(
    wallet: wallet,
    firstName: 'Test',
    accessMode: const AccessMode.loaded(),
  );
  final fileManager = FileManager();

  tearDown(() {
    reset(storage);
  });

  blocTest<AccountsBloc, AccountsState>(
    'Tries to load account from storage',
    setUp: () {
      when(storage.read(key: anyNamed('key'), iOptions: anyNamed('iOptions')))
          .thenAnswer((_) async => null);
      when(storage.write(key: anyNamed('key'), value: anyNamed('value')))
          .thenAnswer((_) async {});
    },
    build: () => AccountsBloc(storage: storage, fileManager: fileManager),
    act: (b) {
      b.add(const AccountsEvent.initialize());
    },
    expect: () => [
      const AccountsState(isProcessing: true),
      const AccountsState(),
    ],
    verify: (_) {
      verify(storage.read(key: anyNamed('key'), iOptions: anyNamed('iOptions')))
          .called(2);
      verifyNever(
        storage.write(key: anyNamed('key'), value: anyNamed('value')),
      );
    },
  );

  blocTest<AccountsBloc, AccountsState>(
    'Loads account from storage if it exists',
    setUp: () {
      when(
        storage.read(key: mnemonicKey, iOptions: anyNamed('iOptions')),
      ).thenAnswer((_) async => mnemonic);
      when(
        storage.read(key: nameKey, iOptions: anyNamed('iOptions')),
      ).thenAnswer((_) async => testAccount.firstName);
      when(
        storage.read(key: photoKey, iOptions: anyNamed('iOptions')),
      ).thenAnswer((_) async => null);
      when(
        storage.read(key: onboardingKey, iOptions: anyNamed('iOptions')),
      ).thenAnswer((_) async => 'true');
      when(storage.write(key: anyNamed('key'), value: anyNamed('value')))
          .thenAnswer((_) async {});
    },
    build: () => AccountsBloc(storage: storage, fileManager: fileManager),
    act: (b) {
      b.add(const AccountsEvent.initialize());
    },
    expect: () => [
      const AccountsState(isProcessing: true),
      allOf(
        predicate(
          (AccountsState a) => a.account?.address == testAccount.address,
          'has correct account address',
        ),
        predicate((AccountsState a) => !a.isProcessing, 'is not processing'),
        predicate(
          (AccountsState a) => a.hasFinishedOnboarding,
          'has finished onboarding',
        ),
      ),
    ],
  );

  blocTest<AccountsBloc, AccountsState>(
    'Saves account when created',
    setUp: () {
      when(storage.write(key: anyNamed('key'), value: anyNamed('value')))
          .thenAnswer((_) async {});
    },
    build: () => AccountsBloc(storage: storage, fileManager: fileManager),
    act: (b) {
      b.add(
        AccountsEvent.created(
          mnemonic: Mnemonic.generated(mnemonic),
          account: testAccount,
          hasFinishedOnboarding: false,
        ),
      );
    },
    expect: () => [
      const AccountsState(isProcessing: true),
      allOf(
        predicate(
          (AccountsState a) => a.account?.address == testAccount.address,
          'has correct account address',
        ),
        predicate((AccountsState a) => !a.isProcessing, 'is not processing'),
        predicate(
          (AccountsState a) => !a.hasFinishedOnboarding,
          'has not finished onboarding',
        ),
      ),
    ],
    verify: (_) {
      verify(
        storage.write(
          key: mnemonicKey,
          value: mnemonic,
          iOptions: anyNamed('iOptions'),
        ),
      ).called(1);
      verify(
        storage.write(
          key: nameKey,
          value: testAccount.firstName,
          iOptions: anyNamed('iOptions'),
        ),
      ).called(1);
      verify(
        storage.write(
          key: onboardingKey,
          value: 'false',
          iOptions: anyNamed('iOptions'),
        ),
      ).called(1);
    },
  );
}
