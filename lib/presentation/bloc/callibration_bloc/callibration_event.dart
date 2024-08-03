part of 'callibration_bloc.dart';

@immutable
sealed class CallibrationEvent {
  final double? firstDistance;
  final double? secondDistance;

  const CallibrationEvent({this.firstDistance, this.secondDistance});
}

class FirstDistanceComputeEvent extends CallibrationEvent {
  const FirstDistanceComputeEvent({required firstDistance})
      : super(firstDistance: firstDistance);
}

class SecondDistanceComputeEvent extends CallibrationEvent {
  const SecondDistanceComputeEvent({required secondDistance})
      : super(secondDistance: secondDistance);
}

class CallibrateEvent extends CallibrationEvent {}
