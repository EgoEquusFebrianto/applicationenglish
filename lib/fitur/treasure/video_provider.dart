import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoProvider with ChangeNotifier {
  final String videoPath;
  late VideoPlayerController _controller;
  bool session1 = true;
  bool session2 = false;
  bool isolated = true;

  VideoProvider(this.videoPath) {
    _controller = VideoPlayerController.asset(videoPath);
    _initializeController();
  }

  VideoPlayerController get controller => _controller;

  Future<void> _initializeController() async {
    await _controller.initialize();
    _controller.seekTo(Duration.zero);
    _controller.play();
    _controller.addListener(_onControllerUpdate);
    notifyListeners();
  }

  void _onControllerUpdate() {
    if (!_controller.value.isInitialized) return;

    if (_controller.value.position.inSeconds == 0 && session1) {
      _controller.pause();
    } else if (_controller.value.position.inSeconds == 10 && session2) {
      _controller.pause();
    }
  }

  void setSession(int session) {
    session1 = session == 1;
    session2 = session == 2;

    if (session1) {
      _controller.seekTo(Duration.zero);
      _controller.play();
    } else if (session2 && isolated) {
      _controller.seekTo(Duration.zero);
      _controller.play();
      setIsolated(0);
    } 
    notifyListeners();
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerUpdate);
    _controller.dispose();
    super.dispose();
  }

  void setIsolated(int num) {
    num == 0 ? isolated = false : isolated = true;
    notifyListeners();
  }
}
