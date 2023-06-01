import 'package:gap/gap.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:widget_tools/widget_tools.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '_widget.dart';

class HomeAppBar extends CustomAppBar {
  const HomeAppBar({
    super.key,
    required this.trailing,
    this.onPop,
  });

  final Widget trailing;

  final VoidCallback? onPop;

  @override
  Size get preferredSize => super.preferredSize * 1.2;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return AdaptativeBuilder(
      builder: (context, type) {
        return AppBar(
          leadingWidth: type != BoxType.small ? 160.0 : null,
          toolbarHeight: preferredSize.height,
          leading: FittedBox(
            fit: BoxFit.scaleDown,
            child: Visibility(
              visible: type != BoxType.small,
              replacement: TextButton(
                onPressed: onPop,
                style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.onPrimary),
                child: const Icon(Icons.arrow_back),
              ),
              child: TextButton.icon(
                onPressed: onPop,
                style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.onPrimary),
                label: Text(localizations.presentation.capitalize()),
                icon: const Icon(Icons.arrow_back),
              ),
            ),
          ),
          title: Text(localizations.cinetpaysimulator.capitalize()),
          actions: [trailing],
        );
      },
    );
  }
}

class HomeMessage extends StatelessWidget {
  const HomeMessage({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return ListTile(
      title: Text(
        localizations.fillinformation.capitalize(),
        style: Theme.of(context).textTheme.titleMedium!.copyWith(height: 1.5, color: CupertinoColors.systemGrey),
      ),
    );
  }
}

class HomeSegmentButtons extends StatelessWidget {
  const HomeSegmentButtons({
    super.key,
    this.value = false,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return ListTile(
      title: Text(localizations.productionmode.capitalize()),
      subtitle: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(top: 8.0),
        child: SegmentedButton<bool>(
          onSelectionChanged: (selected) {
            onChanged.call(selected.first);
          },
          segments: [
            ButtonSegment(
              value: false,
              label: Text(localizations.recurrent.capitalize()),
            ),
            ButtonSegment(
              value: true,
              label: Text(localizations.parallel.capitalize()),
            ),
          ],
          selected: {value},
        ),
      ),
    );
  }
}

class HomeFormField extends StatelessWidget {
  const HomeFormField({
    super.key,
    required this.controller,
    required this.onSubmitted,
  });

  final VoidCallback? onSubmitted;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return ListTile(
      title: Text(localizations.pistonscount.capitalize()),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: controller,
                onFieldSubmitted: (value) => onSubmitted?.call(),
                decoration: InputDecoration(hintText: localizations.entercount.capitalize()),
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
              ),
            ),
            const Gap(10.0),
            ElevatedButton(
              onPressed: onSubmitted,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                elevation: 0.0,
              ),
              child: const Text("GO"),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeValidatorItemWidget extends StatelessWidget {
  const HomeValidatorItemWidget({
    super.key,
    required this.label,
    required this.children,
  });

  final Widget label;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.check, color: CupertinoColors.activeGreen),
      title: label,
      subtitle: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        alignment: Alignment.centerLeft,
        child: Card(
          elevation: 0.0,
          color: CupertinoColors.systemFill,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children.map((child) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: child,
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class HomeLabel extends StatelessWidget {
  const HomeLabel({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const TextSpan(text: ' '),
          TextSpan(text: value),
        ],
      ),
    );
  }
}
