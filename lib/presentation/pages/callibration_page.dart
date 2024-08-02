import 'package:flutter/material.dart';
import 'package:humanoid_robo_app/core/configs/colors/app_colors.dart';
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
    return GestureDetector(
      onTap: () {
        firstNode.unfocus();
        secondNode.unfocus();
      },
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBGColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
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
                        onTap: () {},
                      ),
                      const SizedBox(height: 30),
                      CallibrationBox(
                        title: 'Second Distance (cm)',
                        distanceController: secondDistanceController,
                        focusNode: secondNode,
                        onTap: () {},
                      ),
                      const SizedBox(height: 30),
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
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Focal Length:',
                            style: const TextStyle(
                              color: AppColors.textBlackColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            '0.5 cm',
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
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Tan Theta:',
                            style: const TextStyle(
                              color: AppColors.textBlackColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            '2.56',
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
                  ),
                  Container(
                    width: double.maxFinite,
                    height: MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.top -
                        MediaQuery.of(context).padding.bottom -
                        2 * 20,
                    alignment: Alignment.bottomCenter,
                    child: AppButton(
                      onTap: () {},
                      title: 'Callibrate',
                      height: 50,
                    ),
                  )
                ],
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
  const CallibrationBox({
    super.key,
    required this.distanceController,
    required this.focusNode,
    required this.title,
    required this.onTap,
    this.optionalWidget,
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
          Text(
            title,
            style: const TextStyle(
              color: AppColors.userInteractionColor,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),
          TextField(
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
              onTap: () {},
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
