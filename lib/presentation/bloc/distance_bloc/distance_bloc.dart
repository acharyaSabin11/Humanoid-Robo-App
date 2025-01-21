import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:humanoid_robo_app/utils/constants.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

part 'distance_event.dart';
part 'distance_state.dart';

class DistanceBloc extends Bloc<DistanceEvent, DistanceState> {
  DistanceBloc() : super(DistanceInitial()) {
    on<GetDistance>(onGetDistance);
  }

  onGetDistance(GetDistance event, emit) async {
    try {
      var response = await http
          .get(
            Uri.parse('${AppConstants.BASE_URL}/control/distance'),
          )
          .timeout(const Duration(seconds: 5));
      response = await http
          .get(
            Uri.parse('${AppConstants.BASE_URL}/control/distance'),
          )
          .timeout(const Duration(seconds: 5));
      if (response.statusCode != 200) {
        print('Here');
        emit(const GotDistance(distance: 'Error Getting Distance'));
      } else {
        final body = jsonDecode(response.body);
        print(body['Distance']);
        if (body['Object'] == true) {
          emit(GotDistance(
              distance: '${(body['Distance'] as double).round()} cm'));
        } else {
          emit(const GotDistance(distance: 'Error Getting Distance'));
        }
      }
    } catch (e) {
      emit(const GotDistance(distance: 'Server Error'));
    }
  }
}
