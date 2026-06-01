import 'dart:async';
import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:local_auth/local_auth.dart';
import 'package:vibration/vibration.dart';
import 'package:torch_light/torch_light.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:provider/provider.dart';
import '../../Providers/diagnose_result_provider.dart';
import 'CameraTestScreen.dart';
import 'DiagnoseResultPage.dart';
import 'EarReceiverTestScreen.dart';
import 'FingerprintTestScreen.dart';
import 'MicTestScreen.dart';
import 'MultiTouchTestScreen.dart';
import 'ProximityTestScreen.dart';
import 'ScreenLockTestScreen.dart';
import 'SingleTouchTestScreen.dart';
import 'models/getStorage.dart';
import 'models/getdevicename.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Enums & Model
// ─────────────────────────────────────────────────────────────────────────────

enum TestStatus { idle, testing, passed, failed }

enum TestType {
  bluetooth, gps, wifi,
  screenLock, vibration, volumeKey,
  fingerPrint, proximity, frontCamera, backCamera, flashlight,
  battery, charging,
  speaker, microphone, earReceiver,
  singleTouch, multiTouch,
}

class DiagnoseItem {
  final String category;
  final String label;
  final IconData icon;
  final TestType type;
  TestStatus status;
  String? note;

  DiagnoseItem({
    required this.category,
    required this.label,
    required this.icon,
    required this.type,
    this.status = TestStatus.idle,
    this.note,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// Main Screen
// ─────────────────────────────────────────────────────────────────────────────

class GoFixDiagnoseScreen extends StatefulWidget {
  const GoFixDiagnoseScreen({super.key});

  @override
  State<GoFixDiagnoseScreen> createState() => _GoFixDiagnoseScreenState();
}

class _GoFixDiagnoseScreenState extends State<GoFixDiagnoseScreen> {
  bool _checkingAll = false;
  int? _activeIndex;
  String deviceName = "Loading...";
  String storage = "Loading...";
  String ram = "Loading...";
  String deviceBrand = "Loading...";
  String deviceModel = "";
  String imageUrl = "";

  @override
  void initState() {
    super.initState();
    loadDevice();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DiagnoseResultProvider>().registerRetestCallback(_retestItem);
      _restorePreviousResults();

      // Refresh UI
      setState(() {});
    });
  }

  late DiagnoseResultProvider diagnoseProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    diagnoseProvider = context.read<DiagnoseResultProvider>();
  }

  @override
  void dispose() {
    diagnoseProvider.unregisterRetestCallback();
    super.dispose();
  }

  void _restorePreviousResults() {
    final savedResult = context.read<DiagnoseResultProvider>().result;

    if (savedResult == null) return;

    for (final savedItem in savedResult.items) {
      final index =
      _items.indexWhere((e) => e.label == savedItem.label);

      if (index != -1) {
        _items[index].status = savedItem.status;
        _items[index].note = savedItem.note;
      }
    }
  }
  void loadDevice() async {
    final details = await getDeviceDetails();
    final storageData = await getStorage();
    final ramData = await DeviceHelper.getRam();

    print("===== DEVICE DETAILS =====");
    print("Brand       : ${details['brand']}");
    print("Model       : ${details['model']}");
    print("Image URL   : ${details['imageUrl']}");
    print("Storage     : $storageData");
    print("RAM         : $ramData");

    setState(() {
      deviceBrand = details['brand'] ?? "";
      deviceModel = details['model'] ?? "";
      imageUrl = details['imageUrl'] ?? "";
      storage = storageData;
      ram = ramData;
    });
  }

  final Battery _battery = Battery();
  final LocalAuthentication _localAuth = LocalAuthentication();

