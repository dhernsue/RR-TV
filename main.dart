import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

void main() {
  runApp(const TTYRecording());
}

class TTYRecording extends StatelessWidget {
  const TTYRecording({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TTY Recording',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const RecordingHome(),
    );
  }
}

class RecordingHome extends StatefulWidget {
  const RecordingHome({super.key});

  @override
  State<RecordingHome> createState() => _RecordingHomeState();
}

class _RecordingHomeState extends State<RecordingHome> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  bool isRecording = false;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.network(
      // Demo video (तुम चाहो तो अपना link डाल सकते हो)
      'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    )..initialize().then((_) {
        setState(() {});
        _chewieController = ChewieController(
          videoPlayerController: _videoPlayerController,
          autoPlay: false,
          looping: false,
        );
      });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  void toggleRecording() {
    setState(() {
      isRecording = !isRecording;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isRecording ? "Recording Started 🎥" : "Recording Stopped ⏹️"),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TTY Recording"),
        centerTitle: true,
      ),
      body: Center(
        child: _chewieController != null &&
                _chewieController!.videoPlayerController.value.isInitialized
            ? Chewie(controller: _chewieController!)
            : const CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: toggleRecording,
        backgroundColor: isRecording ? Colors.red : Colors.green,
        child: Icon(isRecording ? Icons.stop : Icons.fiber_manual_record),
      ),
    );
  }
}
