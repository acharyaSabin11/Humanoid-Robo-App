import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

part 'callibration_event.dart';
part 'callibration_state.dart';

class CallibrationBloc extends Bloc<CallibrationEvent, CallibrationState> {
  CallibrationBloc() : super(CallibrationInitial()) {
    on<FirstDistanceComputeEvent>(onFirstDistanceComputeEvent);
    on<SecondDistanceComputeEvent>(onSecondDistanceComputeEvent);
    on<CallibrateEvent>(onCallibrateEvent);
  }

  onFirstDistanceComputeEvent(FirstDistanceComputeEvent event, emit) async {
    try {
      var response = await http
          .post(
            Uri.parse('http://192.168.254.16:3000/control/callibration'),
            headers: {'content-type': 'application/json'},
            body: jsonEncode(
              {'firstDistance': event.firstDistance},
            ),
          )
          .timeout(const Duration(seconds: 5));
      if (response.statusCode != 200) {
        emit(const ErrorState(
            errorMessage: 'You are unauthorized for this request'));
      } else {
        final body = jsonDecode(response.body);
        if (body['status'] == 'success') {
          emit(FirstDistanceDone());
        }
      }
    } catch (e) {
      emit(const ErrorState(errorMessage: 'Issue Connecting with the Server.'));
    }
  }

  onSecondDistanceComputeEvent(SecondDistanceComputeEvent event, emit) async {
    try {
      var response = await http
          .post(
            Uri.parse('http://192.168.254.16:3000/control/callibration'),
            headers: {'content-type': 'application/json'},
            body: jsonEncode(
              {'secondDistance': event.secondDistance},
            ),
          )
          .timeout(const Duration(seconds: 5));
      if (response.statusCode != 200) {
        emit(const ErrorState(
            errorMessage: 'You are unauthorized for this request'));
      } else {
        final body = jsonDecode(response.body);
        if (body['status'] == 'success') {
          emit(SecondDistanceDone());
        }
      }
    } catch (e) {
      emit(const ErrorState(errorMessage: 'Issue Connecting with the Server.'));
    }
  }

  onCallibrateEvent(CallibrateEvent event, emit) async {
    try {
      var response = await http
          .post(
            Uri.parse('http://192.168.254.16:3000/control/callibration'),
            headers: {'content-type': 'application/json'},
            body: jsonEncode(
              {'callibrate': true},
            ),
          )
          .timeout(const Duration(seconds: 5));
      if (response.statusCode != 200) {
        print(response.statusCode);
        emit(const ErrorState(
            errorMessage: 'You are unauthorized for this request'));
      } else {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        if (body['status'] == 'success') {
          emit(CallibrationDone(callibrationParameters: body));
        }
      }
    } catch (e) {
      emit(const ErrorState(errorMessage: 'Issue Connecting with the Server.'));
    }
  }
}
