import 'package:flutter/material.dart';
import 'package:humanoid_robo_app/core/configs/assets/app_images.dart';
import 'package:humanoid_robo_app/presentation/pages/control_page.dart';

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
      color: Colors.blue,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    );
    redirect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AppImages.roboImage),
            Text(
              'Humaoid Robo (Major Project - Thapathali Campus)',
              style: TextStyle(
                color: Colors.blue[900],
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const Text(
              'Team Members: ',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
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
        builder: (context) => ControlPage(),
      ),
    );
  }
}
