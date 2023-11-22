import 'dart:math';

import 'package:flutter/material.dart';

import 'options.dart';
import 'sky_plot.dart';

class SkyPlotPainter extends CustomPainter {
  final List<SkyData>? skyData;
  final BuildContext context;
  final SkyPlotOptions options;

  SkyPlotPainter(this.skyData, this.context, this.options);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final paint = Paint()
      ..color = Theme.of(context).colorScheme.primary
      ..style = PaintingStyle.stroke;

    // Draw horizon circle
    canvas.drawCircle(center, radius, paint);

    // Draw divisions
    drawDivisions(canvas, size, center, radius);

    if (options.showAzimuthDivisionTexts) {
      // Draw  degree text
      drawDegreeText(context, canvas, size, center, radius);
    }
    if (options.showDirectionalText) {
      // Draw directions
      drawDirectionLabels(canvas, size, center, radius);
    }

    if (options.showElevationDivisionTexts) {
      // Draw elevation degree text
      drawElevationText(context, canvas, size, center, radius);
    }

    // Draw north arrow
    drawNorth(canvas, size, center, radius);

    for (int i = 1; i <= options.elevationDivisions; i++) {
      double ringRadius = radius * i / (options.elevationDivisions + 1);
      canvas.drawCircle(center, ringRadius, options.elevationRingPaint);
    }
  }

  void drawElevationText(BuildContext context, Canvas canvas, Size size,
      Offset center, double radius) {
    // Color textColor = Theme.of(context).colorScheme.primary;

    for (int i = 1; i <= options.elevationDivisions; i++) {
      double ringRadius = radius * i / (options.elevationDivisions + 1);
      String elevationText =
          '${(90 - (90 * i / (options.elevationDivisions + 1))).round()}°';
      options.textPainter.text =
          TextSpan(text: elevationText, style: options.elevationTextStyle);
      options.textPainter.layout();
      canvas.save();

      // Adjusting the translation to draw the text towards the south
      canvas.translate(center.dx, center.dy + ringRadius);

      // Adjusting the text position to be centered
      options.textPainter.paint(
          canvas,
          Offset(
              -options.textPainter.width / 2, -options.textPainter.height / 2));

      canvas.restore();
    }
  }

  void drawNorth(Canvas canvas, Size size, Offset center, double radius) {
    Offset northEnd = center + Offset(0, -radius);
    if (options.showNorthArrowLine) {
      // Draw North indicator line with gradient
      final northLinePaint = options.northArrowLinePaint ?? Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.blue, Colors.red],
        ).createShader(Rect.fromPoints(center, center + Offset(0, -radius)))
        ..strokeWidth = 2;

      canvas.drawLine(center, northEnd, northLinePaint);
    }

    if (options.showNorthArrowHead) {
      Path arrowPath = Path();
      arrowPath.moveTo(northEnd.dx, northEnd.dy); // Top of the arrow
      arrowPath.lineTo(northEnd.dx - options.arrowHeadWidth / 2,
          northEnd.dy + options.arrowHeadHeight); // Bottom left
      arrowPath.lineTo(northEnd.dx + options.arrowHeadWidth / 2,
          northEnd.dy + options.arrowHeadHeight); // Bottom right
      arrowPath.close();

      canvas.drawPath(arrowPath, options.arrowPaint);
    }
  }

  void drawDivisions(Canvas canvas, Size size, Offset center, double radius) {
    for (int i = 0; i < 360; i += options.azimuthDivisions) {
      double rad = i * (pi / 180);
      double totalLength = radius;
      double currentLength = 0.0;

      // draw division with dotted lines
      if (options.showAzimuthDivisions) {
        while (currentLength < totalLength) {
          final startDash = Offset(
            center.dx + (currentLength / totalLength) * radius * cos(rad),
            center.dy + (currentLength / totalLength) * radius * sin(rad),
          );
          currentLength += options.dashWidth;
          final endDash = Offset(
            center.dx + (currentLength / totalLength) * radius * cos(rad),
            center.dy + (currentLength / totalLength) * radius * sin(rad),
          );
          currentLength += options.dashSpace;

          canvas.drawLine(startDash, endDash, options.dottedLinePaint);
        }
      }

      //Draw division ticks
      if (options.showAzimuthDivisionTick) {
        Offset start = center + Offset(cos(rad) * radius, sin(rad) * radius);
        Offset end = center +
            Offset(
                cos(rad) * (radius - options.azimuthDivisionTickWith),
                sin(rad) *
                    (radius -
                        options
                            .azimuthDivisionTickWith)); // Adjust 10 for division length
        canvas.drawLine(start, end, options.divisionLinePaint);
      }
    }
  }

  void drawDegreeText(BuildContext context, Canvas canvas, Size size,
      Offset center, double radius) {
    // Adjust the angle so that 0 degrees is at the top
    for (int i = 0; i < 360; i += options.azimuthDivisions) {
      double radian = (i - 90) * (pi / 180);
      Offset position = Offset(
        center.dx + (radius + options.horizontalTextOffset) * cos(radian),
        center.dy + (radius + options.horizontalTextOffset) * sin(radian),
      );

      // Rotate the canvas to align the text with the division
      canvas.save();
      canvas.translate(position.dx, position.dy);

      // Rotate text, add pi to align horizontally
      canvas.rotate(radian +
          (options.allAzimuthTextsLTR
              ? (i < 180
                  ? options.divisionTextRotation / 180
                  : options.divisionTextRotation)
              : 0));

      //canvas.rotate(radian + (i < 180 ? pi / 180 : pi));

      // Apply vertical offset here
      options.textPainter.text = TextSpan(
        text: '$i°'.padLeft(3),
        style: options.azimuthTextStyle,
      );
      options.textPainter.layout();
      options.textPainter.paint(
          canvas,
          Offset(-options.textPainter.width / 2,
              -options.textPainter.height / 2 + options.verticalTextOffset));

      canvas.restore(); // Restore the canvas to its original state
    }
  }

  void drawDirectionLabels(
      Canvas canvas, Size size, Offset center, double radius) {
    final Map<int, String> directionLabels = {
      0: 'N',
      22: 'NNE',
      45: 'NE',
      67: 'ENE',
      90: 'E',
      112: 'ESE',
      135: 'SE',
      157: 'SSE',
      180: 'S',
      202: 'SSW',
      225: 'SW',
      247: 'WSW',
      270: 'W',
      292: 'WNW',
      315: 'NW',
      337: 'NNW'
    };

    int step;
    switch (options.directionDetail) {
      case DirectionDetail.none:
        return;
      case DirectionDetail.two:
        step = 180;
        break;
      case DirectionDetail.four:
        step = 90;
        break;
      case DirectionDetail.eight:
        step = 45;
        break;
      case DirectionDetail.sixteen:
        step = 22; // Or appropriate value for 16 directions
        break;
    }

    for (int i = 0; i < 360; i += step) {
      if (directionLabels.containsKey(i)) {
        double rad = (i - 90) * (pi / 180);
        Offset position = Offset(
          center.dx +
              (radius + options.directionHorizontalTextOffset) * cos(rad),
          center.dy +
              (radius + options.directionHorizontalTextOffset) * sin(rad),
        );

        canvas.save();
        canvas.translate(position.dx, position.dy);
        canvas.rotate(rad + pi / 2);

        options.textPainter.text = TextSpan(
          text: directionLabels[i],
          style: options.directionTextStyle,
        );
        options.textPainter.layout();
        options.textPainter.paint(
          canvas,
          Offset(
              -options.textPainter.width / 2,
              -options.textPainter.height / 2 +
                  options.directionVerticalTextOffset),
        );

        canvas.restore();

        Offset start = center + Offset(cos(rad) * radius, sin(rad) * radius);
        Offset end = center +
            Offset(cos(rad) * (radius - 5),
                sin(rad) * (radius - 5)); // Adjust 10 for division length
        canvas.drawLine(start, end, options.divisionLinePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant SkyPlotPainter oldDelegate) {
    return oldDelegate.skyData != skyData;
  }
}
