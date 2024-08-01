import 'dart:async';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:humanoid_robo_app/core/configs/colors/app_colors.dart';

class ImageStreamWidget extends StatefulWidget {
  const ImageStreamWidget({
    super.key,
    required this.url,
    required this.height,
    required this.width,
    required this.label,
  });
  final String url;
  final double height;
  final double width;
  final String label;
  @override
  State<ImageStreamWidget> createState() => _ImageStreamWidgetState();
}

class _ImageStreamWidgetState extends State<ImageStreamWidget> {
  late final StreamController<Uint8List> _imageStreamController;
  final client = http.Client();

  @override
  void initState() {
    super.initState();
    _imageStreamController = StreamController<Uint8List>();
    _startImageStream();
  }

  void _startImageStream() async {
    final url = widget.url;
    final request = http.Request('GET', Uri.parse(url));
    try {
      final response =
          await client.send(request).timeout(const Duration(seconds: 5));

      if (response.statusCode != 200) {
        _imageStreamController.addError('Issue Communicating with the Server');
      } else {
        final stream = response.stream;
        stream.listen((chunk) {
          final dataString = String.fromCharCodes(chunk);
          const boundary = '--frame';
          int midIndex = -1, lengthEnd = -1, length = -1, imgEnd = -1;
          final startIndex = dataString.indexOf(boundary) + boundary.length;
          if (startIndex - boundary.length != -1) {
            midIndex = dataString.indexOf('Content-Length: ', startIndex) + 16;
          }
          if (midIndex - 16 > -1) {
            lengthEnd = dataString.indexOf('\r\n\r\n', midIndex);
          }

          if (lengthEnd != -1) {
            length = int.parse(dataString.substring(midIndex, lengthEnd));
            imgEnd = dataString.indexOf('\r\n', lengthEnd + 4);
          }

          // Tackling the case when the frame is not fully received.
          if (imgEnd > lengthEnd + 4) {
            final imageData = chunk.sublist(lengthEnd + 4, imgEnd);
            if (length == imageData.length) {
              _imageStreamController.add(Uint8List.fromList(imageData));
            } else {
              debugPrint('Error Receiving Image Data');
            }
          }

          // print("IL : ${String.fromCharCodes(imageData).length}");
          // _imageStreamController.add(Uint8List.fromList(imageData));
        }, onDone: () {
          client.close();
          _imageStreamController.close();
        }, onError: (err) {
          client.close();
          debugPrint('Server Disconnected Suddenly');
          _imageStreamController.addError('Server Disconnected Suddenly');
        });
      }
    } on TimeoutException catch (_) {
      _imageStreamController.addError('Server Timed Out');
    } catch (e) {
      _imageStreamController.addError(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
            color: AppColors.inactiveButtonColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: StreamBuilder<Uint8List>(
            stream: _imageStreamController.stream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: const CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                    child: Text(
                  snapshot.error.toString(),
                  style: const TextStyle(
                    color: Colors.purple,
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ));
              } else if (snapshot.hasData) {
                return Image.memory(
                  snapshot.data!,
                  gaplessPlayback: true,
                );
              } else {
                return const Text('No image available');
              }
            },
          ),
        ),
        Text(
          widget.label,
          style: const TextStyle(
            color: AppColors.inactiveButtonColor,
            fontWeight: FontWeight.w500,
            fontSize: 17,
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    client.close();
    _imageStreamController.close();
    super.dispose();
  }
}
