import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;

class VideoProvider with ChangeNotifier {
  final String videoPath;
  late VideoPlayerController _controller;
  RewardedAd? _rewardedAd;
  Map<String, List<Map<String, dynamic>>> getReward = {};
  bool acceptedProccess = false;
  bool session1 = true;
  bool session2 = false;
  bool isolated = true;

  VideoProvider(this.videoPath) {
    _controller = VideoPlayerController.asset(videoPath);
    _initializeController();
  }

  RewardedAd? get rewardedAd => _rewardedAd;
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

  void triggerDialogAfterDelay(BuildContext context) {
    Timer(Duration(seconds: 1, milliseconds: 850), () {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Hadiah'),
            content: Text('Apakah Anda ingin menerima hadiah?'),
            actions: [
              TextButton(
                onPressed: () {
                  _rewardedAd!.show(
                    onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
                      print('User mendapatkan reward: ${reward.amount}');
                      
                      functions();

                      // Logika untuk memberikan hadiah bisa ditambahkan di sini, berupa
                      // 1. logika untuk hadiah yang diberikan secara umum adalah 5 koleksi kata baru di kamus;
                      // 2. logika untuk hadiah tambahan 5 kolokesi kata lagi bila izin iklan diberikan;

                    },
                  ).then((value) {
                    setIsolated(1);
                    setSession(1);
                    Navigator.of(context).pop();
                  }).catchError((error) {
                    setIsolated(1);
                    setSession(1);
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Gagal menampilkan iklan, coba lagi.'))
                    );
                  });
                },
                child: Text('Terima'),
              ),
              TextButton(
                onPressed: () {
                  setIsolated(1);
                  setSession(1);
                  Navigator.of(context).pop();
                },
                child: Text('Tolak'),
              ),
            ],
          );
        },
      );
    });
  }

  void loadRewardedAd() {
    RewardedAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/5224354917',
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          notifyListeners();
        },
        onAdFailedToLoad: (error) {
          print('Failed to load a rewarded ad: $error');
        },
      ),
    );
  }
  
  void FunctionGetterData() async{
    const jsonUrl = "https://raw.githubusercontent.com/EgoEquusFebrianto/public_data/main/rewardAdSource.json";
    final response = await http.get(Uri.parse(jsonUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      getReward = data;
      acceptedProccess = true;
      notifyListeners();
    } else {
      throw Exception('Invalid JSON format: Expected a list of entries');
    }
  }

  void InitializeCodeReward() async {
    
    
  }

  void functions() {
    FunctionGetterData();
    if(acceptedProccess) {
      InitializeCodeReward();
    }
  }
}
