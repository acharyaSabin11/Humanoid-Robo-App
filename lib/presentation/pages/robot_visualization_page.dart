import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_embed_unity/flutter_embed_unity.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class RobotVisualizationPage extends StatefulWidget {
  const RobotVisualizationPage({super.key});

  @override
  State<RobotVisualizationPage> createState() => _RobotVisualizationPageState();
}

class _RobotVisualizationPageState extends State<RobotVisualizationPage> {
  final TextEditingController ipController = TextEditingController();

  bool webSocketConnected = false;
  WebSocketChannel? channel;

  @override
  void initState() {
    super.initState();
    ipController.text = '192.168.254.6';
  }

  double sliderValue = 0.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Unity Integration'),
      ),
      body: !webSocketConnected
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
                          if (message is Uint8List) {
                            sendToUnity(
                              'Robot Assembly',
                              'SetRotationAngle',
                              String.fromCharCodes(message),
                            );
                          }
                          // print(message.runtimeType);

                          // print(
                          //     'Message received: ${message.runtimeType.toString() == 'Uint8List' ? String.fromCharCodes(message as Uint8List) : message}');
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
                          content:
                              Text('Caught By Catch Block: Socket Exception')));
                      setState(() {
                        webSocketConnected = false;
                      });
                    }
                  },
                  child: const Text('Connect to WebSocket Server'),
                ),
                ElevatedButton(
                    onPressed: () => {
                          setState(() {
                            webSocketConnected = true;
                          })
                        },
                    child: const Text("Continue without Connection")),
              ],
            )
          : Column(
              children: [
                Expanded(
                  child: EmbedUnity(
                    onMessageFromUnity: (String message) {
                      // Receive message from Unity sent via SendToFlutter.cs
                      print('Message From Unity: $message');
                    },
                  ),
                ),
                //   Slider(
                //     value: sliderValue,
                //     onChanged: (value) {
                //       sendToUnity('Right Hand Shoulder', 'SetRotationAngle',
                //           (value * 360).toString());
                //       setState(() {
                //         sliderValue = value;
                //       });
                //     },
                //   ),
                //   Text((sliderValue * 360).floor().toString()),
              ],
            ),
    );
  }
}
