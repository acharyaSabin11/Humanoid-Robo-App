part of 'saveimages_bloc.dart';

@immutable
sealed class SaveimagesEvent {}

class SaveEvent extends SaveimagesEvent {}

class DontSaveEvent extends SaveimagesEvent {}
