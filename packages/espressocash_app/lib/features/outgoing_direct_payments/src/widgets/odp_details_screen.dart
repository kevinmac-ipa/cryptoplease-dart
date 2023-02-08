import 'package:auto_route/auto_route.dart';
import 'package:dfunc/dfunc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/balances/context_ext.dart';
import '../../../../core/presentation/format_amount.dart';
import '../../../../core/presentation/format_date.dart';
import '../../../../core/presentation/utils.dart';
import '../../../../core/transactions/create_transaction_link.dart';
import '../../../../di.dart';
import '../../../../l10n/device_locale.dart';
import '../../../../l10n/l10n.dart';
import '../../../../ui/timeline.dart';
import '../../../../ui/transfer_status/transfer_error.dart';
import '../../../../ui/transfer_status/transfer_progress.dart';
import '../../../../ui/transfer_status/transfer_success.dart';
import '../../models/outgoing_direct_payment.dart';
import '../bl/bloc.dart';
import '../bl/repository.dart';

class ODPDetailsScreen extends StatefulWidget {
  const ODPDetailsScreen({
    super.key,
    required this.id,
  });

  final String id;

  @override
  State<ODPDetailsScreen> createState() => _ODPDetailsScreenState();
}

class _ODPDetailsScreenState extends State<ODPDetailsScreen> {
  late final Stream<OutgoingDirectPayment?> _payment;

  @override
  void initState() {
    super.initState();
    _payment = sl<ODPRepository>().watch(widget.id);
  }

  @override
  Widget build(BuildContext context) => StreamBuilder<OutgoingDirectPayment?>(
        stream: _payment,
        builder: (context, state) {
          final payment = state.data;

          return BlocConsumer<ODPBloc, ODPState>(
            listener: (context, _) => payment?.status.mapOrNull(
              success: (_) => context.notifyBalanceAffected(),
            ),
            builder: (context, state) {
              if (payment == null || state.contains(payment.id)) {
                return TransferProgress(
                  onBack: () => context.router.pop(),
                );
              }

              return payment.status.maybeMap(
                success: (status) => TransferSuccess(
                  onBack: () => context.router.pop(),
                  onOkPressed: () => context.router.pop(),
                  statusContent: context.l10n.outgoingTransferSuccess(
                    payment.amount.format(DeviceLocale.localeOf(context)),
                  ),
                  content: CpTimeline(
                    status: CpTimelineStatus.success,
                    active: 1,
                    items: [
                      CpTimelineItem(title: context.l10n.transferInitiated),
                      CpTimelineItem(
                        title: context.l10n.receivedBy(
                          payment.receiver.toBase58().toShortAddress(),
                        ),
                        // TODO(rhbrunetto): use received date instead
                        subtitle: context.formatDate(payment.created),
                      ),
                    ],
                  ),
                  onMoreDetailsPressed: () {
                    final link = status.txId
                        .let(createTransactionLink)
                        .let(Uri.parse)
                        .toString();
                    context.openLink(link);
                  },
                ),
                txFailure: (it) => TransferError(
                  onBack: () => context.router.pop(),
                  onRetry: () =>
                      context.read<ODPBloc>().add(ODPEvent.process(payment.id)),
                  reason: it.reason,
                ),
                orElse: () => TransferError(
                  onBack: () => context.router.pop(),
                  onRetry: () =>
                      context.read<ODPBloc>().add(ODPEvent.process(payment.id)),
                ),
              );
            },
          );
        },
      );
}
