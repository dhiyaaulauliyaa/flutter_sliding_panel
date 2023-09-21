part of '../sliding_panel.dart';

class _RefresherWidget extends StatefulWidget {
  const _RefresherWidget({
    required this.config,
    required this.panelController,
    required this.internalController,
  });

  final SlidingPanelRefresherConfig config;
  final SlidingPanelController panelController;
  final _InternalController internalController;

  @override
  State<_RefresherWidget> createState() => _RefresherWidgetState();
}

class _RefresherWidgetState extends State<_RefresherWidget> {
  late final bool _useCustomBuilder;
  late final double _indicatorDefaultPosition;

  double _indicatorDragCompletion = 0;
  double _indicatorDisplacement = 0;
  bool _isPanelAnimating = false;
  bool _isRefreshing = false;

  Size get _indicatorSize => widget.config.indicatorSize ?? const Size(42, 42);

  @override
  void initState() {
    super.initState();

    _useCustomBuilder = widget.config.indicatorBuilder != null;
    _indicatorDefaultPosition =
        widget.config.edgeOffset - _indicatorSize.height;

    widget.panelController.addListener(_calcIndicatorDisplacement);
    widget.internalController.addListener(_setPanelAnimatingStatus);
  }

  @override
  void dispose() {
    widget.panelController.removeListener(_calcIndicatorDisplacement);
    widget.internalController.removeListener(_setPanelAnimatingStatus);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      top: _indicatorDefaultPosition + _indicatorDisplacement,
      duration: _isPanelAnimating ? widget.config.resetDuration : Duration.zero,
      curve: widget.config.resetCurve,
      child: Container(
        width: _indicatorSize.width,
        height: _indicatorSize.height,
        alignment: _useCustomBuilder ? null : Alignment.center,
        decoration: _useCustomBuilder
            ? null
            : widget.config.indicatorDecoration ??
                BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                ),
        child: widget.config.indicatorBuilder?.call(
              context,
              _isRefreshing,
              _indicatorDisplacement,
            ) ??
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: _RefreshIndicatorWidget(
                key: ValueKey(
                  _isRefreshing
                      ? '_RefreshIndicatorWidget-Refreshing'
                      : '_RefreshIndicatorWidget-Default',
                ),
                isRefreshing: _isRefreshing,
                opacity: _indicatorOpacity,
                refreshChild: widget.config.indicatorRefreshChild,
                child: widget.config.indicatorChild,
              ),
            ),
      ),
    );
  }

  void _setPanelAnimatingStatus() {
    if (widget.internalController.isAnimating != _isPanelAnimating) {
      setState(() {
        _isPanelAnimating = widget.internalController.isAnimating;
      });
    }
  }

  void _setIndicatorDisplacement(double displacement) {
    if (displacement != _indicatorDisplacement) {
      setState(() {
        _indicatorDisplacement = displacement;
        _indicatorDragCompletion = displacement / widget.config.maxDisplacement;
      });
    }
  }

  void _calcIndicatorDisplacement() {
    final panelDetail = widget.panelController.value;
    final panelDragCompletionRate = panelDetail.dragCompletionRate;

    if (panelDetail.position > panelDetail.anchorPosition) {
      _setIndicatorDisplacement(0);
      return;
    }

    var offset = panelDragCompletionRate *
        widget.config.maxDisplacement *
        widget.config.displacementSpeed;

    if (offset > widget.config.maxDisplacement) {
      offset = widget.config.maxDisplacement;
    }

    // Check whether allow to refresh or not
    if (offset == 0 && _indicatorDisplacement > widget.config.triggerOffset) {
      _setIndicatorDisplacement(widget.config.triggerOffset);
      _startRefresh();
      return;
    }

    if (!_isRefreshing) _setIndicatorDisplacement(offset);
  }

  Future<void> _startRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    await widget.config.onRefresh.call();

    setState(() {
      _isPanelAnimating = true;
      _isRefreshing = false;

      _setIndicatorDisplacement(0);
    });
  }

  double get _indicatorOpacity {
    const speed = 1;
    const startOffset = 0.2;
    var opacity = _indicatorDragCompletion * speed;

    if (opacity < startOffset) opacity = 0;
    if (opacity > 1) opacity = 1;

    return opacity;
  }
}

class _RefreshIndicatorWidget extends StatelessWidget {
  const _RefreshIndicatorWidget({
    super.key,
    required this.isRefreshing,
    required this.opacity,
    required this.refreshChild,
    required this.child,
  });

  final bool isRefreshing;
  final double opacity;

  final Widget? refreshChild;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    if (isRefreshing) {
      return refreshChild ??
          Padding(
            padding: const EdgeInsets.all(12),
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Theme.of(context).iconTheme.color,
            ),
          );
    } else {
      return Opacity(
        opacity: opacity,
        child: AnimatedRotation(
          duration: Duration.zero,
          turns: opacity,
          child: child,
        ),
      );
    }
  }
}
