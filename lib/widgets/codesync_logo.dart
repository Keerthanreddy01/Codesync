/// CodeSync Logo Widget
import 'package:flutter/material.dart';
import '../config/app_colors.dart';

class CodeSyncLogo extends StatelessWidget {
  final double size;
  final Color? color;
  final bool showText;

  const CodeSyncLogo({
    super.key,
    this.size = 64,
    this.color,
    this.showText = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomPaint(
          size: Size(size, size),
          painter: CodeSyncLogoPainter(
            color: color ?? Colors.white,
          ),
        ),
        if (showText) ...[
          const SizedBox(height: 12),
          Text(
            'CODESYNC',
            style: TextStyle(
              fontSize: size * 0.3,
              fontWeight: FontWeight.w900,
              color: color ?? Colors.white,
              letterSpacing: 2.0,
            ),
          ),
        ],
      ],
    );
  }
}

class CodeSyncLogoPainter extends CustomPainter {
  final Color color;

  CodeSyncLogoPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = size.width * 0.08
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final scale = size.width / 100;

    // Draw the geometric "CS" logo
    // Left "C" shape
    final cPath = Path();
    cPath.moveTo(20 * scale, 35 * scale);
    cPath.quadraticBezierTo(15 * scale, 50 * scale, 20 * scale, 65 * scale);
    cPath.lineTo(20 * scale, 65 * scale);
    canvas.drawPath(cPath, paint);

    // Top left connector
    canvas.drawLine(
      Offset(20 * scale, 35 * scale),
      Offset(35 * scale, 25 * scale),
      paint,
    );

    // Bottom left connector
    canvas.drawLine(
      Offset(20 * scale, 65 * scale),
      Offset(35 * scale, 75 * scale),
      paint,
    );

    // Right "S" shape - top curve
    final sTopPath = Path();
    sTopPath.moveTo(50 * scale, 25 * scale);
    sTopPath.quadraticBezierTo(60 * scale, 25 * scale, 65 * scale, 35 * scale);
    sTopPath.quadraticBezierTo(70 * scale, 45 * scale, 60 * scale, 50 * scale);
    canvas.drawPath(sTopPath, paint);

    // Right "S" shape - bottom curve
    final sBottomPath = Path();
    sBottomPath.moveTo(60 * scale, 50 * scale);
    sBottomPath.quadraticBezierTo(70 * scale, 55 * scale, 65 * scale, 65 * scale);
    sBottomPath.quadraticBezierTo(60 * scale, 75 * scale, 50 * scale, 75 * scale);
    canvas.drawPath(sBottomPath, paint);
  }

  @override
  bool shouldRepaint(CodeSyncLogoPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
