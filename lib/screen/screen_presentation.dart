import 'package:gap/gap.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:widget_tools/widget_tools.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '_screen.dart';

class PresentationScreen extends StatelessWidget {
  const PresentationScreen({super.key});

  static const name = "presentation";
  static const path = "/presentation";

  /// Assets
  void _onSubmitPressed(BuildContext context) {
    DatabaseService.instance.value = true;
    context.goNamed(HomeScreen.name);
  }

  @override
  Widget build(BuildContext context) {
    return AdaptativeBuilder(
      builder: (context, type) {
        return Scaffold(
          body: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (type != BoxType.small) const Expanded(child: PresentationMachineImage()),
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverPinnedHeader(
                      child: PresentationAppBar(
                        trailing: ValueListenableBuilder<Locale>(
                          valueListenable: LocalizationService.instance,
                          builder: (context, locale, child) {
                            return PresentationDropdown(
                              onChanged: (value) => LocalizationService.instance.value = value!,
                              items: AppLocalizations.supportedLocales,
                              value: locale,
                            );
                          },
                        ),
                      ),
                    ),
                    SliverFillRemaining(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const PresentationMessage(),
                          const Gap(80.0),
                          PresentationSubmitButton(
                            onPressed: () => _onSubmitPressed(context),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
