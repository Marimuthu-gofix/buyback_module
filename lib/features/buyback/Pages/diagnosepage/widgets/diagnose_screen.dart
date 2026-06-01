import 'package:flutter/material.dart';
import '../services/connectivity_service.dart';

class DiagnoseScreen extends StatefulWidget {
  @override
  _DiagnoseScreenState createState() => _DiagnoseScreenState();
}

class _DiagnoseScreenState extends State<DiagnoseScreen> {
  final ConnectivityService _connectivityService = ConnectivityService();

  Map<String, bool> _status = {
    'network': false,
    'wifi': false,
    'gps': false,
    'bluetooth': false,
  };

  @override
  void initState() {
    super.initState();
    _checkAllServices();  // Call service on screen load
  }

  Future<void> _checkAllServices() async {
    final results = await _connectivityService.checkAllServices();
    setState(() {
      _status = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GoFix Diagnose'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Network',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 16),
            _buildServiceCard('Bluetooth', _status['bluetooth'] ?? false),
            _buildServiceCard('GPS', _status['gps'] ?? false),
            _buildServiceCard('WiFi', _status['wifi'] ?? false),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _checkAllServices,
                child: Text('Refresh'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(String title, bool isEnabled) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFF2E2E2E)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Color(0xFF2E2E2E),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.check_circle,
              color: Colors.white,
              size: 20,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isEnabled ? Colors.green : Colors.red,
            ),
            child: Center(
              child: Icon(
                isEnabled ? Icons.check : Icons.close,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
// import 'dart:async';
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:battery_plus/battery_plus.dart';
// import 'package:local_auth/local_auth.dart';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:vibration/vibration.dart';
//
// class DiagnoseScreen extends StatefulWidget {
//   const DiagnoseScreen({super.key});
//
//   @override
//   State<DiagnoseScreen> createState() => _DiagnoseScreenState();
// }
//
// class _DiagnoseScreenState extends State<DiagnoseScreen> {
//   final player = AudioPlayer();
//   final battery = Battery();
//   final auth = LocalAuthentication();
//
//   int currentIndex = 0;
//   bool isRunning = false;
//
//   // ================= CATEGORY FLOW =================
//
//   final List<Map<String, dynamic>> tests = [
//     {"cat": "Network", "name": "Bluetooth", "type": "auto"},
//     {"cat": "Network", "name": "GPS", "type": "auto"},
//     {"cat": "Network", "name": "WiFi", "type": "auto"},
//
//     {"cat": "Device", "name": "Vibration", "type": "manual"},
//     {"cat": "Device", "name": "Volume Key", "type": "manual"},
//
//     {"cat": "Sensor", "name": "Fingerprint", "type": "manual"},
//
//     {"cat": "Camera", "name": "Front Camera", "type": "manual"},
//     {"cat": "Camera", "name": "Back Camera", "type": "manual"},
//     {"cat": "Camera", "name": "Flash", "type": "manual"},
//
//     {"cat": "Battery", "name": "Charging", "type": "manual"},
//
//     {"cat": "Media", "name": "Speaker", "type": "manual"},
//     {"cat": "Media", "name": "Microphone", "type": "manual"},
//
//     {"cat": "Touch", "name": "Touch Test", "type": "manual"},
//   ];
//
//   List<String> results = [];
//
//   @override
//   void initState() {
//     super.initState();
//     startFlow();
//   }
//
//   void startFlow() async {
//     if (isRunning) return;
//     isRunning = true;
//     await runTest();
//   }
//
//   Future<void> runTest() async {
//     if (currentIndex >= tests.length) {
//       print("✅ ALL TESTS COMPLETED");
//       print(results);
//       return;
//     }
//
//     final test = tests[currentIndex];
//
//     print("👉 Running: ${test["name"]}");
//
//     if (test["type"] == "auto") {
//       bool res = await runAuto(test["name"]);
//       updateResult(res);
//     } else {
//       runManual(test["name"]);
//     }
//   }
//
//   // ================= AUTO =================
//
//   Future<bool> runAuto(String name) async {
//     switch (name) {
//       case "Bluetooth":
//         return await FlutterBluePlus.isOn;
//
//       case "GPS":
//         return await Geolocator.isLocationServiceEnabled();
//
//       case "WiFi":
//         var conn = await Connectivity().checkConnectivity();
//         return conn == ConnectivityResult.wifi;
//
//       default:
//         return false;
//     }
//   }
//
//   // ================= SAFE RESULT =================
//
//   void updateResult(bool pass) {
//     if (currentIndex >= tests.length) return;
//
//     results.add(pass ? "pass" : "fail");
//
//     print("✔ ${tests[currentIndex]["name"]} = ${pass ? "PASS" : "FAIL"}");
//
//     setState(() {
//       currentIndex++;
//     });
//
//     Future.delayed(const Duration(milliseconds: 300), runTest);
//   }
//
//   // ================= MANUAL =================
//
//   void runManual(String name) {
//     switch (name) {
//       case "Vibration":
//         testVibration();
//         break;
//
//       case "Speaker":
//         testSpeaker();
//         break;
//
//       case "Fingerprint":
//         testFingerprint();
//         break;
//
//       case "Charging":
//         testCharging();
//         break;
//
//       case "Touch Test":
//         testTouch();
//         break;
//
//       default:
//         updateResult(true);
//     }
//   }
//
//   // ================= TESTS =================
//
//   void testVibration() async {
//     await Vibration.vibrate(duration: 500);
//
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text("Vibration"),
//         content: const Text("Did it vibrate?"),
//         actions: [
//           TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//                 updateResult(false);
//               },
//               child: const Text("No")),
//           ElevatedButton(
//               onPressed: () {
//                 Navigator.pop(context);
//                 updateResult(true);
//               },
//               child: const Text("Yes")),
//         ],
//       ),
//     );
//   }
//
//   void testSpeaker() async {
//     await player.play(AssetSource('sound/beep.mp3'));
//
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text("Speaker"),
//         content: const Text("Did you hear sound?"),
//         actions: [
//           TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//                 updateResult(false);
//               },
//               child: const Text("No")),
//           ElevatedButton(
//               onPressed: () {
//                 Navigator.pop(context);
//                 updateResult(true);
//               },
//               child: const Text("Yes")),
//         ],
//       ),
//     );
//   }
//
//   void testFingerprint() async {
//     try {
//       bool ok = await auth.authenticate(
//         localizedReason: "Scan Fingerprint",
//       );
//       updateResult(ok);
//     } catch (_) {
//       updateResult(false);
//     }
//   }
//
//   void testCharging() {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Plug charger now")),
//     );
//
//     battery.onBatteryStateChanged.listen((state) {
//       if (state == BatteryState.charging) {
//         updateResult(true);
//       }
//     });
//   }
//
//   void testTouch() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => TouchTestScreen(
//           onDone: (r) {
//             Navigator.pop(context);
//             updateResult(r);
//           },
//         ),
//       ),
//     );
//   }
//
//   // ================= UI =================
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         title: const Text("Diagnose"),
//         backgroundColor: Colors.black,
//       ),
//       body: ListView.builder(
//         padding: const EdgeInsets.all(16),
//         itemCount: tests.length,
//         itemBuilder: (_, i) {
//           return Container(
//             margin: const EdgeInsets.symmetric(vertical: 6),
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: i == currentIndex
//                   ? Colors.green.withOpacity(0.3)
//                   : Colors.grey[900],
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Text(
//               tests[i]["name"],
//               style: const TextStyle(color: Colors.white),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
//
// class TouchTestScreen extends StatefulWidget {
//   final Function(bool) onDone;
//   const TouchTestScreen({super.key, required this.onDone});
//
//   @override
//   State<TouchTestScreen> createState() => _TouchTestScreenState();
// }
//
// class _TouchTestScreenState extends State<TouchTestScreen> {
//   final int grid = 6;
//   late List<bool> touched;
//
//   @override
//   void initState() {
//     super.initState();
//     touched = List.generate(grid * grid, (_) => false);
//   }
//
//   void mark(int index) {
//     if (!touched[index]) {
//       setState(() => touched[index] = true);
//
//       if (touched.every((e) => e)) {
//         Future.delayed(const Duration(milliseconds: 300), () {
//           widget.onDone(true);
//         });
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: LayoutBuilder(
//         builder: (context, constraints) {
//           double cellW = constraints.maxWidth / grid;
//           double cellH = constraints.maxHeight / grid;
//
//           return GestureDetector(
//             onPanDown: (d) => handle(d.localPosition, cellW, cellH),
//             onPanUpdate: (d) => handle(d.localPosition, cellW, cellH),
//
//             child: GridView.builder(
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: touched.length,
//               gridDelegate:
//               SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: grid,
//               ),
//               itemBuilder: (_, i) => Container(
//                 margin: const EdgeInsets.all(2),
//                 decoration: BoxDecoration(
//                   color: touched[i] ? Colors.green : Colors.red,
//                   borderRadius: BorderRadius.circular(6),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   void handle(Offset pos, double w, double h) {
//     int x = (pos.dx ~/ w);
//     int y = (pos.dy ~/ h);
//     int index = y * grid + x;
//
//     if (index >= 0 && index < touched.length) {
//       mark(index);
//     }
//   }
// }

// import 'dart:async';
// import 'dart:developer' as dev;
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:battery_plus/battery_plus.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
// import 'package:local_auth/local_auth.dart';
// import 'package:vibration/vibration.dart';
// import 'package:torch_light/torch_light.dart';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:camera/camera.dart';
// import 'package:proximity_sensor/proximity_sensor.dart';
// import 'package:volume_controller/volume_controller.dart';
//
// // ─────────────────────────────────────────────────────────────────────────────
// // Enums & Model
// // ─────────────────────────────────────────────────────────────────────────────
//
// enum TestStatus { idle, testing, passed, failed }
//
// enum TestType {
//   bluetooth, gps, wifi,
//   screenLock, vibration, volumeKey,
//   fingerPrint, proximity, frontCamera, backCamera, flashlight,
//   battery, charging,
//   speaker, microphone, earReceiver,
//   singleTouch, multiTouch,
// }
//
// class DiagnoseItem {
//   final String category;
//   final String label;
//   final IconData icon;
//   final TestType type;
//   TestStatus status;
//   String? note;
//
//   DiagnoseItem({
//     required this.category,
//     required this.label,
//     required this.icon,
//     required this.type,
//     this.status = TestStatus.idle,
//     this.note,
//   });
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// // Main Screen
// // ─────────────────────────────────────────────────────────────────────────────
//
// class GoFixDiagnoseScreen extends StatefulWidget {
//   const GoFixDiagnoseScreen({super.key});
//
//   @override
//   State<GoFixDiagnoseScreen> createState() => _GoFixDiagnoseScreenState();
// }
//
// class _GoFixDiagnoseScreenState extends State<GoFixDiagnoseScreen> {
//   bool _checkingAll = false;
//   int? _activeIndex;
//
//   final Battery _battery = Battery();
//   final LocalAuthentication _localAuth = LocalAuthentication();
//
//   final List<DiagnoseItem> _items = [
//     DiagnoseItem(category: 'Network',    label: 'Bluetooth',       icon: Icons.bluetooth,          type: TestType.bluetooth),
//     DiagnoseItem(category: 'Network',    label: 'GPS',             icon: Icons.gps_fixed,          type: TestType.gps),
//     DiagnoseItem(category: 'Network',    label: 'Wifi',            icon: Icons.wifi,               type: TestType.wifi),
//     DiagnoseItem(category: 'Device',     label: 'Screen Lock Key', icon: Icons.lock_outline,       type: TestType.screenLock),
//     DiagnoseItem(category: 'Device',     label: 'Vibration',       icon: Icons.vibration,          type: TestType.vibration),
//     DiagnoseItem(category: 'Device',     label: 'Volume Key',      icon: Icons.volume_up_outlined, type: TestType.volumeKey),
//     DiagnoseItem(category: 'Sensor',     label: 'Finger Print',    icon: Icons.fingerprint,        type: TestType.fingerPrint),
//     DiagnoseItem(category: 'Sensor',     label: 'Proximity',       icon: Icons.sensors,            type: TestType.proximity),
//     DiagnoseItem(category: 'Sensor',     label: 'Front Camera',    icon: Icons.camera_front,       type: TestType.frontCamera),
//     DiagnoseItem(category: 'Sensor',     label: 'Back Camera',     icon: Icons.camera_rear,        type: TestType.backCamera),
//     DiagnoseItem(category: 'Sensor',     label: 'Flashlight',      icon: Icons.flashlight_on,      type: TestType.flashlight),
//     DiagnoseItem(category: 'Battery',    label: 'Battery',         icon: Icons.battery_full,       type: TestType.battery),
//     DiagnoseItem(category: 'Battery',    label: 'Charging',        icon: Icons.power,              type: TestType.charging),
//     DiagnoseItem(category: 'Multimedia', label: 'Speaker',         icon: Icons.volume_up,          type: TestType.speaker),
//     DiagnoseItem(category: 'Multimedia', label: 'Micro Phone',     icon: Icons.mic,                type: TestType.microphone),
//     DiagnoseItem(category: 'Multimedia', label: 'Ear Receiver',    icon: Icons.hearing,            type: TestType.earReceiver),
//     DiagnoseItem(category: 'Touch',      label: 'Single Touch',    icon: Icons.touch_app,          type: TestType.singleTouch),
//     DiagnoseItem(category: 'Touch',      label: 'Multi Touch',     icon: Icons.layers,             type: TestType.multiTouch),
//   ];
//
//   Map<String, List<DiagnoseItem>> get _grouped {
//     final m = <String, List<DiagnoseItem>>{};
//     for (final i in _items) {
//       m.putIfAbsent(i.category, () => []).add(i);
//     }
//     return m;
//   }
//
//   // ── Run All ───────────────────────────────────────────────────────────────
//
//   Future<void> _checkAll() async {
//     if (_checkingAll) return;
//     setState(() => _checkingAll = true);
//     for (int i = 0; i < _items.length; i++) {
//       if (!mounted) return;
//       await _runTest(i);
//     }
//     if (!mounted) return;
//     setState(() { _checkingAll = false; _activeIndex = null; });
//     _printTerminal();
//     _showResultSheet();
//   }
//
//   Future<void> _startSingle(int index) async {
//     if (_checkingAll || _items[index].status == TestStatus.testing) return;
//     await _runTest(index);
//     _printTerminal();
//   }
//
//   // ── Route test ────────────────────────────────────────────────────────────
//
//   /// Tests that require a dedicated full-screen interaction
//   static const _manualPageTypes = {
//     TestType.screenLock, TestType.volumeKey,
//     TestType.fingerPrint, TestType.proximity,
//     TestType.frontCamera, TestType.backCamera,
//     TestType.microphone, TestType.earReceiver,
//     TestType.singleTouch, TestType.multiTouch,
//   };
//
//   Future<void> _runTest(int index) async {
//     final item = _items[index];
//     setState(() { _activeIndex = index; item.status = TestStatus.testing; item.note = 'Checking…'; });
//
//     if (_manualPageTypes.contains(item.type)) {
//       final passed = await _openPage(item.type);
//       if (!mounted) return;
//       setState(() {
//         item.status = passed ? TestStatus.passed : TestStatus.failed;
//         item.note   = passed ? 'Passed' : 'Failed / Skipped';
//         _activeIndex = null;
//       });
//     } else {
//       await _autoTest(item);
//       if (!mounted) return;
//       setState(() => _activeIndex = null);
//     }
//   }
//
//   // ── Auto tests ────────────────────────────────────────────────────────────
//
//   Future<void> _autoTest(DiagnoseItem item) async {
//     TestStatus status = TestStatus.passed;
//     String note = 'OK';
//     try {
//       switch (item.type) {
//
//         case TestType.battery:
//           final level = await _battery.batteryLevel;
//           note = 'Level: $level%';
//           break;
//
//         case TestType.charging:
//           final state = await _battery.batteryState;
//           note = 'State: ${state.name}';
//           if (state == BatteryState.unknown) status = TestStatus.failed;
//           break;
//
//         case TestType.wifi:
//           final r = await Connectivity().checkConnectivity();
//           if (r.contains(ConnectivityResult.wifi)) {
//             note = 'Connected to WiFi';
//           } else {
//             note = 'WiFi not active';
//             status = TestStatus.failed;
//           }
//           break;
//
//         case TestType.bluetooth:
//           note = await FlutterBluePlus.isSupported ? 'BT Supported' : 'Not Supported';
//           if (!await FlutterBluePlus.isSupported) status = TestStatus.failed;
//           break;
//
//         case TestType.gps:
//           var perm = await Geolocator.checkPermission();
//           if (perm == LocationPermission.denied) perm = await Geolocator.requestPermission();
//           if (perm == LocationPermission.always || perm == LocationPermission.whileInUse) {
//             final pos = await Geolocator.getCurrentPosition();
//             note = 'Lat: ${pos.latitude.toStringAsFixed(2)}, Lon: ${pos.longitude.toStringAsFixed(2)}';
//           } else {
//             note = 'GPS Permission Denied';
//             status = TestStatus.failed;
//           }
//           break;
//
//         case TestType.vibration:
//           if (await Vibration.hasVibrator() ?? false) {
//             await Vibration.vibrate(duration: 600);
//             note = 'Vibrated';
//           } else {
//             note = 'No vibrator';
//             status = TestStatus.failed;
//           }
//           break;
//
//         case TestType.flashlight:
//           await TorchLight.enableTorch();
//           await Future.delayed(const Duration(milliseconds: 800));
//           await TorchLight.disableTorch();
//           note = 'Flashlight toggled';
//           break;
//
//       // Speaker: play assets/sound/beep.mp3
//         case TestType.speaker:
//           final player = AudioPlayer();
//           await player.play(AssetSource('sound/beep.mp3'));
//           await Future.delayed(const Duration(seconds: 2));
//           await player.dispose();
//           note = 'Beep played';
//           break;
//
//         default:
//           note = 'Skipped';
//       }
//     } catch (e) {
//       status = TestStatus.failed;
//       note = 'Error: $e';
//     }
//     if (!mounted) return;
//     setState(() { item.status = status; item.note = note; });
//   }
//
//   // ── Open manual page and return pass/fail ─────────────────────────────────
//
//   Future<bool> _openPage(TestType type) async {
//     Widget page;
//     switch (type) {
//       case TestType.screenLock:  page = const ScreenLockTestScreen();              break;
//       case TestType.volumeKey:   page = const VolumeKeyTestScreen();               break;
//       case TestType.fingerPrint: page = FingerprintTestScreen(auth: _localAuth);   break;
//       case TestType.proximity:   page = const ProximityTestScreen();               break;
//       case TestType.frontCamera: page = const CameraTestScreen(useFront: true);    break;
//       case TestType.backCamera:  page = const CameraTestScreen(useFront: false);   break;
//       case TestType.microphone:  page = const ManualTestScreen(
//           title: 'Microphone Test', icon: Icons.mic,
//           instruction: 'Speak clearly into the microphone.\nDoes your voice come through the speaker?\nTap Pass or Fail.');
//       break;
//       case TestType.earReceiver: page = const EarReceiverTestScreen();             break;
//       case TestType.singleTouch: page = const SingleTouchTestScreen();             break;
//       case TestType.multiTouch:  page = const MultiTouchTestScreen();              break;
//       default: return false;
//     }
//     final result = await Navigator.of(context).push<bool>(MaterialPageRoute(builder: (_) => page));
//     return result ?? false;
//   }
//
//   // ── Terminal output ───────────────────────────────────────────────────────
//
//   void _printTerminal() {
//     final passed  = _items.where((e) => e.status == TestStatus.passed).length;
//     final failed  = _items.where((e) => e.status == TestStatus.failed).length;
//     final skipped = _items.where((e) => e.status == TestStatus.idle).length;
//
//     const sep = '════════════════════════════════════════════════';
//     debugPrint(sep);
//     debugPrint('           GOFIX DIAGNOSE  RESULTS             ');
//     debugPrint(sep);
//     for (final item in _items) {
//       final ic = item.status == TestStatus.passed ? '✅'
//           : item.status == TestStatus.failed  ? '❌' : '⏭️ ';
//       final line = '$ic  [${item.category.padRight(10)}]  ${item.label.padRight(18)} →  ${item.status.name.toUpperCase()}${item.note != null ? "  (${item.note})" : ""}';
//       debugPrint(line);
//       dev.log(line, name: 'GoFix');
//     }
//     debugPrint('────────────────────────────────────────────────');
//     debugPrint('TOTAL ${_items.length} | ✅ $passed Passed | ❌ $failed Failed | ⏭️  $skipped Skipped');
//     debugPrint(sep);
//   }
//
//   // ── Result sheet ──────────────────────────────────────────────────────────
//
//   void _showResultSheet() {
//     final passed = _items.where((e) => e.status == TestStatus.passed).length;
//     final failed = _items.where((e) => e.status == TestStatus.failed).length;
//
//     showModalBottomSheet<void>(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: const Color(0xFF1A1A1A),
//       shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
//       builder: (_) => DraggableScrollableSheet(
//         expand: false,
//         initialChildSize: 0.6,
//         minChildSize: 0.4,
//         maxChildSize: 0.9,
//         builder: (_, ctrl) => Padding(
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             children: [
//               Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2))),
//               const SizedBox(height: 20),
//               const Text('Diagnosis Complete', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
//               const SizedBox(height: 16),
//               Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
//                 _Badge(label: 'Total',  value: '${_items.length}', color: Colors.white70),
//                 _Badge(label: 'Passed', value: '$passed',          color: const Color(0xFF00E676)),
//                 _Badge(label: 'Failed', value: '$failed',          color: const Color(0xFFFF5252)),
//               ]),
//               const SizedBox(height: 16),
//               Expanded(
//                 child: ListView(controller: ctrl, children: _items.map((item) {
//                   final color = item.status == TestStatus.passed ? const Color(0xFF00E676)
//                       : item.status == TestStatus.failed  ? const Color(0xFFFF5252) : Colors.white38;
//                   final icon  = item.status == TestStatus.passed ? Icons.check_circle_rounded
//                       : item.status == TestStatus.failed  ? Icons.cancel_rounded : Icons.radio_button_unchecked;
//                   return ListTile(
//                     dense: true,
//                     leading: Icon(item.icon, color: Colors.white54, size: 18),
//                     title: Text(item.label, style: const TextStyle(color: Colors.white, fontSize: 13)),
//                     subtitle: item.note != null ? Text(item.note!, style: const TextStyle(color: Colors.white38, fontSize: 11)) : null,
//                     trailing: Icon(icon, color: color, size: 18),
//                   );
//                 }).toList()),
//               ),
//               const SizedBox(height: 12),
//               SizedBox(
//                 width: double.infinity, height: 50,
//                 child: ElevatedButton(
//                   onPressed: () => Navigator.pop(context),
//                   style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF007F), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
//                   child: const Text('Close Report', style: TextStyle(fontWeight: FontWeight.bold)),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   // ── Build ─────────────────────────────────────────────────────────────────
//
//   @override
//   Widget build(BuildContext context) => Scaffold(
//     backgroundColor: const Color(0xFF111111),
//     appBar: AppBar(
//       backgroundColor: const Color(0xFF111111),
//       elevation: 0,
//       title: const Text('GoFix Diagnose', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
//       actions: [
//         Padding(
//           padding: const EdgeInsets.only(right: 8),
//           child: TextButton.icon(
//             onPressed: _checkingAll ? null : _checkAll,
//             icon: _checkingAll
//                 ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
//                 : const Icon(Icons.play_arrow_rounded, color: Color(0xFFFF007F)),
//             label: Text(_checkingAll ? 'Checking…' : 'Run All',
//                 style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
//           ),
//         ),
//       ],
//     ),
//     body: ListView(
//       padding: const EdgeInsets.all(16),
//       children: [
//         for (final entry in _grouped.entries) ...[
//           Padding(
//             padding: const EdgeInsets.only(top: 16, bottom: 8, left: 4),
//             child: Text(entry.key.toUpperCase(),
//                 style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white38, letterSpacing: 1.4)),
//           ),
//           for (final item in entry.value) _buildCard(_items.indexOf(item), item),
//         ],
//         const SizedBox(height: 40),
//       ],
//     ),
//   );
//
//   Widget _buildCard(int index, DiagnoseItem item) {
//     final bool isActive = _activeIndex == index;
//     final Color sc = _statusColor(item.status);
//     return GestureDetector(
//       onTap: () => _startSingle(index),
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 250),
//         margin: const EdgeInsets.only(bottom: 10),
//         decoration: BoxDecoration(
//           color: const Color(0xFF1E1E1E),
//           borderRadius: BorderRadius.circular(14),
//           border: Border.all(color: isActive ? const Color(0xFFFF007F).withOpacity(0.6) : Colors.white10),
//         ),
//         child: Row(children: [
//           Container(
//             width: 56, height: 60,
//             decoration: BoxDecoration(
//               color: isActive ? const Color(0xFFFF007F).withOpacity(0.1) : Colors.white.withOpacity(0.03),
//               borderRadius: const BorderRadius.only(topLeft: Radius.circular(14), bottomLeft: Radius.circular(14)),
//             ),
//             child: Icon(item.icon, color: isActive ? const Color(0xFFFF007F) : Colors.white60, size: 22),
//           ),
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//               child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//                 Text(item.label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
//                 if (item.note != null) ...[
//                   const SizedBox(height: 3),
//                   Text(item.note!, style: const TextStyle(color: Colors.white38, fontSize: 11)),
//                 ],
//               ]),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(right: 14),
//             child: isActive
//                 ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFFF007F)))
//                 : Icon(_statusIcon(item.status), color: sc, size: 20),
//           ),
//         ]),
//       ),
//     );
//   }
//
//   Color _statusColor(TestStatus s) {
//     switch (s) {
//       case TestStatus.passed:  return const Color(0xFF00E676);
//       case TestStatus.failed:  return const Color(0xFFFF5252);
//       case TestStatus.testing: return const Color(0xFFFFD600);
//       case TestStatus.idle:    return Colors.white24;
//     }
//   }
//
//   IconData _statusIcon(TestStatus s) {
//     switch (s) {
//       case TestStatus.passed:  return Icons.check_circle_rounded;
//       case TestStatus.failed:  return Icons.cancel_rounded;
//       case TestStatus.testing: return Icons.hourglass_empty_rounded;
//       case TestStatus.idle:    return Icons.arrow_forward_ios_rounded;
//     }
//   }
// }
//
// class _Badge extends StatelessWidget {
//   final String label, value;
//   final Color color;
//   const _Badge({required this.label, required this.value, required this.color});
//   @override
//   Widget build(BuildContext context) => Column(children: [
//     Text(value, style: TextStyle(color: color, fontSize: 28, fontWeight: FontWeight.bold)),
//     Text(label,  style: const TextStyle(color: Colors.white54, fontSize: 12)),
//   ]);
// }
//
// // ═════════════════════════════════════════════════════════════════════════════
// // SCREEN LOCK KEY TEST
// // Detects power-button press via app lifecycle pause → resume cycle
// // ═════════════════════════════════════════════════════════════════════════════
//
// class ScreenLockTestScreen extends StatefulWidget {
//   const ScreenLockTestScreen({super.key});
//   @override State<ScreenLockTestScreen> createState() => _ScreenLockTestScreenState();
// }
//
// class _ScreenLockTestScreenState extends State<ScreenLockTestScreen> {
//   bool _detected = false;
//   int  _pauseCount = 0;
//   late final AppLifecycleListener _listener;
//
//   @override
//   void initState() {
//     super.initState();
//     _listener = AppLifecycleListener(
//       onPause: () => _pauseCount++,
//       onResume: () {
//         if (_pauseCount > 0 && mounted && !_detected) {
//           setState(() => _detected = true);
//           Future.delayed(const Duration(milliseconds: 800), () {
//             if (mounted) Navigator.pop(context, true);
//           });
//         }
//       },
//     );
//   }
//
//   @override void dispose() { _listener.dispose(); super.dispose(); }
//
//   @override
//   Widget build(BuildContext context) => _KeyTestScaffold(
//     title: 'Screen Lock Key',
//     icon: Icons.lock_outline,
//     instruction: 'Press the  Power / Lock  button\non the side of your device.\nThen press it again to wake the screen.',
//     detected: _detected,
//     onFail: () => Navigator.pop(context, false),
//   );
// }
//
// // ═════════════════════════════════════════════════════════════════════════════
// // VOLUME KEY TEST
// // Detects volume-up AND volume-down via HardwareKeyboard
// // ═════════════════════════════════════════════════════════════════════════════
//
// class VolumeKeyTestScreen extends StatefulWidget {
//   const VolumeKeyTestScreen({super.key});
//
//   @override
//   State<VolumeKeyTestScreen> createState() => _VolumeKeyTestScreenState();
// }
//
// class _VolumeKeyTestScreenState extends State<VolumeKeyTestScreen> {
//   bool _up = false;
//   bool _down = false;
//   double _lastVolume = 0;
//   bool _completed = false;
//
//   @override
//   void initState() {
//     super.initState();
//
//     // ✅ Force volume to mid level (VERY IMPORTANT)
//     VolumeController().setVolume(0.5);
//
//     VolumeController().getVolume().then((value) {
//       _lastVolume = value;
//     });
//
//     VolumeController().listener((volume) {
//       if (_completed) return;
//
//       // ✅ Ignore first callback noise
//       if (_lastVolume == 0) {
//         _lastVolume = volume;
//         return;
//       }
//
//       if (volume > _lastVolume) {
//         setState(() => _up = true);
//       } else if (volume < _lastVolume) {
//         setState(() => _down = true);
//       }
//
//       _lastVolume = volume;
//       _checkDone();
//     });
//   }
//
//   @override
//   void dispose() {
//     VolumeController().removeListener();
//     super.dispose();
//   }
//
//   void _checkDone() {
//     if (_up && _down && !_completed) {
//       _completed = true;
//
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         if (!mounted) return;
//         Navigator.pop(context, true);
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF0D0D0D),
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         title: const Text('Volume Button Test'),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 24),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(Icons.volume_up_rounded,
//                 size: 80, color: Color(0xFFFF007F)),
//
//             const SizedBox(height: 30),
//
//             const Text(
//               'Press Volume Buttons',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//
//             const SizedBox(height: 10),
//
//             const Text(
//               'Press Volume UP and Volume DOWN to complete the test',
//               textAlign: TextAlign.center,
//               style: TextStyle(color: Colors.white54),
//             ),
//
//             const SizedBox(height: 50),
//
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 _keyCard("Volume Up", Icons.add, _up),
//                 _keyCard("Volume Down", Icons.remove, _down),
//               ],
//             ),
//
//             const SizedBox(height: 60),
//
//             if (_up && _down)
//               const Text(
//                 "✔ Test Passed",
//                 style: TextStyle(
//                   color: Colors.greenAccent,
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//
//             const SizedBox(height: 40),
//
//             OutlinedButton(
//               onPressed: () => Navigator.pop(context, false),
//               style: OutlinedButton.styleFrom(
//                 foregroundColor: Colors.white54,
//                 side: const BorderSide(color: Colors.white24),
//                 padding:
//                 const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//               ),
//               child: const Text("Skip / Fail"),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _keyCard(String label, IconData icon, bool active) {
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 300),
//       padding: const EdgeInsets.all(20),
//       width: 130,
//       decoration: BoxDecoration(
//         color: active ? Colors.green.withOpacity(0.15) : Colors.white10,
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(
//           color: active ? Colors.greenAccent : Colors.white24,
//           width: 2,
//         ),
//       ),
//       child: Column(
//         children: [
//           Icon(icon,
//               size: 40,
//               color: active ? Colors.greenAccent : Colors.white54),
//           const SizedBox(height: 10),
//           Text(
//             label,
//             style: TextStyle(
//               color: active ? Colors.greenAccent : Colors.white70,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Icon(
//             active ? Icons.check_circle : Icons.radio_button_unchecked,
//             color: active ? Colors.greenAccent : Colors.white24,
//           )
//         ],
//       ),
//     );
//   }
// }
//
// class _KeyDot extends StatelessWidget {
//   final String label;
//   final bool detected;
//   const _KeyDot({required this.label, required this.detected});
//   @override
//   Widget build(BuildContext context) => Column(children: [
//     AnimatedContainer(
//       duration: const Duration(milliseconds: 300),
//       width: 80, height: 80,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: detected ? const Color(0xFF00E676).withOpacity(0.15) : Colors.white.withOpacity(0.05),
//         border: Border.all(color: detected ? const Color(0xFF00E676) : Colors.white24, width: 2),
//       ),
//       child: Icon(detected ? Icons.check : Icons.touch_app,
//           color: detected ? const Color(0xFF00E676) : Colors.white38, size: 32),
//     ),
//     const SizedBox(height: 10),
//     Text(label, style: TextStyle(color: detected ? const Color(0xFF00E676) : Colors.white54, fontSize: 13)),
//   ]);
// }
//
// class _KeyTestScaffold extends StatelessWidget {
//   final String title, instruction;
//   final IconData icon;
//   final bool detected;
//   final VoidCallback onFail;
//   const _KeyTestScaffold({required this.title, required this.icon, required this.instruction, required this.detected, required this.onFail});
//   @override
//   Widget build(BuildContext context) => Scaffold(
//     backgroundColor: Colors.black,
//     appBar: AppBar(title: Text(title), backgroundColor: Colors.black),
//     body: Center(
//       child: Padding(
//         padding: const EdgeInsets.all(32),
//         child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
//           AnimatedContainer(
//             duration: const Duration(milliseconds: 400),
//             width: 100, height: 100,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: detected ? const Color(0xFF00E676).withOpacity(0.15) : Colors.white.withOpacity(0.05),
//               border: Border.all(color: detected ? const Color(0xFF00E676) : Colors.white24, width: 2),
//             ),
//             child: Icon(detected ? Icons.check : icon,
//                 color: detected ? const Color(0xFF00E676) : Colors.white38, size: 44),
//           ),
//           const SizedBox(height: 28),
//           Text(detected ? 'Key Detected! ✅' : instruction,
//               textAlign: TextAlign.center,
//               style: TextStyle(color: detected ? const Color(0xFF00E676) : Colors.white70, fontSize: 17, height: 1.6)),
//           const SizedBox(height: 48),
//           if (!detected)
//             OutlinedButton(
//               onPressed: onFail,
//               style: OutlinedButton.styleFrom(foregroundColor: Colors.white54, side: const BorderSide(color: Colors.white24)),
//               child: const Text('Skip / Fail'),
//             ),
//         ]),
//       ),
//     ),
//   );
// }
//
// // ═════════════════════════════════════════════════════════════════════════════
// // FINGERPRINT TEST
// // Uses local_auth biometric prompt
// // ═════════════════════════════════════════════════════════════════════════════
//
// class FingerprintTestScreen extends StatefulWidget {
//   final LocalAuthentication auth;
//
//   const FingerprintTestScreen({super.key, required this.auth});
//
//   @override
//   State<FingerprintTestScreen> createState() => _FingerprintTestScreenState();
// }
//
// class _FingerprintTestScreenState extends State<FingerprintTestScreen> {
//   String _message = 'Tap to start fingerprint test';
//   bool _testing = false;
//   bool _completed = false;
//   bool _showManual = false;
//
//   Future<void> _authenticate() async {
//     if (_testing) return;
//
//     setState(() {
//       _testing = true;
//       _message = 'Checking device...';
//       _showManual = false;
//     });
//
//     try {
//       // ✅ Check support
//       final isSupported = await widget.auth.isDeviceSupported();
//       final canCheck = await widget.auth.canCheckBiometrics;
//
//       debugPrint("isSupported: $isSupported");
//       debugPrint("canCheck: $canCheck");
//
//       if (!isSupported || !canCheck) {
//         _failWithManual("Biometric not supported");
//         return;
//       }
//
//       // ✅ Check enrolled biometrics
//       final biometrics = await widget.auth.getAvailableBiometrics();
//
//       debugPrint("biometrics: $biometrics");
//
//       if (biometrics.isEmpty) {
//         _failWithManual("No fingerprint added");
//         return;
//       }
//
//       setState(() {
//         _message = 'Place your finger on the sensor';
//       });
//
//       // ✅ Authenticate
//       final ok = await widget.auth.authenticate(
//         localizedReason: 'Scan your fingerprint',
//         options: const AuthenticationOptions(
//           biometricOnly: true,
//           stickyAuth: false, // 🔥 important
//           useErrorDialogs: true,
//         ),
//       );
//
//       if (!mounted) return;
//
//       if (ok && !_completed) {
//         _completed = true;
//         _finish(true);
//       } else {
//         _failWithManual("Authentication failed");
//       }
//     } catch (e) {
//       _failWithManual("Error: $e");
//     }
//   }
//
//   void _failWithManual(String msg) {
//     if (!mounted) return;
//
//     setState(() {
//       _testing = false;
//       _message = msg;
//       _showManual = true; // 🔥 show manual fallback
//     });
//   }
//
//   void _finish(bool result) {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (!mounted) return;
//       Navigator.pop(context, result);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) => Scaffold(
//     backgroundColor: const Color(0xFF0D0D0D),
//     appBar: AppBar(
//       title: const Text('Fingerprint Test'),
//       backgroundColor: Colors.transparent,
//       elevation: 0,
//     ),
//     body: Padding(
//       padding: const EdgeInsets.all(24),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           // 🔥 Icon
//           Container(
//             width: 110,
//             height: 110,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: const Color(0xFFFF007F).withOpacity(0.1),
//               border: Border.all(
//                 color: const Color(0xFFFF007F),
//                 width: 2,
//               ),
//             ),
//             child: const Icon(Icons.fingerprint,
//                 size: 60, color: Color(0xFFFF007F)),
//           ),
//
//           const SizedBox(height: 30),
//
//           // 🔥 Message
//           Text(
//             _message,
//             textAlign: TextAlign.center,
//             style: const TextStyle(color: Colors.white70, fontSize: 16),
//           ),
//
//           const SizedBox(height: 40),
//
//           // 🔥 Start Button
//           if (!_testing && !_showManual)
//             ElevatedButton(
//               onPressed: _authenticate,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFFFF007F),
//                 padding: const EdgeInsets.symmetric(
//                     horizontal: 32, vertical: 14),
//               ),
//               child: const Text("Start Test"),
//             ),
//
//           // 🔥 Loading
//           if (_testing)
//             const CircularProgressIndicator(
//               color: Color(0xFFFF007F),
//             ),
//
//           const SizedBox(height: 20),
//
//           // 🔥 Manual fallback buttons
//           if (_showManual) ...[
//             ElevatedButton.icon(
//               onPressed: () => _finish(true),
//               icon: const Icon(Icons.check),
//               label: const Text("Mark as Passed"),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.green,
//                 padding: const EdgeInsets.symmetric(
//                     horizontal: 24, vertical: 12),
//               ),
//             ),
//             const SizedBox(height: 12),
//           ],
//
//           // 🔥 Skip / Fail
//           OutlinedButton(
//             onPressed: () => _finish(false),
//             child: const Text("Skip / Fail"),
//           ),
//         ],
//       ),
//     ),
//   );
// }
//
// // ═════════════════════════════════════════════════════════════════════════════
// // PROXIMITY TEST
// // ═════════════════════════════════════════════════════════════════════════════
//
// class ProximityTestScreen extends StatefulWidget {
//   const ProximityTestScreen({super.key});
//   @override State<ProximityTestScreen> createState() => _ProximityTestScreenState();
// }
//
// class _ProximityTestScreenState extends State<ProximityTestScreen> {
//   StreamSubscription<int>? _sub;
//   bool _near = false;
//   bool _everNear = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _sub = ProximitySensor.events.listen((v) {
//       final near = v > 0;
//       setState(() { _near = near; if (near) _everNear = true; });
//     });
//   }
//
//   @override void dispose() { _sub?.cancel(); super.dispose(); }
//
//   @override
//   Widget build(BuildContext context) => Scaffold(
//     backgroundColor: Colors.black,
//     appBar: AppBar(title: const Text('Proximity Test'), backgroundColor: Colors.black),
//     body: Center(
//       child: Padding(
//         padding: const EdgeInsets.all(32),
//         child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
//           AnimatedContainer(
//             duration: const Duration(milliseconds: 200),
//             width: 120, height: 120,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: _near ? const Color(0xFFFF007F).withOpacity(0.2) : Colors.white.withOpacity(0.05),
//               border: Border.all(color: _near ? const Color(0xFFFF007F) : Colors.white24, width: 3),
//             ),
//             child: Icon(Icons.sensors, color: _near ? const Color(0xFFFF007F) : Colors.white38, size: 56),
//           ),
//           const SizedBox(height: 28),
//           AnimatedSwitcher(
//             duration: const Duration(milliseconds: 250),
//             child: Text(
//               _near ? '🟥  Object NEAR' : '⬜  No Object Detected',
//               key: ValueKey(_near),
//               style: TextStyle(color: _near ? const Color(0xFFFF007F) : Colors.white54, fontSize: 18, fontWeight: FontWeight.w600),
//             ),
//           ),
//           const SizedBox(height: 8),
//           const Text('Cover the top earpiece sensor with your hand',
//               style: TextStyle(color: Colors.white38, fontSize: 13)),
//           if (_everNear) ...[
//             const SizedBox(height: 12),
//             const Text('✅ Proximity detected at least once', style: TextStyle(color: Color(0xFF00E676), fontSize: 13)),
//           ],
//           const SizedBox(height: 48),
//           Row(children: [
//             Expanded(child: OutlinedButton(
//               onPressed: () => Navigator.pop(context, false),
//               style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFFFF5252), side: const BorderSide(color: Color(0xFFFF5252)), padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
//               child: const Text('❌  Fail', style: TextStyle(fontWeight: FontWeight.bold)),
//             )),
//             const SizedBox(width: 16),
//             Expanded(child: ElevatedButton(
//               onPressed: _everNear ? () => Navigator.pop(context, true) : null,
//               style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00E676), foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
//               child: const Text('✅  Pass', style: TextStyle(fontWeight: FontWeight.bold)),
//             )),
//           ]),
//         ]),
//       ),
//     ),
//   );
// }
//
// // ═════════════════════════════════════════════════════════════════════════════
// // CAMERA TEST (front or back) – live preview
// // ═════════════════════════════════════════════════════════════════════════════
//
// class CameraTestScreen extends StatefulWidget {
//   final bool useFront;
//   const CameraTestScreen({super.key, required this.useFront});
//   @override State<CameraTestScreen> createState() => _CameraTestScreenState();
// }
//
// class _CameraTestScreenState extends State<CameraTestScreen> {
//   CameraController? _ctrl;
//   String? _error;
//
//   @override
//   void initState() { super.initState(); _initCamera(); }
//
//   Future<void> _initCamera() async {
//     try {
//       final cameras = await availableCameras();
//       final dir = widget.useFront ? CameraLensDirection.front : CameraLensDirection.back;
//       final cam = cameras.firstWhere((c) => c.lensDirection == dir, orElse: () => cameras.first);
//       _ctrl = CameraController(cam, ResolutionPreset.medium, enableAudio: false);
//       await _ctrl!.initialize();
//       if (mounted) setState(() {});
//     } catch (e) { setState(() => _error = e.toString()); }
//   }
//
//   @override void dispose() { _ctrl?.dispose(); super.dispose(); }
//
//   @override
//   Widget build(BuildContext context) => Scaffold(
//     backgroundColor: Colors.black,
//     appBar: AppBar(
//       title: Text(widget.useFront ? 'Front Camera Test' : 'Back Camera Test'),
//       backgroundColor: Colors.black,
//     ),
//     body: Column(children: [
//       Expanded(
//         child: _error != null
//             ? Center(child: Text('Camera Error:\n$_error', style: const TextStyle(color: Colors.red), textAlign: TextAlign.center))
//             : (_ctrl?.value.isInitialized ?? false)
//             ? CameraPreview(_ctrl!)
//             : const Center(child: CircularProgressIndicator(color: Color(0xFFFF007F))),
//       ),
//       Padding(
//         padding: const EdgeInsets.all(20),
//         child: Row(children: [
//           Expanded(child: OutlinedButton(
//             onPressed: () => Navigator.pop(context, false),
//             style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFFFF5252), side: const BorderSide(color: Color(0xFFFF5252)), padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
//             child: const Text('❌  Fail', style: TextStyle(fontWeight: FontWeight.bold)),
//           )),
//           const SizedBox(width: 16),
//           Expanded(child: ElevatedButton(
//             onPressed: () => Navigator.pop(context, true),
//             style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00E676), foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
//             child: const Text('✅  Pass', style: TextStyle(fontWeight: FontWeight.bold)),
//           )),
//         ]),
//       ),
//     ]),
//   );
// }
//
// // ═════════════════════════════════════════════════════════════════════════════
// // EAR RECEIVER TEST – plays beep through earpiece, user confirms
// // ═════════════════════════════════════════════════════════════════════════════
//
// class EarReceiverTestScreen extends StatefulWidget {
//   const EarReceiverTestScreen({super.key});
//   @override State<EarReceiverTestScreen> createState() => _EarReceiverTestScreenState();
// }
//
// class _EarReceiverTestScreenState extends State<EarReceiverTestScreen> {
//   bool _played = false;
//
//   @override
//   void initState() { super.initState(); _playBeep(); }
//
//   Future<void> _playBeep() async {
//     try {
//       final player = AudioPlayer();
//       // Route audio through earpiece (in-call mode)
//       await player.setAudioContext(AudioContext(
//         android: AudioContextAndroid(
//           audioMode: AndroidAudioMode.inCommunication,
//           audioFocus: AndroidAudioFocus.gain,
//           contentType: AndroidContentType.speech,
//           usageType: AndroidUsageType.voiceCommunication,
//           isSpeakerphoneOn: false,
//         ),
//       ));
//       await player.play(AssetSource('sound/beep.mp3'));
//       await Future.delayed(const Duration(seconds: 2));
//       await player.dispose();
//       if (mounted) setState(() => _played = true);
//     } catch (_) {
//       if (mounted) setState(() => _played = true);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) => Scaffold(
//     backgroundColor: Colors.black,
//     appBar: AppBar(title: const Text('Ear Receiver Test'), backgroundColor: Colors.black),
//     body: Center(
//       child: Padding(
//         padding: const EdgeInsets.all(32),
//         child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
//           Container(
//             width: 100, height: 100,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: const Color(0xFFFF007F).withOpacity(0.1),
//               border: Border.all(color: const Color(0xFFFF007F).withOpacity(0.5), width: 2),
//             ),
//             child: const Icon(Icons.hearing, color: Color(0xFFFF007F), size: 52),
//           ),
//           const SizedBox(height: 28),
//           Text(
//             _played
//                 ? 'Hold the phone to your ear.\nDid you hear the beep sound?'
//                 : 'Playing beep through ear receiver…',
//             textAlign: TextAlign.center,
//             style: const TextStyle(color: Colors.white70, fontSize: 16, height: 1.6),
//           ),
//           const SizedBox(height: 48),
//           if (_played)
//             Row(children: [
//               Expanded(child: OutlinedButton(
//                 onPressed: () => Navigator.pop(context, false),
//                 style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFFFF5252), side: const BorderSide(color: Color(0xFFFF5252)), padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
//                 child: const Text('❌  No / Fail', style: TextStyle(fontWeight: FontWeight.bold)),
//               )),
//               const SizedBox(width: 16),
//               Expanded(child: ElevatedButton(
//                 onPressed: () => Navigator.pop(context, true),
//                 style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00E676), foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
//                 child: const Text('✅  Yes / Pass', style: TextStyle(fontWeight: FontWeight.bold)),
//               )),
//             ])
//           else
//             const CircularProgressIndicator(color: Color(0xFFFF007F)),
//         ]),
//       ),
//     ),
//   );
// }
//
// // ═════════════════════════════════════════════════════════════════════════════
// // GENERIC MANUAL TEST SCREEN  (Microphone, etc.)
// // ═════════════════════════════════════════════════════════════════════════════
//
// class ManualTestScreen extends StatelessWidget {
//   final String title;
//   final IconData icon;
//   final String instruction;
//   const ManualTestScreen({super.key, required this.title, required this.icon, required this.instruction});
//
//   @override
//   Widget build(BuildContext context) => Scaffold(
//     backgroundColor: Colors.black,
//     appBar: AppBar(title: Text(title), backgroundColor: Colors.black),
//     body: Center(
//       child: Padding(
//         padding: const EdgeInsets.all(32),
//         child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
//           Container(
//             width: 100, height: 100,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: const Color(0xFFFF007F).withOpacity(0.1),
//               border: Border.all(color: const Color(0xFFFF007F).withOpacity(0.5), width: 2),
//             ),
//             child: Icon(icon, color: const Color(0xFFFF007F), size: 48),
//           ),
//           const SizedBox(height: 28),
//           Text(instruction, textAlign: TextAlign.center,
//               style: const TextStyle(color: Colors.white70, fontSize: 16, height: 1.7)),
//           const SizedBox(height: 56),
//           Row(children: [
//             Expanded(child: OutlinedButton(
//               onPressed: () => Navigator.pop(context, false),
//               style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFFFF5252), side: const BorderSide(color: Color(0xFFFF5252)), padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
//               child: const Text('❌  Fail', style: TextStyle(fontWeight: FontWeight.bold)),
//             )),
//             const SizedBox(width: 16),
//             Expanded(child: ElevatedButton(
//               onPressed: () => Navigator.pop(context, true),
//               style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00E676), foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
//               child: const Text('✅  Pass', style: TextStyle(fontWeight: FontWeight.bold)),
//             )),
//           ]),
//         ]),
//       ),
//     ),
//   );
// }
//
// // ═════════════════════════════════════════════════════════════════════════════
// // SINGLE TOUCH TEST
// // ═════════════════════════════════════════════════════════════════════════════
//
// class SingleTouchTestScreen extends StatefulWidget {
//   const SingleTouchTestScreen({super.key});
//   @override State<SingleTouchTestScreen> createState() => _SingleTouchTestScreenState();
// }
//
// class _SingleTouchTestScreenState extends State<SingleTouchTestScreen> {
//   static const int rows = 14, cols = 7;
//   final Set<int> _touched = {};
//
//   void _handle(PointerEvent e, BoxConstraints c) {
//     final col = (e.localPosition.dx / (c.maxWidth  / cols)).floor().clamp(0, cols - 1);
//     final row = (e.localPosition.dy / (c.maxHeight / rows)).floor().clamp(0, rows - 1);
//     final idx = row * cols + col;
//     if (_touched.add(idx) && _touched.length == rows * cols) {
//       Future.delayed(const Duration(milliseconds: 300), () { if (mounted) Navigator.pop(context, true); });
//     } else {
//       setState(() {});
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) => Scaffold(
//     backgroundColor: Colors.black,
//     appBar: AppBar(
//       title: const Text('Single Touch Test'),
//       backgroundColor: Colors.black,
//       actions: [Center(child: Padding(padding: const EdgeInsets.only(right: 16),
//           child: Text('${_touched.length} / ${rows * cols}', style: const TextStyle(color: Colors.white70))))],
//     ),
//     body: LayoutBuilder(
//       builder: (_, c) => Listener(
//         onPointerDown: (e) => _handle(e, c),
//         onPointerMove: (e) => _handle(e, c),
//         child: GridView.builder(
//           physics: const NeverScrollableScrollPhysics(),
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: cols, childAspectRatio: 1),
//           itemCount: rows * cols,
//           itemBuilder: (_, i) => AnimatedContainer(
//             duration: const Duration(milliseconds: 80),
//             decoration: BoxDecoration(
//               color: _touched.contains(i) ? const Color(0xFF00E676).withOpacity(0.55) : Colors.transparent,
//               border: Border.all(color: Colors.white10, width: 0.5),
//             ),
//           ),
//         ),
//       ),
//     ),
//     bottomNavigationBar: SafeArea(child: Padding(
//       padding: const EdgeInsets.all(16),
//       child: OutlinedButton(
//         onPressed: () => Navigator.pop(context, false),
//         style: OutlinedButton.styleFrom(foregroundColor: Colors.white54, side: const BorderSide(color: Colors.white24)),
//         child: const Text('Skip / Fail'),
//       ),
//     )),
//   );
// }
//
// // ═════════════════════════════════════════════════════════════════════════════
// // MULTI TOUCH TEST
// // ═════════════════════════════════════════════════════════════════════════════
//
// class MultiTouchTestScreen extends StatefulWidget {
//   const MultiTouchTestScreen({super.key});
//   @override State<MultiTouchTestScreen> createState() => _MultiTouchTestScreenState();
// }
//
// class _MultiTouchTestScreenState extends State<MultiTouchTestScreen> {
//   final Map<int, Offset> _pointers = {};
//   int _maxPointers = 0;
//
//   @override
//   Widget build(BuildContext context) => Scaffold(
//     backgroundColor: Colors.black,
//     appBar: AppBar(title: const Text('Multi-Touch Test'), backgroundColor: Colors.black),
//     body: Listener(
//       onPointerDown: (e) => setState(() {
//         _pointers[e.pointer] = e.localPosition;
//         if (_pointers.length > _maxPointers) _maxPointers = _pointers.length;
//       }),
//       onPointerMove:   (e) => setState(() => _pointers[e.pointer] = e.localPosition),
//       onPointerUp:     (e) => setState(() => _pointers.remove(e.pointer)),
//       onPointerCancel: (e) => setState(() => _pointers.remove(e.pointer)),
//       child: Stack(children: [
//         const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
//           Icon(Icons.touch_app, size: 64, color: Colors.white10),
//           SizedBox(height: 16),
//           Text('Place multiple fingers on screen', style: TextStyle(color: Colors.white24)),
//         ])),
//         CustomPaint(painter: _TouchPainter(_pointers), size: Size.infinite),
//         Positioned(top: 20, left: 0, right: 0, child: Center(
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//             decoration: BoxDecoration(color: const Color(0xFFFF007F), borderRadius: BorderRadius.circular(30)),
//             child: Text('Active: ${_pointers.length}  |  Max: $_maxPointers',
//                 style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
//           ),
//         )),
//       ]),
//     ),
//     bottomNavigationBar: SafeArea(child: Padding(
//       padding: const EdgeInsets.all(16),
//       child: Row(children: [
//         Expanded(child: OutlinedButton(
//           onPressed: () => Navigator.pop(context, false),
//           style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFFFF5252), side: const BorderSide(color: Color(0xFFFF5252)), padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
//           child: const Text('❌  Fail', style: TextStyle(fontWeight: FontWeight.bold)),
//         )),
//         const SizedBox(width: 16),
//         Expanded(child: ElevatedButton(
//           onPressed: _maxPointers >= 2 ? () => Navigator.pop(context, true) : null,
//           style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00E676), foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
//           child: const Text('✅  Pass', style: TextStyle(fontWeight: FontWeight.bold)),
//         )),
//       ]),
//     )),
//   );
// }
//
// class _TouchPainter extends CustomPainter {
//   final Map<int, Offset> pointers;
//   _TouchPainter(this.pointers);
//   static const _colors = [Colors.blue, Colors.green, Colors.red, Colors.yellow, Colors.purple, Colors.orange];
//   @override
//   void paint(Canvas canvas, Size size) {
//     pointers.forEach((id, pos) {
//       final c = _colors[id % _colors.length];
//       canvas.drawCircle(pos, 50, Paint()..color = c.withOpacity(0.2));
//       canvas.drawCircle(pos, 50, Paint()..color = c..style = PaintingStyle.stroke..strokeWidth = 2);
//       canvas.drawCircle(pos, 5,  Paint()..color = Colors.white);
//     });
//   }
//   @override bool shouldRepaint(_TouchPainter o) => true;
// }