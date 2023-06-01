import 'dart:math';

import '_schema.dart';

class Box {
  const Box._(this.pistons);

  factory Box.create() {
    final pistons = List<Machine>.empty(growable: true);
    final mt = List.filled(0 + Random().nextInt(2), const MT());
    final mj = List.filled(0 + Random().nextInt(2), const MJ());
    final ma = List.filled(0 + Random().nextInt(2), const MA());

    pistons.addAll([...mt, ...mj, ...ma]);
    return Box._(pistons..shuffle());
  }

  final List<Machine> pistons;
}

class PistonFactory {
  const PistonFactory._(this.pistons);

  factory PistonFactory.generate({required int boxCount}) {
    final values = List.generate(boxCount, (index) => Box.create());
    return PistonFactory._(values);
  }

  final List<Box> pistons;

  List<M> getTypeMachine<M extends Machine>() {
    return pistons.fold([], (result, item) => result..addAll(item.pistons)).whereType<M>().toList();
  }

  List<MP> getMPMachine({required int mtCount, required int mjCount, required int maCount}) {
    final result = min(min(mtCount, mjCount), maCount);
    return List.filled(result, const MP());
  }
}
