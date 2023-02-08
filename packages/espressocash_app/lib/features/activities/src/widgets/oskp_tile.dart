import 'package:auto_route/auto_route.dart';
import 'package:dfunc/dfunc.dart';
import 'package:flutter/material.dart';

import '../../../../core/presentation/format_amount.dart';
import '../../../../core/presentation/format_date.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../l10n/device_locale.dart';
import '../../../../l10n/l10n.dart';
import '../../../../routes.gr.dart';
import '../../../../ui/activity_tile.dart';
import '../activity.dart';

class OSKPTile extends StatelessWidget {
  const OSKPTile({super.key, required this.activity});

  final OSKPActivity activity;

  @override
  Widget build(BuildContext context) => ActivityTile(
        title: activity.data.status.maybeMap(
          canceled: always(context.l10n.transferCanceled),
          orElse: always(context.l10n.sentViaLink),
        ),
        amount: activity.data.status.maybeMap(
          orElse: always(
            '-${activity.data.amount.format(DeviceLocale.localeOf(context))}',
          ),
          canceled: always(null),
        ),
        subtitle: context.formatDate(activity.created),
        icon: activity.data.status.maybeMap(
          orElse: always(Assets.icons.outgoing.svg()),
          canceled: always(Assets.icons.txFailed.svg()),
        ),
        onTap: () => context.router.navigate(OSKPRoute(id: activity.id)),
      );
}
