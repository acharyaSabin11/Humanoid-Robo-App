part of 'distance_bloc.dart';

@immutable
sealed class DistanceState {
  final String? distance;
  const DistanceState({this.distance});
}

final class DistanceInitial extends DistanceState {}

final class GotDistance extends DistanceState {
  const GotDistance({required String distance}) : super(distance: distance);
}
