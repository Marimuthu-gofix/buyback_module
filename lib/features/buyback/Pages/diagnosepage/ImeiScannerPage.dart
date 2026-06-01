import 'dart:io';
import 'package:buyback_module/features/buyback/Pages/diagnosepage/widgets/initiatediagostics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ImeiScannerPage extends StatefulWidget {
  const ImeiScannerPage({super.key});

  @override
  State<ImeiScannerPage> createState() => _ImeiScannerPageState();
}

class _ImeiScannerPageState extends State<ImeiScannerPage> {
  File? _image;
  String _imei1 = '';
  String _imei2 = '';
  bool _loading = false;
  bool _scanned = false;
  final ImagePicker _picker = ImagePicker();

  // ── Teal accent matching Cashify ──────────────────────────────────────────
  static const Color _deeppink = Color(0xffFF4FD8);
  static const Color _red = Color(0xFFE53935);

  Future<void> _saveImeis() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('imei1', _imei1);
    await prefs.setString('imei2', _imei2);
  }

  Future<void> _pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(source: source, imageQuality: 95);
    if (picked == null) return;
    setState(() {
      _image = File(picked.path);
      _imei1 = '';
      _imei2 = '';
      _scanned = false;
    });
    await _scanImei();
  }

  Future<void> _scanImei() async {
    if (_image == null) return;
    setState(() => _loading = true);

    try {
      final inputImage = InputImage.fromFile(_image!);
      final textRecognizer =
      TextRecognizer(script: TextRecognitionScript.latin);
      final RecognizedText recognizedText =
      await textRecognizer.processImage(inputImage);
      await textRecognizer.close();

      final allText = recognizedText.text;
      debugPrint('Recognized Text: $allText');

      final imeiRegex = RegExp(r'\b\d{15}\b');
      final matches = imeiRegex.allMatches(allText.replaceAll(' ', ''));
      final imeis = matches.map((m) => m.group(0)!).toList();

      setState(() {
        _imei1 = imeis.isNotEmpty ? imeis[0] : '';
        _imei2 = imeis.length > 1 ? imeis[1] : '';
        _scanned = true;
      });
      await _saveImeis();
      // AUTO NAVIGATION
      if (_imei1.isNotEmpty && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const InitiateDiagostics(),
          ),
        );
      }
    } catch (e) {
      setState(() => _scanned = true);
      debugPrint('IMEI scan error: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  void _copy(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to clipboard'),
        backgroundColor: _deeppink,
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _openDialer() async {
    final uri = Uri(scheme: 'tel', path: '*%2306%23');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  void _showPickerSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: _deeppink.withOpacity(0.15),
                  child: const Icon(Icons.camera_alt, color: _deeppink),
                ),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: _deeppink.withOpacity(0.15),
                  child: const Icon(Icons.photo_library, color: _deeppink),
                ),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool found = _imei1.isNotEmpty || _imei2.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Diagnose",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────────────────────────
            const Text(
              'IMEI Capture',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'To evaluate the state of your trade in device, we will process your IMEI, Device make and Phone\'s state.',
              style: TextStyle(
                fontSize: 13.5,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 28),

            // ── Step 1 ───────────────────────────────────────────────────────
            _StepRow(
              stepNumber: '1',
              teal: _deeppink,
              isLast: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Dial *#06# on Phone\'s dialer to get the IMEI',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: _openDialer,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Go To Phone\'s Dialer',
                          style: TextStyle(
                            color: _deeppink,
                            fontWeight: FontWeight.w600,
                            fontSize: 13.5,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Icon(Icons.dialpad, color: _deeppink, size: 18),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Step 2 ───────────────────────────────────────────────────────
            _StepRow(
              stepNumber: '2',
              teal: _deeppink,
              isLast: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Take screenshot of the IMEI, come back here and upload the screenshot below',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        height: 1.5),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Do not crop or edit the screenshot Ensure the screenshot contains both IMEIs clearly Take a new screenshot - avoid uploading older screenshots",
                    style: TextStyle(
                        fontSize: 10,
                        color: Colors.red,
                        height: 1.4),
                  ),
                  // Warnings
                  const SizedBox(height: 10),
                  // Info box
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF6FB),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline,
                      size: 16, color: Colors.blueGrey),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "You should be able to take screenshots on your device by holding down the 'Power' and 'Volume down' buttons.",
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.blueGrey,
                          height: 1.4),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // ── Image preview (shown only after pick) ────────────────────────
            // if (_image != null) ...[
            //   ClipRRect(
            //     borderRadius: BorderRadius.circular(12),
            //     child: Stack(
            //       children: [
            //         Image.file(_image!,
            //             width: double.infinity,
            //             height: 220,
            //             fit: BoxFit.contain),
            //         Positioned(
            //           top: 8,
            //           right: 8,
            //           child: GestureDetector(
            //             onTap: _loading ? null : _showPickerSheet,
            //             child: Container(
            //               padding: const EdgeInsets.symmetric(
            //                   horizontal: 10, vertical: 6),
            //               decoration: BoxDecoration(
            //                 color: Colors.black45,
            //                 borderRadius: BorderRadius.circular(8),
            //               ),
            //               child: const Row(
            //                 children: [
            //                   Icon(Icons.refresh,
            //                       color: Colors.white, size: 14),
            //                   SizedBox(width: 4),
            //                   Text('Change',
            //                       style: TextStyle(
            //                           color: Colors.white, fontSize: 12)),
            //                 ],
            //               ),
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            //   const SizedBox(height: 16),
            // ],

            // ── Loading ──────────────────────────────────────────────────────
            if (_loading)
              Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(color: _deeppink),
                    const SizedBox(height: 12),
                    const Text('Scanning for IMEI...',
                        style: TextStyle(color: Colors.black45, fontSize: 13)),
                    const SizedBox(height: 16),
                  ],
                ),
              ),

            // ── IMEI Results ─────────────────────────────────────────────────
            // if (_scanned && !_loading) ...[
            //   if (found) ...[
            //     if (_imei1.isNotEmpty)
            //       _ImeiCard(
            //         label: _imei2.isNotEmpty ? 'IMEI 1' : 'IMEI',
            //         value: _imei1,
            //         teal: _deeppink,
            //         onCopy: () => _copy(_imei1),
            //       ),
            //     if (_imei2.isNotEmpty) ...[
            //       const SizedBox(height: 10),
            //       _ImeiCard(
            //         label: 'IMEI 2',
            //         value: _imei2,
            //         teal: _deeppink,
            //         onCopy: () => _copy(_imei2),
            //       ),
            //     ],
            //     const SizedBox(height: 16),
            //   ] else ...[
            //     Container(
            //       width: double.infinity,
            //       padding: const EdgeInsets.all(16),
            //       decoration: BoxDecoration(
            //         color: Colors.red.shade50,
            //         borderRadius: BorderRadius.circular(10),
            //         border:
            //         Border.all(color: Colors.red.shade200),
            //       ),
            //       child: Row(
            //         children: [
            //           Icon(Icons.error_outline,
            //               color: _red, size: 20),
            //           const SizedBox(width: 10),
            //           const Expanded(
            //             child: Text(
            //               'No IMEI found. Try a clearer image or different angle.',
            //               style:
            //               TextStyle(color: Colors.black54, fontSize: 13),
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //     const SizedBox(height: 16),
            //   ],
            // ],

            // ── Upload Button ────────────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: _loading
                    ? null
                    : () {
                  if (_imei1.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const InitiateDiagostics(),
                      ),
                    );
                  } else {
                    _showPickerSheet();
                  }
                },
                icon: const Icon(Icons.upload_rounded,
                    color: Colors.white, size: 20),
                label: Text(
                  _image == null ? 'Click here to upload' : 'Upload New Screenshot',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _deeppink,
                  disabledBackgroundColor: _deeppink.withOpacity(0.5),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// ── Step Row Widget ────────────────────────────────────────────────────────────
class _StepRow extends StatelessWidget {
  final String stepNumber;
  final Color teal;
  final bool isLast;
  final Widget child;

  const _StepRow({
    required this.stepNumber,
    required this.teal,
    required this.isLast,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Number + vertical line
          Column(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: teal,
                child: Text(
                  stepNumber,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: teal.withOpacity(0.25),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

// ── IMEI Result Card ───────────────────────────────────────────────────────────
class _ImeiCard extends StatelessWidget {
  final String label;
  final String value;
  final Color teal;
  final VoidCallback onCopy;

  const _ImeiCard({
    required this.label,
    required this.value,
    required this.teal,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.sim_card, color: teal, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style:
                    const TextStyle(color: Colors.white, fontSize: 11)),
                const SizedBox(height: 4),
                SelectableText(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onCopy,
            icon: Icon(Icons.copy_rounded, color: teal, size: 20),
            tooltip: 'Copy',
          ),
        ],
      ),
    );
  }
}