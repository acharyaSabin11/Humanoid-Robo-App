import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

part 'control_event.dart';
part 'control_state.dart';

const baseUrl = 'http://192.168.254.16:3000';

class ControlBloc extends Bloc<ControlEvent, ControlState> {
  ControlBloc() : super(const NotStreamingState({})) {
    on<StreamControlEvent>(streamControlHandler);
  }

  void streamControlHandler(StreamControlEvent event, emit) async {
    Uri url = Uri.parse('$baseUrl/control');
    print(event.stream);
    var response = await http.post(
      url,
      headers: {'content-type': 'application/json'},
      body: jsonEncode(
        {
          "streaming": event.stream ?? '',
          'showBoundingBoxes': event.showBoundingBoxes,
        },
      ),
    );
    debugPrint('Response status: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');
    debugPrint('Map: ${(jsonDecode(response.body))['Stream1']}');
    if (response.statusCode == 200) {
      if (event.stream == 'start') {
        emit(StreamingState(jsonDecode(response.body)));
      } else {
        emit(NotStreamingState(jsonDecode(response.body)));
      }
    }
  }
}
