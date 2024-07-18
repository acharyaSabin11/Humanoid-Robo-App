part of 'control_bloc.dart';

abstract class ControlEvent {
  const ControlEvent();
}

class StreamControlEvent extends ControlEvent {
  final String? stream;
  final bool? showBoundingBoxes;
  const StreamControlEvent({this.stream, this.showBoundingBoxes});
}
