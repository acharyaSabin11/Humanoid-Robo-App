import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:humanoid_robo_app/core/configs/colors/app_colors.dart';
import 'package:humanoid_robo_app/presentation/bloc/control_bloc/control_bloc.dart';
import 'package:humanoid_robo_app/presentation/widgets/toggle_widget.dart';

class ControlPage extends StatelessWidget {
  ControlPage({super.key});
  bool boundingBoxes = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBGColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(
                Icons.settings,
                size: 37,
                color: AppColors.userInteractionColor,
              ),
              const Text(
                'Control Center',
                style: TextStyle(
                  color: AppColors.userInteractionColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),
              Expanded(
                child: BlocBuilder<ControlBloc, ControlState>(
                  builder: (context, state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Stream Control',
                          style: TextStyle(
                            color: AppColors.userInteractionColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        ToggleWidget(
                          onTap: () {
                            BlocProvider.of<ControlBloc>(context).add(
                              StreamControlEvent(
                                stream: state.streamStatus == false
                                    ? 'start'
                                    : 'stop',
                              ),
                            );
                          },
                          toggleText: 'Stream Status',
                          buttonText: const ['On', 'Off'],
                          buttonStatus: state.streamStatus ?? false,
                          indent: true,
                        ),
                        const SizedBox(height: 10),
                        ToggleWidget(
                          onTap: () {
                            BlocProvider.of<ControlBloc>(context).add(
                              StreamControlEvent(
                                showBoundingBoxes: !(state
                                        .serverResponse!['boundingBoxStatus'] ??
                                    false),
                              ),
                            );
                          },
                          toggleText: 'Bounding Boxes',
                          buttonText: const ['On', 'Off'],
                          buttonStatus:
                              state.serverResponse!['boundingBoxStatus'] ??
                                  false,
                          indent: true,
                        ),
                      ],
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
