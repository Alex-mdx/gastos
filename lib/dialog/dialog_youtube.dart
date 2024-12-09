import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class DialogYoutube extends StatefulWidget {
  final String link;
  const DialogYoutube({super.key, required this.link});

  @override
  State<DialogYoutube> createState() => _DialogYoutubeState();
}

class _DialogYoutubeState extends State<DialogYoutube> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Column(mainAxisSize: MainAxisSize.min,children: [
      YoutubePlayer(
          showVideoProgressIndicator: true,
          controller: YoutubePlayerController(
              initialVideoId: 'iLnmTe5Q2Qw',
              flags: YoutubePlayerFlags(autoPlay: false,mute: false,showLiveFullscreenButton: false,useHybridComposition: true)))
    ]));
  }
}
