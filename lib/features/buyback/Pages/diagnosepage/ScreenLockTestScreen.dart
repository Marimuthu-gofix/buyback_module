import 'package:flutter/material.dart';
import 'package:volume_controller/volume_controller.dart';

class ScreenLockTestScreen extends StatefulWidget {
  const ScreenLockTestScreen({super.key});
  @override State<ScreenLockTestScreen> createState() => _ScreenLockTestScreenState();
}

class _ScreenLockTestScreenState extends State<ScreenLockTestScreen> {
  bool _detected = false;
  int  _pauseCount = 0;
  late final AppLifecycleListener _listener;

  @override
  void initState() {
    super.initState();
    _listener = AppLifecycleListener(
      onPause: () => _pauseCount++,
      onResume: () {
        if (_pauseCount > 0 && mounted && !_detected) {
          setState(() => _detected = true);
          Future.delayed(const Duration(milliseconds: 800), () {
            if (mounted) Navigator.pop(context, true);
          });
        }
      },
    );
  }

  @override void dispose() { _listener.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => _KeyTestScaffold(
    title: 'Screen Lock Key',
    icon: Icons.lock_outline,
    instruction: 'Press the  Power / Lock  button\non the side of your device.\nThen press it again to wake the screen.',
    detected: _detected,
    onFail: () => Navigator.pop(context, false),
  );
}

class VolumeKeyTestScreen extends StatefulWidget {
  const VolumeKeyTestScreen({super.key});

  @override
  State<VolumeKeyTestScreen> createState() => _VolumeKeyTestScreenState();
}

class _VolumeKeyTestScreenState extends State<VolumeKeyTestScreen> {
  bool _up = false;
  bool _down = false;
  double _lastVolume = 0;
  bool _completed = false;

  @override
  void initState() {
    super.initState();

    // ✅ Force volume to mid level (VERY IMPORTANT)
    VolumeController().setVolume(0.5);

    VolumeController().getVolume().then((value) {
      _lastVolume = value;
    });

    VolumeController().listener((volume) {
      if (_completed) return;

      // ✅ Ignore first callback noise
      if (_lastVolume == 0) {
        _lastVolume = volume;
        return;
      }

      if (volume > _lastVolume) {
        setState(() => _up = true);
      } else if (volume < _lastVolume) {
        setState(() => _down = true);
      }

      _lastVolume = volume;
      _checkDone();
    });
  }

  @override
  void dispose() {
    VolumeController().removeListener();
    super.dispose();
  }

  void _checkDone() {
    if (_up && _down && !_completed) {
      _completed = true;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        Navigator.pop(context, true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text('Volume Button Test',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),

      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.volume_up_rounded,
                size: 80, color: Color(0xFFFF007F)),

            const SizedBox(height: 30),

            const Text(
              'Press Volume Buttons',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Press Volume UP and Volume DOWN to complete the test',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white54),
            ),

            const SizedBox(height: 50),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _keyCard("Volume Up", Icons.add, _up),
                _keyCard("Volume Down", Icons.remove, _down),
              ],
            ),

            const SizedBox(height: 60),

            if (_up && _down)
              const Text(
                "✔ Test Passed",
                style: TextStyle(
                  color: Colors.greenAccent,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

            const SizedBox(height: 40),

            OutlinedButton(
              onPressed: () => Navigator.pop(context, false),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white54,
                side: const BorderSide(color: Colors.white24),
                padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text("Skip / Fail"),
            )
          ],
        ),
      ),
    );
  }

  Widget _keyCard(String label, IconData icon, bool active) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(20),
      width: 130,
      decoration: BoxDecoration(
        color: active ? Colors.green.withOpacity(0.15) : Colors.white10,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: active ? Colors.greenAccent : Colors.white24,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Icon(icon,
              size: 40,
              color: active ? Colors.greenAccent : Colors.white54),
          const SizedBox(height: 10),
          Text(
            label,
            style: TextStyle(
              color: active ? Colors.greenAccent : Colors.white70,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Icon(
            active ? Icons.check_circle : Icons.radio_button_unchecked,
            color: active ? Colors.greenAccent : Colors.white24,
          )
        ],
      ),
    );
  }
}

class _KeyDot extends StatelessWidget {
  final String label;
  final bool detected;
  const _KeyDot({required this.label, required this.detected});
  @override
  Widget build(BuildContext context) => Column(children: [
    AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 80, height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: detected ? const Color(0xFF00E676).withOpacity(0.15) : Colors.white.withOpacity(0.05),
        border: Border.all(color: detected ? const Color(0xFF00E676) : Colors.white24, width: 2),
      ),
      child: Icon(detected ? Icons.check : Icons.touch_app,
          color: detected ? const Color(0xFF00E676) : Colors.white38, size: 32),
    ),
    const SizedBox(height: 10),
    Text(label, style: TextStyle(color: detected ? const Color(0xFF00E676) : Colors.white54, fontSize: 13)),
  ]);
}

class _KeyTestScaffold extends StatelessWidget {
  final String title, instruction;
  final IconData icon;
  final bool detected;
  final VoidCallback onFail;
  const _KeyTestScaffold({required this.title, required this.icon, required this.instruction, required this.detected, required this.onFail});
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.black,
    appBar: AppBar(title: Text(title,
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
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            width: 100, height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: detected ? const Color(0xFF00E676).withOpacity(0.15) : Colors.white.withOpacity(0.05),
              border: Border.all(color: detected ? const Color(0xFF00E676) : Colors.white24, width: 2),
            ),
            child: Icon(detected ? Icons.check : icon,
                color: detected ? const Color(0xFF00E676) : Colors.white38, size: 44),
          ),
          const SizedBox(height: 28),
          Text(detected ? 'Key Detected! ✅' : instruction,
              textAlign: TextAlign.center,
              style: TextStyle(color: detected ? const Color(0xFF00E676) : Colors.white70, fontSize: 17, height: 1.6)),
          const SizedBox(height: 48),
          if (!detected)
            OutlinedButton(
              onPressed: onFail,
              style: OutlinedButton.styleFrom(foregroundColor: Colors.white54, side: const BorderSide(color: Colors.white24)),
              child: const Text('Skip / Fail'),
            ),
        ]),
      ),
    ),
  );
}