import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:humanoid_robo_app/core/configs/colors/app_colors.dart';
import 'package:humanoid_robo_app/presentation/bloc/callibration_bloc/callibration_bloc.dart';
import 'package:humanoid_robo_app/presentation/widgets/app_button.dart';

class CallibrationPage extends StatelessWidget {
  CallibrationPage({super.key});
  final TextEditingController firstDistanceController = TextEditingController();
  final TextEditingController secondDistanceController =
      TextEditingController();
  final FocusNode firstNode = FocusNode();
  final FocusNode secondNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return BlocListener<CallibrationBloc, CallibrationState>(
      listener: (context, state) {
        print('Serv');
        if (state is ErrorState) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        }
      },
      child: GestureDetector(
        onTap: () {
          firstNode.unfocus();
          secondNode.unfocus();
        },
        child: Scaffold(
          backgroundColor: AppColors.scaffoldBGColor,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: BlocBuilder<CallibrationBloc, CallibrationState>(
                builder: (context, state) {
                  return SingleChildScrollView(
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            const Icon(
                              Icons.straighten,
                              size: 50,
                              color: AppColors.userInteractionColor,
                            ),
                            const Text(
                              'Parameters Callibration',
                              style: TextStyle(
                                color: AppColors.userInteractionColor,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 30),
                            CallibrationBox(
                              title: 'First Distance (cm)',
                              distanceController: firstDistanceController,
                              focusNode: firstNode,
                              done: (state is FirstDistanceDone ||
                                  state is SecondDistanceDone ||
                                  state is CallibrationDone),
                              onTap: () {
                                if (firstDistanceController.text.isNotEmpty) {
                                  BlocProvider.of<CallibrationBloc>(context)
                                      .add(FirstDistanceComputeEvent(
                                          firstDistance: double.parse(
                                              firstDistanceController.text)));
                                }
                              },
                            ),
                            const SizedBox(height: 30),
                            if (state is FirstDistanceDone ||
                                state is CallibrationDone ||
                                state is SecondDistanceDone)
                              CallibrationBox(
                                title: 'Second Distance (cm)',
                                distanceController: secondDistanceController,
                                focusNode: secondNode,
                                done: (state is SecondDistanceDone ||
                                    state is CallibrationDone),
                                onTap: () {
                                  if (secondDistanceController
                                      .text.isNotEmpty) {
                                    BlocProvider.of<CallibrationBloc>(context)
                                        .add(
                                      SecondDistanceComputeEvent(
                                        secondDistance: double.parse(
                                            secondDistanceController.text),
                                      ),
                                    );
                                  }
                                },
                              ),
                            const SizedBox(height: 30),
                            if (state is CallibrationDone)
                              Column(
                                children: [
                                  const Text(
                                    'Parameters',
                                    style: TextStyle(
                                      color: AppColors.userInteractionColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Focal Length:',
                                        style: const TextStyle(
                                          color: AppColors.textBlackColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        '${state.callibrationParameters!['focal-length']} cm',
                                        style: const TextStyle(
                                          color: AppColors.textBlackColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Tan Theta:',
                                        style: const TextStyle(
                                          color: AppColors.textBlackColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        '${state.callibrationParameters!['tantheta']}',
                                        style: const TextStyle(
                                          color: AppColors.textBlackColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ],
                              )
                          ],
                        ),
                        if (state is CallibrationDone ||
                            state is SecondDistanceDone)
                          Container(
                            width: double.maxFinite,
                            height: MediaQuery.of(context).size.height -
                                MediaQuery.of(context).padding.top -
                                MediaQuery.of(context).padding.bottom -
                                2 * 20,
                            alignment: Alignment.bottomCenter,
                            child: AppButton(
                              onTap: () {
                                BlocProvider.of<CallibrationBloc>(context)
                                    .add(CallibrateEvent());
                              },
                              title: 'Callibrate',
                              height: 50,
                            ),
                          )
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CallibrationBox extends StatelessWidget {
  final TextEditingController distanceController;
  final FocusNode focusNode;
  final String title;
  final VoidCallback onTap;
  final Widget? optionalWidget;
  final bool done;
  const CallibrationBox({
    super.key,
    required this.distanceController,
    required this.focusNode,
    required this.title,
    required this.onTap,
    this.optionalWidget,
    required this.done,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.callibrationBoxColor,
        boxShadow: const [
          BoxShadow(
              color: AppColors.inactiveButtonColor,
              offset: Offset(1, 1),
              blurRadius: 4,
              spreadRadius: 1)
        ],
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.userInteractionColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
                textAlign: TextAlign.center,
              ),
              if (done)
                const Text(
                  'Done',
                  style: TextStyle(
                    color: AppColors.userInteractionColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                  textAlign: TextAlign.center,
                ),
            ],
          ),
          const SizedBox(height: 15),
          TextField(
            controller: distanceController,
            focusNode: focusNode,
            decoration: const InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.inactiveButtonColor,
                  width: 2,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.userInteractionColor,
                  width: 2,
                ),
              ),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 15),
          Center(
            child: AppButton(
              onTap: onTap,
              title: 'Get Bounding Boxes',
              height: 50,
            ),
          ),
          optionalWidget ?? const SizedBox(),
        ],
      ),
    );
  }
}
