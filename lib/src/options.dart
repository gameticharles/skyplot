import 'dart:math';

import 'package:flutter/material.dart';

import 'id_text_position.dart';

/// Enumeration for the levels of detail in displaying cardinal and intercardinal directions.
///
/// This enum determines how many direction labels (e.g., N, NE, E) are displayed on the sky plot.
///
/// - [none]: No direction labels are displayed.
/// - [two]: Displays two primary cardinal directions: North (N) and South (S).
/// - [four]: Displays four primary cardinal directions: North (N), East (E), South (S), and West (W).
/// - [eight]: Displays the four cardinal directions and four intercardinal directions:
///   Northeast (NE), Southeast (SE), Southwest (SW), and Northwest (NW).
/// - [sixteen]: Displays all cardinal and intercardinal directions, including the secondary
///   intercardinal directions: North-Northeast (NNE), East-Northeast (ENE), East-Southeast (ESE),
///   South-Southeast (SSE), South-Southwest (SSW), West-Southwest (WSW), West-Northwest (WNW),
///   and North-Northwest (NNW).
enum DirectionDetail {
  /// No direction labels are displayed.
  ///
  /// This option is suitable for minimalistic designs where direction labels are not required.
  none,

  /// Displays only one cardinal direction: North (N).
  ///
  /// This option provides a basic orientation reference, suitable for simple directional needs.
  one,

  /// Displays two primary cardinal directions: North (N) and South (S).
  ///
  /// This option provides a basic orientation reference, suitable for simple directional needs.
  two,

  /// Displays four primary cardinal directions: North (N), East (E), South (S), and West (W).
  /// This option is a standard choice for basic navigation and orientation purposes.
  four,

  /// Displays the four cardinal directions and four intercardinal directions:
  /// Northeast (NE), Southeast (SE), Southwest (SW), and Northwest (NW).
  ///
  /// This option offers more detailed directional guidance without being overly complex.
  eight,

  /// Displays all cardinal and intercardinal directions, including the secondary
  /// intercardinal directions: North-Northeast (NNE), East-Northeast (ENE),
  /// East-Southeast (ESE), South-Southeast (SSE), South-Southwest (SSW),
  /// West-Southwest (WSW), West-Northwest (WNW), and North-Northwest (NNW).
  ///
  /// This option provides the most detailed directional information, suitable for precise orientation.
  sixteen
}

/// Options class for configuring the appearance and behavior of the SkyPlot widget.
///
/// This class allows customization of various aspects of the SkyPlot,
/// such as text styles, radii, divisions, offsets, and paints.
class SkyPlotOptions {
  /// Text style for azimuth divisions.
  final TextStyle azimuthTextStyle;

  /// Text style for cardinal or directions.
  final TextStyle directionTextStyle;

  /// Text style for elevation divisions.
  final TextStyle elevationTextStyle;

  /// Text style for satellite ID when not in fix.
  final TextStyle satelliteIdNotInFixTextStyle;

  /// Text style for satellite ID when in fix.
  final TextStyle satelliteIdInFixTextStyle;

  /// Base radius for satellites not in fix.
  final double baseRadiusNotInFix;

  /// Base radius for satellites in fix.
  final double baseRadiusInFix;

  /// Number of divisions for azimuth.
  final int azimuthDivisions;

  /// Number of divisions for elevation.
  final int elevationDivisions;

  /// Rotation angle (in radians) for division text.
  final double divisionTextRotation;

  /// Width of the tick mark at each azimuth division.
  final double azimuthDivisionTickWith;

  /// Horizontal offset for text positioning. Negative values move text towards the center.
  final double horizontalTextOffset;

  /// Vertical offset for text positioning.
  final double verticalTextOffset;

  /// Horizontal offset for text positioning. Negative values move text towards the center.
  final double elevationHorizontalTextOffset;

  /// Vertical offset for text positioning.
  final double elevationVerticalTextOffset;

  /// Horizontal offset for direction text positioning. Negative values move text towards the center.
  final double directionHorizontalTextOffset;

  /// Vertical offset for direction text positioning.
  final double directionVerticalTextOffset;

  /// Paint used for the horizon circle.
  final Paint horizonCirclePaint;

  /// Paint used for elevation rings.
  final Paint elevationRingPaint;

  /// Paint used for division lines.
  final Paint divisionLinePaint;

  /// Paint used for dotted lines.
  final Paint dottedLinePaint;

  /// Paint used for the arrow.
  final Paint arrowPaint;

  /// Width of the north arrow head.
  final double arrowHeadWidth;

  /// Height of the north arrow head.
  final double arrowHeadHeight;

  /// Paint used for the north arrow line.
  final Paint? northArrowLinePaint;

  /// Whether to show azimuth divisions.
  final bool showAzimuthDivisions;

  /// Whether to show azimuth division texts.
  final bool showAzimuthDivisionTexts;

  /// Whether to show azimuth division tick marks.
  final bool showAzimuthDivisionTick;

  /// Whether all azimuth texts are Left-To-Right.
  final bool allAzimuthTextsLTR;

  /// Whether to show elevation divisions.
  final bool showElevationDivisions;

  /// Whether to show elevation division texts.
  final bool showElevationDivisionTexts;

