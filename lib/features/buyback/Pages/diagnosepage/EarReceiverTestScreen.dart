import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class EarReceiverTestScreen extends StatefulWidget {
  const EarReceiverTestScreen({super.key});
  @override State<EarReceiverTestScreen> createState() => _EarReceiverTestScreenState();
}

class _EarReceiverTestScreenState extends State<EarReceiverTestScreen> {
  bool _played = false;

  @override
  void initState() { super.initState(); _playBeep(); }

  Future<void> _playBeep() async {
    try {
      final player = AudioPlayer();
      // Route audio through earpiece (in-call mode)
      await player.setAudioContext(AudioContext(
        android: AudioContextAndroid(
          audioMode: AndroidAudioMode.inCommunication,
          audioFocus: AndroidAudioFocus.gain,
          contentType: AndroidContentType.speech,
          usageType: AndroidUsageType.voiceCommunication,
          isSpeakerphoneOn: false,
        ),
      ));
      await player.play(AssetSource('sound/beep.mp3'));
      await Future.delayed(const Duration(seconds: 2));
      await player.dispose();
      if (mounted) setState(() => _played = true);
    } catch (_) {
      if (mounted) setState(() => _played = true);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.black,
    appBar: AppBar(title: const Text('Ear Receiver Test',
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)
    ), backgroundColor: Colors.black,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
    ),
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            width: 100, height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFFF007F).withOpacity(0.1),
              border: Border.all(color: const Color(0xFFFF007F).withOpacity(0.5), width: 2),
            ),
            child: const Icon(Icons.hearing, color: Color(0xFFFF007F), size: 52),
          ),
          const SizedBox(height: 28),
          Text(
            _played
                ? 'Hold the phone to your ear.\nDid you hear the beep sound?'
                : 'Playing beep through ear receiver…',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70, fontSize: 16, height: 1.6),
          ),
          const SizedBox(height: 48),
          if (_played)
            Row(children: [
              Expanded(child: OutlinedButton(
                onPressed: () => Navigator.pop(context, false),
                style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFFFF5252), side: const BorderSide(color: Color(0xFFFF5252)), padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: const Text('❌  No / Fail', style: TextStyle(fontWeight: FontWeight.bold)),
              )),
              const SizedBox(width: 16),
              Expanded(child: ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00E676), foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: const Text('✅  Yes / Pass', style: TextStyle(fontWeight: FontWeight.bold)),
              )),
            ])
          else
            const CircularProgressIndicator(color: Color(0xFFFF007F)),
        ]),
      ),
    ),
  );
}