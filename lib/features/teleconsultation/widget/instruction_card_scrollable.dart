import 'dart:async';
import 'package:ausa/common/model/test.dart';
import 'package:ausa/constants/typography.dart';
import 'package:flutter/material.dart';
import 'package:ausa/constants/typography.dart';

class InstructionCardScrollable extends StatefulWidget {
  final Test test;
  final Function(bool) onShowLess;
  const InstructionCardScrollable({
    super.key,
    required this.test,
    required this.onShowLess,
  });

  @override
  State<InstructionCardScrollable> createState() =>
      _InstructionCardScrollableState();
}

class _InstructionCardScrollableState extends State<InstructionCardScrollable> {
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _autoPlayTimer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _autoPlayTimer = Timer.periodic(const Duration(seconds: 6), (_) {
      if (_currentPage < widget.test.instructions!.length - 1) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      } else {
        _pageController.animateToPage(
          0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final instructions = widget.test.instructions!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Instructions",
            style: AppTypography.body(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),

          SizedBox(
            height: MediaQuery.of(context).size.height * 0.25,
            child: PageView.builder(
              controller: _pageController,
              itemCount: instructions.length,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              itemBuilder: (context, index) {
                final step = instructions[index];
                return Center(
                  child: Image.asset(
                    step.image,
                    height: MediaQuery.of(context).size.height * 0.25,
                    fit: BoxFit.contain,
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // Stepper dots
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: instructions.length,
                    onPageChanged: (index) {
                      setState(() => _currentPage = index);
                    },
                    itemBuilder: (context, index) {
                      return Text(
                        "Step ${index + 1}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      );
                    },
                  ),
                ),
              ),

              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(instructions.length, (index) {
                    final isActive = index == _currentPage;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 4,
                      width: isActive ? 24 : 10,
                      decoration: BoxDecoration(
                        color: isActive ? Colors.blue : Colors.grey[300],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: instructions.length,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              itemBuilder: (context, index) {
                final step = instructions[index];
                return Text(
                  step.content,
                  style: AppTypography.body(),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          TextButton(
            onPressed: () {
              widget.onShowLess(true);
            },
            child: Text(
              'Show less',
              style:  AppTypography.callout(color: Color(0xFF2978FB)),
            ),
          ),
        ],
      ),
    );
  }
}
