import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const name = "home";
  static const path = "/";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// Assets
  late final ValueNotifier<bool> _concurrencyController;
  late final TextEditingController _boxCountController;

  void _onPop() {
    DatabaseService.instance.value = false;
    context.goNamed(PresentationScreen.name);
  }

  /// FactoryService
  late final FactoryService _factoryService;
  int? mtCount;
  int? mjCount;
  int? maCount;
  int? mpCount;

  Duration? mtDuration;
  Duration? mjDuration;
  Duration? maDuration;
  Duration? mpDuration;
  Duration? totalDuration;

  void _listenFactoryState() {
    final state = _factoryService.value;
    if (state is FactoryResultFilterState) {
      mtCount = state.mtList.length;
      mjCount = state.mjList.length;
      maCount = state.maList.length;
      mpCount = state.mpList.length;

      _handleFactory(
        mtList: state.mtList,
        mjList: state.mjList,
        maList: state.maList,
        mpList: state.mpList,
      );
    } else if (state is FactoryMachineHandlerResultState) {
      mtDuration = state.mtDuration;
      mjDuration = state.mjDuration;
      maDuration = state.maDuration;
      mpDuration = state.mpDuration;
      totalDuration = state.totalDuration;
    }
  }

  void _clearFactory() {
    _boxCountController.clear();
    _concurrencyController.value = false;
    _factoryService.value = const FactoryInitState();
  }

  void _filterFactory() {
    final boxCount = int.tryParse(_boxCountController.text);
    if (boxCount != null) {
      _factoryService.handle(FactoryFilterBoxEvent(boxCount: boxCount));
    }
  }

  void _handleFactory({
    required List<MT> mtList,
    required List<MJ> mjList,
    required List<MA> maList,
    required List<MP> mpList,
  }) {
    _factoryService.handle(FactoryMachineHandlerEvent(
      concurrency: _concurrencyController.value,
      mtList: mtList,
      mjList: mjList,
      maList: maList,
      mpList: mpList,
    ));
  }

  @override
  void initState() {
    super.initState();

    /// Assets
    _concurrencyController = ValueNotifier(false);
    _boxCountController = TextEditingController();

    /// FactoryService
    _factoryService = FactoryService();
    _factoryService.addListener(_listenFactoryState);
  }

  @override
  void dispose() {
    _factoryService.removeListener(_listenFactoryState);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: HomeAppBar(
        onPop: _onPop,
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
      body: Center(
        child: AspectRatio(
          aspectRatio: 0.6,
          child: CustomScrollView(
            slivers: [
              const SliverPadding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                sliver: SliverToBoxAdapter(child: HomeMessage()),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 16.0)),
              SliverToBoxAdapter(
                child: ValueListenableBuilder<bool>(
                  valueListenable: _concurrencyController,
                  builder: (context, value, child) {
                    return HomeSegmentButtons(
                      onChanged: (value) => _concurrencyController.value = value,
                      value: value,
                    );
                  },
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 8.0)),
              SliverToBoxAdapter(
                child: HomeFormField(
                  controller: _boxCountController,
                  onSubmitted: _filterFactory,
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 16.0)),
              ValueListenableBuilder<FactoryState>(
                valueListenable: _factoryService,
                builder: (context, state, child) {
                  if (state is FactoryInitState) {
                    return const SliverFillRemaining(
                      hasScrollBody: false,
                    );
                  }
                  return SliverList.list(
                    children: [
                      HomeValidatorItemWidget(
                        label: Text(localizations.createannfilterparts.capitalize()),
                        children: [
                          HomeLabel(label: localizations.headcount.capitalize(), value: '$mtCount'),
                          HomeLabel(label: localizations.skirtcount.capitalize(), value: '$mjCount'),
                          HomeLabel(label: localizations.pincount.capitalize(), value: '$maCount'),
                          HomeLabel(label: localizations.possiblepistoncount.capitalize(), value: '$mpCount'),
                        ],
                      ),
                      HomeValidatorItemWidget(
                        label: Text(localizations.processingandassemblypart.capitalize()),
                        children: [
                          HomeLabel(label: localizations.headduration.capitalize(), value: mtDuration!.formatDuration()),
                          HomeLabel(label: localizations.skirtduration.capitalize(), value: mjDuration!.formatDuration()),
                          HomeLabel(label: localizations.pinduration.capitalize(), value: maDuration!.formatDuration()),
                          HomeLabel(label: localizations.assemblyduration.capitalize(), value: mpDuration!.formatDuration()),
                        ],
                      ),
                      const SizedBox(height: 24.0),
                      Card(
                        elevation: 0.0,
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                        child: ListTile(
                          trailing: TextButton(
                            onPressed: _clearFactory,
                            style: TextButton.styleFrom(foregroundColor: CupertinoColors.activeOrange),
                            child: Text(localizations.clear.capitalize()),
                          ),
                          title: HomeLabel(
                            label: localizations.totalduration.capitalize(),
                            value: totalDuration!.formatDuration(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24.0),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
