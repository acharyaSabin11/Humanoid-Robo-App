import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:humanoid_robo_app/core/configs/colors/app_colors.dart';
import 'package:humanoid_robo_app/presentation/bloc/bloc/saveimages_bloc.dart';
import 'package:humanoid_robo_app/presentation/widgets/toggle_widget.dart';

class SavePage extends StatelessWidget {
  const SavePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SaveimagesBloc, SaveimagesState>(
      listener: (context, state) {
        if (state is ResponseFailedState) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed Connecting to Server')));
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBGColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Column(
                children: [
                  const Icon(
                    Icons.image,
                    size: 37,
                    color: AppColors.userInteractionColor,
                  ),
                  const Text(
                    'Dataset Generation',
                    style: TextStyle(
                      color: AppColors.userInteractionColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 50),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Save Images',
                          style: TextStyle(
                            color: AppColors.userInteractionColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        BlocBuilder<SaveimagesBloc, SaveimagesState>(
                          builder: (context, state) {
                            return ToggleWidget(
                              buttonStatus: state.status,
                              buttonText: const ['Saving', 'Not saving'],
                              onTap: () {
                                state.status
                                    ? BlocProvider.of<SaveimagesBloc>(context)
                                        .add(DontSaveEvent())
                                    : BlocProvider.of<SaveimagesBloc>(context)
                                        .add(SaveEvent());
                              },
                              toggleText: 'Toggle Saving Images',
                              indent: true,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
