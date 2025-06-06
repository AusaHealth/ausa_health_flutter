import 'package:ausa/common/model/user.dart';
import 'package:ausa/common/widget/containers.dart';
import 'package:flutter/material.dart';

class DoctorInfo extends StatelessWidget {
  final User doctor;
  const DoctorInfo({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return BlurContainer(child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.person),
              const SizedBox(width: 8),
              Column(
                children: [
                  Text(doctor.name),
                  Text(doctor.specialization),
                ],
              ),
            ],
          ));
  }
}