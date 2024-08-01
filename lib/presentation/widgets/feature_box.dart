import 'package:flutter/material.dart';
import 'package:humanoid_robo_app/core/configs/colors/app_colors.dart';

class FeatureBox extends StatelessWidget {
  const FeatureBox({
    super.key,
    required this.title,
    required this.iconData,
    this.color = AppColors.userInteractionColor,
    required this.onTap,
  });

  final String title;
  final IconData iconData;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 6,
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        splashColor: color.withOpacity(0.1),
        child: Container(
          padding:
              const EdgeInsets.only(top: 15, bottom: 20, left: 20, right: 20),
          height: 140,
          width: 140,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                iconData,
                size: 56,
                color: color,
              ),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: color,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    height: 1.2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
