import 'package:flutter/material.dart';

import 'options.dart';
import 'sky_data.dart';

/// A widget that displays a sky object with an optional child widget.
///
/// The `SkyObject` widget is used within the `SkyPlot` widget to represent
/// individual sky objects, such as satellites. It can display a flag with an optional
/// child widget, such as an icon or text.
///
/// - [size]: The size of the container. Determines the diameter of the circular representation.
/// - [child]: A widget to display inside the circle. This could represent a satellite's flag or other relevant iconography.
class SkyObject extends StatelessWidget {
  /// The optional child widget to display within the sky object widget.
  final Widget? child;

  /// The option sky data representing the object.
  final SkyData? skyData;

  /// The size of the satellite flag.
  final double size;

  /// Options to customize the appearance and behavior of the sky object.
  final SkyPlotOptions options;

  /// Creates a [SkyObject] widget.
  ///
  /// The [skyData] parameter is required and should contain the [SkyData] object
  /// representing the sky object to be displayed.
  ///
  /// The [size] parameter determines the size of the satellite flag.
  ///
  /// The [options] parameter allows customization of various aspects of the satellite flag,
  /// such as text styles, positioning, and paints.
  const SkyObject({
    super.key,
    this.child,
    this.skyData,
    required this.size,
    required this.options,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        Container(
          width: size,
          height: size,
          clipBehavior: Clip.hardEdge,
          decoration: (skyData != null && skyData!.usedInFix == true)
              ? options.skyObjectInFixDecoration
              : options.skyObjectNotInFixDecoration,
          child: child != null
              ? Center(
                  child: child,
                )
              : null,
        ),
        if (skyData != null)
          Positioned(
            top: options.idTextPosition.top,
            bottom: options.idTextPosition.bottom,
            right: options.idTextPosition.right,
            left: options.idTextPosition.left,
            height: options.idTextPosition.height,
            width: options.idTextPosition.width,
            child: Text(
              '${skyData!.id}',
              style: skyData!.usedInFix ?? false
                  ? options.satelliteIdInFixTextStyle
                  : options.satelliteIdNotInFixTextStyle,
            ),
          ),
      ],
    );
  }
}
