import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';
import '../../models/problem.dart';
import '../../services/voice/tts_service.dart';

/// Screen for drawing solutions to math problems with finger
class DrawingCanvasScreen extends StatefulWidget {
  final List<MathProblem> problems;
  final int currentProblemIndex;
  final List<Uint8List> previousDrawings;

  const DrawingCanvasScreen({
    super.key,
    required this.problems,
    this.currentProblemIndex = 0,
    this.previousDrawings = const [],
  });

  @override
  State<DrawingCanvasScreen> createState() => _DrawingCanvasScreenState();
}

class _DrawingCanvasScreenState extends State<DrawingCanvasScreen> {
  final List<DrawingPoint?> _points = [];
  final GlobalKey _canvasKey = GlobalKey();
  final TTSService _tts = TTSService();

  late int _currentIndex;
  late List<Uint8List?> _drawings;
  int? _userAnswer;
  Color _selectedColor = Colors.black;
  double _strokeWidth = 4.0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentProblemIndex;
    _drawings = List<Uint8List?>.filled(widget.problems.length, null);

    // Load previous drawings if any
    for (int i = 0; i < widget.previousDrawings.length && i < _drawings.length; i++) {
      _drawings[i] = widget.previousDrawings[i];
    }

    _speakInstructions();
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  Future<void> _speakInstructions() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final problem = widget.problems[_currentIndex];
    await _tts.speak(
      "Let's solve ${problem.operand1} ${problem.type.symbol} ${problem.operand2}. "
      "Use your finger to write down your work and answer on the canvas below!"
    );
  }

  void _onPanStart(DragStartDetails details) {
    setState(() {
      _points.add(
        DrawingPoint(
          offset: details.localPosition,
          paint: Paint()
            ..color = _selectedColor
            ..strokeWidth = _strokeWidth
            ..strokeCap = StrokeCap.round
            ..isAntiAlias = true,
        ),
      );
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _points.add(
        DrawingPoint(
          offset: details.localPosition,
          paint: Paint()
            ..color = _selectedColor
            ..strokeWidth = _strokeWidth
            ..strokeCap = StrokeCap.round
            ..isAntiAlias = true,
        ),
      );
    });
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      _points.add(null); // null marks end of a stroke
    });
  }

  void _clearCanvas() {
    setState(() {
      _points.clear();
      _userAnswer = null;
    });
  }

  Future<Uint8List?> _captureCanvas() async {
    try {
      final boundary = _canvasKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return null;

      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      debugPrint('Error capturing canvas: $e');
      return null;
    }
  }

  Future<void> _submitAnswer() async {
    if (_points.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please draw your work on the canvas first!'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Capture the current drawing
    final drawing = await _captureCanvas();
    if (drawing != null) {
      _drawings[_currentIndex] = drawing;
    }

    // Move to next problem or submit
    if (_currentIndex < widget.problems.length - 1) {
      setState(() {
        _currentIndex++;
        _points.clear();
        _userAnswer = null;
      });
      _speakInstructions();
    } else {
      // All problems done - go to review
      final nonNullDrawings = _drawings.whereType<Uint8List>().toList();

      if (!mounted) return;
      context.go(
        '/math-practice/drawing-review',
        extra: {
          'problems': widget.problems,
          'drawings': nonNullDrawings,
        },
      );
    }
  }

  Widget _buildProblemDisplay() {
    final problem = widget.problems[_currentIndex];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade200, width: 2),
      ),
      child: Column(
        children: [
          Text(
            'Problem ${_currentIndex + 1} of ${widget.problems.length}',
            style: TextStyle(
              fontSize: 16,
              color: Colors.blue.shade700,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${problem.operand1} ${problem.type.symbol} ${problem.operand2} = ?',
                style: const TextStyle(
                  fontFamily: 'Courier',
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Draw Your Solution'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _clearCanvas,
            tooltip: 'Clear canvas',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Problem at the top
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildProblemDisplay(),
            ),

            // Drawing tools
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  const Text('Color: ', style: TextStyle(fontWeight: FontWeight.bold)),
                  _buildColorButton(Colors.black),
                  _buildColorButton(Colors.blue),
                  _buildColorButton(Colors.red),
                  _buildColorButton(Colors.green),
                  const SizedBox(width: 16),
                  const Text('Size: ', style: TextStyle(fontWeight: FontWeight.bold)),
                  _buildSizeButton(2.0, 'Thin'),
                  _buildSizeButton(4.0, 'Normal'),
                  _buildSizeButton(8.0, 'Thick'),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Instructions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.touch_app, color: Colors.green.shade700),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Use your finger to write your work and answer!',
                        style: TextStyle(
                          color: Colors.green.shade900,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Drawing Canvas
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade300, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: RepaintBoundary(
                      key: _canvasKey,
                      child: GestureDetector(
                        onPanStart: _onPanStart,
                        onPanUpdate: _onPanUpdate,
                        onPanEnd: _onPanEnd,
                        child: CustomPaint(
                          painter: DrawingPainter(points: _points),
                          size: Size.infinite,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Action buttons
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _clearCanvas,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Clear'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: _submitAnswer,
                      icon: Icon(
                        _currentIndex < widget.problems.length - 1
                            ? Icons.arrow_forward
                            : Icons.check,
                      ),
                      label: Text(
                        _currentIndex < widget.problems.length - 1
                            ? 'Next Problem'
                            : 'Submit All',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorButton(Color color) {
    final isSelected = _selectedColor == color;
    return GestureDetector(
      onTap: () => setState(() => _selectedColor = color),
      child: Container(
        width: 36,
        height: 36,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade400,
            width: isSelected ? 3 : 1,
          ),
        ),
        child: isSelected
            ? const Icon(Icons.check, color: Colors.white, size: 20)
            : null,
      ),
    );
  }

  Widget _buildSizeButton(double size, String label) {
    final isSelected = _strokeWidth == size;
    return GestureDetector(
      onTap: () => setState(() => _strokeWidth = size),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.blue.shade700 : Colors.grey.shade400,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

/// Model for a single drawing point
class DrawingPoint {
  final Offset offset;
  final Paint paint;

  DrawingPoint({required this.offset, required this.paint});
}

/// Custom painter for drawing on canvas
class DrawingPainter extends CustomPainter {
  final List<DrawingPoint?> points;

  DrawingPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(
          points[i]!.offset,
          points[i + 1]!.offset,
          points[i]!.paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) => true;
}
