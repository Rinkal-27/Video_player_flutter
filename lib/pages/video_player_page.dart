import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';

enum Source { Asset, Network }

class VideoPlayerPage extends StatefulWidget {
  const VideoPlayerPage({Key? key}) : super(key: key);

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late CustomVideoPlayerController _customVideoPlayerController;

  Source currentSource = Source.Asset;

  Uri videoUri = Uri.parse(
      "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4");
  String assetVideoPath = "assets/videos/horses.mp4";

  late bool isLoading = true;

  @override
  void initState() {
    super.initState();
    initializeVideoPlayer(currentSource);
  }

  @override
  void dispose() {
    _customVideoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player'),
        backgroundColor: Color.fromARGB(0, 55, 123, 160),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Color.fromRGBO(255, 6, 249, 237),
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: CustomVideoPlayer(
                    customVideoPlayerController: _customVideoPlayerController,
                  ),
                ),
                SizedBox(height: 20),
                _sourceButtons(),
              ],
            ),
    );
  }

  Widget _sourceButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: Color.fromARGB(0, 55, 123, 160)),
          onPressed: () {
            _changeSource(Source.Network);
          },
          child: Text("Network"),
        ),
        SizedBox(width: 20),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: Color.fromARGB(0, 55, 123, 160)),
          onPressed: () {
            _changeSource(Source.Asset);
          },
          child: Text("Asset"),
        ),
      ],
    );
  }

  void _changeSource(Source source) {
    setState(() {
      currentSource = source;
      initializeVideoPlayer(currentSource);
    });
  }

  void initializeVideoPlayer(Source source) {
    setState(() {
      isLoading = true;
    });
    VideoPlayerController _videoPlayerController;
    if (source == Source.Asset) {
      _videoPlayerController = VideoPlayerController.asset(assetVideoPath)
        ..initialize().then((_) {
          setState(() {
            isLoading = false;
          });
        });
    } else if (source == Source.Network) {
      _videoPlayerController =
          VideoPlayerController.network(videoUri.toString())
            ..initialize().then((_) {
              setState(() {
                isLoading = false;
              });
            });
    } else {
      return;
    }
    _customVideoPlayerController = CustomVideoPlayerController(
        context: context, videoPlayerController: _videoPlayerController);
  }
}