  final List<DiagnoseItem> _items = [
    DiagnoseItem(category: 'Network',    label: 'Bluetooth',       icon: Icons.bluetooth,          type: TestType.bluetooth),
    DiagnoseItem(category: 'Network',    label: 'GPS',             icon: Icons.gps_fixed,          type: TestType.gps),
    DiagnoseItem(category: 'Network',    label: 'Wifi',            icon: Icons.wifi,               type: TestType.wifi),
    DiagnoseItem(category: 'Device',     label: 'Screen Lock Key', icon: Icons.lock_outline,       type: TestType.screenLock),
    DiagnoseItem(category: 'Device',     label: 'Vibration',       icon: Icons.vibration,          type: TestType.vibration),
    DiagnoseItem(category: 'Device',     label: 'Volume Key',      icon: Icons.volume_up_outlined, type: TestType.volumeKey),
    DiagnoseItem(category: 'Sensor',     label: 'Finger Print',    icon: Icons.fingerprint,        type: TestType.fingerPrint),
    DiagnoseItem(category: 'Sensor',     label: 'Proximity',       icon: Icons.sensors,            type: TestType.proximity),
    DiagnoseItem(category: 'Sensor',     label: 'Front Camera',    icon: Icons.camera_front,       type: TestType.frontCamera),
    DiagnoseItem(category: 'Sensor',     label: 'Flashlight',      icon: Icons.flashlight_on,      type: TestType.flashlight),
    DiagnoseItem(category: 'Sensor',     label: 'Back Camera',     icon: Icons.camera_rear,        type: TestType.backCamera),

    DiagnoseItem(category: 'Battery',    label: 'Battery',         icon: Icons.battery_full,       type: TestType.battery),
    DiagnoseItem(category: 'Battery',    label: 'Charging',        icon: Icons.power,              type: TestType.charging),
    DiagnoseItem(category: 'Multimedia', label: 'Speaker',         icon: Icons.volume_up,          type: TestType.speaker),
    DiagnoseItem(category: 'Multimedia', label: 'Micro Phone',     icon: Icons.mic,                type: TestType.microphone),
    DiagnoseItem(category: 'Multimedia', label: 'Ear Receiver',    icon: Icons.hearing,            type: TestType.earReceiver),
    DiagnoseItem(category: 'Touch',      label: 'Single Touch',    icon: Icons.touch_app,          type: TestType.singleTouch),
    DiagnoseItem(category: 'Touch',      label: 'Multi Touch',     icon: Icons.layers,             type: TestType.multiTouch),
  ];

  Map<String, List<DiagnoseItem>> get _grouped {
    final m = <String, List<DiagnoseItem>>{};
    for (final i in _items) {
      m.putIfAbsent(i.category, () => []).add(i);
    }
    return m;
  }

  // ── Save current state to provider ───────────────────────────────────────
  void _saveToProvider() {
    context.read<DiagnoseResultProvider>().saveResult(
      deviceName: deviceModel,
      deviceSpec: '$ram • $storage',
      imageUrl: imageUrl,
      items: _items,
    );
  }

