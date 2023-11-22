import 'package:advance_math/advance_math.dart';
import 'package:flutter/material.dart';

import 'options.dart';
import 'sky_object.dart';
import 'sky_plot_painter.dart';

class SkyPlot extends StatelessWidget {
  final List<SkyData> skyData;
  final Map<String, Widget> categories;
  final SkyPlotOptions options;

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
            ...filteredSkyData.map((skyObject) {
              double sizeOfFlag = (skyObject.usedInFix ?? false
                      ? options.baseRadiusInFix
                      : options.baseRadiusNotInFix) *
                  2;

              // Convert azimuth and elevation to Cartesian coordinates
              double radAzimuth = (skyObject.azimuthDegrees! - 90) * (pi / 180);
              double satelliteRadius =
                  radius * (90 - skyObject.elevationDegrees!) / 90;
              Offset satellitePosition = Offset(
                center.dx + satelliteRadius * cos(radAzimuth) - sizeOfFlag / 2,
                center.dy + satelliteRadius * sin(radAzimuth) - sizeOfFlag / 2,
              );

              return Positioned(
                left: satellitePosition.dx,
                top: satellitePosition.dy,
                child: SatelliteFlagWidget(
                  satellite: skyObject,
                  size: sizeOfFlag,
                  options: options,
                  child: categories[skyObject.category]!,
                ),
              );
            }),
          ],
        );
      },
    );
  }
}

class SatelliteFlagWidget extends StatelessWidget {
  final Widget? child;
  final SkyData satellite;
  final double size;
  final SkyPlotOptions options;

  const SatelliteFlagWidget({
    super.key,
    this.child,
    required this.satellite,
    required this.size,
    required this.options,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        SkyObject(
          isUsedInFix: satellite.usedInFix,
          size: size,
          child: child,
        ),
        Positioned(
          top: options.idTextPosition.top,
          bottom: options.idTextPosition.bottom,
          right: options.idTextPosition.right,
          left: options.idTextPosition.left,
          height: options.idTextPosition.height,
          width: options.idTextPosition.width,
          child: Text(
            '${satellite.id}',
            style: satellite.usedInFix ?? false
                ? options.satelliteIdInFixTextStyle
                : options.satelliteIdNotInFixTextStyle,
          ),
        ),
      ],
    );
  }
}

class SkyData {
  const SkyData({
    this.azimuthDegrees,
    this.category,
    this.elevationDegrees,
    this.id,
    this.usedInFix,
  });

  final double? azimuthDegrees;
  final String? category;
  final double? elevationDegrees;
  final String? id;
  final bool? usedInFix;
}
