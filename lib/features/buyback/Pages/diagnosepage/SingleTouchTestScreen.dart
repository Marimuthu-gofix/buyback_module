import 'package:flutter/material.dart';

class SingleTouchTestScreen extends StatefulWidget {
  const SingleTouchTestScreen({super.key});

  @override
  State<SingleTouchTestScreen> createState() => _SingleTouchTestScreenState();
}

class _SingleTouchTestScreenState extends State<SingleTouchTestScreen> {
  static const int rows = 14;
  static const int cols = 7;

  final Set<int> _touched = {};

  void _handle(Offset pos, Size size) {
    final cellW = size.width / cols;
    final cellH = size.height / rows;

    final col = (pos.dx / cellW).floor().clamp(0, cols - 1);
    final row = (pos.dy / cellH).floor().clamp(0, rows - 1);

    final index = row * cols + col;

    if (_touched.add(index)) {
      setState(() {});
      if (_touched.length == rows * cols) {
        Future.delayed(const Duration(milliseconds: 400), () {
          if (mounted) Navigator.pop(context, true);
        });
      }
    }
  }

  void _reset() => setState(() => _touched.clear());

  @override
  Widget build(BuildContext context) {
    final total = rows * cols;
    final progress = _touched.length / total;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: Stack(
        children: [

          // ── Full Screen Touch Area ─────────────────────────────────────────
          Positioned.fill(
            child: LayoutBuilder(
              builder: (_, constraints) {
                final size = Size(constraints.maxWidth, constraints.maxHeight);
                return GestureDetector(
                  onPanDown: (d) => _handle(d.localPosition, size),
                  onPanUpdate: (d) => _handle(d.localPosition, size),
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: total,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: cols,
                      mainAxisExtent: constraints.maxHeight / rows,
                    ),
                    itemBuilder: (_, i) {
                      final isTouched = _touched.contains(i);
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 100),
                        margin: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isTouched
                              ? const Color(0xFF00E676)
                              : const Color(0xFFFF3B7A).withOpacity(0.8),
                          boxShadow: isTouched
                              ? [
                            BoxShadow(
                              color: const Color(0xFF00E676).withOpacity(0.5),
                              blurRadius: 6,
                              spreadRadius: 1,
                            )
                          ]
                              : null,
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),

          // ── AppBar Overlay ─────────────────────────────────────────────────
          Positioned(
            top: 0, left: 0, right: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.85),
                    Colors.transparent,
                  ],
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  child: Row(
                    children: [
                      // Back button
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded,
                            color: Colors.white),
                        onPressed: () => Navigator.pop(context, false),
                      ),

                      // Title
                      const Expanded(
                        child: Text(
                          'Touch Screen Test',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      // Counter
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: const Color(0xFFFF007F).withOpacity(0.5)),
                        ),
                        child: Text(
                          '${_touched.length}/$total',
                          style: const TextStyle(
                            color: Color(0xFFFF007F),
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),

                      // Reset
                      IconButton(
                        icon: const Icon(Icons.refresh_rounded,
                            color: Colors.white70),
                        onPressed: _reset,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── Bottom Bar Overlay ─────────────────────────────────────────────
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.85),
                    Colors.transparent,
                  ],
                ),
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      // Progress bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.white24,
                          color: progress == 1.0
                              ? const Color(0xFF00E676)
                              : const Color(0xFFFF007F),
                          minHeight: 6,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Row(
                        children: [
                          // Status text
                          Expanded(
                            child: Text(
                              _touched.length == total
                                  ? '✅ All dots touched — Pass!'
                                  : '${total - _touched.length} dots remaining',
                              style: TextStyle(
                                color: _touched.length == total
                                    ? const Color(0xFF00E676)
                                    : Colors.white70,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),

                          // Skip button
                          GestureDetector(
                            onTap: () => Navigator.pop(context, false),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white10,
                                borderRadius: BorderRadius.circular(10),
                                border:
                                Border.all(color: Colors.white24),
                              ),
                              child: const Text(
                                'Skip / Fail',
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}