import 'package:flutter/material.dart';

/// Options for configuring the appearance and behavior of the radar sweep
/// in a sky plot visualization.
///
/// This class allows customization of the radar sweep's color, stroke width,
/// shadow angle, shadow opacity, shadow color, and the duration of the sweep animation.
class RadarSweepOptions {
  /// The color of the radar sweep line.
  final Color sweepColor;

  /// The stroke width of the radar sweep line.
  final double sweepStrokeWidth;

  /// The angular width of the radar sweep's trailing shadow.
  final double shadowAngle;

  /// The opacity of the radar sweep's trailing shadow.
  final double shadowOpacity;

  /// The color of the radar sweep's trailing shadow.
  final Color shadowColor;

  /// The duration of the radar sweep animation.
  ///
  /// Determines how long it takes for the radar sweep to complete a full rotation.
  /// The duration is specified in seconds. Default is 5 seconds.
  final Duration duration;

  /// Creates a [RadarSweepOptions] with the given properties.
  ///
  /// The properties allow customization of the radar sweep's appearance and behavior
  /// in the sky plot. Defaults will be used for any properties that are not provided.
  RadarSweepOptions({
    this.sweepColor = Colors.green,
    this.sweepStrokeWidth = 2.0,
    this.shadowAngle = 20.0,
    this.shadowOpacity = 0.3,
    this.shadowColor = Colors.green,
    this.duration = const Duration(seconds: 5),
  });
}
