import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:humanoid_robo_app/presentation/bloc/control_bloc/control_bloc.dart';

class ControlPage extends StatelessWidget {
  ControlPage({super.key});
  bool boundingBoxes = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(
      child: BlocBuilder<ControlBloc, ControlState>(
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ToggleButtons(children: children, isSelected: isSelected)
              ElevatedButton(
                onPressed: () {
                  BlocProvider.of<ControlBloc>(context).add(
                    StreamControlEvent(
                      stream: state.streamStatus == false ? 'start' : 'stop',
                    ),
                  );
                },
                child: Text(
                  state.streamStatus == false ? 'Start' : 'Stop',
                  style: const TextStyle(color: Colors.blue, fontSize: 18),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Bounding Boxes',
                    style: const TextStyle(
                        fontSize: 20,
                        color: Colors.purple,
                        fontWeight: FontWeight.bold),
                  ),
                  Checkbox(
                      value:
                          state.serverResponse!['boundingBoxStatus'] ?? false,
                      onChanged: (value) => {
                            BlocProvider.of<ControlBloc>(context).add(
                              StreamControlEvent(
                                showBoundingBoxes: value,
                              ),
                            )
                          }),
                ],
              ),
              Text(
                'Stream Status: ' +
                        state.serverResponse!['Stream1'].toString() ??
                    'Null',
                style: const TextStyle(
                    fontSize: 25,
                    color: Colors.purple,
                    fontWeight: FontWeight.bold),
              ),
            ],
          );
        },
      ),
    ));
  }
}