  /// Whether to show the north arrow head.
  final bool showNorthArrowHead;

  /// Show the north arrow line
  final bool showNorthArrowLine;

  /// Show directional text on the plot
  final bool showDirectionalText;

  /// Whether to show directional ticks
  final bool showDirectionDivisionTicks;

  /// Show sky object not used in fix
  final bool showSkyObjectNotInFix;

  /// Width of the dash in dotted lines.
  final double dashWidth;

  /// Space between dashes in dotted lines.
  final double dashSpace;

  /// TextPainter used for drawing text.
  final TextPainter textPainter;

  /// Position of the satellite ID text.
  final SkyObjectIDTextPosition idTextPosition;

  /// Specifies the level of detail for direction labels.
  final DirectionDetail directionDetail;

  /// Decoration of the container for sky objects in fix
  final BoxDecoration? skyObjectInFixDecoration;

  /// Decoration of the container for sky objects not used in fix
  final BoxDecoration? skyObjectNotInFixDecoration;

  /// Constructs a [SkyPlotOptions] instance with given parameters.
  SkyPlotOptions({
    this.azimuthTextStyle =
        const TextStyle(fontSize: 10, fontWeight: FontWeight.normal),
    this.directionTextStyle =
        const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
    this.elevationTextStyle =
        const TextStyle(fontSize: 10, fontWeight: FontWeight.normal),
    this.satelliteIdNotInFixTextStyle = const TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.normal,
      shadows: [
        Shadow(
          offset: Offset(1.5, 1.5),
          color: Colors.grey,
          blurRadius: 3,
        ),
      ],
    ),
    this.satelliteIdInFixTextStyle = const TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.bold,
      shadows: [
        Shadow(
          offset: Offset(1.5, 1.5),
          color: Colors.grey,
          blurRadius: 3,
        ),
      ],
    ),
    this.baseRadiusNotInFix = 6.0,
    this.baseRadiusInFix = 8.0,
    this.azimuthDivisions = 30,
    this.elevationDivisions = 2,
    this.horizontalTextOffset = -13.0,
    this.verticalTextOffset = -5.0,
    this.directionHorizontalTextOffset = 5.0,
    this.directionVerticalTextOffset = 0.0,
    this.elevationHorizontalTextOffset = 5.0,
    this.elevationVerticalTextOffset = 0.0,
    this.divisionTextRotation = pi, //radians
    this.azimuthDivisionTickWith = 20,
    this.showAzimuthDivisionTick = true,
    this.showAzimuthDivisions = true,
    this.showAzimuthDivisionTexts = true,
    this.allAzimuthTextsLTR = false,
    this.showElevationDivisions = true,
    this.showElevationDivisionTexts = true,
    this.showNorthArrowHead = true,
    this.showDirectionalText = true,
    this.showDirectionDivisionTicks = true,
    this.showNorthArrowLine = false,
    this.showSkyObjectNotInFix = true,
    this.dashWidth = 5.0,
    this.dashSpace = 3.0,
    this.directionDetail = DirectionDetail.eight,
    SkyObjectIDTextPosition? idTextPosition,
    Paint? horizonCirclePaint,
    Paint? elevationRingPaint,
    Paint? divisionLinePaint,
    Paint? dottedLinePaint,
    TextPainter? textPainter,
    this.northArrowLinePaint,
    Paint? arrowPaint,
    this.arrowHeadWidth = 15.0,
    this.arrowHeadHeight = 20.0,
    BoxDecoration? skyObjectInFixDecoration,
    BoxDecoration? skyObjectNotInFixDecoration,
  })  : idTextPosition = idTextPosition ??
            const SkyObjectIDTextPosition(bottom: -6.0, right: -8.0),
        horizonCirclePaint = horizonCirclePaint ?? Paint()
          ..color = Colors.blue
          ..style = PaintingStyle.stroke,
        elevationRingPaint = elevationRingPaint ?? Paint()
          ..color = Colors.grey.withOpacity(0.5)
          ..style = PaintingStyle.stroke,
        divisionLinePaint = divisionLinePaint ?? Paint()
          ..color = Colors.grey
          ..strokeWidth = 1
          ..style = PaintingStyle.stroke,
        dottedLinePaint = dottedLinePaint ?? Paint()
          ..color = Colors.grey.withOpacity(0.5)
          ..strokeWidth = 1
          ..style = PaintingStyle.stroke,
        arrowPaint = arrowPaint ?? Paint()
          ..color = Colors.red
          ..style = PaintingStyle.fill,
        // Get the text color from the theme
        skyObjectInFixDecoration = skyObjectInFixDecoration ??
            const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green,
              boxShadow: [
                BoxShadow(
                  offset: Offset(1.5, 1.5),
                  color: Colors.grey,
                  blurRadius: 3,
                ),
              ],
            ),
        skyObjectNotInFixDecoration = skyObjectNotInFixDecoration ??
            const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.lightBlueAccent,
              boxShadow: [
                BoxShadow(
                  offset: Offset(1.5, 1.5),
                  color: Colors.grey,
                  blurRadius: 3,
                ),
              ],
            ),
        textPainter =
            textPainter ?? TextPainter(textDirection: TextDirection.ltr);
}
