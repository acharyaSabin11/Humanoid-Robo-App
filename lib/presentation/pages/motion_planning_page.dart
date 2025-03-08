import 'dart:convert';
import 'dart:typed_data';
import 'dart:math';
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
    '15:Right Hip Yaw': 100,
    '2:Right Hip Roll': 90,
    '4:Right Hip Pitch': 101,
    '5:Right Knee': 92,
    '18:Right Ankle': 73, // this needs to be changed
    '19:Right Foot': 85,
    '33:Left Hip Yaw': 92,
    '25:Left Hip Roll': 92,
    '26:Left Hip Pitch': 95,
    '27:Left Knee': 84,
    '14:Left Ankle': 97, // this needs to be changed
    '12:Left Foot': 86,
    '40:Right Shoulder Pitch': 37,
    '50:Left Shoulder Pitch': 135,
    '80:Right Arm': 90,
    '90:Left Arm': 83,
    '60:Right Shoulder Roll': 65,
    '70:Left Shoulder Roll': 105,
    '23:Head': 90,
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

  bool subtractOffset = true;

  TextEditingController jumpToController = TextEditingController();

  @override
  void initState() {
    super.initState();
    ipController.text = '192.168.254.6';
    maxFramesCountTextEditingController.text = '10';
    maxFrames = 10;
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
                                // final wsUri = Uri.parse(
                                //     'wss://node-server-humanoid-robo.onrender.com?apiKey=A1B2-C3D4-E5F6-G7H8-I9');
                                final newChannel =
                                    WebSocketChannel.connect(wsUri);

                                // Listen for messages and errors
                                newChannel.stream.listen(
                                  (message) {
                                    if (message is Uint8List) {
                                      print(String.fromCharCodes(message));
                                    } else {
                                      if (message !=
                                          'Hey Flutter Application') {
                                        try {
                                          Map<String, dynamic> data =
                                              jsonDecode(message);
                                          setState(() {
                                            motorMap = {
                                              '15:Right Hip Yaw':
                                                  data['RightHipYaw'].floor(),
                                              '2:Right Hip Roll':
                                                  data['RightHipRoll'].floor(),
                                              '4:Right Hip Pitch':
                                                  data['RightHipPitch'].floor(),
                                              '5:Right Knee':
                                                  data['RightKnee'].floor(),
                                              '18:Right Ankle': data[
                                                      'RightAnkle']
                                                  .floor(), // this needs to be changed
                                              '19:Right Foot':
                                                  data['RightFoot'].floor(),
                                              '33:Left Hip Yaw':
                                                  data['LeftHipYaw'].floor(),
                                              '25:Left Hip Roll':
                                                  data['LeftHipRoll'].floor(),
                                              '26:Left Hip Pitch':
                                                  data['LeftHipPitch'].floor(),
                                              '27:Left Knee':
                                                  data['LeftKnee'].floor(),
                                              '14:Left Ankle': data['LeftAnkle']
                                                  .floor(), // this needs to be changed
                                              '12:Left Foot':
                                                  data['LeftFoot'].floor(),
                                              '40:Right Shoulder Pitch':
                                                  data['RightShoulderPitch']
                                                      .floor(),
                                              '50:Left Shoulder Pitch':
                                                  data['LeftShoulderPitch']
                                                      .floor(),
                                              '60:Right Shoulder Roll':
                                                  data['RightShoulderRoll']
                                                      .floor(),
                                              '70:Left Shoulder Roll':
                                                  data['LeftShoulderRoll']
                                                      .floor(),
                                              '80:Right Arm': data['RightArm'],
                                              '90:Left Arm':
                                                  data['LeftArm'].floor(),
                                              '23:Head': data['Head'].floor(),
                                            };
                                          });
                                          print(jsonDecode(message));
                                        } catch (e) {
                                          print(e);
                                        }
                                      }
                                    }
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
                                        initializedMotors.length < 19
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
                                            : initializedMotors.length == 19
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
                              TextField(
                                controller: jumpToController,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                          color: Colors.blue, width: 10),
                                    ),
                                    hintText: 'Enter frame to jump to'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  int jumpFrameNumber =
                                      int.parse(jumpToController.text.trim());
                                  setState(() {
                                    frameNumber = jumpFrameNumber;
                                    serverFrameNumber = jumpFrameNumber;
                                  });
                                  channel?.sink.add(
                                    jsonEncode(
                                      <String, dynamic>{
                                        "type": "frame-change",
                                        "frameNumber": int.parse(
                                            jumpToController.text.trim()),
                                        "frameIncrease": true
                                      },
                                    ),
                                  );
                                },
                                child: const Text("Jump to the frame"),
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
                                    for (int j = 0; j < 5; j++) {
                                      for (int i = 0; i <= maxFrames; i++) {
                                        if (i == 0) continue;
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
                                            const Duration(milliseconds: 1000));
                                      }
                                      channel?.sink.add(
                                        jsonEncode(
                                          <String, dynamic>{
                                            "type": "server-frame",
                                            "frameNumber": 0,
                                          },
                                        ),
                                      );
                                    }
                                  },
                                  child: Text("Run Walk Motion")),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Pickup Frame Control',
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
                              const Text(
                                'Manual Motor Controls',
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
                              Row(
                                children: [
                                  Checkbox(
                                    value: subtractOffset,
                                    onChanged: (value) => {
                                      setState(() {
                                        subtractOffset = value!;
                                      })
                                    },
                                  ),
                                  const SizedBox(width: 10),
                                  const Text(
                                    'Subtract Offset',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
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
                                        value: (motorMap[element]! / 180).abs(),
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
                                          // '${motorMap[element]! - (referenceMotorMap[element]! * (subtractOffset ? 1 : 0))} Degrees',
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
