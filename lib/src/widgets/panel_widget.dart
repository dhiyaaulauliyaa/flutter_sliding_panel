part of '../sliding_panel.dart';

class PanelWidget extends StatefulWidget {
  const PanelWidget({
    super.key,
    required this.maxHeight,
    required this.maxWidth,
    required this.child,
    required this.config,
    required this.controller,
    required this.internalController,
    required this.delegate,
    this.abovePanel,
    this.decoration,
    this.onDragStart,
    this.onDragEnd,
    this.onDragUpdate,
  });

  final double maxHeight;
  final double maxWidth;

  final InternalController internalController;

  final SlidingPanelController controller;
  final SlidingPanelConfig config;
  final PanelContentDelegate? delegate;

  final Widget child;
  final Widget? abovePanel;
  final BoxDecoration? decoration;

  final VoidCallback? onDragStart;
  final VoidCallback? onDragEnd;
  final void Function(SlidingPanelDetail details)? onDragUpdate;

  @override
  State<PanelWidget> createState() => _PanelWidgetState();
}

class _PanelWidgetState extends State<PanelWidget> {
  late SlidingPanelStatus _lastPanelStatus;

  late double _expandPosition;
  late double _anchorPosition;
  late double _panelPosition;

  late bool _haveScrollableChild;
  late int _scrollableChildCount;
  late List<ScrollController> _scrollController;
  late ValueNotifier<List<ScrollPhysics>> _scrollPhysics;
  late ScrollablePanelContentDelegate _scrollDelegate;
  final _justExpanded = ValueNotifier<bool>(false);

  Duration _duration = Duration.zero;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();

    _initPanel();
    _initController();
    _initScrollView();
  }

  @override
  void didUpdateWidget(covariant PanelWidget oldWidget) {
    if (!mounted) return;
    super.didUpdateWidget(oldWidget);

    _updateScrollDelegate();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_controllerListener);
    _disposeScrollController();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedPositioned(
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
        ),
        if (widget.abovePanel != null)
          AnimatedPositioned(
            bottom: _panelPosition,
            duration: _duration,
            curve: widget.config.snapingCurve,
            onEnd: _resetAnimation,
            child: GestureDetector(
              onVerticalDragStart: _dragStartHandler,
              onVerticalDragEnd: _dragEndHandler,
              onVerticalDragUpdate: _dragUpdateHandler,
              child: Container(
                width: widget.maxWidth,
                alignment: Alignment.center,
                child: widget.abovePanel,
              ),
            ),
          ),
      ],
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
      widget.controller.initValue(
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

  void _initScrollView() {
    _haveScrollableChild = widget.delegate is ScrollablePanelContentDelegate;
    if (!_haveScrollableChild) return;

    _scrollDelegate = widget.delegate! as ScrollablePanelContentDelegate;
    _scrollPhysics = _scrollDelegate.physics;
    _scrollController = _scrollDelegate.scrollController;
    _scrollableChildCount = _scrollController.length;

    if (widget.controller.value.status == SlidingPanelStatus.anchored) {
      _updateScrollPhysics(enableScroll: false);
    }

    for (var i = 0; i < _scrollController.length; i++) {
      _scrollController[i].addListener(() => _scrollListener(i));
    }
  }

  //?? ---------------------------------------- ??//
  //?? ---------- ScrollView Handler ---------- ??//
  void _updateScrollDelegate() {
    if (!_haveScrollableChild) return;

    var needToDispose = false;
    for (var i = 0; i < _scrollController.length; i++) {
      needToDispose = _scrollController[i] !=
          (widget.delegate! as ScrollablePanelContentDelegate)
              .scrollController[i];

      if (needToDispose) break;
    }

    if (needToDispose) _disposeScrollController();

    _initScrollView();
  }

  void _disposeScrollController() {
    if (!_haveScrollableChild) return;

    for (final controller in _scrollController) {
      controller.dispose();
    }
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

  //?? ---------------------------------------- ??//
  //?? ---------- ScrollView Handler ---------- ??//
  void _updateScrollPhysics({required bool enableScroll}) {
    final isChanging = _scrollPhysics.value.first !=
        (enableScroll
            ? _scrollDelegate.defaultPhysics
            : const NeverScrollableScrollPhysics());

    if (isChanging) {
      _scrollPhysics.value = List.generate(
        _scrollableChildCount,
        (index) => enableScroll
            ? _scrollDelegate.defaultPhysics[index]
            : const NeverScrollableScrollPhysics(),
      );
    }
  }

  void _scrollToTop() {
    for (final controller in _scrollController) {
      if (controller.hasClients) {
        controller.animateTo(
          0,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeOutCirc,
        );
      }
    }
  }

  void _updateScrollViewState({required SlidingPanelStatus status}) {
    if (!_haveScrollableChild) return;

    _justExpanded.value = status == SlidingPanelStatus.expanded;

    _updateScrollPhysics(
      enableScroll: status == SlidingPanelStatus.expanded,
    );

    if (status == SlidingPanelStatus.anchored) _scrollToTop();
  }

  void _scrollListener(int index) {
    final controller = _scrollController[index];
    if (!controller.hasClients) return;

    /* If Scrolled Down */
    if (controller.position.userScrollDirection == ScrollDirection.forward) {
      /* If panel is just been expanded, then anchor the panel */
      if (_justExpanded.value) {
        _animatePanel(_anchorPosition, SlidingPanelStatus.anchored);
        return;
      }

      /* If panel scrolled to top, disable scroll to allow panel anchored  */
      if (controller.position.pixels < 0.1) {
        _updateScrollPhysics(enableScroll: false);
        return;
      }
    }

    /* If Scrolled Up */
    if (controller.position.userScrollDirection == ScrollDirection.reverse) {
      if (_justExpanded.value) _justExpanded.value = false;

      return;
    }
  }

  //?? ---------------------------------- ??//
  //?? ---------- Drag Handler ---------- ??//
  void _dragStartHandler(DragStartDetails details) {
    _resetAnimation();
    widget.onDragStart?.call();
  }

  void _dragUpdateHandler(DragUpdateDetails details) {
    _resetAnimation();
    widget.controller.setStatus(SlidingPanelStatus.onDrag);

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

    widget.controller.setValue(
      widget.controller.value.copyWith(
        status: SlidingPanelStatus.onDrag,
        position: newOffset,
      ),
    );
    widget.onDragUpdate?.call(widget.controller.value);

    setState(() => _panelPosition = newOffset);
  }

  void _dragEndHandler(DragEndDetails details) {
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
        widget.internalController.setAnimatingStatus(_isAnimating);

        /* Handle Status */
        widget.controller.setStatus(status);
        _lastPanelStatus = status;

        /* Handle Position */
        _panelPosition = position;

        /* Handle Controller */
        widget.controller.setValue(
          widget.controller.value.copyWith(
            status: status,
            position: position,
            lastSnapPosition: position,
            lastSnapStatus: status,
          ),
        );

        /* Handle ScrollView */
        _updateScrollViewState(status: status);
      });
    }

    widget.onDragEnd?.call();
  }

  void _resetAnimation() {
    if (_isAnimating) {
      setState(() {
        _isAnimating = false;
        widget.internalController.setAnimatingStatus(_isAnimating);
        _duration = Duration.zero;
      });
    }
  }
}
