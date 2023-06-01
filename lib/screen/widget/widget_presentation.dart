import 'package:gap/gap.dart';
import 'package:flutter/material.dart';
import 'package:widget_tools/widget_tools.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '_widget.dart';

class PresentationMachineImage extends StatelessWidget {
  const PresentationMachineImage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: ColoredBox(
        color: Theme.of(context).colorScheme.primary,
        child: FractionallySizedBox(
          heightFactor: 0.7,
          child: Assets.images.chainIndustry.lottie(),
        ),
      ),
    );
  }
}

class PresentationAppBar extends CustomAppBar {
  const PresentationAppBar({
    super.key,
    required this.trailing,
  });

  final Widget trailing;

  @override
  Size get preferredSize => super.preferredSize * 1.5;

  @override
  Widget build(BuildContext context) {
    return AdaptativeBuilder(
      builder: (context, type) {
        return Center(
          widthFactor: type == BoxType.small ? 1.0 : 0.5,
          child: AppBar(
            elevation: 0.0,
            leadingWidth: 200.0,
            toolbarHeight: preferredSize.height,
            backgroundColor: Colors.transparent,
            leading: Center(
              child: Assets.images.logoCinetpay.image(width: 150.0),
            ),
            actions: [trailing],
          ),
        );
      },
    );
  }
}

class PresentationDropdown extends StatelessWidget {
  const PresentationDropdown({
    super.key,
    this.value,
    required this.items,
    required this.onChanged,
  });

  final Locale? value;
  final List<Locale> items;
  final ValueChanged<Locale?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Center(
        child: DropdownButton<Locale>(
          value: value,
          onChanged: onChanged,
          style: const TextStyle(color: Colors.grey),
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item.languageCode.capitalize()),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class PresentationMessage extends StatelessWidget {
  const PresentationMessage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;
    return AdaptativeBuilder(
      builder: (context, type) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                localizations.welcome.capitalize(),
                style: theme.textTheme.displayMedium,
              ),
              const Gap(10.0),
              Text(
                localizations.trysimulatorpistons.capitalize(),
                style: theme.textTheme.headlineMedium!.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class PresentationSubmitButton extends StatelessWidget {
  const PresentationSubmitButton({
    super.key,
    required this.onPressed,
  });

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: 34.0,
            vertical: 20.0,
          ),
        ),
        child: Text(
          localizations.getstarted.capitalize(),
          style: const TextStyle(fontSize: 18.0),
        ),
      ),
    );
  }
}
