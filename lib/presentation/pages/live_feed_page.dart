import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:humanoid_robo_app/core/configs/colors/app_colors.dart';
import 'package:humanoid_robo_app/presentation/bloc/distance_bloc/distance_bloc.dart';
import 'package:humanoid_robo_app/presentation/widgets/app_button.dart';
import 'package:humanoid_robo_app/presentation/widgets/image_stream_widget.dart';
import 'package:humanoid_robo_app/utils/constants.dart';

class LiveFeedPage extends StatefulWidget {
  const LiveFeedPage({super.key});

  @override
  State<LiveFeedPage> createState() => _LiveFeedPageState();
}

class _LiveFeedPageState extends State<LiveFeedPage> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  final double scaleFactor = 1.5;
  final double height = 320;
  final width = 480;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.only(top: 20),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Live Stream',
              style: TextStyle(
                color: AppColors.userInteractionColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ImageStreamWidget(
                  url: '${AppConstants.BASE_URL}/control/stream1',
                  height: height / scaleFactor,
                  width: width / scaleFactor,
                  label: 'Left-Cam',
                ),
                const SizedBox(width: 30),
                ImageStreamWidget(
                  url: '${AppConstants.BASE_URL}/control/stream2',
                  height: height / scaleFactor,
                  width: width / scaleFactor,
                  label: 'Right-Cam',
                ),
              ],
            ),
            AppButton(
              onTap: () {
                BlocProvider.of<DistanceBloc>(context).add(GetDistance());
              },
              title: 'Calculate Distance',
              width: 200,
            ),
            const SizedBox(height: 5),
            BlocBuilder<DistanceBloc, DistanceState>(
              builder: (context, state) {
                return Text(
                  'Image at Distance: ${state.distance}',
                  style: const TextStyle(
                    color: AppColors.userInteractionColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                );
              },
            ),
          ],
        ),
      ),
    ));
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }
}
