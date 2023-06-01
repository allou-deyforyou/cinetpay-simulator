import 'dart:math';

abstract class Machine {
  const Machine();

  Duration get duration;

  Duration get getHandlerDuration {
    if (Random().nextDouble() <= 0.25) {
      return duration + Duration(minutes: (Random().nextInt(6) + 5));
    }
    return duration;
  }
}

class MT extends Machine {
  const MT();

  @override
  Duration get duration => const Duration(minutes: 2);
}

class MJ extends Machine {
  const MJ();

  @override
  Duration get duration => const Duration(minutes: 3);
}

class MA extends Machine {
  const MA();

  @override
  Duration get duration => const Duration(minutes: 2, seconds: 30);
}

class MP extends Machine {
  const MP();

  @override
  Duration get duration => const Duration(minutes: 1);
}
