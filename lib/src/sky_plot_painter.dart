import 'package:advance_math/advance_math.dart';
import 'package:flutter/material.dart';

import 'options.dart';
import 'radar_options.dart';
import 'sky_data.dart';

/// A custom painter for drawing a sky plot visualization.
///
/// This painter is responsible for drawing a representation of sky objects (like satellites)
/// based on their azimuth and elevation data. It also supports additional features like
/// radar sweep animation and directional labels.
///
/// The painter uses the provided [SkyPlotOptions] and [RadarSweepOptions] to customize
/// the appearance and behavior of the plot.
///
/// [skyData]: A list of [SkyData] objects representing the sky objects to be visualized.
/// [context]: The build context from which the painter can obtain theming information.
/// [options]: Configuration options for the sky plot.
/// [sweepAngle]: The current angle of the radar sweep, used when [showRadar] is true.
/// [radarSweepOptions]: Configuration options for the radar sweep.
/// [showRadar]: A flag indicating whether the radar sweep animation should be shown.
class SkyPlotPainter extends CustomPainter {
  final List<SkyData>? skyData;
  final BuildContext context;
  final SkyPlotOptions options;
  final double sweepAngle;
  final RadarSweepOptions radarSweepOptions;
  final bool showRadar;

  SkyPlotPainter(
    this.skyData,
    this.context,
    this.options,
    this.sweepAngle,
    this.showRadar,
    this.radarSweepOptions,
  );

  @override
  void paint(Canvas canvas, Size size) {
    //Compute the center
    final center = Offset(size.width / 2, size.height / 2);

    // Compute the radius
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

    if (showRadar) {
      // Draw radar sweep
      drawRadarSweep(canvas, size, sweepAngle, center, radius);
    }
  }

  /// Draws the radar sweep animation on the canvas.
  ///
  /// This method handles the drawing of the radar sweep, including the moving line
  /// and its trailing shadow. The radar sweep's appearance is controlled by [radarSweepOptions].
  ///
  /// [canvas]: The canvas on which to draw.
  /// [size]: The size of the drawing area.
  /// [angle]: The current angle of the radar sweep.
  /// [center]: The center point of the radar sweep.
  /// [radius]: The radius of the radar sweep.
  void drawRadarSweep(
      Canvas canvas, Size size, double angle, Offset center, double radius) {
    // Rotate the canvas so 0 degrees is at the top
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(-pi / 2); // Rotate 90 degrees counter-clockwise
    canvas.translate(-center.dx, -center.dy);

    // Radar sweep line paint
    Paint sweepPaint = Paint()
      ..color = radarSweepOptions.sweepColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = radarSweepOptions.sweepStrokeWidth;

    // Trailing shadow sector
    double startAngle =
        toRadians((angle - radarSweepOptions.shadowAngle + 360) % 360);
    double sweepAngle = toRadians(radarSweepOptions.shadowAngle);

    // Gradient for the shadow sector
    var gradientShader = SweepGradient(
      center: Alignment.center,
      startAngle: startAngle,
      endAngle: startAngle + sweepAngle,
      colors: [
        radarSweepOptions.shadowColor.withOpacity(0.01),
        radarSweepOptions.shadowColor
            .withOpacity(radarSweepOptions.shadowOpacity),
      ],
    ).createShader(Rect.fromCircle(center: center, radius: radius));

    // Shadow sector paint
    Paint shadowPaint = Paint()
      ..shader = gradientShader
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius;

    // Draw the radar sweep line and shadow sector
    drawSweep(
        canvas, center, radius, angle, sweepPaint, shadowPaint, gradientShader);

    // When the angle approaches 360 degrees, start drawing the next sweep cycle
    if (angle > 360 - radarSweepOptions.shadowAngle) {
      double overlapAngle = angle - 360;
      drawSweep(canvas, center, radius, overlapAngle, sweepPaint, shadowPaint,
          gradientShader);
    }

    // Restore the canvas rotation
    canvas.restore();
  }

