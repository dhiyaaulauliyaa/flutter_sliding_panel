part of '../sliding_panel.dart';

class _PanelWidget extends StatefulWidget {
  const _PanelWidget({
    required this.maxHeight,
    required this.maxWidth,
    required this.child,
    required this.config,
    required this.controller,
    this.decoration,
    this.onDragStart,
    this.onDragEnd,
    this.onDragUpdate,
  });

  final double maxHeight;
  final double maxWidth;

  final SlidingPanelController controller;
  final SlidingPanelConfig config;

  final Widget child;
  final BoxDecoration? decoration;

  final VoidCallback? onDragStart;
  final VoidCallback? onDragEnd;
  final void Function(SlidingPanelDetail details)? onDragUpdate;

  @override
  State<_PanelWidget> createState() => _PanelWidgetState();
}

class _PanelWidgetState extends State<_PanelWidget> {
  late SlidingPanelStatus _lastPanelStatus;

  late double _expandPosition;
  late double _anchorPosition;
  late double _panelPosition;

  Duration _duration = Duration.zero;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _initPanel();
    _initController();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_controllerListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      bottom: _panelPosition,
      duration: _duration,
      curve: widget.config.snapingCurve,
      onEnd: _resetAnimation,
      child: Transform.translate(
        offset: Offset(0, widget.maxHeight),
        child: GestureDetector(
          onVerticalDragStart: _dragStartHandler,
          onVerticalDragEnd: _dragEndHandler,
          onVerticalDragUpdate: _dragUpdateHandler,
          child: Container(
            width: widget.maxWidth,
            height: widget.maxHeight,
            decoration: widget.decoration,
            child: ClipRRect(
              borderRadius:
                  widget.decoration?.borderRadius ?? BorderRadius.zero,
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }

  //?? ------------------------------------ ??//
  //?? ---------- Initialization ---------- ??//
  void _initPanel() {
    _lastPanelStatus = widget.controller.status;
    _anchorPosition = widget.config.anchorPosition;
    _expandPosition = widget.config.expandPosition;
    switch (widget.controller.status) {
      case SlidingPanelStatus.expanded:
        _panelPosition = _expandPosition;
        break;
      case SlidingPanelStatus.onDrag:
      case SlidingPanelStatus.anchored:
        _panelPosition = _anchorPosition;
        break;
    }
  }

  void _initController() {
    widget.controller.addListener(_controllerListener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.controller._initValue(
        SlidingPanelDetail(
          status: _lastPanelStatus,
          position: _panelPosition,
          anchorPosition: _anchorPosition,
          expandPosition: _expandPosition,
          lastSnapStatus: _lastPanelStatus,
          lastSnapPosition: _panelPosition,
        ),
      );
    });
  }

  //?? ---------------------------------------- ??//
  //?? ---------- Controller Handler ---------- ??//
  void _controllerListener() {
    switch (widget.controller.value.status) {
      case SlidingPanelStatus.anchored:
        _animatePanel(_anchorPosition, SlidingPanelStatus.anchored);
        break;
      case SlidingPanelStatus.expanded:
        _animatePanel(_expandPosition, SlidingPanelStatus.expanded);
        break;
      default:
        break;
    }
  }

  //?? ---------------------------------- ??//
  //?? ---------- Drag Handler ---------- ??//
  void _dragStartHandler(DragStartDetails details) {
    _resetAnimation();
    widget.onDragStart?.call();
    widget.controller._setStatus(SlidingPanelStatus.onDrag);
  }

  void _dragUpdateHandler(DragUpdateDetails details) {
    _resetAnimation();
    widget.controller._setStatus(SlidingPanelStatus.onDrag);

    final delta = -(details.primaryDelta ?? 0);
    var newOffset = _panelPosition + delta;
    const exceedTolerance = 100;

    final overflowCondition = [
      newOffset.isNegative,
      newOffset > widget.maxHeight,
      newOffset > _expandPosition + exceedTolerance,
      newOffset < _anchorPosition - exceedTolerance,
    ];
    final isOverflow = overflowCondition.any((c) => c);

    /* Ignore new position if exceed overflow tolerance */
    if (isOverflow) return;

    /* Decrease speed exponentially if exceed MaxOffset */
    final isExceedMaxOffset = newOffset > _expandPosition;
    if (isExceedMaxOffset) {
      final exceedOffset = newOffset - _expandPosition;
      final exceedRatio = exceedOffset / exceedTolerance;
      newOffset = _panelPosition + (delta * pow(1 - exceedRatio, 2));
    }

    /* Decrease speed exponentially if exceed MinOffset */
    final isExceedMinOffset = newOffset < widget.config.anchorPosition;
    if (isExceedMinOffset) {
      final exceedOffset = (newOffset - _anchorPosition).abs();
      final exceedRatio = exceedOffset / exceedTolerance;
      newOffset = _panelPosition + (delta * pow(1 - exceedRatio, 2));
    }

    widget.controller._setValue(
      widget.controller.value.copyWith(
        status: SlidingPanelStatus.onDrag,
        position: newOffset,
      ),
    );
    widget.onDragUpdate?.call(widget.controller.value);

    setState(() => _panelPosition = newOffset);
  }

  void _dragEndHandler(DragEndDetails details) {
    widget.onDragEnd?.call();

    /* Snap panel to expand position */
    if (_panelPosition > _expandPosition) {
      _animatePanel(_expandPosition, SlidingPanelStatus.expanded);
      return;
    }

    /* Snap panel to anchor position */
    if (_panelPosition < _anchorPosition) {
      _animatePanel(_anchorPosition, SlidingPanelStatus.anchored);
      return;
    }

    /* Snap panel according to nearest snap position (expand/anchor) */
    final lastSnapPosition = _lastPanelStatus == SlidingPanelStatus.anchored
        ? _anchorPosition
        : _expandPosition;
    final oppositeSnapPosition = _lastPanelStatus == SlidingPanelStatus.anchored
        ? _expandPosition
        : _anchorPosition;
    final oppositeSnapStatus = _lastPanelStatus == SlidingPanelStatus.anchored
        ? SlidingPanelStatus.expanded
        : SlidingPanelStatus.anchored;
    final reference = widget.config.snapingBehavior.isAlternating
        ? lastSnapPosition
        : _anchorPosition;

    final distance = _panelPosition - reference;
    final distanceRatio = distance.abs() / widget.config.innerDistance;
    final aboveThreshold = distanceRatio > widget.config.snapingThreshold;

    _animatePanel(
      aboveThreshold ? oppositeSnapPosition : lastSnapPosition,
      aboveThreshold ? oppositeSnapStatus : _lastPanelStatus,
    );
    return;
  }

  //?? --------------------------------------- ??//
  //?? ---------- Animation Handler ---------- ??//
  void _animatePanel(double position, SlidingPanelStatus status) {
    if (_panelPosition != position) {
      setState(() {
        /* Handle Animation */
        _duration = widget.config.snapingDuration;
        _isAnimating = true;

        /* Handle Status */
        widget.controller._setStatus(status);
        _lastPanelStatus = status;

        /* Handle Position */
        _panelPosition = position;

        /* Handle Controller */
        widget.controller._setValue(
          widget.controller.value.copyWith(
            status: status,
            position: position,
            lastSnapPosition: position,
            lastSnapStatus: status,
          ),
        );
      });
    }
  }

  void _resetAnimation() {
    if (_isAnimating) {
      setState(() {
        _isAnimating = false;
        _duration = Duration.zero;
      });
    }
  }
}
