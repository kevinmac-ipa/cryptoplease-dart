import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nested/nested.dart';

import '../../di.dart';
import 'bl/balances_bloc.dart';

class BalancesModule extends SingleChildStatelessWidget {
  const BalancesModule({Key? key, Widget? child})
      : super(key: key, child: child);

  @override
  Widget buildWithChild(BuildContext context, Widget? child) => BlocProvider(
        create: (context) => sl<BalancesBloc>(),
        child: child,
      );
}
