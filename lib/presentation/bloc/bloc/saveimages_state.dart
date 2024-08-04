part of 'saveimages_bloc.dart';

@immutable
sealed class SaveimagesState {
  final bool status;
  const SaveimagesState({this.status = false});
}

final class SaveimagesInitial extends SaveimagesState {}

class ResponseReceivedState extends SaveimagesState {
  const ResponseReceivedState({required bool status}) : super(status: status);
}

class ResponseFailedState extends SaveimagesState {}
