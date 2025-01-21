import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:humanoid_robo_app/utils/constants.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

part 'saveimages_event.dart';
part 'saveimages_state.dart';

class SaveimagesBloc extends Bloc<SaveimagesEvent, SaveimagesState> {
  SaveimagesBloc() : super(SaveimagesInitial()) {
    on<SaveEvent>(onSaveEvent);
    on<DontSaveEvent>(onDontSaveEvent);
  }

  onSaveEvent(SaveEvent event, emit) async {
    await saveFunction(true, emit);
  }

  onDontSaveEvent(DontSaveEvent event, emit) async {
    await saveFunction(false, emit);
  }

  Future<void> saveFunction(bool task, emit) async {
    try {
      var response = await http
          .post(
            Uri.parse('${AppConstants.BASE_URL}/control/save'),
            headers: {'content-type': 'application/json'},
            body: jsonEncode(
              {'save': task},
            ),
          )
          .timeout(const Duration(seconds: 5));
      if (response.statusCode != 200) {
        emit(ResponseFailedState());
      } else {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final bool status = body['status'] as bool;
        emit(ResponseReceivedState(status: status));
      }
    } catch (e) {
      print(e);
      emit(ResponseFailedState());
    }
  }
}
