import 'package:advance_math/advance_math.dart';
import 'package:flutter/material.dart';

import 'options.dart';
import 'sky_data.dart';
import 'sky_object.dart';
import 'sky_plot_painter.dart';

/// A widget that displays a sky plot visualization for a list of sky objects.
///
/// The `SkyPlot` widget takes a list of [SkyData] objects representing sky objects
/// and visualizes their positions on a sky plot. It provides options to customize
/// the appearance and behavior of the plot.
///
/// Example usage:
/// ```dart
/// SkyPlot(
///   skyData: skyDataList,
///   categories: categoryWidgets,
///   options: SkyPlotOptions(),
/// )
/// ```
class SkyPlot extends StatelessWidget {
  /// The list of sky data representing sky objects to be visualized.
  final List<SkyData> skyData;

  /// A map of category names to corresponding widgets to display on the sky plot.
  final Map<String, Widget> categories;

  /// Options to customize the appearance and behavior of the sky plot.
  final SkyPlotOptions options;

  /// Creates a [SkyPlot] widget.
  ///
  /// The [skyData] parameter is required and should contain a list of [SkyData] objects
  /// representing the sky objects to be displayed on the sky plot.
  ///
  /// The [categories] parameter is a map that associates category names with
  /// corresponding widgets to display on the sky plot. These widgets will be used to
  /// represent different categories of sky objects.
  ///
  /// The [options] parameter allows customization of various aspects of the sky plot,
  /// such as text styles, radii, divisions, offsets, and paints.
  SkyPlot({
    super.key,
    required this.skyData,
    SkyPlotOptions? options,
    required this.categories,
  }) : options = options ?? SkyPlotOptions();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        var size = Size.square(constraints.biggest.shortestSide);
        var center = Offset(size.width / 2, size.height / 2);
        var radius = size.width / 2;

        // Filter skyData based on the option
        List<SkyData> filteredSkyData = options.showSkyObjectNotInFix
            ? skyData
            : skyData.where((data) => data.usedInFix ?? false).toList();

        return Stack(
          children: [
            CustomPaint(
              painter: SkyPlotPainter(
                skyData,
                context,
                options,
              ),
              size: size,
            ),
            ...filteredSkyData.map((skyObjectData) {
              double sizeOfFlag = (skyObjectData.usedInFix ?? false
                      ? options.baseRadiusInFix
                      : options.baseRadiusNotInFix) *
                  2;

              // Convert azimuth and elevation to Cartesian coordinates
              double radAzimuth =
                  (skyObjectData.azimuthDegrees! - 90) * (pi / 180);
              double satelliteRadius =
                  radius * (90 - skyObjectData.elevationDegrees!) / 90;
              Offset satellitePosition = Offset(
                center.dx + satelliteRadius * cos(radAzimuth) - sizeOfFlag / 2,
                center.dy + satelliteRadius * sin(radAzimuth) - sizeOfFlag / 2,
              );

              return Positioned(
                left: satellitePosition.dx,
                top: satellitePosition.dy,
                child: SkyObject(
                  skyData: skyObjectData,
                  size: sizeOfFlag,
                  options: options,
                  child: categories[skyObjectData.category]!,
                ),
              );
            }),
          ],
        );
      },
    );
  }
}
