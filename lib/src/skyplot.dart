import 'package:advance_math/advance_math.dart';
import 'package:flutter/material.dart';

import 'options.dart';
import 'radar_options.dart';
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
class SkyPlot extends StatefulWidget {
  /// The list of sky data representing sky objects to be visualized.
  final List<SkyData> skyData;

  /// A map of category names to corresponding widgets to display on the sky plot.
  final Map<String, Widget> categories;

  /// Options to customize the appearance and behavior of the sky plot.
  final SkyPlotOptions options;

  /// Options to customize the appearance and behavior of the sky plot.
  final RadarSweepOptions radarSweepOptions;

  /// Whether to show radar animation
  final bool showRadar;

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
    RadarSweepOptions? radarSweepOptions,
    required this.categories,
    this.showRadar = false,
  })  : options = options ?? SkyPlotOptions(),
        radarSweepOptions = radarSweepOptions ?? RadarSweepOptions();

  @override
  State<SkyPlot> createState() => _SkyPlotState();
}

class _SkyPlotState extends State<SkyPlot> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.radarSweepOptions.duration,
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: 0.0, end: 360.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void didUpdateWidget(SkyPlot oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showRadar != oldWidget.showRadar) {
      if (widget.showRadar) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        var size = Size.square(constraints.biggest.shortestSide);
        var center = Offset(size.width / 2, size.height / 2);
        // var radius = size.width / 2;

        double maxRadius = size.width / 2;

        // Reduce the radius if directional texts are shown to ensure they fit within the canvas
        if (widget.options.showDirectionalText) {
          maxRadius -= widget.options
              .directionHorizontalTextOffset; // Adjust this value as needed
        }

        // Use this adjusted radius for drawing the elements
        final radius = maxRadius - 5; // Additional padding for safety

        // Filter skyData based on the option
        List<SkyData> filteredSkyData = widget.options.showSkyObjectNotInFix
            ? widget.skyData
            : widget.skyData.where((data) => data.usedInFix ?? false).toList();

        return Stack(
          children: [
            CustomPaint(
              painter: SkyPlotPainter(
                filteredSkyData,
                context,
                widget.options,
                _animation.value,
                widget.showRadar,
                widget.radarSweepOptions,
              ),
              size: size,
              //
            ),
            ...filteredSkyData.map((skyObjectData) {
              double sizeOfFlag = (skyObjectData.usedInFix ?? false
                      ? widget.options.baseRadiusInFix
                      : widget.options.baseRadiusNotInFix) *
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
                  options: widget.options,
                  child: widget.categories[skyObjectData.category]!,
                ),
              );
            }),
          ],
        );
      },
    );
  }
}
