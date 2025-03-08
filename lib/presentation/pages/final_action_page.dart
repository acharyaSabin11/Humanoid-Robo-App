import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class FinalActionPage extends StatefulWidget {
  const FinalActionPage({super.key});

  @override
  State<FinalActionPage> createState() => _FinalActionPageState();
}

class _FinalActionPageState extends State<FinalActionPage> {
  final List<String> messageList = <String>[];

  final TextEditingController ipController = TextEditingController();
  int serverFrameNumber = 0;
  int forwardWalkingMaxFrames = 10;
  int leftSideWalkingMaxFrames = 4;

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
        title: const Text('Final Action Page'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                messageList.clear();
              });
            },
            icon: const Icon(Icons.close),
          ),
          IconButton(
            onPressed: () {
              //Send message to server to the server to start final action.
              channel?.sink.add(jsonEncode({
                'type': 'final_action',
                'data': {
                  'action': 'start',
                },
              }));
            },
            icon: const Icon(Icons.start),
          ),
        ],
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
                              handleControlInfo(message);
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
              : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: messageList
                            .map((e) => Row(
                                  children: [
                                    const Icon(
                                      Icons.info,
                                      color: Colors.green,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Text(
                                        e,
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  ],
                                ))
                            .toList() as List<Widget>,
                      ),
                    ],
                  ),
                )),
    );
  }

  void handleControlInfo(message) {
    Map<String, dynamic> controlInfo = jsonDecode(message);
    if (controlInfo['type'] == 'control_info') {
      debugPrint('Control Info: $controlInfo');
      setState(() {
        messageList.add(controlInfo['message'].toString());
      });
    }
  }
}
