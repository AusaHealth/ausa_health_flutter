import 'package:flutter/material.dart';

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: Image.asset(
            'assets/images/profile.png',
            width: 280,
            height: 280,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 32),
        // Profile Details Card
        Expanded(
          child: Stack(
            children: [
              // Blue gradient shadow
              Positioned(
                right: 0,
                bottom: 0,
                left: 40,
                top: 40,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: RadialGradient(
                      colors: [Color(0xFF0049F5), Color(0x000049F5)],
                      radius: 1.2,
                      center: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
              // Card with content
              Container(
                margin: const EdgeInsets.only(top: 8, left: 0),
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tab Bar
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFE0B2),
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: Row(
                        children: [
                          _ProfileTabButton(
                            label: 'Personal',
                            selected: true,
                            onTap: () {},
                          ),
                          _ProfileTabButton(
                            label: 'Contact',
                            selected: false,
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Details Row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left column
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              _ProfileDetail(
                                label: 'Name',
                                value: 'Lucy O.',
                                bold: true,
                              ),
                              _ProfileDetail(label: 'Age', value: '67'),
                              _ProfileDetail(
                                label: 'Height',
                                value: '5\'8\"',
                                bold: true,
                              ),
                              _ProfileDetail(
                                label: 'BMI',
                                value: '26.8',
                                color: Color(0xFF2196F3),
                              ),
                            ],
                          ),
                        ),
                        // Right column
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              _ProfileDetail(
                                label: 'Birthday',
                                value: 'July 23, 1980',
                                bold: true,
                              ),
                              _ProfileDetail(label: 'Gender', value: 'F'),
                              _ProfileDetail(
                                label: 'Weight',
                                value: '176 lbs',
                                bold: true,
                              ),
                            ],
                          ),
                        ),
                        // Edit button
                        IconButton(
                          icon: Icon(Icons.edit, color: Color(0xFF2196F3)),
                          onPressed: () {},
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Edit',
                          style: TextStyle(
                            color: Color(0xFF2196F3),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProfileTabButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ProfileTabButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFFFA726) : Colors.transparent,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}

class _ProfileDetail extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  final Color? color;

  const _ProfileDetail({
    required this.label,
    required this.value,
    this.bold = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Text(
            '$label ',
            style: const TextStyle(color: Colors.black54, fontSize: 16),
          ),
          Text(
            value,
            style: TextStyle(
              color: color ?? Colors.black,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
