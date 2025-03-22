import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoPath;

  const VideoPlayerScreen({required this.videoPath, Key? key}) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen>
    with SingleTickerProviderStateMixin {
  late VideoPlayerController _controller;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  bool _isPlaying = false;
  bool _showControls = true;
  bool _isArrowHovered = false; // Track hover state for arrow button

  @override
  void initState() {
    super.initState();

    // Video Controller
    _controller = VideoPlayerController.asset(widget.videoPath)
      ..initialize().then((_) {
        setState(() {});
      });

    _controller.addListener(() {
      setState(() {
        _isPlaying = _controller.value.isPlaying;
      });
    });

    // Animation Controller for Downward Exit
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, 1), // Moves down
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_isPlaying) {
        _controller.pause();
        _isPlaying = false;
        _showControls = true;
      } else {
        _controller.play();
        _isPlaying = true;
        _hideControlsAfterDelay();
      }
    });
  }

  void _hideControlsAfterDelay() {
    Future.delayed(const Duration(seconds: 3), () {
      if (_controller.value.isPlaying) {
        setState(() {
          _showControls = false;
        });
      }
    });
  }

  // Trigger exit animation
  void _exitVideo() {
    _animationController.forward().then((_) {
      Navigator.pop(context); // Exit after animation completes
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SlideTransition(
        position: _slideAnimation,
        child: Center(
          child: GestureDetector(
            onTap: _togglePlayPause,
            child: MouseRegion(
              onEnter: (_) => setState(() {
                if (_isPlaying) _showControls = true;
              }),
              onExit: (_) => _hideControlsAfterDelay(),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Video Container
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    alignment: Alignment.center,
                    child: _controller.value.isInitialized
                        ? AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child: VideoPlayer(_controller),
                          )
                        : const CircularProgressIndicator(),
                  ),

                  // Play button (always visible when paused)
                  if (!_isPlaying)
                    const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 50,
                    ),

                  // Pause button (only visible on hover)
                  AnimatedOpacity(
                    opacity: (_isPlaying && _showControls) ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(
                      Icons.pause,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),

                  // Progress Bar & Timer (hides when playing)
                  Positioned(
                    bottom: 30,
                    left: 20,
                    right: 20,
                    child: AnimatedOpacity(
                      opacity: _showControls ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 300),
                      child: Column(
                        children: [
                          VideoProgressIndicator(
                            _controller,
                            allowScrubbing: true,
                            colors: const VideoProgressColors(
                              playedColor: Colors.red,
                              backgroundColor: Colors.grey,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _formatDuration(_controller.value.position),
                                style: const TextStyle(color: Colors.white),
                              ),
                              Text(
                                _formatDuration(_controller.value.duration),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Down Arrow Button (Exit with Smooth Animation)
                  Positioned(
                    top: 40,
                    left: 20,
                    child: MouseRegion(
                      onEnter: (_) => setState(() => _isArrowHovered = true),
                      onExit: (_) => setState(() => _isArrowHovered = false),
                      child: GestureDetector(
                        onTap: _exitVideo,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _isArrowHovered
                                ? Colors.white.withOpacity(0.8) // White on hover
                                : Colors.grey.withOpacity(0.5), // Grey default
                          ),
                          padding: const EdgeInsets.all(8),
                          child: const Icon(
                            Icons.keyboard_arrow_down,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [if (duration.inHours > 0) hours, minutes, seconds].join(':');
  }
}
