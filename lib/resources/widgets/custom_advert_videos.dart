import 'package:flutter/material.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CustomAdvertVideos extends StatefulWidget {
  final String videoUrl; // YouTube Video URL passed as a parameter

  CustomAdvertVideos({required this.videoUrl});

  @override
  _CustomAdvertVideosState createState() => _CustomAdvertVideosState();
}

class _CustomAdvertVideosState extends State<CustomAdvertVideos> {
  // late YoutubePlayerController _controller;
  bool _isMuted = true;

  @override
  void initState() {
    super.initState();
    // Initialize the YoutubePlayerController with the YouTube URL
    // _controller = YoutubePlayerController(
    //   initialVideoId: YoutubePlayer.convertUrlToId(widget.videoUrl)!,
    //   flags: YoutubePlayerFlags(
    //     autoPlay: true, // Autoplay the video
    //     mute: true, // Start muted
    //     loop: true, // Loop the video
    //   ),
    // );
  }

  // Toggle between mute and unmute
  void _toggleMute() {
    setState(() {
      // _isMuted = !_isMuted;
      // _controller.setVolume(_isMuted ? 0 : 100); // Mute or unmute
    });
  }

  @override
  void dispose() {
    super.dispose();
    // _controller.dispose(); // Clean up the controller when done
  }

  @override
  Widget build(BuildContext context) {
    return Container();
    //  YoutubePlayerBuilder(
    //       player: YoutubePlayer(
    //         controller: _controller,
    //         showVideoProgressIndicator: true, // Show progress bar
    //       ),
    //       builder: (context, player) {
    //         return Stack(
    //           alignment: Alignment.bottomCenter,
    //           children: [
    //             player,
    //             // Play/Pause and Mute Controls
    //             Positioned(
    //               bottom: 20,
    //               left: 20,
    //               right: 20,
    //               child: Row(
    //                 mainAxisAlignment: MainAxisAlignment.center,
    //                 children: [
    //                   IconButton(
    //                     icon: Icon(
    //                       _controller.value.isPlaying
    //                           ? Icons.pause
    //                           : Icons.play_arrow,
    //                       color: Colors.white,
    //                     ),
    //                     onPressed: () {
    //                       setState(() {
    //                         if (_controller.value.isPlaying) {
    //                           _controller.pause();
    //                         } else {
    //                           _controller.play();
    //                         }
    //                       });
    //                     },
    //                   ),
    //                   IconButton(
    //                     icon: Icon(
    //                       _isMuted ? Icons.volume_off : Icons.volume_up,
    //                       color: Colors.white,
    //                     ),
    //                     onPressed: _toggleMute,
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ],
    //         );
    //       },
    //     // ),

    // );
  }
}
