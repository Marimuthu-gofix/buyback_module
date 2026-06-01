import 'package:flutter/material.dart';


class MultiTouchTestScreen extends StatefulWidget {
  const MultiTouchTestScreen({super.key});
  @override State<MultiTouchTestScreen> createState() => _MultiTouchTestScreenState();
}

class _MultiTouchTestScreenState extends State<MultiTouchTestScreen> {
  final Map<int, Offset> _pointers = {};
  int _maxPointers = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.black,
    appBar: AppBar(title: const Text('Multi-Touch Test',
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)
    ), backgroundColor: Colors.black,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),),
    body: Listener(
      onPointerDown: (e) => setState(() {
        _pointers[e.pointer] = e.localPosition;
        if (_pointers.length > _maxPointers) _maxPointers = _pointers.length;
      }),
      onPointerMove:   (e) => setState(() => _pointers[e.pointer] = e.localPosition),
      onPointerUp:     (e) => setState(() => _pointers.remove(e.pointer)),
      onPointerCancel: (e) => setState(() => _pointers.remove(e.pointer)),
      child: Stack(children: [
        const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.touch_app, size: 64, color: Colors.white10),
          SizedBox(height: 16),
          Text('Place multiple fingers on screen', style: TextStyle(color: Colors.white24)),
        ])),
        CustomPaint(painter: _TouchPainter(_pointers), size: Size.infinite),
        Positioned(top: 20, left: 0, right: 0, child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(color: const Color(0xFFFF007F), borderRadius: BorderRadius.circular(30)),
            child: Text('Active: ${_pointers.length}  |  Max: $_maxPointers',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          ),
        )),
      ]),
    ),
    bottomNavigationBar: SafeArea(child: Padding(
      padding: const EdgeInsets.all(16),
      child: Row(children: [
        Expanded(child: OutlinedButton(
          onPressed: () => Navigator.pop(context, false),
          style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFFFF5252), side: const BorderSide(color: Color(0xFFFF5252)), padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
          child: const Text('❌  Fail', style: TextStyle(fontWeight: FontWeight.bold)),
        )),
        const SizedBox(width: 16),
        Expanded(child: ElevatedButton(
          onPressed: _maxPointers >= 2 ? () => Navigator.pop(context, true) : null,
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00E676), foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
          child: const Text('✅  Pass', style: TextStyle(fontWeight: FontWeight.bold)),
        )),
      ]),
    )),
  );
}

class _TouchPainter extends CustomPainter {
  final Map<int, Offset> pointers;
  _TouchPainter(this.pointers);
  static const _colors = [Colors.blue, Colors.green, Colors.red, Colors.yellow, Colors.purple, Colors.orange];
  @override
  void paint(Canvas canvas, Size size) {
    pointers.forEach((id, pos) {
      final c = _colors[id % _colors.length];
      canvas.drawCircle(pos, 50, Paint()..color = c.withOpacity(0.2));
      canvas.drawCircle(pos, 50, Paint()..color = c..style = PaintingStyle.stroke..strokeWidth = 2);
      canvas.drawCircle(pos, 5,  Paint()..color = Colors.white);
    });
  }
  @override bool shouldRepaint(_TouchPainter o) => true;
}