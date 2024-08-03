part of 'callibration_bloc.dart';

@immutable
sealed class CallibrationState {
  final bool? firstDistanceDone;
  final bool? secondDistanceDone;
  final bool? callibrationDone;
  final Map<String, dynamic>? callibrationParameters;
  final String? errorMessage;

  const CallibrationState({
    this.firstDistanceDone,
    this.secondDistanceDone,
    this.callibrationDone,
    this.callibrationParameters,
    this.errorMessage,
  });
}

final class CallibrationInitial extends CallibrationState {}

final class FirstDistanceDone extends CallibrationState {}

final class SecondDistanceDone extends CallibrationState {}

final class CallibrationDone extends CallibrationState {
  const CallibrationDone({required callibrationParameters})
      : super(callibrationParameters: callibrationParameters);
}

final class ErrorState extends CallibrationState {
  const ErrorState({required errorMessage}) : super(errorMessage: errorMessage);
}
