import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_application_5/constants/colors/app_colors.dart';

class Landingdistancebar extends StatelessWidget {
  final String? lda;
  final String? opLd;
  final double width;

  const Landingdistancebar({
    super.key,
    this.lda,
    this.opLd,
    this.width = 220,
  });

  @override
  Widget build(BuildContext context) {
    final double ldaValue = double.tryParse(lda ?? '') ?? 0;
    final double opLdValue = double.tryParse(opLd ?? '') ?? 0;

    const double marginX = 12;      // Margen horizontal
    const double marginTop = 18;    // Espacio superior para que el texto de LDA no se corte
    const double marginBottom = 10; // Margen inferior
    const double cardHeight = 85;

    final double ratio = ldaValue > 0 ? opLdValue / ldaValue : 0.0;

    final Color barColor;
    if (opLdValue > ldaValue) {
      barColor = AppColors.red;
    } else if (opLdValue >= ldaValue * 0.95) {
      barColor = Colors.amber;
    } else {
      barColor = AppColors.green;
    }

    return SizedBox(
      width: width,
      height: cardHeight,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double runwayWidth = constraints.maxWidth - (marginX * 2);
          const double maxRatio = 1.10;
          final double visualRatio = ratio.clamp(0.0, maxRatio);

          final double ldaX = marginX + runwayWidth * (1.0 / maxRatio);
          final double opLdX = marginX + runwayWidth * (visualRatio / maxRatio);

          return Stack(
            clipBehavior: Clip.none,
            children: [
              // Control de la grafica de la pista principal (fondo y lineas)
              Positioned.fill(
                child: CustomPaint(
                  painter: _RunwayPainterHorizontal(
                    marginTop: marginTop,
                    marginBottom: marginBottom,
                    marginX: marginX,
                  ),
                ),
              ),

              // Barra de OpLD
              AnimatedPositioned(
                duration: const Duration(milliseconds: 450),
                curve: Curves.easeInOut,
                top: marginTop,
                bottom: marginBottom,
                left: marginX,
                right: math.max(0.0, constraints.maxWidth - opLdX),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    color: barColor.withOpacity(0.48),
                    borderRadius: BorderRadius.horizontal(
                      left: const Radius.circular(5),
                      right: visualRatio >= 1.05
                          ? const Radius.circular(5)
                          : const Radius.circular(3),
                    ),
                    border: Border.all(
                      color: barColor.withOpacity(0.85),
                      width: 1.5,
                    ),
                  ),
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 6),
                ),
              ),

              // Linea divisora de LDA negra
              Positioned(
                top: marginTop - 2,
                bottom: marginBottom - 2,
                left: ldaX,
                width: 2.5,
                child: Container(
                  color: AppColors.black,
                ),
              ),

              // Control del texto LDA de afuera de la grafica
              Positioned(
                left: ldaX - 12,
                top: -5,
                child: const Text(
                  'LDA',
                  style: TextStyle(
                    color: AppColors.resultNotes,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _RunwayPainterHorizontal extends CustomPainter {
  final double marginTop;
  final double marginBottom;
  final double marginX;

  _RunwayPainterHorizontal({
    this.marginTop = 18,
    this.marginBottom = 10,
    this.marginX = 12,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Cuerpo de la pista
    final Rect runwayRect = Rect.fromLTWH(
      marginX,
      marginTop,
      size.width - (marginX * 2),
      size.height - marginTop - marginBottom,
    );

    final RRect runway = RRect.fromRectAndRadius(
      runwayRect,
      const Radius.circular(5),
    );

    final Paint runwayPaint = Paint()
      ..color = const Color(0xFF6B6B6B)
      ..style = PaintingStyle.fill;

    canvas.drawRRect(runway, runwayPaint);

    // Borde blanco de la pista
    final Paint borderPaint = Paint()
      ..color = AppColors.white
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    canvas.drawRRect(runway, borderPaint);

    // Línea central discontinua
    final double centerY = marginTop + (runwayRect.height / 2);
    final Paint centerPaint = Paint()
      ..color = AppColors.white
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.square;

    const double dashWidth = 10;
    const double dashGap = 6;

    double x = marginX + 4;
    while (x < size.width - marginX - 4) {
      final double endX = math.min(
        x + dashWidth,
        size.width - marginX - 4,
      );

      canvas.drawLine(
        Offset(x, centerY),
        Offset(endX, centerY),
        centerPaint,
      );

      x += dashWidth + dashGap;
    }
  }

  @override
  bool shouldRepaint(covariant _RunwayPainterHorizontal oldDelegate) {
    return oldDelegate.marginTop != marginTop ||
        oldDelegate.marginBottom != marginBottom ||
        oldDelegate.marginX != marginX;
  }
}