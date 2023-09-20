part of '../../sliding_panel.dart';

/// Contain info about panel position and status.
class SlidingPanelDetail extends Equatable {
  const SlidingPanelDetail({
    required this.status,
    required this.position,
    required this.anchorPosition,
    required this.expandPosition,
    required this.lastSnapStatus,
    required this.lastSnapPosition,
  });

  final SlidingPanelStatus status;
  final double position;
  final double anchorPosition;
  final double expandPosition;

  final SlidingPanelStatus lastSnapStatus;
  final double lastSnapPosition;

  /// Whether panel is expanded or not
  bool get isExpanded => position == expandPosition;

  /// Whether panel is anchored or not
  bool get isAnchored => position == anchorPosition;

  /// Get drag range between anchor & expand position in pixel
  double get dragRange => (anchorPosition - expandPosition).abs();

  /// Get value of drag completion percentage.
  ///
  /// The value start to be calculated from last snap position
  ///
  /// Percentage value is presented in 0.0 - 1.0
  double get dragCompletionRate =>
      (position - lastSnapPosition).abs() / dragRange;

  SlidingPanelDetail copyWith({
    SlidingPanelStatus? status,
    double? position,
    double? anchorPosition,
    double? expandPosition,
    SlidingPanelStatus? lastSnapStatus,
    double? lastSnapPosition,
  }) =>
      SlidingPanelDetail(
        status: status ?? this.status,
        position: position ?? this.position,
        anchorPosition: anchorPosition ?? this.anchorPosition,
        expandPosition: expandPosition ?? this.expandPosition,
        lastSnapStatus: lastSnapStatus ?? this.lastSnapStatus,
        lastSnapPosition: lastSnapPosition ?? this.lastSnapPosition,
      );

  @override
  List<Object?> get props => [
        status,
        position,
        anchorPosition,
        expandPosition,
        lastSnapStatus,
        lastSnapPosition,
      ];
}