  // ── Run All ───────────────────────────────────────────────────────────────
  Future<void> _retestItem(String label) async {
    final index = _items.indexWhere((e) => e.label == label);
    if (index == -1) return;

    Navigator.of(context).pop();

    await _startSingle(index);
    if (!mounted) return;

    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const DiagnoseResultPage()),
    );
  }

  Future<void> _checkAll() async {
    if (_checkingAll) return;
    setState(() => _checkingAll = true);

    for (int i = 0; i < _items.length; i++) {
      if (!mounted) return;
      await _runTest(i);
      // ✅ Save to provider after EVERY individual test during Run All
      _saveToProvider();
    }

    if (!mounted) return;
    setState(() {
      _checkingAll = false;
      _activeIndex = null;
    });

    _printTerminal();

    // Final save before navigating
    _saveToProvider();

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const DiagnoseResultPage()),
    );
  }

  // ── Single Test — runs one test and saves to provider immediately ─────────
  Future<void> _startSingle(int index) async {
    if (_checkingAll || _items[index].status == TestStatus.testing) return;

    // Run the test
    await _runTest(index);

    if (!mounted) return;

    _printTerminal();

    // ✅ Save updated result to provider immediately after single test
    _saveToProvider();
  }

  // ── Route test ────────────────────────────────────────────────────────────
  static const _manualPageTypes = {
    TestType.screenLock, TestType.volumeKey,
    TestType.fingerPrint, TestType.proximity,
    TestType.frontCamera, TestType.backCamera,
    TestType.microphone, TestType.earReceiver,
    TestType.singleTouch, TestType.multiTouch,
  };

  Future<void> _runTest(int index) async {
    final item = _items[index];
    setState(() {
      _activeIndex = index;
      item.status = TestStatus.testing;
      item.note = 'Checking…';
    });

    if (_manualPageTypes.contains(item.type)) {
      final passed = await _openPage(item.type);
      if (!mounted) return;
      setState(() {
        item.status = passed ? TestStatus.passed : TestStatus.failed;
        item.note   = passed ? 'Passed' : 'Failed / Skipped';
        _activeIndex = null;
      });
    } else {
      await _autoTest(item);
      if (!mounted) return;
      setState(() => _activeIndex = null);
    }
  }

  // ── Auto tests ────────────────────────────────────────────────────────────
  Future<bool> _waitForCharger({Duration timeout = const Duration(seconds: 20)}) async {
    final completer = Completer<bool>();
    late StreamSubscription<BatteryState> sub;

    sub = _battery.onBatteryStateChanged.listen((state) {
      if (state == BatteryState.charging) {
        if (!completer.isCompleted) completer.complete(true);
      }
    }, onError: (e) {
      if (!completer.isCompleted) completer.complete(false);
    });

    final userCanceled = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Charging Test'),
        content: const Text(
            'Please plug the charger into the device. The app will detect charging automatically.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('OK'),
          ),
        ],
      ),
    );

    if (userCanceled == true) {
      await sub.cancel();
      return false;
    }

    final result = await Future.any([
      completer.future,
      Future.delayed(timeout, () => false),
    ]);

    await sub.cancel();
    return result;
  }

  Future<void> _autoTest(DiagnoseItem item) async {
    TestStatus status = TestStatus.passed;
    String note = 'OK';
    try {
      switch (item.type) {
        case TestType.battery:
          final level = await _battery.batteryLevel;
          note = 'Level: $level%';
          break;

        case TestType.charging:
          final ok = await _waitForCharger(timeout: const Duration(seconds: 20));
          note = ok ? 'Charger detected (charging)' : 'Charger not detected / timeout';
          status = ok ? TestStatus.passed : TestStatus.failed;
          break;

        case TestType.wifi:
          final r = await Connectivity().checkConnectivity();
          if (r.contains(ConnectivityResult.wifi)) {
            note = 'Connected to WiFi';
          } else {
            note = 'WiFi not active';
            status = TestStatus.failed;
          }
          break;

        case TestType.bluetooth:
          note = await FlutterBluePlus.isSupported ? 'BT Supported' : 'Not Supported';
          if (!await FlutterBluePlus.isSupported) status = TestStatus.failed;
          break;

        case TestType.gps:
          var perm = await Geolocator.checkPermission();
          if (perm == LocationPermission.denied) {
            perm = await Geolocator.requestPermission();
          }
          if (perm == LocationPermission.always ||
              perm == LocationPermission.whileInUse) {
            final pos = await Geolocator.getCurrentPosition();
            note =
            'Lat: ${pos.latitude.toStringAsFixed(2)}, Lon: ${pos.longitude.toStringAsFixed(2)}';
          } else {
            note = 'GPS Permission Denied';
            status = TestStatus.failed;
          }
          break;

        case TestType.vibration:
          if (await Vibration.hasVibrator() ?? false) {
            await Vibration.vibrate(duration: 600);
            note = 'Vibrated';
          } else {
            note = 'No vibrator';
            status = TestStatus.failed;
          }
          break;

        case TestType.flashlight:
          await TorchLight.enableTorch();
          await Future.delayed(const Duration(milliseconds: 800));
          await TorchLight.disableTorch();
          note = 'Flashlight toggled';
          break;

        case TestType.speaker:
          final player = AudioPlayer();
          await player.play(AssetSource('sound/beep.mp3'));
          await Future.delayed(const Duration(seconds: 2));
          await player.dispose();
          note = 'Beep played';
          break;

        default:
          note = 'Skipped';
      }
    } catch (e) {
      status = TestStatus.failed;
      note = 'Error: $e';
    }
    if (!mounted) return;
    setState(() {
      item.status = status;
      item.note = note;
    });
  }

  // ── Open manual page ──────────────────────────────────────────────────────
  Future<bool> _openPage(TestType type) async {
    Widget page;
    switch (type) {
      case TestType.screenLock:  page = const ScreenLockTestScreen();            break;
      case TestType.volumeKey:   page = const VolumeKeyTestScreen();             break;
      case TestType.fingerPrint: page = FingerprintTestScreen(auth: _localAuth); break;
      case TestType.proximity:   page = const ProximityTestScreen();             break;
      case TestType.frontCamera: page = const CameraTestScreen(useFront: true);  break;
      case TestType.backCamera:  page = const CameraTestScreen(useFront: false); break;
      case TestType.microphone:
        page = const MicTestScreen(
          title: 'Microphone Test',
          icon: Icons.mic,
          instruction:
          'Speak clearly into the microphone.\nDoes your voice come through the speaker?\nTap Pass or Fail.',
        );
        break;
      case TestType.earReceiver: page = const EarReceiverTestScreen();           break;
      case TestType.singleTouch: page = const SingleTouchTestScreen();           break;
      case TestType.multiTouch:  page = const MultiTouchTestScreen();            break;
      default: return false;
    }
    final result = await Navigator.of(context)
        .push<bool>(MaterialPageRoute(builder: (_) => page));
    return result ?? false;
  }

  // ── Terminal output ───────────────────────────────────────────────────────
  void _printTerminal() {
    final passed  = _items.where((e) => e.status == TestStatus.passed).length;
    final failed  = _items.where((e) => e.status == TestStatus.failed).length;
    final skipped = _items.where((e) => e.status == TestStatus.idle).length;

    const sep = '════════════════════════════════════════════════';
    debugPrint(sep);
    debugPrint('           GOFIX DIAGNOSE  RESULTS             ');
    debugPrint(sep);
    for (final item in _items) {
      final ic = item.status == TestStatus.passed
          ? '✅'
          : item.status == TestStatus.failed
          ? '❌'
          : '⏭️ ';
      final line =
          '$ic  [${item.category.padRight(10)}]  ${item.label.padRight(18)} →  ${item.status.name.toUpperCase()}${item.note != null ? "  (${item.note})" : ""}';
      debugPrint(line);
      dev.log(line, name: 'GoFix');
    }
    debugPrint('────────────────────────────────────────────────');
    debugPrint(
        'TOTAL ${_items.length} | ✅ $passed Passed | ❌ $failed Failed | ⏭️  $skipped Skipped');
    debugPrint(sep);
  }

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFF111111),
    appBar: AppBar(
      backgroundColor: const Color(0xFF111111),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      elevation: 0,
      title: const Text('Diagnose',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: TextButton.icon(
            onPressed: _checkingAll ? null : _checkAll,
            icon: _checkingAll
                ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: Colors.white),
            )
                : const Icon(Icons.play_arrow_rounded,
                color: Color(0xFFFF007F)),
            label: Text(
              _checkingAll ? 'Checking…' : 'Run All',
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    ),
    body: ListView(
      padding: const EdgeInsets.all(16),
      children: [
        for (final entry in _grouped.entries) ...[
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 8, left: 4),
            child: Text(
              entry.key.toUpperCase(),
              style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.white38,
                  letterSpacing: 1.4),
            ),
          ),
          for (final item in entry.value)
            _buildCard(_items.indexOf(item), item),
        ],
        const SizedBox(height: 40),
      ],
    ),
  );

  Widget _buildCard(int index, DiagnoseItem item) {
    final bool isActive = _activeIndex == index;
    final Color sc = _statusColor(item.status);
    return GestureDetector(
      onTap: () => _startSingle(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: isActive
                  ? const Color(0xFFFF007F).withOpacity(0.6)
                  : Colors.white10),
        ),
        child: Row(children: [
          Container(
            width: 56,
            height: 60,
            decoration: BoxDecoration(
              color: isActive
                  ? const Color(0xFFFF007F).withOpacity(0.1)
                  : Colors.white.withOpacity(0.03),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  bottomLeft: Radius.circular(14)),
            ),
            child: Icon(item.icon,
                color:
                isActive ? const Color(0xFFFF007F) : Colors.white60,
                size: 22),
          ),
          Expanded(
            child: Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.label,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14)),
                  if (item.note != null) ...[
                    const SizedBox(height: 3),
                    Text(item.note!,
                        style: const TextStyle(
                            color: Colors.white38, fontSize: 11)),
                  ],
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: isActive
                ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: Color(0xFFFF007F)),
            )
                : Icon(_statusIcon(item.status), color: sc, size: 20),
          ),
        ]),
      ),
    );
  }

  Color _statusColor(TestStatus s) {
    switch (s) {
      case TestStatus.passed:  return const Color(0xFF00E676);
      case TestStatus.failed:  return const Color(0xFFFF5252);
      case TestStatus.testing: return const Color(0xFFFFD600);
      case TestStatus.idle:    return Colors.white24;
    }
  }

  IconData _statusIcon(TestStatus s) {
    switch (s) {
      case TestStatus.passed:  return Icons.check_circle_rounded;
      case TestStatus.failed:  return Icons.cancel_rounded;
      case TestStatus.testing: return Icons.hourglass_empty_rounded;
      case TestStatus.idle:    return Icons.arrow_forward_ios_rounded;
    }
  }
}

class _Badge extends StatelessWidget {
  final String label, value;
  final Color color;
  const _Badge({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) => Column(children: [
    Text(value,
        style: TextStyle(
            color: color, fontSize: 28, fontWeight: FontWeight.bold)),
    Text(label,
        style: const TextStyle(color: Colors.white54, fontSize: 12)),
  ]);
}