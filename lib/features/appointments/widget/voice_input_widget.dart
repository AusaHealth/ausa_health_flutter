import 'package:ausa/constants/color.dart';
import 'package:flutter/material.dart';

class VoiceInputWidget extends StatefulWidget {
  final bool isRecording;
  final VoidCallback onToggleRecording;
  final VoidCallback? onClear;

  const VoiceInputWidget({
    super.key,
    required this.isRecording,
    required this.onToggleRecording,
    this.onClear,
  });

  @override
  State<VoiceInputWidget> createState() => _VoiceInputWidgetState();
}

class _VoiceInputWidgetState extends State<VoiceInputWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(VoiceInputWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRecording && !oldWidget.isRecording) {
      _animationController.repeat(reverse: true);
    } else if (!widget.isRecording && oldWidget.isRecording) {
      _animationController.stop();
      _animationController.reset();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Microphone button
        GestureDetector(
          onTap: widget.onToggleRecording,
          child: AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: widget.isRecording ? _scaleAnimation.value : 1.0,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        widget.isRecording
                            ? AppColors.primary700
                            : AppColors.primary700.withOpacity(0.1),
                    border: Border.all(color: AppColors.primary700, width: 2),
                  ),
                  child: Icon(
                    widget.isRecording ? Icons.stop : Icons.mic,
                    color:
                        widget.isRecording
                            ? Colors.white
                            : AppColors.primary700,
                    size: 20,
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(width: 16),

        // Waveform or status text
        Expanded(
          child:
              widget.isRecording
                  ? _buildWaveform()
                  : Container(
                    height: 40,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Tap to record',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ),
        ),

        // Clear button
        if (widget.onClear != null)
          GestureDetector(
            onTap: widget.onClear,
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Text(
                'Clear',
                style: TextStyle(
                  color: const Color(0xFFFF8A00),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildWaveform() {
    return Container(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(12, (index) {
          return AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              final height =
                  (20 + (index % 3) * 10) * (0.5 + 0.5 * _scaleAnimation.value);
              return Container(
                width: 3,
                height: height,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF8A00),
                  borderRadius: BorderRadius.circular(2),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
