import 'package:flutter/material.dart';

class DeviceSelectionProgress extends StatelessWidget {
  final int currentStep; // 1 or 2
  final String deviceType;

  const DeviceSelectionProgress({
    super.key,
    required this.currentStep,
    required this.deviceType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$deviceType Device Selection',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildStepCircle('1', 'Select $deviceType', currentStep >= 1),
            _buildLine(),
            _buildStepCircle('2', 'Select Model', currentStep >= 2),
          ],
        ),
      ],
    );
  }

  Widget _buildStepCircle(String step, String label, bool isActive) {
    return Column(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: isActive ? Color(0xFFFF64E6) : Colors.white,
          child: Text(
            step,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.white)),
      ],
    );
  }

  Widget _buildLine() {
    return Container(
      width: 120,
      height: 2,
      color: Colors.white,
      margin: EdgeInsetsDirectional.only(bottom: 35, start: 10, end: 10),
    );
  }
}
