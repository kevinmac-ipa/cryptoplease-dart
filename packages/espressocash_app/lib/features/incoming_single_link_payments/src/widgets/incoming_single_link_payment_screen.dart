import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/balances/context_ext.dart';
import '../../../../di.dart';
import '../../../../l10n/l10n.dart';
import '../../../../ui/transfer_status/transfer_error.dart';
import '../../../../ui/transfer_status/transfer_progress.dart';
import '../../../../ui/transfer_status/transfer_success.dart';
import '../../../incoming_split_key_payments/widgets/invalid_escrow_error_widget.dart';
import '../bl/islp_bloc.dart';
import '../bl/islp_payment.dart';
import '../bl/islp_repository.dart';

class IncomingSingleLinkScreen extends StatefulWidget {
  const IncomingSingleLinkScreen({
    super.key,
    required this.id,
  });

  final String id;

  @override
  State<IncomingSingleLinkScreen> createState() =>
      _IncomingSingleLinkScreenState();
}

class _IncomingSingleLinkScreenState extends State<IncomingSingleLinkScreen> {
  late final Stream<IncomingSingleLinkPayment?> _payment;

  @override
  void initState() {
    super.initState();
    _payment = sl<ISLPRepository>().watch(widget.id);
  }

  @override
  Widget build(BuildContext context) =>
      StreamBuilder<IncomingSingleLinkPayment?>(
        stream: _payment,
        builder: (context, state) {
          final payment = state.data;

          return BlocConsumer<ISLPBloc, ISLPState>(
            listener: (context, state) => payment?.status.mapOrNull(
              txSent: (_) => context.notifyBalanceAffected(),
            ),
            builder: (context, state) {
              if (payment == null || state.contains(payment.id)) {
                return TransferProgress(
                  onBack: () => context.router.pop(),
                );
              }

              return payment.status.maybeMap(
                success: (_) => TransferSuccess(
                  onBack: () => context.router.pop(),
                  onOkPressed: () => context.router.pop(),
                  statusContent: context.l10n.moneyReceived,
                ),
                txEscrowFailure: (_) => const InvalidEscrowErrorWidget(),
                orElse: () => TransferError(
                  onBack: () => context.router.pop(),
                  onRetry: () => context
                      .read<ISLPBloc>()
                      .add(ISLPEvent.process(payment.id)),
                ),
              );
            },
          );
        },
      );
}
