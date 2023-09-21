part of '../../sliding_panel.dart';

/// Set sliding panel's refresher configuration
class SlidingPanelRefresherConfig extends Equatable {
  const SlidingPanelRefresherConfig({
    required this.onRefresh,
    this.triggerOffset = 75.0,
    this.maxDisplacement = 110.0,
    this.displacementSpeed = 4.0,
    this.edgeOffset = 0.0,
    this.indicatorSize,
    this.indicatorBuilder,
    this.indicatorRefreshChild,
    this.indicatorDecoration,
    this.indicatorChild = const Icon(Icons.refresh),
    this.resetDuration = const Duration(milliseconds: 250),
    this.resetCurve = Curves.easeOutCirc,
  });

  /// The minimum distance from the panelContent viewport's edge [edgeOffset]
  /// where the refresh callback is allow to be triggered.
  /// In most cases, [triggerOffset] distance starts counting from the parent's
  /// edges. However, if [edgeOffset] is larger than zero then the [triggerOffset]
  /// value is calculated from that offset instead of the parent's edge.
  ///
  /// By default, the value of `triggerOffset` is 75.
  final double triggerOffset;

  /// Refresh indicator widget's maximum displacement distance. The distance
  /// is calculated from the panelContent viewport's edge [edgeOffset]
  /// In most cases, [triggerOffset] distance starts counting from the parent's
  /// edges. However, if [edgeOffset] is larger than zero then the [triggerOffset]
  /// value is calculated from that offset instead of the parent's edge.
  ///
  /// By default, the value of `triggerOffset` is 110.
  final double maxDisplacement;

  /// The offset where refresh indicator widget starts to appear on drag start.
  ///
  /// Depending whether the indicator is showing on the top or bottom, the value
  /// of this variable controls how far from the parent's edge the progress
  /// indicator starts to appear.
  ///
  /// By default, the edge offset is set to 0.
  final double edgeOffset;

  /// Defines refresh indicator's displacement speed rate over
  /// sliding panel dragged distance.
  ///
  /// By default, the value of `displacementSpeed` is 4.
  final double displacementSpeed;

  /// A function that's called when the user has dragged the refresh indicator
  /// far enough to demonstrate that they want the app to refresh. The returned
  /// [Future] must complete when the refresh operation is finished.
  final RefreshCallback onRefresh;

  /// The duration when indicator should be back to its initial position
  ///
  /// By default, the value of `resetDuration` is 250ms.
  final Duration resetDuration;

  /// The animation curve when indicator is moving back to its initial position
  ///
  /// By default, the value of `resetCurve` is Curves.easeOutCirc.
  final Curve resetCurve;

  /// Size of refresh indicator widget
  ///
  /// By default, the value of `indicatorSize` is Size(42,42).
  final Size? indicatorSize;

  /// Use this builder if want to show a custom RefreshIndicator widget.
  /// The builder has below params:
  /// - `BuildContext` context: to pass context to the builder
  /// - `bool` isRefreshing: whether the widget is refreshing or not
  /// - `double` displacement: the displacement position of the RefresherWidget
  ///
  /// The `isRefreshing` params typically used to show different widget when
  /// the refresher is refreshing. i.e. Show CircularProgressIndicator when
  /// refreshing, otherwise show refresh icon.
  ///
  /// The `displacement` params typically used to manipulate indicator widget
  /// when it is exposed. i.e. displacement is used as a reference for the
  /// refresher's opacity. The bigger the displacement, the bigger the opacity,
  /// and vice versa.
  ///
  /// The widget size returns by this builder is affected by [indicatorSize]
  ///
  /// By default, the value of `indicatorBuilder` is null
  final Widget Function(
    BuildContext context,
    bool isRefreshing,
    double displacement,
  )? indicatorBuilder;

  /// Widget to be shown on refresh indicator when it is exposed
  /// (panel is dragged), Typically an [Icon]
  ///
  /// This will be ignored if [indicatorBuilder] is not null
  ///
  /// By default, the value of `indicatorChild` is refresh icon.
  final Widget indicatorChild;

  /// Widget to be shown on refresh indicator when it is refeshing
  /// Typically a [CircularProgressIndicator]
  ///
  /// This will be ignored if [indicatorBuilder] is not null
  ///
  /// By default, the value of `indicatorRefreshChild` is
  /// CircularProgressIndicator.
  final Widget? indicatorRefreshChild;

  /// Refresh indicator widget decoration
  ///
  /// This will be ignored if [indicatorBuilder] is not null
  final BoxDecoration? indicatorDecoration;

  @override
  List<Object?> get props => [
        onRefresh,
        triggerOffset,
        maxDisplacement,
        displacementSpeed,
        edgeOffset,
        indicatorSize,
        indicatorBuilder,
        indicatorRefreshChild,
        indicatorDecoration,
        indicatorChild,
        resetDuration,
        resetCurve,
      ];
}
