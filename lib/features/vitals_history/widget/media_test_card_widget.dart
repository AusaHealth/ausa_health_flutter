import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:video_player/video_player.dart';
import '../../../constants/constants.dart';
import '../model/media_test_reading.dart';

class MediaTestCardWidget extends StatefulWidget {
  final MediaTestReading reading;
  final bool isSelected;
  final bool isSelectionMode;
  final VoidCallback onTap;

  const MediaTestCardWidget({
    super.key,
    required this.reading,
    required this.isSelected,
    required this.isSelectionMode,
    required this.onTap,
  });

  @override
  State<MediaTestCardWidget> createState() => _MediaTestCardWidgetState();
}

class _MediaTestCardWidgetState extends State<MediaTestCardWidget> {
  AudioPlayer? _audioPlayer;
  VideoPlayerController? _videoPlayerController;
  bool _isPlaying = false;
  bool _isLoading = false;
  bool _shouldAutoPlay = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  @override
  void dispose() {
    _audioPlayer?.dispose();
    if (_videoPlayerController != null) {
      _videoPlayerController!.removeListener(_videoStateListener);
      _videoPlayerController!.dispose();
    }
    super.dispose();
  }

  void _initializePlayer() {
    if (widget.reading.hasRecording) {
      if (widget.reading.type == MediaTestType.bodySound) {
        _audioPlayer = AudioPlayer();
        _audioPlayer!.onPlayerStateChanged.listen((PlayerState state) {
          if (mounted) {
            setState(() {
              _isPlaying = state == PlayerState.playing;
              _isLoading = false;
            });
          }
        });
      } else {
        // Initialize video player immediately for ENT tests
        _initializeVideoPlayer();
      }
    }
  }

  void _initializeVideoPlayer() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      _videoPlayerController = VideoPlayerController.asset(
        widget.reading.recordingPath!,
      );

      await _videoPlayerController!.initialize();

