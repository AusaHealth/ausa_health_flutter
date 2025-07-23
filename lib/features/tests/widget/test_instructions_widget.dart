import 'dart:async';

import 'package:ausa/common/model/test.dart';
import 'package:ausa/constants/color.dart';
import 'package:ausa/constants/icons.dart';
import 'package:ausa/constants/spacing.dart';
import 'package:ausa/constants/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TestInstructionsWidget extends StatefulWidget {
  final Test test;
  final VoidCallback? onClose;

  const TestInstructionsWidget({super.key, required this.test, this.onClose});

  @override
  State<TestInstructionsWidget> createState() => _TestInstructionsWidgetState();
}

class _TestInstructionsWidgetState extends State<TestInstructionsWidget>
    with TickerProviderStateMixin {
  int currentInstructionIndex = 0;
  bool isExpanded = false;
  late AnimationController _expandController;
  Timer? _autoTimer;
  Timer? _countdownTimer;
  bool _showCompletionCard = false;
  int _countdownSeconds = 3;

  List<TestInstruction> get instructions => widget.test.instructions ?? [];
  bool get hasInstructions => instructions.isNotEmpty;
  bool get canGoPrevious => currentInstructionIndex > 0;
  bool get canGoNext => currentInstructionIndex < instructions.length - 1;
  bool get hasImages =>
      hasInstructions &&
      instructions.any(
        (instruction) =>
            instruction.image != null && instruction.image!.isNotEmpty,
      );

  @override
  void initState() {
    super.initState();
    _expandController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // If the test should auto-start, begin auto progression.
    if (widget.test.startBehavior == TestStartBehavior.auto) {
      if (hasInstructions) {
        _startAutoProgress();
      } else {
        _triggerCompletion();
      }
    }
  }

  @override
  void dispose() {
    _autoTimer?.cancel();
    _countdownTimer?.cancel();
    _expandController.dispose();
    super.dispose();
  }

  void _startAutoProgress() {
    _autoTimer?.cancel();
    _autoTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (canGoNext) {
        setState(() {
          currentInstructionIndex++;
        });
      } else {
        timer.cancel();
        _triggerCompletion();
      }
    });
  }

  void _triggerCompletion() {
    setState(() {
      _showCompletionCard = true;
    });

    _countdownSeconds = 3;
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdownSeconds > 1) {
        setState(() {
          _countdownSeconds--;
        });
      } else {
        timer.cancel();
        if (widget.onClose != null) {
          widget.onClose!();
        }
      }
    });
  }

  void _goToPrevious() {
    if (canGoPrevious) {
      setState(() {
        currentInstructionIndex--;
      });
    }
  }

  void _goToNext() {
    if (canGoNext) {
      setState(() {
        currentInstructionIndex++;
      });
    }
  }

  void _toggleExpansion() {
    setState(() {
      isExpanded = !isExpanded;
      if (isExpanded) {
        _expandController.forward();
      } else {
        _expandController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showCompletionCard) {
      return _buildCompletionCard();
    }

    return Material(
      elevation: isExpanded ? 16 : 4,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: isExpanded ? 300 : 300,
        height: isExpanded ? 400 : (!hasImages ? 130 : 160),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.primary700.withValues(alpha: 0.2),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: isExpanded ? _buildExpandedView() : _buildCollapsedView(),
        ),
      ),
    );
  }

  Widget _buildCollapsedView() {
    if (!hasInstructions) {
      return _buildFallbackCollapsed();
    }

    final currentInstruction = instructions[currentInstructionIndex];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Step ${currentInstructionIndex + 1} of ${instructions.length}',
                style: AppTypography.callout(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary700,
                ),
              ),

              // Navigation row
              if (hasInstructions && instructions.length > 1) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  spacing: 16,
                  children: [
                    _buildSmallNavigationButton(
                      iconPath: AusaIcons.chevronLeft,
                      onPressed: canGoPrevious ? _goToPrevious : null,
                      isEnabled: canGoPrevious,
                    ),
                    _buildSmallNavigationButton(
                      iconPath: AusaIcons.chevronRight,
                      onPressed: canGoNext ? _goToNext : null,
                      isEnabled: canGoNext,
                    ),
                  ],
                ),
              ],
            ],
          ),

          // Header
          SizedBox(height: AppSpacing.sm),

          // Content
          Expanded(
            child: Text(
              currentInstruction.content.isNotEmpty
                  ? currentInstruction.content
                  : 'Follow the instructions to complete this test safely.',
              style: AppTypography.body(
                color: Colors.grey[700],
                fontWeight: FontWeight.w400,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          SizedBox(height: AppSpacing.sm),

          // Show More button (only if images available)
          if (hasImages)
            GestureDetector(
              onTap: _toggleExpansion,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary700.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Text(
                  'Show More',
                  textAlign: TextAlign.left,
                  style: AppTypography.callout(color: AppColors.primary700),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildExpandedView() {
    if (!hasInstructions) {
      return _buildFallbackExpanded();
    }

    final currentInstruction = instructions[currentInstructionIndex];

    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Instructions',
                style: AppTypography.callout(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary700,
                ),
              ),
            ],
          ),
        ),

        // Image section (if expanded and showing images)
        if (currentInstruction.image != null &&
            currentInstruction.image!.isNotEmpty)
          Container(
            height: 120,
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                currentInstruction.image!,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.image_not_supported,
                      color: Colors.grey[400],
                      size: 40,
                    ),
                  );
                },
              ),
            ),
          ),

        // Content section
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Step indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Step ${(currentInstructionIndex + 1).toString().padLeft(2, '0')}',
                      style: AppTypography.callout(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: AppSpacing.sm),

                // Segmented progress bar
                Row(
                  children: List.generate(
                    instructions.length,
                    (index) => Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            currentInstructionIndex = index;
                          });
                        },
                        child: Container(
                          height: 4,
                          margin: EdgeInsets.only(
                            right: index < instructions.length - 1 ? 4 : 0,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color:
                                index <= currentInstructionIndex
                                    ? AppColors.primary700
                                    : Colors.grey[300],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: AppSpacing.md),

                // Instruction title
                if (currentInstruction.title.isNotEmpty) ...[
                  Text(
                    currentInstruction.title,
                    style: AppTypography.callout(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: AppSpacing.sm),
                ],

                // Instruction content
                Expanded(
                  child: Text(
                    currentInstruction.content.isNotEmpty
                        ? currentInstruction.content
                        : 'No instruction content available.',
                    style: AppTypography.body(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),

                GestureDetector(
                  onTap: _toggleExpansion,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary700.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text(
                      'Show Less',
                      textAlign: TextAlign.left,
                      style: AppTypography.callout(color: AppColors.primary700),
                    ),
                  ),
                ),

                // Navigation controls
                // SizedBox(height: AppSpacing.md),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSmallNavigationButton({
    required String iconPath,
    required VoidCallback? onPressed,
    required bool isEnabled,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: isEnabled ? onPressed : null,
        child: Container(
          padding: EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color:
                isEnabled
                    ? AppColors.primary700.withValues(alpha: 0.1)
                    : const Color.fromARGB(255, 238, 238, 238),
          ),
          child: Center(
            child: SvgPicture.asset(
              iconPath,
              width: 16,
              height: 16,
              colorFilter: ColorFilter.mode(
                isEnabled ? AppColors.primary700 : Colors.grey[400]!,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFallbackCollapsed() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'Instructions',
            style: AppTypography.callout(
              fontWeight: FontWeight.w600,
              color: AppColors.primary700,
            ),
          ),

          SizedBox(height: AppSpacing.sm),

          // Content
          Expanded(
            child: Text(
              widget.test.instruction ??
                  'Follow the instructions to complete this test safely and accurately.',
              style: AppTypography.body(color: Colors.grey[700]),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Show More button only if images are present in instructions list
          if (hasImages)
            GestureDetector(
              onTap: _toggleExpansion,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primary700,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Show More',
                  textAlign: TextAlign.center,
                  style: AppTypography.body(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFallbackExpanded() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Instructions',
                style: AppTypography.callout(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary700,
                ),
              ),
              GestureDetector(
                onTap: _toggleExpansion,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary700.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Text(
                    'Show Less',
                    textAlign: TextAlign.left,
                    style: AppTypography.callout(color: AppColors.primary700),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          Expanded(
            child: Text(
              widget.test.instruction ??
                  'Follow the instructions to complete this test safely and accurately.',
              style: AppTypography.body(color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletionCard() {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 300,
        height: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: const DecorationImage(
            image: AssetImage('assets/images/success_info_bg.png'),
            fit: BoxFit.cover,
          ),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF6B8DFB), Color(0xFF23A4F2)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'You are all set!',
                style: AppTypography.body(
                  weight: AppTypographyWeight.medium,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Test starting automatically in',
                style: AppTypography.body(color: Colors.white, weight: AppTypographyWeight.regular),
              ),
              Text(
                '$_countdownSeconds seconds.',
                style: AppTypography.body(color: Colors.white, weight: AppTypographyWeight.regular),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
