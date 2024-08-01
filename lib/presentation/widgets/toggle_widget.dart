import 'package:flutter/material.dart';
import 'package:humanoid_robo_app/core/configs/colors/app_colors.dart';

class ToggleWidget extends StatelessWidget {
  const ToggleWidget({
    super.key,
    required this.onTap,
    required this.toggleText,
    required this.buttonText,
    required this.buttonStatus,
    required this.indent,
  });
  final VoidCallback onTap;
  final List<String> buttonText;
  final String toggleText;
  final bool buttonStatus;
  final bool indent;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: indent ? 20 : 0),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                toggleText,
                style: const TextStyle(
                  color: AppColors.textBlackColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              Material(
                elevation: 6,
                color: buttonStatus
                    ? AppColors.userInteractionColor
                    : AppColors.inactiveButtonColor,
                borderRadius: BorderRadius.circular(30),
                child: InkWell(
                  onTap: onTap,
                  borderRadius: BorderRadius.circular(30),
                  splashColor: (!buttonStatus
                          ? AppColors.userInteractionColor
                          : AppColors.inactiveButtonColor)
                      .withOpacity(0.1),
                  child: Container(
                    height: 30,
                    constraints: const BoxConstraints(minWidth: 60),
                    child: Center(
                      child: Text(
                        buttonStatus ? buttonText[0] : buttonText[1],
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
