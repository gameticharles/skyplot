/// A data class representing information about a sky object.
///
/// The `SkyData` class stores information about a sky object, such as its azimuth and
/// elevation angles, category, unique identifier, and whether it is used in a fix.
class SkyData {
  /// The azimuth angle of the sky object in degrees.
  final double? azimuthDegrees;

  /// The category of the sky object.
  final String? category;

  /// The elevation angle of the sky object in degrees.
  final double? elevationDegrees;

  /// The unique identifier of the sky object.
  final String? id;

  /// Whether the sky object is used in a fix.
  final bool? usedInFix;

  /// Creates a [SkyData] object with the specified parameters.
  const SkyData({
    this.azimuthDegrees,
    this.category,
    this.elevationDegrees,
    this.id,
    this.usedInFix,
  });
}
