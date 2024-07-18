part of 'control_bloc.dart';

abstract class ControlState {
  final bool? streamStatus;
  final Map<String, dynamic>? serverResponse;
  const ControlState({this.streamStatus, this.serverResponse});
}

class StreamingState extends ControlState {
  const StreamingState(final Map<String, dynamic> serverResponse)
      : super(streamStatus: true, serverResponse: serverResponse);
}

class NotStreamingState extends ControlState {
  const NotStreamingState(final Map<String, dynamic> serverResponse)
      : super(streamStatus: false, serverResponse: serverResponse);
}
