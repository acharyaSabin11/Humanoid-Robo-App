import 'package:flutter/material.dart';
import 'package:humanoid_robo_app/core/configs/colors/app_colors.dart';
import 'package:humanoid_robo_app/presentation/pages/callibration_page.dart';
import 'package:humanoid_robo_app/presentation/pages/control_page.dart';
import 'package:humanoid_robo_app/presentation/pages/live_feed_page.dart';
import 'package:humanoid_robo_app/presentation/pages/motion_planning_page.dart';
import 'package:humanoid_robo_app/presentation/pages/save_page.dart';
import 'package:humanoid_robo_app/presentation/widgets/feature_box.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBGColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              children: [
                const Text(
                  'Robo Hub',
                  style: TextStyle(
                    color: AppColors.userInteractionColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: GridView.count(
                      crossAxisSpacing: 30,
                      mainAxisSpacing: 20,
                      crossAxisCount: 2,
                      children: [
                        FeatureBox(
                          iconData: Icons.settings,
                          title: 'Control Center',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ControlPage(),
                              ),
                            );
                          },
                        ),
                        FeatureBox(
                          iconData: Icons.stream,
                          title: 'Live Stream',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LiveFeedPage(),
                              ),
                            );
                          },
                        ),
                        FeatureBox(
                          iconData: Icons.android,
                          title: 'Robot Status',
                          onTap: () {},
                        ),
                        FeatureBox(
                          iconData: Icons.straighten,
                          title: 'Parameter Calibration',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CallibrationPage(),
                              ),
                            );
                          },
                        ),
                        FeatureBox(
                          iconData: Icons.image,
                          title: 'Dataset Generation',
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const SavePage()));
                          },
                        ),
                        FeatureBox(
                          iconData: Icons.directions_run,
                          title: 'Motion Planning',
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    const MotionPlanningPage()));
                          },
                        ),
                        FeatureBox(
                          iconData: Icons.access_time,
                          title: 'Comming Soon',
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
