import 'package:flutter/material.dart';
import 'package:ausa/common/model/test.dart';
import 'package:ausa/constants/color.dart';
import 'package:ausa/constants/typography.dart';
import 'package:ausa/constants/spacing.dart';

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
  }

  @override
  void dispose() {
    _expandController.dispose();
    super.dispose();
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
    return Material(
      elevation: isExpanded ? 16 : 4,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: isExpanded ? 300 : 300,
        height: isExpanded ? 400 : 160,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 16,
                children: [
                  _buildSmallNavigationButton(
                    icon: Icons.arrow_back_ios,
                    onPressed: canGoPrevious ? _goToPrevious : null,
                    isEnabled: canGoPrevious,
                  ),
                  _buildSmallNavigationButton(
                    icon: Icons.arrow_forward_ios,
                    onPressed: canGoNext ? _goToNext : null,
                    isEnabled: canGoNext,
                  ),
                ],
              ),
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

          // Show More button
          GestureDetector(
            onTap: _toggleExpansion,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                if (currentInstruction.title != null &&
                    currentInstruction.title!.isNotEmpty) ...[
                  Text(
                    currentInstruction.title!,
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
                    currentInstruction.content != null &&
                            currentInstruction.content!.isNotEmpty
                        ? currentInstruction.content!
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
    required IconData icon,
    required VoidCallback? onPressed,
    required bool isEnabled,
  }) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color:
            isEnabled
                ? AppColors.primary700.withValues(alpha: 0.1)
                : Colors.grey[100],
        border: Border.all(
          color:
              isEnabled
                  ? AppColors.primary700.withValues(alpha: 0.3)
                  : Colors.grey[300]!,
        ),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        onPressed: onPressed,
        icon: Icon(
          icon,
          size: 12,
          color: isEnabled ? AppColors.primary700 : Colors.grey[400],
        ),
      ),
    );
  }

  Widget _buildNavigationButton({
    required IconData icon,
    required VoidCallback? onPressed,
    required bool isEnabled,
  }) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color:
            isEnabled
                ? AppColors.primary700.withValues(alpha: 0.1)
                : Colors.grey[100],
        border: Border.all(
          color:
              isEnabled
                  ? AppColors.primary700.withValues(alpha: 0.3)
                  : Colors.grey[300]!,
        ),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        onPressed: onPressed,
        icon: Icon(
          icon,
          size: 16,
          color: isEnabled ? AppColors.primary700 : Colors.grey[400],
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

          // Show More button
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
}