      if (_videoPlayerController!.value.isInitialized) {
        // Simple state listener
        _videoPlayerController!.addListener(_videoStateListener);

        // Auto-play if user intended to play
        if (_shouldAutoPlay) {
          _shouldAutoPlay = false;
          await _videoPlayerController!.play();
        }

        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        print('❌ Video controller not initialized after await');
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } catch (e, stackTrace) {
      print('❌ Video error: $e');
      print('📋 Stack: $stackTrace');

      // Try fallback with direct path
      try {
        print('🔄 Trying direct path fallback...');
        _videoPlayerController?.dispose();
        _videoPlayerController = VideoPlayerController.asset(
          'assets/sample/video.mp4',
        );
        await _videoPlayerController!.initialize();

        if (_videoPlayerController!.value.isInitialized) {
          print('✅ Fallback successful!');
          _videoPlayerController!.addListener(_videoStateListener);

          // Auto-play if user intended to play
          if (_shouldAutoPlay) {
            _shouldAutoPlay = false;
            await _videoPlayerController!.play();
          }
        }
      } catch (e2) {
        print('❌ Fallback failed: $e2');
      }

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _videoStateListener() {
    if (mounted && _videoPlayerController != null) {
      setState(() {
        _isPlaying = _videoPlayerController!.value.isPlaying;
        // Force loading state to false when video is ready
        if (_videoPlayerController!.value.isInitialized && _isLoading) {
          _isLoading = false;
        }
      });

      // Debug output
      if (_videoPlayerController!.value.hasError) {
        print(
          '🚨 Video has error: ${_videoPlayerController!.value.errorDescription}',
        );
      }
    }
  }

  void _togglePlayPause() async {
    if (widget.isSelectionMode) {
      widget.onTap();
      return;
    }

    if (!widget.reading.hasRecording) return;

    // For video, if not initialized, try to initialize first
    if (widget.reading.type == MediaTestType.ent &&
        (_videoPlayerController == null ||
            !_videoPlayerController!.value.isInitialized)) {
      print('🎬 Video not ready, initializing...');
      _shouldAutoPlay = true; // Set flag to auto-play after initialization
      _initializeVideoPlayer();
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      if (widget.reading.type == MediaTestType.bodySound) {
        if (_isPlaying) {
          await _audioPlayer?.pause();
        } else {
          await _audioPlayer?.play(
            AssetSource(
              widget.reading.recordingPath!.replaceFirst('assets/', ''),
            ),
          );
        }
        setState(() {
          _isLoading = false;
        });
      } else {
        print('🎬 Playing/Pausing video...');
        if (_isPlaying) {
          await _videoPlayerController?.pause();
        } else {
          await _videoPlayerController?.play();
        }
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('❌ Media playback error: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.xl2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.xl2),
          child:
              widget.reading.type == MediaTestType.ent
                  ? _buildEntLayout()
                  : _buildBodySoundLayout(),
        ),
      ),
    );
  }

  Widget _buildEntLayout() {
    return Row(
      children: [
        // Left section - Video content
        Expanded(
          flex: 2,
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.all(AppSpacing.md),
            height: 180,
            child: Stack(
              children: [
                // Video background
                _videoPlayerController != null &&
                        _videoPlayerController!.value.isInitialized
                    ? Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppRadius.xl2),
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(
                            width: _videoPlayerController!.value.size.width,
                            height: _videoPlayerController!.value.size.height,
                            child: VideoPlayer(_videoPlayerController!),
                          ),
                        ),
                      ),
                    )
                    : Positioned.fill(child: _buildVideoPreview()),

                // Category label overlay (top-left)
                Positioned(
                  top: 10,
                  left: 20,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildCategoryIcon(),
                        SizedBox(width: AppSpacing.xs),
                        Text(
                          widget.reading.displayCategory,
                          style: AppTypography.callout(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Play button (center)
                Center(
                  child: GestureDetector(
                    onTap: _togglePlayPause,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child:
                          _isLoading
                              ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                              : Icon(
                                _isPlaying ? Icons.pause : Icons.play_arrow,
                                color: Colors.white,
                                size: 28,
                              ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Right section - Time
        Container(
          width: 100,
          height: 180,
          color:
              widget.isSelected
                  ? AppColors.primary700.withOpacity(0.1)
                  : Colors.white,
          child: Padding(
            padding: EdgeInsets.only(top: AppSpacing.xl),
            child: Align(
              alignment: Alignment.topCenter,
              child: Text(
                _formatTime(widget.reading.timestamp),
                style: AppTypography.body(
                  color: Colors.black87,
                  weight: AppTypographyWeight.semibold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBodySoundLayout() {
    return Column(
      children: [
        // Header with icon, title, and time
        Container(
          height: 76,
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.sm,
          ),
          color: Colors.white,
          child: Row(
            children: [
              _buildCategoryIcon(),
              SizedBox(width: AppSpacing.sm),
              Text(
                widget.reading.displayCategory,
                style: AppTypography.body(
                  color: Colors.black87,
                  weight: AppTypographyWeight.semibold,
                ),
              ),
              Spacer(),
              Text(
                _formatTime(widget.reading.timestamp),
                style: AppTypography.body(
                  color: Colors.black,
                  weight: AppTypographyWeight.medium,
                ),
              ),
            ],
          ),
        ),

        // Media player section with gradient background
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors:
                    widget.isSelected
                        ? [
                          AppColors.primary800.withOpacity(0.7),
                          AppColors.primary900.withOpacity(0.7),
                        ]
                        : [AppColors.primary800, AppColors.primary900],
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Waveform background
                Positioned.fill(child: _buildWaveform()),

                // Play button
                GestureDetector(
                  onTap: _togglePlayPause,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child:
                        _isLoading
                            ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                            : Icon(
                              _isPlaying ? Icons.pause : Icons.play_arrow,
                              color: Colors.white,
                              size: 28,
                            ),
                  ),
                ),
                SizedBox(width: AppSpacing.md),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWaveform() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(25, (index) {
          // Create a dotted waveform pattern
          final opacity = 0.4 + (index % 3) * 0.2;
          return Container(
            width: 3,
            height: 2,
            margin: EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(opacity),
              borderRadius: BorderRadius.circular(1),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildVideoPreview() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl2),
        image: DecorationImage(
          image: AssetImage(
            'assets/images/test_image.png',
          ), // Using existing test image as video thumbnail
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.3),
            BlendMode.darken,
          ),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.xl2),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black.withOpacity(0.2)],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryIcon() {
    IconData iconData;
    Color iconColor;

    switch (widget.reading.category.toLowerCase()) {
      case 'heart':
        iconData = Icons.favorite;
        iconColor = AppColors.primary700;
        break;
      case 'lungs':
      case 'lung':
        iconData = Icons.air;
        iconColor = AppColors.primary700;
        break;
      case 'stomach':
        iconData = Icons.monitor_heart;
        iconColor = AppColors.primary700;
        break;
      case 'bowel':
        iconData = Icons.medication;
        iconColor = AppColors.primary700;
        break;
      case 'ear':
        iconData = Icons.hearing;
        iconColor = AppColors.white;
        break;
      case 'nose':
        iconData = Icons.self_improvement;
        iconColor = AppColors.white;
        break;
      case 'throat':
        iconData = Icons.record_voice_over;
        iconColor = AppColors.white;
        break;
      default:
        iconData = Icons.graphic_eq;
        iconColor = AppColors.primary700;
    }

    return Container(
      width: 32,
      height: 32,

      child: Icon(iconData, color: iconColor, size: 20),
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays == 0) {
      // Same day - show time
      final hour = timestamp.hour;
      final minute = timestamp.minute.toString().padLeft(2, '0');
      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      return '$displayHour:$minute $period';
    } else {
      // Different day - show date
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${months[timestamp.month - 1]} ${timestamp.day}';
    }
  }
}
