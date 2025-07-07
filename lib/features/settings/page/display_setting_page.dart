import 'package:ausa/constants/typography.dart';
import 'package:flutter/material.dart';

class DisplaySettingPage extends StatefulWidget {
  const DisplaySettingPage({super.key});

  @override
  State<DisplaySettingPage> createState() => _DisplaySettingPageState();
}

class _DisplaySettingPageState extends State<DisplaySettingPage> {
  double brightness = 0.45;
  double textSize = 1.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),

      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Brightness Card
            _DisplayCard(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${(brightness * 100).round()} %',
                    style: AppTypography.title1(
                      color: Colors.blue,
                      fontWeight: FontWeight.w400,
                    ).copyWith(fontSize: 48),
                  ),
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _CustomSlider(
                      value: brightness,
                      onChanged: (v) => setState(() => brightness = v),
                      icon: Icons.wb_sunny_rounded,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Brightness',
                    style: AppTypography.body(
                      color: Colors.black,
                    ).copyWith(fontSize: 24),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 32),
            // Text Size Card
            _DisplayCard(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'A',
                        style: AppTypography.title1(
                          color: Colors.blue,
                          fontWeight: FontWeight.w400,
                        ).copyWith(fontSize: 24),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'A',
                        style: AppTypography.title1(
                          color: Colors.blue,
                          fontWeight: FontWeight.w400,
                        ).copyWith(fontSize: 32),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'A',
                        style: AppTypography.title1(
                          color: Colors.blue,
                          fontWeight: FontWeight.w400,
                        ).copyWith(fontSize: 38),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _CustomSlider(
                      value: textSize,
                      onChanged: (v) => setState(() => textSize = v),
                      icon: Icons.text_fields_rounded,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Text Size',
                    style: AppTypography.body(
                      color: Colors.black,
                    ).copyWith(fontSize: 24),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DisplayCard extends StatelessWidget {
  final Widget child;
  const _DisplayCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 350,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _CustomSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;
  final IconData icon;

  const _CustomSlider({
    required this.value,
    required this.onChanged,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 2,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 0),
            overlayShape: SliderComponentShape.noOverlay,
            activeTrackColor: const Color(0xFF1673FF),
            inactiveTrackColor: const Color(0xFFE0E0E0),
          ),
          child: Slider(value: value, onChanged: onChanged, min: 0, max: 1),
        ),
        Positioned(
          child: Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: Color(0xFF1673FF),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
        ),
      ],
    );
  }
}
