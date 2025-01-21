import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:humanoid_robo_app/core/configs/colors/app_colors.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MotionPlanningPage extends StatefulWidget {
  const MotionPlanningPage({super.key});

  @override
  State<MotionPlanningPage> createState() => _MotionPlanningPageState();
}

class _MotionPlanningPageState extends State<MotionPlanningPage> {
  static const Map<String, int> referenceMotorMap = {
    '0:Right Hip Yaw': 84,
    '1:Right Hip Roll': 77,
    '2:Right Hip Ptich': 90,
    '3:Right Knee': 90,
    '4:Right Ankle': 136,
    '5:Right Foot': 94,
    '6:Left Hip Yaw': 80,
    '7:Left Hip Roll': 90,
    '8:Left Hip Pitch': 90,
    '9:Left Knee': 74,
    '10:Left Ankle': 103,
    '11:Left Foot': 86,
    '12:Right Shoulder Pitch': 90,
    '13:Left Shoulder Pitch': 46,
    '14:Right Shoulder Roll': 90,
    '15:Left Shoulder Roll': 90,
    '16:Right Arm': 90,
    '17:Left Arm': 90,
    '18:Torso': 90,
    '19:Head': 90,
  };
  Map<String, int> motorMap = {...referenceMotorMap};

  final TextEditingController ipController = TextEditingController();

