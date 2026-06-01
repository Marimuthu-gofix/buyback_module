import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

class MicTestScreen extends StatefulWidget {
  final String title;
  final IconData icon;
  final String instruction;

  const MicTestScreen({
    super.key,
    required this.title,
    required this.icon,
    required this.instruction,
  });

  @override
  State<MicTestScreen> createState() => _MicTestScreenState();
}

class _MicTestScreenState extends State<MicTestScreen> {
  final AudioRecorder _audioRecorder = AudioRecorder();
  StreamSubscription<Amplitude>? _amplitudeSubscription;

  double _dbLevel = -160.0;
  bool _isRecording = false;
  int _successHits = 0;
  bool _isAutoValidating = false;

  @override
  void initState() {
    super.initState();
    _startMicTest();
  }

  Future<void> _startMicTest() async {
    try {
      // 1. Request Permission
      final status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) return;

      // 2. Prepare File Path
      final tempDir = await getTemporaryDirectory();
      final String path = '${tempDir.path}/mic_test_temp.m4a';
      final file = File(path);
      if (await file.exists()) await file.delete();

      // 3. Start Recording
      if (await _audioRecorder.hasPermission()) {
        const config = RecordConfig();
        await _audioRecorder.start(config, path: path);

        setState(() => _isRecording = true);

        // 4. Listen for volume levels
        _amplitudeSubscription = _audioRecorder
            .onAmplitudeChanged(const Duration(milliseconds: 100))
            .listen((amp) {
          if (!mounted) return;

          setState(() => _dbLevel = amp.current);

          // AUTO-VALIDATION LOGIC
          // Speaking volume is typically > -25dB.
          // We require 3 hits (300ms of sound) to trigger auto-pass.
          if (amp.current > -25) {
            _successHits++;
            if (_successHits >= 3 && !_isAutoValidating) {
              _handleAutoPass();
            }
          } else {
            _successHits = 0;
          }
        });
      }
    } catch (e) {
      debugPrint("Mic Test Error: $e");
    }
  }

  void _handleAutoPass() async {
    _isAutoValidating = true;
    // Small delay so the user sees the "Success" state
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      _stopAndExit(true);
    }
  }

  void _stopAndExit(bool result) async {
    await _audioRecorder.stop();
    if (mounted) {
      Navigator.pop(context, result);
    }
  }

  @override
  void dispose() {
    _amplitudeSubscription?.cancel();
    _audioRecorder.dispose();
    super.dispose();
  }

  // Logic to convert dB to scale factor for animation
  double get _visualScale => (1.0 + (_dbLevel + 45) / 45).clamp(1.0, 1.6);

  @override
  Widget build(BuildContext context) {
    // Detect if "hearing" voice for UI feedback
    final bool isHearingVoice = _dbLevel > -25;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

            // Pulse Visualizer
            AnimatedScale(
              duration: const Duration(milliseconds: 100),
              scale: _isRecording ? _visualScale : 1.0,
              child: Container(
                width: 100, height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isHearingVoice
                      ? Colors.green.withOpacity(0.2)
                      : const Color(0xFFFF007F).withOpacity(0.1),
                  border: Border.all(
                    color: isHearingVoice ? Colors.green : const Color(0xFFFF007F).withOpacity(0.5),
                    width: 3,
                  ),
                ),
                child: Icon(
                    isHearingVoice ? Icons.check : widget.icon,
                    color: isHearingVoice ? Colors.green : const Color(0xFFFF007F),
                    size: 48
                ),
              ),
            ),

            const SizedBox(height: 20),
            Text(
              isHearingVoice ? "Voice Detected!" : "Listening...",
              style: TextStyle(
                  color: isHearingVoice ? Colors.green : Colors.white38,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1
              ),
            ),

            const SizedBox(height: 40),
            Text(
              widget.instruction,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, fontSize: 16, height: 1.7),
            ),

            const SizedBox(height: 56),

            // Manual Override Buttons
            Row(children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _stopAndExit(false),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFFF5252),
                    side: const BorderSide(color: Color(0xFFFF5252)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('❌  Fail', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _stopAndExit(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00E676),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('✅  Pass', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ]),
          ]),
        ),
      ),
    );
  }
}