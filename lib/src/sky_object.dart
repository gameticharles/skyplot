import 'package:flutter/material.dart';

/// A widget that represents an object in the sky plot, such as a satellite.
///
/// This widget displays a circular container with a customizable [child] widget inside.
/// The color of the container indicates whether the object is used in a fix, based on [isUsedInFix].
///
/// Parameters:
/// - [size]: The size of the container. Determines the diameter of the circular representation.
/// - [child]: A widget to display inside the circle. This could represent a satellite's flag or other relevant iconography.
/// - [isUsedInFix]: A boolean indicating whether the object is part of a fix.
///   If `true`, the container's color is green, indicating active usage.
///   If `false` or `null`, the color is light blue, indicating non-active status.
class SkyObject extends StatelessWidget {
  /// The size of the circular container.
  final double size;

  /// The widget to be displayed inside the container, typically representing the object.
  final Widget? child;

  /// Indicates whether the object is used in a fix.
  final bool? isUsedInFix;

  /// Constructs a [SkyObject] with the given parameters.
  const SkyObject({
    super.key,
    required this.child,
    required this.isUsedInFix,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isUsedInFix ?? false ? Colors.green : Colors.lightBlueAccent,
        boxShadow: const [
          BoxShadow(
            offset: Offset(1.5, 1.5),
            color: Colors.black45,
            blurRadius: 3,
          ),
        ],
      ),
      child: child != null
          ? Center(
              child: FittedBox(
                child: child,
              ),
            )
          : null,
    );
  }
}
