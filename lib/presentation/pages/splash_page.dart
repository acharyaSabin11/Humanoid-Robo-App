import 'package:flutter/material.dart';
import 'package:humanoid_robo_app/core/configs/assets/app_images.dart';
import 'package:humanoid_robo_app/core/configs/colors/app_colors.dart';
import 'package:humanoid_robo_app/presentation/pages/control_page.dart';
import 'package:humanoid_robo_app/presentation/pages/home_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late final memberStyle;
  @override
  void initState() {
    super.initState();
    memberStyle = TextStyle(
      color: AppColors.textBlackColor,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    );
    redirect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Image.asset(AppImages.topRightImage),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Image.asset(AppImages.bottomLeftImage),
            ),
            Positioned(
              top: MediaQuery.of(context)
                  .viewPadding
                  .top, //getting the height of the status bar
              left: 20,
              child: SizedBox(
                height: 80,
                child: Image.asset(
                  AppImages.thapathaliHeaderImage,
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const SizedBox(height: 100),
                    Image.asset(
                      AppImages.roboImage,
                      height: 300,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Enhancing Humanoid Robot Functionality Through Vision-Based Navigation with Fall Recovery and Object Manipulation',
                      style: TextStyle(
                        color: AppColors.userInteractionColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 25),
                    const Text(
                      'Team Members: ',
                      style: TextStyle(
                        color: AppColors.textBlackColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Aayush Pathak(THA077BEI002)',
                      style: memberStyle,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Bal Krishna Shah(THA077BEI010)',
                      style: memberStyle,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Sabin Acharya(THA077BEI035)',
                      style: memberStyle,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Safal Karki(THA077BEI036)',
                      style: memberStyle,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 25),
                    const Text(
                      'Under the supervision of',
                      style: TextStyle(
                        color: AppColors.textBlackColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Er.Saroj Shakya',
                      style: memberStyle,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> redirect() async {
    await Future.delayed(const Duration(seconds: 2));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomePage(),
      ),
    );
  }
}
