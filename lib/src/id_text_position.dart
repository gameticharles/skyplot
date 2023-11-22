/// A class to define the position and size for the Sky Object ID text.
///
/// This class works similarly to the `Positioned` widget in Flutter but is
/// tailored for specifying the position of the Sky Object ID text within the SkyPlot widget.
/// It allows for the specification of left, top, right, bottom, width, and height constraints.
///
/// The `SkyObjectIDTextPosition` can be used to place the Sky Object ID text at a specific
/// location relative to its parent. If any of the positional constraints are omitted,
/// the corresponding dimension or position will be left unconstrained.
///
/// Examples:
/// - To position the text at the top right corner, provide values for `top` and `right`.
/// - To set the size of the text area without positioning, provide values for `width` and `height`.
class SkyObjectIDTextPosition {
  /// Distance from the left edge of the parent widget.
  /// If null, the left position will be unconstrained.
  final double? left;

  /// Distance from the top edge of the parent widget.
  /// If null, the top position will be unconstrained.
  final double? top;

  /// Distance from the right edge of the parent widget.
  /// If null, the right position will be unconstrained.
  final double? right;

  /// Distance from the bottom edge of the parent widget.
  /// If null, the bottom position will be unconstrained.
  final double? bottom;

  /// The width of the text area.
  /// If null, the width will be unconstrained and determined by the content and other constraints.
  final double? width;

  /// The height of the text area.
  /// If null, the height will be unconstrained and determined by the content and other constraints.
  final double? height;

  /// Constructs a [SkyObjectIDTextPosition] with optional positional constraints.
  ///
  /// Specifying a `null` value for any of the constraints means that the constraint
  /// will not be applied, giving flexibility in positioning the text.
  const SkyObjectIDTextPosition({
    this.left,
    this.top,
    this.right,
    this.bottom,
    this.width,
    this.height,
  });
}
