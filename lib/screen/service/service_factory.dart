import 'dart:math';

import 'package:flutter/foundation.dart';

import '_service.dart';

abstract class FactoryState {
  const FactoryState();
}

class FactoryInitState extends FactoryState {
  const FactoryInitState();
}

class FactoryPendingState extends FactoryState {
  const FactoryPendingState();
}

class FactoryFilterPendingState extends FactoryPendingState {
  const FactoryFilterPendingState();
}

class FactoryMachineHandlerPendingState extends FactoryPendingState {
  const FactoryMachineHandlerPendingState();
}

class FactoryFailureState extends FactoryState {
  const FactoryFailureState();
}

class FactoryService extends ValueNotifier<FactoryState> {
  FactoryService([super.value = const FactoryInitState()]);

  Future<void> handle(FactoryEvent event) => event.execute(this);
}

class FactoryResultFilterState extends FactoryState {
  const FactoryResultFilterState({
    required this.mtList,
    required this.mjList,
    required this.maList,
    required this.mpList,
  });

  final List<MT> mtList;
  final List<MJ> mjList;
  final List<MA> maList;
  final List<MP> mpList;
}

class FactoryMachineHandlerResultState extends FactoryState {
  const FactoryMachineHandlerResultState({
    required this.mtDuration,
    required this.mjDuration,
    required this.maDuration,
    required this.mpDuration,
    required this.totalDuration,
    required this.concurrency,
  });

  final Duration mtDuration;
  final Duration mjDuration;
  final Duration maDuration;
  final Duration mpDuration;
  final Duration totalDuration;

  final bool concurrency;
}

abstract class FactoryEvent {
  const FactoryEvent();

  Future<void> execute(FactoryService service);
}

class FactoryFilterBoxEvent extends FactoryEvent {
  const FactoryFilterBoxEvent({
    required this.boxCount,
  });

  final int boxCount;

  @override
  Future<void> execute(FactoryService service) async {
    service.value = const FactoryFilterPendingState();
    final factory = PistonFactory.generate(boxCount: boxCount);

    final mtList = factory.getTypeMachine<MT>();
    final mjList = factory.getTypeMachine<MJ>();
    final maList = factory.getTypeMachine<MA>();
    final mpList = factory.getMPMachine(mtCount: mtList.length, mjCount: mjList.length, maCount: maList.length);

    service.value = FactoryResultFilterState(mtList: mtList, mjList: mjList, maList: maList, mpList: mpList);
  }
}

class FactoryMachineHandlerEvent extends FactoryEvent {
  const FactoryMachineHandlerEvent({
    this.concurrency = false,
    required this.mtList,
    required this.mjList,
    required this.maList,
    required this.mpList,
  });

  final List<MT> mtList;
  final List<MJ> mjList;
  final List<MA> maList;
  final List<MP> mpList;
  final bool concurrency;

  @override
  Future<void> execute(FactoryService service) async {
    service.value = const FactoryMachineHandlerPendingState();

    final mtDuration = mtList.fold(Duration.zero, (result, item) => item.getHandlerDuration + result);
    final mjDuration = mjList.fold(Duration.zero, (result, item) => item.getHandlerDuration + result);
    final maDuration = maList.fold(Duration.zero, (result, item) => item.getHandlerDuration + result);

    final duration = concurrency ? max(max(maDuration.inMinutes, mjDuration.inMinutes), mtDuration.inMinutes) : mtDuration.inMinutes + mjDuration.inMinutes + maDuration.inMinutes;

    final mpDuration = mpList.fold(Duration.zero, (result, item) => item.getHandlerDuration + result);

    service.value = FactoryMachineHandlerResultState(
      totalDuration: Duration(minutes: duration) + mpDuration,
      concurrency: concurrency,
      mtDuration: mtDuration,
      mjDuration: mjDuration,
      maDuration: maDuration,
      mpDuration: mpDuration,
    );
  }
}
