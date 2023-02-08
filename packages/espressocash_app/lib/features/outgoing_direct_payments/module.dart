import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nested/nested.dart';
import 'package:provider/provider.dart';

import '../../core/accounts/bl/account.dart';
import '../../core/accounts/module.dart';
import '../../di.dart';
import 'src/bl/bloc.dart';
import 'src/bl/repository.dart';
import 'src/widgets/link_listener.dart';

class ODPModule extends SingleChildStatelessWidget {
  const ODPModule({Key? key, Widget? child}) : super(key: key, child: child);

  @override
  Widget buildWithChild(BuildContext context, Widget? child) => MultiProvider(
        providers: [
          BlocProvider<ODPBloc>(
            create: (context) => sl<ODPBloc>(
              param1: context.read<MyAccount>().wallet,
            ),
          ),
        ],
        child: LogoutListener(
          onLogout: (_) => sl<ODPRepository>().clear(),
          child: ODPLinkListener(child: child ?? const SizedBox.shrink()),
        ),
      );
}
