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
  final Map<String, int> motorMap = {
    '1': 0,
    '2': 0,
    '3': 0,
    '4': 0,
    '5': 0,
    '6': 0,
    '7': 0,
    '8': 0,
    '9': 0,
    '10': 0,
    '11': 0,
    '12': 0,
    '13': 0,
    '14': 0,
    '15': 0,
    '16': 0,
  };

  final TextEditingController ipController = TextEditingController();

  bool webSocketConnected = false;
  WebSocketChannel? channel;

  @override
  void initState() {
    super.initState();
    ipController.text = '192.168.254.20';
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
                    : Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Motor Controls',
                                style: TextStyle(
                                  color: AppColors.userInteractionColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              ...(motorMap.keys
                                  .toList()
                                  .map((element) => Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                                  setState(() {
                                                    motorMap[element] =
                                                        (value * 180).floor();
                                                  });
                                                  channel?.sink.add(
                                                      jsonEncode(<String, int>{
                                                    element:
                                                        (value * 180).floor()
                                                  }));
                                                }
                                              }),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                '${motorMap[element]!} Degrees',
                                                style: const TextStyle(
                                                    color: Colors.green),
                                              ),
                                            ],
                                          )
                                        ],
                                      ))
                                  .toList())
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
