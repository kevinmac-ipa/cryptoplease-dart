import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../accounts/bl/account.dart';
import 'bl/balances_bloc.dart';

extension BalancesExt on BuildContext {
  void notifyBalanceAffected() {
    final bloc = read<BalancesBloc>();
    final account = read<MyAccount>();

    bloc.add(BalancesEvent.requested(address: account.address));
  }
}