  /// Draws the radar sweep along with its trailing shadow sector.
  ///
  /// This function is responsible for drawing both the radar sweep line and its trailing shadow,
  /// giving an effect of a radar scanning the sky plot.
  void drawSweep(Canvas canvas, Offset center, double radius, double angle,
      Paint sweepPaint, Paint shadowPaint, Shader gradientShader) {
    // Ensure angle is within 0 - 360 range
    angle = angle % 360;

    // Calculate end point of the radar line
    Offset sweepEnd = center +
        Offset(radius * cos(toRadians(angle)), radius * sin(toRadians(angle)));

    // Draw the radar sweep line
    canvas.drawLine(center, sweepEnd, sweepPaint);

    // Trailing shadow sector
    double startAngle =
        toRadians((angle - radarSweepOptions.shadowAngle + 360) % 360);
    double sweepAngle = toRadians(radarSweepOptions.shadowAngle);

    // Update the shader for the shadow paint
    shadowPaint.shader = gradientShader;

    // Draw the trailing shadow sector
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius / 2),
        startAngle, sweepAngle, false, shadowPaint);
  }

  /// Draws elevation texts on the sky plot.
  ///
  /// This method renders elevation degree texts at specified intervals on the sky plot.
  /// The positioning and style of the texts are based on [options].
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
      canvas.translate(center.dx,
          center.dy + ringRadius + options.elevationHorizontalTextOffset);

      // Adjusting the text position to be centered
      options.textPainter.paint(
          canvas,
          Offset(
              -options.textPainter.width / 2,
              -options.textPainter.height / 2 +
                  options.elevationVerticalTextOffset));

      canvas.restore();
    }
  }

  /// Draws the north arrow on the sky plot.
  ///
  /// The north arrow is drawn to indicate the direction of north on the plot.
  /// Its appearance can be customized via [options].
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

  /// Draws the sky plot divisions on the canvas.
  ///
  /// This method handles the drawing of azimuth and elevation divisions.
  /// The divisions are drawn as lines or circles on the sky plot.
  ///
  /// [canvas]: The canvas on which to draw.
  /// [size]: The size of the drawing area.
  /// [center]: The center point of the sky plot.
  /// [radius]: The radius of the sky plot.
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

  /// Draws degree texts for azimuth divisions on the sky plot.
  ///
  /// This method renders texts at specified azimuth division intervals.
  /// The appearance and positioning of these texts are governed by [options].
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
        text: '$i°',
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

  /// Draws directional labels on the sky plot.
  ///
  /// This method renders labels for cardinal and intercardinal directions (e.g., N, NE, E, SE, etc.)
  /// at their respective azimuth angles on the sky plot. The labels are positioned
  /// based on the [radius] and [center] of the plot, with their appearance and visibility
  /// controlled by [options].
  ///
  /// The method supports different levels of detail in displaying direction labels as specified by
  /// [options.directionDetail], ranging from primary cardinal directions (N, E, S, W) to more
  /// detailed sixteen-point compass rose.
  void drawDirectionLabels(
      Canvas canvas, Size size, Offset center, double radius) {
    final Map<double, String> directionLabels = {
      0: 'N',
      22.5: 'NNE',
      45: 'NE',
      67.5: 'ENE',
      90: 'E',
      112.5: 'ESE',
      135: 'SE',
      157.5: 'SSE',
      180: 'S',
      202.5: 'SSW',
      225: 'SW',
      247.5: 'WSW',
      270: 'W',
      292.5: 'WNW',
      315: 'NW',
      337.5: 'NNW'
    };

    // Determine the step for iterating through direction labels based on the level of detail
    double step;
    switch (options.directionDetail) {
      case DirectionDetail.none:
        return; // Do not draw any labels if the detail level is set to none
      case DirectionDetail.one:
        drawLabelForDirection(
            canvas, center, radius, 0, 'N'); // Function to draw label for North
        return;
      case DirectionDetail.two:
        step = 180; // Only North and South
        break;
      case DirectionDetail.four:
        step = 90; // Cardinal directions: North, East, South, West
        break;
      case DirectionDetail.eight:
        step = 45; // Cardinal and ordinal directions (e.g., NE, SE)
        break;
      case DirectionDetail.sixteen:
        step =
            22.5; // Cardinal, ordinal, and secondary intercardinal directions
        break;
    }

    // Draw each label at its corresponding direction angle
    for (double i = 0; i <= 360; i += step) {
      if (directionLabels.containsKey(i)) {
        drawLabelForDirection(canvas, center, radius, i, directionLabels[i]!);
      }
    }
  }

  void drawLabelForDirection(
      Canvas canvas, Offset center, double radius, double angle, String label) {
    // Convert angle to radians adjusting for top orientation
    double rad = (angle - 90) * (pi / 180);
    Offset position = Offset(
      center.dx + (radius + options.directionHorizontalTextOffset) * cos(rad),
      center.dy + (radius + options.directionHorizontalTextOffset) * sin(rad),
    );

// Position and rotate the canvas for label drawing
    canvas.save();
    canvas.translate(position.dx, position.dy);
    canvas.rotate(rad + pi / 2);

    options.textPainter.text = TextSpan(
      text: label,
      style: options.directionTextStyle,
    );

    // Draw the label
    options.textPainter.layout();
    options.textPainter.paint(
      canvas,
      Offset(
          -options.textPainter.width / 2,
          -options.textPainter.height / 2 +
              options.directionVerticalTextOffset),
    );

    // Restore the original canvas state
    canvas.restore();

    // Optionally draw line markers for each direction
    if (options.showDirectionDivisionTicks) {
      Offset start = center + Offset(cos(rad) * radius, sin(rad) * radius);
      Offset end =
          center + Offset(cos(rad) * (radius - 5), sin(rad) * (radius - 5));
      canvas.drawLine(start, end, options.divisionLinePaint);
    }
  }

  /// Determines whether the painter should repaint.
  ///
  /// Repainting is required when the satellite data, plot options, or radar sweep angle changes.
  @override
  bool shouldRepaint(covariant SkyPlotPainter oldDelegate) {
    return oldDelegate.skyData != skyData ||
        oldDelegate.options != options || // Assuming options are comparable
        (showRadar &&
            oldDelegate.sweepAngle != sweepAngle); // Repaint for radar sweep
  }
}
