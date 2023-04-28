part of '../sliding_panel.dart';

/// Set sliding panel configuration (position, animation, behavior).
class SlidingPanelConfig extends Equatable {
  const SlidingPanelConfig({
    required this.anchorPosition,
    required this.expandPosition,
    this.snapingThreshold = 0.3,
    this.snapingBehavior = SlidingPanelSnapingBehavior.alternating,
    this.snapingDuration = const Duration(milliseconds: 500),
    this.snapingCurve = Curves.easeOutQuart,
  }) : assert(
          snapingThreshold >= 0 && snapingThreshold <= 1,
          'SnapingThreshold should be between or equal to 0 and 1 ',
        );

  /// Position of panel when it is anchored.
  /// - Stated in pixel
  /// - Lowest offset is at bottom-most position of viewport
  /// - Highest offset is at top-most position of viewport
  ///
  /// Anchor position must be lower than expanded position
  final double anchorPosition;

  /// Position of panel when it is expanded.
  /// - Stated in pixel
  /// - Lowest offset is at bottom-most position of viewport
  /// - Highest offset is at top-most position of viewport
  ///
  /// Expand position must be higher than anchor position
  final double expandPosition;

  /// Distance between panel last position when user tap up the screen
  /// and its destined snap postion.
  ///
  /// If [snapingBehavior] is Fixed:
  /// - lower value will makes sheet easier to anchor
  /// - higher value will makes sheet easier to expand
  ///
  /// If [snapingBehavior] is Alternating:
  /// - lower value will makes sheet easier to snap to its last state
  /// - higher value will makes sheet easier to snap to its opposite position
  ///
  /// Value must be between 0-1.
  ///
  /// Default is 0.3
  final double snapingThreshold;

  /// Define how panel will be snapped when user tap up the screen.
  /// See [snapingThreshold] for detailed explanation
  ///
  /// Default to [SlidingPanelSnapingBehavior.alternating]
  final SlidingPanelSnapingBehavior snapingBehavior;

  /// Duration when panel is animating from last position
  /// to its snapped position (expanded/achored)
  ///
  /// Default to [500 milliseconds]
  final Duration snapingDuration;

  /// Animation Curve when panel is animating from last position
  /// to its snapped position (expanded/achored)
  ///
  /// Default to [Curves.easeOutQuart]
  final Curve snapingCurve;

  /// Distance between [expandPosition] and [anchorPosition]
  @protected
  double get innerDistance => expandPosition - anchorPosition;

  @override
  List<Object?> get props => [
        anchorPosition,
        expandPosition,
        snapingThreshold,
        snapingBehavior,
        snapingDuration,
        snapingCurve,
      ];
}
