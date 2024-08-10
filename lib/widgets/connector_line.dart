import 'package:flutter/material.dart';

class ConnectorLine extends StatelessWidget {
  final double indent;  // Indentação para ajustar a posição das linhas
  final bool hasChildren;  // Se o nó tem filhos ou não

  ConnectorLine({required this.indent, this.hasChildren = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: indent,
      child: CustomPaint(
        painter: _LinePainter(hasChildren),
      ),
    );
  }
}

class _LinePainter extends CustomPainter {
  final bool hasChildren;

  _LinePainter(this.hasChildren);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 2.0;

    // Linha vertical
    canvas.drawLine(Offset(size.width / 2, 0), Offset(size.width / 2, size.height), paint);

    // Linha horizontal apenas se o nó tiver filhos
    if (hasChildren) {
      canvas.drawLine(Offset(size.width / 2, size.height / 2), Offset(size.width, size.height / 2), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
