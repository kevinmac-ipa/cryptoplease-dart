import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../../l10n/l10n.dart';
import '../../../../ui/app_bar.dart';
import '../../../../ui/info_widget.dart';
import '../../../../ui/onboarding_screen.dart';
import '../../../../ui/theme.dart';
import 'onboarding_flow_screen.dart';

class NoEmailAndPasswordScreen extends StatelessWidget {
  const NoEmailAndPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => CpTheme.dark(
        child: Scaffold(
          body: OnboardingScreen(
            footer: OnboardingFooterButton(
              text: context.l10n.iUnderstand,
              onPressed: () => context.onboardingRouter
                  .onExplainNoEmailAndPasswordCompleted(),
            ),
            children: [
              CpAppBar(
                leading: BackButton(
                  onPressed: () => context.router.pop(),
                ),
              ),
              const OnboardingLogo(),
              OnboardingPadding(
                child: CpInfoWidget(
                  message: Text(context.l10n.noEmailInCryptoInfo),
                ),
              ),
              const SizedBox(height: 38),
              OnboardingDescription(
                text: context.l10n.noEmailInCryptoParagraph,
              ),
            ],
          ),
        ),
      );
}