  bool webSocketConnected = false;
  WebSocketChannel? channel;
  int frameNumber = 0;
  int serverFrameNumber = 0;
  List<String> initializedMotors = [];
  int maxFrames = 0;
  TextEditingController maxFramesCountTextEditingController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    ipController.text = '192.168.254.6';
    maxFramesCountTextEditingController.text = '10';
    maxFrames = 9;
  }

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
                const Icon(
                  Icons.directions_run,
                  size: 37,
                  color: AppColors.userInteractionColor,
                ),
                const Text(
                  'Motion Planning',
                  style: TextStyle(
                    color: AppColors.userInteractionColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 50),
                !webSocketConnected
                    ? Column(
                        children: [
                          TextField(
                            controller: ipController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      color: Colors.blue, width: 10),
                                ),
                                hintText: 'Enter the IP address of Server'),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              try {
                                // Attempt WebSocket connection
                                final wsUri = Uri.parse(
                                    'ws://${ipController.text.trim()}:3000?apiKey=A1B2-C3D4-E5F6-G7H8-I9');
                                final newChannel =
                                    WebSocketChannel.connect(wsUri);

                                // Listen for messages and errors
                                newChannel.stream.listen(
                                  (message) {
                                    print('Message received: $message');
                                  },
                                  onError: (error) {
                                    print('WebSocket error: $error');
                                    setState(() {
                                      webSocketConnected = false;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Caught By Stream onError Method: Socket Exception => $error')));
                                  },
                                  onDone: () {
                                    print('WebSocket connection closed.');
                                    setState(() {
                                      webSocketConnected = false;
                                    });
                                  },
                                  cancelOnError: true,
                                );

                                // If connection succeeds, update state
                                setState(() {
                                  channel = newChannel;
                                  webSocketConnected = true;
                                });

                                print('WebSocket connected successfully.');
                              } catch (e) {
                                // Catch and handle connection errors
                                print('Failed to connect to WebSocket: $e');
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        'Caught By Catch Block: Socket Exception')));
                                setState(() {
                                  webSocketConnected = false;
                                });
                              }
                            },
                            child: const Text('Connect to WebSocket Server'),
                          ),
                        ],
                      )
                    : Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Motor Initializations',
                                style: TextStyle(
                                  color: AppColors.userInteractionColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                width: 250,
                                child: Column(
                                  children: [
                                    ...(initializedMotors.map(
                                      (element) => SizedBox(
                                        width: double.maxFinite,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              element,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            const Icon(
                                              Icons.check,
                                              color: Colors.green,
                                            ),
                                          ],
                                        ),
                                      ),
                                    )),
                                  ],
                                ),
                              ),
                              Center(
                                child: initializedMotors.isNotEmpty &&
                                        initializedMotors.length < 20
                                    ? null
                                    : ElevatedButton(
                                        onPressed: () async {
                                          setState(() {
                                            initializedMotors = [];
                                          });
                                          for (String element
                                              in motorMap.keys.toList()) {
                                            print(element);
                                            String motorNumber =
                                                element.split(":")[0];
                                            channel?.sink.add(
                                              jsonEncode(
                                                <String, dynamic>{
                                                  "type": "motion-planning",
                                                  "key": int.parse(motorNumber),
                                                  "value": motorMap[element]!
                                                },
                                              ),
                                            );
                                            setState(() {
                                              initializedMotors
                                                  .add(element.split(":")[1]);
                                            });
                                            await Future.delayed(
                                                const Duration(seconds: 1));
                                          }
                                        },
                                        child: Text(initializedMotors.isEmpty
                                            ? 'Initialize Motors'
                                            : initializedMotors.length == 20
                                                ? 'Reinitialize Motors'
                                                : 'Intitializing...'),
                                      ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Frame By Frame Control',
                                    style: TextStyle(
                                      color: AppColors.userInteractionColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        frameNumber = 0;
                                      });
                                    },
                                    child: const Text(
                                      "Reset Frame",
                                      style: TextStyle(color: Colors.green),
                                    ),
                                  ),
                                ],
                              ),
                              Center(
                                child: Text(
                                  'Frame $frameNumber',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        if (frameNumber == 0) {
                                          frameNumber = maxFrames;
                                        } else {
                                          frameNumber--;
                                        }
                                      });
                                      channel?.sink.add(
                                        jsonEncode(
                                          <String, dynamic>{
                                            "type": "frame-change",
                                            "frameNumber": frameNumber,
                                            "frameIncrease": false
                                          },
                                        ),
                                      );
                                    },
                                    child: const Text("Previous Frame"),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        if (frameNumber == maxFrames) {
                                          frameNumber = 0;
                                        } else {
                                          frameNumber++;
                                        }
                                      });
                                      channel?.sink.add(
                                        jsonEncode(
                                          <String, dynamic>{
                                            "type": "frame-change",
                                            "frameNumber": frameNumber,
                                            "frameIncrease": true
                                          },
                                        ),
                                      );
                                    },
                                    child: const Text("Next Frame"),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Frame Control(Server)',
                                    style: TextStyle(
                                      color: AppColors.userInteractionColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        serverFrameNumber = 0;
                                      });
                                    },
                                    child: const Text(
                                      "Reset Frame",
                                      style: TextStyle(color: Colors.green),
                                    ),
                                  ),
                                ],
                              ),
                              TextField(
                                controller: maxFramesCountTextEditingController,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                          color: Colors.blue, width: 10),
                                    ),
                                    hintText: 'Enter the maximum Frame Count'),
                                onChanged: (value) {
                                  setState(() {
                                    if (value == '') {
                                      maxFrames = 0;
                                    } else {
                                      maxFrames = int.parse(value);
                                    }
                                  });
                                },
                              ),
                              Center(
                                child: Text(
                                  'Frame $serverFrameNumber',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        if (serverFrameNumber == 0) {
                                          serverFrameNumber = maxFrames;
                                        } else {
                                          serverFrameNumber--;
                                        }
                                      });
                                      channel?.sink.add(
                                        jsonEncode(
                                          <String, dynamic>{
                                            "type": "frame-change",
                                            "frameNumber": serverFrameNumber,
                                            "frameIncrease": false
                                          },
                                        ),
                                      );
                                    },
                                    child: const Text("Previous Frame"),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        if (serverFrameNumber == maxFrames) {
                                          serverFrameNumber = 0;
                                        } else {
                                          serverFrameNumber++;
                                        }
                                      });
                                      channel?.sink.add(
                                        jsonEncode(
                                          <String, dynamic>{
                                            "type": "server-frame",
                                            "frameNumber": serverFrameNumber,
                                          },
                                        ),
                                      );
                                    },
                                    child: const Text("Next Frame"),
                                  ),
                                ],
                              ),
                              ElevatedButton(
                                  onPressed: () async {
                                    for (int j = 0; j < 2; j++) {
                                      for (int i = 0; i < maxFrames; i++) {
                                        setState(() {
                                          if (serverFrameNumber == maxFrames) {
                                            serverFrameNumber = 0;
                                          } else {
                                            serverFrameNumber++;
                                          }
                                        });
                                        channel?.sink.add(
                                          jsonEncode(
                                            <String, dynamic>{
                                              "type": "server-frame",
                                              "frameNumber": serverFrameNumber,
                                            },
                                          ),
                                        );
                                        await Future.delayed(
                                            const Duration(milliseconds: 1700));
                                      }
                                    }
                                  },
                                  child: Text("Run Walk Motion")),
                              const Text(
                                'Mannual Motor Controls',
                                style: TextStyle(
                                  color: AppColors.userInteractionColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  setState(() {
                                    motorMap = {...referenceMotorMap};
                                  });
                                },
                                child: const Text(
                                    'Reset Values to Initial Positions'),
                              ),
                              ...(motorMap.keys.toList().map((element) {
                                List<String> splitList = element.split(":");
                                String motorNumber = splitList[0];
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Motor $element',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Slider(
                                        value: motorMap[element]! / 180,
                                        onChanged: (value) {
                                          {
                                            if (value.floor() ==
                                                motorMap[element]) {
                                              return;
                                            }

                                            setState(() {
                                              motorMap[element] =
                                                  (value * 180).floor();
                                            });
                                            channel?.sink.add(
                                              jsonEncode(
                                                <String, dynamic>{
                                                  "type": "motion-planning",
                                                  "key": int.parse(motorNumber),
                                                  "value": motorMap[element]!
                                                },
                                              ),
                                            );
                                          }
                                        }),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          '${motorMap[element]!} Degrees',
                                          style: const TextStyle(
                                              color: Colors.green),
                                        ),
                                      ],
                                    )
                                  ],
                                );
                              }).toList())
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
