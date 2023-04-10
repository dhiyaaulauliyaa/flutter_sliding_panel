part of '../sliding_panel.dart';

enum SlidingPanelSnapingBehavior {
  /// Snaping point will be fixed, calculated from anchor point
  fixed,

  /// Snaping point will be calculated based on panel status
  /// - If panel is anchored, snaping point will be
  /// calculated start from its anchor height
  /// - If panel is expanded, snaping point will be
  /// calculated start from its expanded height
  alternating;

  bool get isAlternating => this == alternating;
  bool get isFixed => this == fixed;
}

enum SlidingPanelStatus {
  /// The panel is fully expanded
  expanded,

  /// The panel is anchored
  anchored,

  /// The panel is being dragged
  onDrag,
}
