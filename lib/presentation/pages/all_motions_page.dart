import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class AllMotionsPage extends StatefulWidget {
  const AllMotionsPage({super.key});

  @override
  State<AllMotionsPage> createState() => _AllMotionsPageState();
}

class _AllMotionsPageState extends State<AllMotionsPage> {
  final TextEditingController ipController = TextEditingController();
  int serverFrameNumber = 0;
  int forwardWalkingMaxFrames = 6;
  int leftSideWalkingMaxFrames = 4;
  int counterClockWiseMaxFrames = 5;
  int clockWiseMaxFrames = 5;
  int pickupMaxFrames = 4;

  bool webSocketConnected = false;

  WebSocketChannel? channel;

  @override
  void initState() {
    super.initState();
    ipController.text = '192.168.254.6';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Unity Integration'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: !webSocketConnected
            ? Column(
                children: [
                  TextField(
                    controller: ipController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Colors.blue, width: 10),
                        ),
                        hintText: 'Enter the IP address of Server'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        // Attempt WebSocket connection
                        final wsUri = Uri.parse(
                            'ws://${ipController.text.trim()}:3000?apiKey=A1B2-C3D4-E5F6-G7H8-I9');
                        final newChannel = WebSocketChannel.connect(wsUri);

                        // Listen for messages and errors
                        newChannel.stream.listen(
                          (message) {
                            debugPrint('Message from WebSocket: $message');
                          },
                          onError: (error) {
                            print('WebSocket error: $error');
                            setState(() {
                              webSocketConnected = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    'Caught By Stream onError Method: Socket Exception')));
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
            : Column(children: [
                Column(
                  children: [
                    Text('Forward Walking Motion'),
                    ElevatedButton(
                      onPressed: () async {
                        for (int j = 0; j < 1; j++) {
                          for (int i = 1; i <= forwardWalkingMaxFrames; i++) {
                            setState(() {
                              if (serverFrameNumber ==
                                  forwardWalkingMaxFrames) {
                                serverFrameNumber = 1;
                              } else {
                                serverFrameNumber++;
                              }
                            });
                            channel?.sink.add(
                              jsonEncode(
                                <String, dynamic>{
                                  "type": "server-frame",
                                  "motion": "Forward Walking Motion",
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
                                "motion": "Forward Walking Motion",
                                "frameNumber": 0,
                              },
                            ),
                          );
                        }
                      },
                      child: const Text('Forward Walking Motion'),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text('Left Side Walking Motion'),
                    ElevatedButton(
                      onPressed: () async {
                        for (int j = 0; j < 1; j++) {
                          for (int i = 0; i <= leftSideWalkingMaxFrames; i++) {
                            setState(() {
                              if (serverFrameNumber ==
                                  leftSideWalkingMaxFrames) {
                                serverFrameNumber = 0;
                              } else {
                                serverFrameNumber++;
                              }
                            });
                            channel?.sink.add(
                              jsonEncode(
                                <String, dynamic>{
                                  "type": "server-frame",
                                  "motion": "Left Side Walking Motion",
                                  "frameNumber": serverFrameNumber,
                                },
                              ),
                            );
                            await Future.delayed(
                                const Duration(milliseconds: 500));
                          }
                          channel?.sink.add(
                            jsonEncode(
                              <String, dynamic>{
                                "type": "server-frame",
                                "motion": "Left Side Walking Motion",
                                "frameNumber": 0,
                              },
                            ),
                          );
                        }
                      },
                      child: const Text('Left Side Walking Motion'),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text('Counter Clockwise Rotation Motion'),
                    ElevatedButton(
                      onPressed: () async {
                        for (int j = 0; j < 1; j++) {
                          for (int i = 0; i <= counterClockWiseMaxFrames; i++) {
                            setState(() {
                              if (serverFrameNumber ==
                                  counterClockWiseMaxFrames) {
                                serverFrameNumber = 0;
                              } else {
                                serverFrameNumber++;
                              }
                            });
                            channel?.sink.add(
                              jsonEncode(
                                <String, dynamic>{
                                  "type": "server-frame",
                                  "motion": "Counter Clockwise Rotation Motion",
                                  "frameNumber": serverFrameNumber,
                                },
                              ),
                            );
                            await Future.delayed(
                                const Duration(milliseconds: 500));
                          }
                          channel?.sink.add(
                            jsonEncode(
                              <String, dynamic>{
                                "type": "server-frame",
                                "motion": "Counter Clockwise Rotation Motion",
                                "frameNumber": 0,
                              },
                            ),
                          );
                        }
                      },
                      child: const Text('Counter Clockwise Rotation Motion'),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text('Backward Walking Motion'),
                    ElevatedButton(
                      onPressed: () async {
                        for (int j = 0; j < 1; j++) {
                          for (int i = 1; i <= forwardWalkingMaxFrames; i++) {
                            setState(() {
                              if (serverFrameNumber ==
                                  forwardWalkingMaxFrames) {
                                serverFrameNumber = 0;
                              } else {
                                serverFrameNumber++;
                              }
                            });
                            channel?.sink.add(
                              jsonEncode(
                                <String, dynamic>{
                                  "type": "server-frame",
                                  "motion": "Backward Walking Motion",
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
                                "motion": "Backward Walking Motion",
                                "frameNumber": 0,
                              },
                            ),
                          );
                        }
                      },
                      child: const Text('Backward Walking Motion'),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text('Right Side Walking Motion'),
                    ElevatedButton(
                      onPressed: () async {
                        for (int j = 0; j < 1; j++) {
                          for (int i = 0; i <= leftSideWalkingMaxFrames; i++) {
                            setState(() {
                              if (serverFrameNumber ==
                                  leftSideWalkingMaxFrames) {
                                serverFrameNumber = 0;
                              } else {
                                serverFrameNumber++;
                              }
                            });
                            channel?.sink.add(
                              jsonEncode(
                                <String, dynamic>{
                                  "type": "server-frame",
                                  "motion": "Right Side Walking Motion",
                                  "frameNumber": serverFrameNumber,
                                },
                              ),
                            );
                            await Future.delayed(
                                const Duration(milliseconds: 500));
                          }
                          channel?.sink.add(
                            jsonEncode(
                              <String, dynamic>{
                                "type": "server-frame",
                                "motion": "Right Side Walking Motion",
                                "frameNumber": 0,
                              },
                            ),
                          );
                        }
                      },
                      child: const Text('Right Side Walking Motion'),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text('Clockwise Rotation Motion'),
                    ElevatedButton(
                      onPressed: () async {
                        for (int j = 0; j < 1; j++) {
                          for (int i = 0; i <= clockWiseMaxFrames; i++) {
                            setState(() {
                              if (serverFrameNumber == clockWiseMaxFrames) {
                                serverFrameNumber = 0;
                              } else {
                                serverFrameNumber++;
                              }
                            });
                            channel?.sink.add(
                              jsonEncode(
                                <String, dynamic>{
                                  "type": "server-frame",
                                  "motion": "Clockwise Rotation Motion",
                                  "frameNumber": serverFrameNumber,
                                },
                              ),
                            );
                            await Future.delayed(
                                const Duration(milliseconds: 500));
                          }
                          channel?.sink.add(
                            jsonEncode(
                              <String, dynamic>{
                                "type": "server-frame",
                                "motion": "Clockwise Rotation Motion",
                                "frameNumber": 0,
                              },
                            ),
                          );
                        }
                      },
                      child: const Text('Clockwise Rotation Motion'),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text('Pickup Motion'),
                    ElevatedButton(
                      onPressed: () async {
                        for (int j = 0; j < 1; j++) {
                          for (int i = 0; i <= pickupMaxFrames; i++) {
                            setState(() {
                              if (serverFrameNumber == pickupMaxFrames) {
                                serverFrameNumber = 0;
                              } else {
                                serverFrameNumber++;
                              }
                            });
                            channel?.sink.add(
                              jsonEncode(
                                <String, dynamic>{
                                  "type": "server-frame",
                                  "motion": "Pickup Motion",
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
                                "motion": "Pickup Motion",
                                "frameNumber": 0,
                              },
                            ),
                          );
                        }
                      },
                      child: const Text('Counter Clockwise Rotation Motion'),
                    ),
                  ],
                ),
              ]),
      ),
    );
  }
}
