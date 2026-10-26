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
    this.width = 285,
  });

  @override
  Widget build(BuildContext context) {
    final double ldaValue = double.tryParse(lda ?? '') ?? 0;
    final double opLdValue = double.tryParse(opLd ?? '') ?? 0;
    final double remainingValue = ldaValue - opLdValue;
    //final double remainingValue = math.max(0.0, ldaValue - opLdValue);
    final orientation = MediaQuery.of(context).orientation == Orientation.landscape;

    const double marginX = 12;      //Margen horizontal de la grafica de la pista
    const double marginTop = 4;     //Margen superior dentro del lienzo de la pista
    const double marginBottom = 4;  //Margen inferior dentro del lienzo de la pista
    const double runwayHeight = 90; //Altura del asfalto

    final double ratio = ldaValue > 0 ? (opLdValue / ldaValue) : 0.0;
    //final int opLdPercent = (ratio * 100).round().clamp(0, 100);
    //final int remainingPercent = (100 - opLdPercent).clamp(0, 100);

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
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double runwayWidth = constraints.maxWidth - (marginX * 2);
          final double visualRatio = ratio.clamp(0.0, 1.0);
          final double opLdX = marginX + (runwayWidth * visualRatio);

          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: marginX),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Textos del apartado de OpLD
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'OpLD:',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: orientation ? 21 : 18,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            '${opLdValue.round()} ft',
                            style: TextStyle(
                              color: barColor,
                              fontSize: orientation ? 21 : 18,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            '${(opLdValue * 0.3048).round()}m',
                            //'${(opLdValue * 0.3048).round()}m | $opLdPercent%',
                            style: TextStyle(
                              color: barColor,
                              fontSize: orientation ? 18 : 16.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    //Textos del apartado de Remaining 
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Remaining:',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: orientation ? 20 : 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          //SizedBox(height: orientation ? 3 : 3),
                          
                          Text(
                            '${remainingValue.round()} ft',
                            style: TextStyle(
                              color: barColor,
                              fontSize: orientation ? 20 : 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                         // SizedBox(height: orientation ? 3 : 3),
                          
                          Text(
                            '${(remainingValue * 0.3048).round()}m',
                            //'${(remainingValue * 0.3048).round()}m | $remainingPercent%',
                            style: TextStyle(
                              color: barColor,
                              fontSize: orientation ? 18 : 16.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 6),

              //Linea sincronizada de OpLD y Remaining
              SizedBox(
                height: 12,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    //Linea horizontal alineada con el asfalto de OpLD y Remaining
                    Positioned(
                      left: marginX,
                      right: marginX,
                      top: 8,
                      child: Container(
                        height: 2.5,
                        color: barColor,
                      ),
                    ),
                    //Linea vertical divisoria sincronizada de OpLD y Remaining
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 450),
                      curve: Curves.easeInOut,
                      left: opLdX - 1.25,
                      top: 4,
                      child: Container(
                        width: 2.5,
                        height: 10,
                        color: barColor,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 2),

              //Grafica de pista de aterrizaje
              SizedBox(
                height: runwayHeight,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    //Asfalto, umbral y lineas
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _RunwayPainterHorizontal(
                          marginTop: marginTop,
                          marginBottom: marginBottom,
                          marginX: marginX,
                        ),
                      ),
                    ),

                    //Barra de OpLD
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
                            right: visualRatio >= 0.98
                                ? const Radius.circular(5)
                                : const Radius.circular(3),
                          ),
                          border: Border.all(
                            color: barColor.withOpacity(0.85),
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 4),

              //Linea de Net LDA
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: marginX),
                child: Container(
                  height: 2.5,
                  color: const Color(0xFF2196F3),
                ),
              ),

              const SizedBox(height: 6),

              //Textos del apartado de Net LDA
              Center(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: orientation ? 20 : 18.5, fontWeight: FontWeight.bold),
                    children: [
                      const TextSpan(
                        text: 'Net LDA: ',
                        style: TextStyle(color: AppColors.white),
                      ),
                      TextSpan(
                        text: '${ldaValue.round()} ft | ${(ldaValue * 0.3048).round()}m',
                        style: const TextStyle(color: Color(0xFF2196F3)),
                      ),
                    ],
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
    this.marginTop = 12,
    this.marginBottom = 12,
    this.marginX = 12,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double runwayHeight = size.height - marginTop - marginBottom;
    final double runwayTotalWidth = size.width - (marginX * 2);

    //Asfalto
    final Rect runwayRect = Rect.fromLTWH(
      marginX,
      marginTop,
      runwayTotalWidth,
      runwayHeight,
    );

    final RRect runway = RRect.fromRectAndRadius(
      runwayRect,
      const Radius.circular(5),
    );

    final Paint runwayPaint = Paint()
      ..color = const Color(0xFF6B6B6B)
      ..style = PaintingStyle.fill;

    canvas.drawRRect(runway, runwayPaint);

    //Borde 
    final Paint borderPaint = Paint()
      ..color = AppColors.white
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    canvas.drawRRect(runway, borderPaint);

    //Umbral 
    final Paint thresholdPaint = Paint()
      ..color = AppColors.white
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.square
      ..style = PaintingStyle.stroke;

    const int barCount = 10;
    const double thresholdLength = 20;
    final double startX = marginX + 6;

    const double verticalPadding = 2;
    final double availableHeight = runwayHeight - (verticalPadding * 2);
    final double spacing = availableHeight / (barCount + 1);

    for (int i = 1; i <= barCount; i++) {
      final double y = marginTop + verticalPadding + (spacing * i);
      canvas.drawLine(
        Offset(startX, y),
        Offset(startX + thresholdLength, y),
        thresholdPaint,
      );
    }

    //Linea central de la pista
    final double centerY = marginTop + (runwayHeight / 2);
    final Paint centerPaint = Paint()
      ..color = AppColors.white
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.square;

    const double dashWidth = 10;
    const double dashGap = 6;

    double x = startX + thresholdLength + 10.0;
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