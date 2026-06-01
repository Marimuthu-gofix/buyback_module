import 'package:buyback_module/features/buyback/Pages/diagnosepage/widgets/initiatediagostics.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../shared/Color/app_colors.dart';
import '../home.dart';
import 'ImeiScannerPage.dart';

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({super.key});

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  static const Color _pink = Color(0xFFFF007F);
  static const Color _bg = Color(0xFF121212);
  static const Color _card = Color(0xFF1E1E1E);

  int? _activeIndex;

  final List<_PermItem> _items = [
    _PermItem('Camera', Icons.camera_alt_outlined, Permission.camera),
    _PermItem('Microphone', Icons.mic_none_rounded, Permission.microphone),
    _PermItem('Location', Icons.location_on_outlined, Permission.location),
    _PermItem('Phone State', Icons.phone_android_outlined, Permission.phone),
    _PermItem('Bluetooth', Icons.bluetooth_outlined, Permission.bluetooth),
  ];

  Map<String, bool> _status = {};

  @override
  void initState() {
    super.initState();
    _checkAll();
  }

  Future<void> _checkAll() async {
    final map = <String, bool>{};
    for (final item in _items) {
      final s = await item.permission.status;
      map[item.title] = s.isGranted;
    }
    setState(() => _status = map);
  }

  Future<void> _request(int index) async {
    setState(() => _activeIndex = index);
    await _items[index].permission.request();
    await _checkAll();
    setState(() => _activeIndex = null);
  }

  bool get _allGranted => _items.every((i) => _status[i.title] == true);

  Future<void> _proceed() async {
    for (int i = 0; i < _items.length; i++) {
      if (!(_status[_items[i].title] ?? false)) {
        await _items[i].permission.request();
      }
    }
    await _checkAll();

    if (!_allGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please allow all permissions')),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final imei1 = prefs.getString('imei1') ?? '';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            imei1.isNotEmpty ? InitiateDiagostics() : const ImeiScannerPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const home()),
          (route) => false,
        );

        return false;
      },
      child: Scaffold(
        backgroundColor: _bg,

        appBar: AppBar(
          backgroundColor: _bg,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const home()),
                (route) => false,
              );
            },
          ),
          title: const Text(
            'Diagnose',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),

        // ✅ BODY
        body: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ─────────────────────────────
              const Text(
                'We need couple of things\nto get started',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'In order to test your phone thoroughly, we need following set of permissions.',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 24),

              // ── GRID ───────────────────────────────
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.9,
                  ),

                  itemCount: _items.length,

                  itemBuilder: (context, index) {
                    final item = _items[index];
                    final granted = _status[item.title] ?? false;
                    final isActive = _activeIndex == index;

                    return GestureDetector(
                      onTap: () => _request(index),

                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),

                        decoration: BoxDecoration(
                          color: _card,
                          borderRadius: BorderRadius.circular(14),

                          border: Border.all(
                            color: granted
                                ? _pink.withOpacity(0.5)
                                : isActive
                                ? _pink.withOpacity(0.6)
                                : Colors.white10,
                            width: 1.2,
                          ),
                        ),

                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 14,
                        ),

                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // ICON
                            isActive
                                ? SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: _pink,
                                    ),
                                  )
                                : Icon(
                                    item.icon,
                                    color: granted ? _pink : Colors.white38,
                                    size: 22,
                                  ),

                            const SizedBox(width: 10),

                            // TEXT
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    item.title,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),

                                  const SizedBox(height: 3),

                                  Text(
                                    granted ? 'Allowed' : 'Tap to allow',
                                    style: TextStyle(
                                      color: granted ? _pink : Colors.white38,
                                      fontSize: 11,
                                      fontWeight: granted
                                          ? FontWeight.w500
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 12),
            ],
          ),
        ),

        // ✅ BOTTOM BUTTON
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 54,

              child: ElevatedButton(
                onPressed: _proceed,

                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF4FD8),
                  elevation: 0,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),

                child: Text(
                  'Proceed',
                  style: TextStyle(
                    color: AppColors.textWhite,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PermItem {
  final String title;
  final IconData icon;
  final Permission permission;
  const _PermItem(this.title, this.icon, this.permission);
}
