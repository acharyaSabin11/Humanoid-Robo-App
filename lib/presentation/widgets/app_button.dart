import 'package:flutter/material.dart';
import 'package:humanoid_robo_app/core/configs/colors/app_colors.dart';

class AppButton extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final double width;
  const AppButton({
    super.key,
    required this.onTap,
    required this.title,
    this.width = 150,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 6,
      color: AppColors.userInteractionColor,
      borderRadius: BorderRadius.circular(30),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        splashColor: AppColors.userInteractionColor.withOpacity(0.1),
        child: Container(
          height: 40,
          width: width,
          constraints: const BoxConstraints(minWidth: 60, maxWidth: 300),
          child: Center(
            child: Text(
              title,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
