import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class FingerprintTestScreen extends StatefulWidget {
  final LocalAuthentication auth;

  const FingerprintTestScreen({super.key, required this.auth});

  @override
  State<FingerprintTestScreen> createState() => _FingerprintTestScreenState();
}

class _FingerprintTestScreenState extends State<FingerprintTestScreen> {
  String _message = 'Tap to start fingerprint test';
  bool _testing = false;
  bool _completed = false;
  bool _showManual = false;

  Future<void> _authenticate() async {
    if (_testing) return;

    setState(() {
      _testing = true;
      _message = 'Checking device...';
      _showManual = false;
    });

    try {
      // ✅ Check support
      final isSupported = await widget.auth.isDeviceSupported();
      final canCheck = await widget.auth.canCheckBiometrics;

      debugPrint("isSupported: $isSupported");
      debugPrint("canCheck: $canCheck");

      if (!isSupported || !canCheck) {
        _failWithManual("Biometric not supported");
        return;
      }

      // ✅ Check enrolled biometrics
      final biometrics = await widget.auth.getAvailableBiometrics();

      debugPrint("biometrics: $biometrics");

      if (biometrics.isEmpty) {
        _failWithManual("No fingerprint added");
        return;
      }

      setState(() {
        _message = 'Place your finger on the sensor';
      });

      // ✅ Authenticate
      final ok = await widget.auth.authenticate(
        localizedReason: 'Scan your fingerprint',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: false, // 🔥 important
          useErrorDialogs: true,
        ),
      );

      if (!mounted) return;

      if (ok && !_completed) {
        _completed = true;
        _finish(true);
      } else {
        _failWithManual("Authentication failed");
      }
    } catch (e) {
      _failWithManual("Error: $e");
    }
  }

  void _failWithManual(String msg) {
    if (!mounted) return;

    setState(() {
      _testing = false;
      _message = msg;
      _showManual = true; // 🔥 show manual fallback
    });
  }

  void _finish(bool result) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Navigator.pop(context, result);
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFF0D0D0D),
    appBar: AppBar(
      title: const Text('Fingerprint Test',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
    ),
    body: Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 🔥 Icon
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFF007F).withOpacity(0.1),
                border: Border.all(
                  color: const Color(0xFFFF007F),
                  width: 2,
                ),
              ),
              child: const Icon(Icons.fingerprint,
                  size: 60, color: Color(0xFFFF007F)),
            ),

            const SizedBox(height: 30),

            // 🔥 Message
            Text(
              _message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),

            const SizedBox(height: 40),

            // 🔥 Start Button
            if (!_testing && !_showManual)
              ElevatedButton(
                onPressed: _authenticate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF007F),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32, vertical: 14),
                ),
                child: const Text("Start Test"),
              ),

            // 🔥 Loading
            if (_testing)
              const CircularProgressIndicator(
                color: Color(0xFFFF007F),
              ),

            const SizedBox(height: 20),

            // 🔥 Manual fallback buttons
            if (_showManual) ...[
              ElevatedButton.icon(
                onPressed: () => _finish(true),
                icon: const Icon(Icons.check),
                label: const Text("Mark as Passed"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 12),
                ),
              ),
              const SizedBox(height: 12),
            ],

            // 🔥 Skip / Fail
            OutlinedButton(
              onPressed: () => _finish(false),
              child: const Text("Skip / Fail"),
            ),
          ],
        ),
      ),
    ),
  );
}

