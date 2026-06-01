// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
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
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraTestScreen extends StatefulWidget {
  final bool useFront;

  const CameraTestScreen({
    super.key,
    required this.useFront,
  });

  @override
  State<CameraTestScreen> createState() => _CameraTestScreenState();
}

class _CameraTestScreenState extends State<CameraTestScreen> {

  CameraController? _controller;

  bool _isLoading = true;
  bool _isCameraReady = false;

  String? _error;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {

    try {

      setState(() {
        _isLoading = true;
        _error = null;
      });

      final cameras = await availableCameras();

      if (cameras.isEmpty) {

        setState(() {
          _error = "No cameras found";
          _isLoading = false;
        });

        return;
      }

      final lensDirection = widget.useFront
          ? CameraLensDirection.front
          : CameraLensDirection.back;

      CameraDescription selectedCamera;

      try {

        selectedCamera = cameras.firstWhere(
              (camera) => camera.lensDirection == lensDirection,
        );

      } catch (_) {

        selectedCamera = cameras.first;
      }

      debugPrint("Using camera: ${selectedCamera.name}");

      // 🔥 Resolution fallback
      final presets = [
        ResolutionPreset.medium,
        ResolutionPreset.low,
        ResolutionPreset.high,
      ];

      CameraController? workingController;

      for (final preset in presets) {

        try {

          debugPrint("Trying preset: $preset");

          final controller = CameraController(
            selectedCamera,
            preset,

            enableAudio: false,

            // 🔥 IMPORTANT
            // DO NOT USE imageFormatGroup
          );

          await controller.initialize();

          // 🔥 Small delay helps many Android devices
          await Future.delayed(
            const Duration(milliseconds: 500),
          );

          if (!controller.value.isInitialized) {

            await controller.dispose();
            continue;
          }

          final previewSize = controller.value.previewSize;

          if (previewSize == null ||
              previewSize.width <= 0 ||
              previewSize.height <= 0) {

            await controller.dispose();
            continue;
          }

          workingController = controller;

          debugPrint("Camera initialized successfully");

          break;

        } catch (e) {

          debugPrint("Preset failed: $preset");

          debugPrint(e.toString());
        }
      }

      if (workingController == null) {

        setState(() {
          _error = "Failed to open camera";
          _isLoading = false;
        });

        return;
      }

      _controller = workingController;

      if (!mounted) return;

      setState(() {
        _isCameraReady = true;
        _isLoading = false;
      });

    } catch (e) {

      debugPrint("Camera error: $e");

      if (!mounted) return;

      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _retryCamera() async {

    try {
      await _controller?.dispose();
    } catch (_) {}

    _controller = null;

    setState(() {
      _isCameraReady = false;
    });

    await Future.delayed(
      const Duration(milliseconds: 1000),
    );

    await _initializeCamera();
  }

  @override
  void dispose() {

    try {
      _controller?.dispose();
    } catch (_) {}

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.black,

      appBar: AppBar(

        elevation: 0,

        backgroundColor: Colors.black,

        foregroundColor: Colors.white,

        title: Text(
          widget.useFront
              ? "Front Camera Test"
              : "Back Camera Test",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Column(

        children: [

          Expanded(
            child: _buildCameraView(),
          ),

          Padding(

            padding: const EdgeInsets.all(20),

            child: Row(

              children: [

                Expanded(
                  child: OutlinedButton(

                    onPressed: () {
                      Navigator.pop(context, false);
                    },

                    style: OutlinedButton.styleFrom(

                      foregroundColor: Colors.red,

                      side: const BorderSide(
                        color: Colors.red,
                      ),

                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                      ),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),

                    child: const Text(
                      "❌ Fail",
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: ElevatedButton(

                    onPressed: () {
                      Navigator.pop(context, true);
                    },

                    style: ElevatedButton.styleFrom(

                      backgroundColor: Colors.greenAccent,

                      foregroundColor: Colors.black,

                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                      ),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),

                    child: const Text(
                      "✅ Pass",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraView() {

    if (_isLoading) {

      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {

      return Center(

        child: Padding(

          padding: const EdgeInsets.all(24),

          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,

            children: [

              const Icon(
                Icons.camera_alt,
                color: Colors.red,
                size: 60,
              ),

              const SizedBox(height: 20),

              Text(

                _error!,

                textAlign: TextAlign.center,

                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton(

                onPressed: _retryCamera,

                child: const Text(
                  "Retry",
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (!_isCameraReady || _controller == null) {

      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return SizedBox.expand(
      child: CameraPreview(_controller!),
    );
  }
}