import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:humanoid_robo_app/presentation/bloc/callibration_bloc/callibration_bloc.dart';
import 'package:humanoid_robo_app/presentation/bloc/control_bloc/control_bloc.dart';
import 'package:humanoid_robo_app/presentation/bloc/distance_bloc/distance_bloc.dart';
import 'package:humanoid_robo_app/presentation/pages/splash_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ControlBloc(),
        ),
        BlocProvider(
          create: (context) => CallibrationBloc(),
        ),
        BlocProvider(
          create: (context) => DistanceBloc(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const SplashPage(),
      ),
    );
  }
}
