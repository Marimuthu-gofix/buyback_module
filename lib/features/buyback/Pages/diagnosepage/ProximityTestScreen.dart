import 'dart:async';

import 'package:flutter/material.dart';
import 'package:proximity_sensor/proximity_sensor.dart';
import 'package:vibration/vibration.dart';

class ProximityTestScreen extends StatefulWidget {
  const ProximityTestScreen({super.key});

  @override
  State<ProximityTestScreen> createState() => _ProximityTestScreenState();
}

class _ProximityTestScreenState extends State<ProximityTestScreen> {
  StreamSubscription<int>? _sub;

  bool _near = false;
  bool _everNear = false;

  @override
  void initState() {
    super.initState();

    _sub = ProximitySensor.events.listen((event) async {
      final isNear = event > 0;

      if (!mounted) return;

      setState(() {
        _near = isNear;
      });

      // ✅ AUTO PASS (only first time)
      if (isNear && !_everNear) {
        _everNear = true;

        // 🔔 vibration feedback (safe check)
        if (await Vibration.hasVibrator() ?? false) {
          Vibration.vibrate(duration: 100);
        }

        // ⏳ small delay for UI feedback
        Future.delayed(const Duration(milliseconds: 400), () {
          if (mounted) {
            Navigator.pop(context, true); // PASS
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Proximity Test',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)
        ),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 🔴 SENSOR INDICATOR
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _near
                      ? const Color(0xFFFF007F).withOpacity(0.2)
                      : Colors.white.withOpacity(0.05),
                  border: Border.all(
                    color: _near
                        ? const Color(0xFFFF007F)
                        : Colors.white24,
                    width: 3,
                  ),
                ),
                child: Icon(
                  Icons.sensors,
                  size: 60,
                  color: _near
                      ? const Color(0xFFFF007F)
                      : Colors.white38,
                ),
              ),

              const SizedBox(height: 30),

              // 🧾 STATUS TEXT
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: Text(
                  _near
                      ? '🟥 Object Detected (NEAR)'
                      : '⬜ No Object Detected',
                  key: ValueKey(_near),
                  style: TextStyle(
                    color: _near
                        ? const Color(0xFFFF007F)
                        : Colors.white54,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Cover the top earpiece sensor with your hand',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 13,
                ),
              ),

              if (_everNear) ...[
                const SizedBox(height: 12),
                const Text(
                  '✅ Proximity detected',
                  style: TextStyle(
                    color: Color(0xFF00E676),
                    fontSize: 13,
                  ),
                ),
              ],

              const SizedBox(height: 50),

              // ❌ FAIL BUTTON
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context, false),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFFF5252),
                    side: const BorderSide(color: Color(0xFFFF5252)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    '❌ Fail',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}