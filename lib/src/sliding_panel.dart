import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

part 'data/config.dart';
part 'data/controller.dart';
part 'data/delegate.dart';
part 'data/detail.dart';
part 'data/enums.dart';
part 'widgets/panel_widget.dart';

typedef ScrollableContentBuilder = Widget Function(
  ScrollController controller,
  ScrollPhysics physics,
);
typedef MultiScrollableContentBuilder = Widget Function(
  List<ScrollController> controller,
  List<ScrollPhysics> physics,
);

class SlidingPanel extends StatelessWidget {
  const SlidingPanel({
    super.key,
    required this.panelContent,
    required this.controller,
    required this.config,
    this.leading,
    this.pageContent,
    this.decoration,
    this.onDragStart,
    this.onDragEnd,
    this.onDragUpdate,
    this.delegate,
  });

  factory SlidingPanel.scrollableContent({
    required SlidingPanelController controller,
    required SlidingPanelConfig config,
    required ScrollableContentBuilder panelContentBuilder,
    Widget? pageContent,
    Widget? leading,
    BoxDecoration? decoration,
    VoidCallback? onDragStart,
    VoidCallback? onDragEnd,
    void Function(SlidingPanelDetail details)? onDragUpdate,
    ScrollController? contentScrollController,
    ScrollPhysics? contentScrollPhysics,
  }) {
    final delegate = ScrollablePanelContentDelegate(
      scrollController: [contentScrollController ?? ScrollController()],
      physics: [contentScrollPhysics ?? const BouncingScrollPhysics()],
    );

    return SlidingPanel(
      controller: controller,
      config: config,
      pageContent: pageContent,
      leading: leading,
      decoration: decoration,
      onDragStart: onDragStart,
      onDragEnd: onDragEnd,
      onDragUpdate: onDragUpdate,
      delegate: delegate,
      panelContent: ValueListenableBuilder<List<ScrollPhysics>>(
        valueListenable: delegate.physics,
        builder: (_, physics, __) {
          return panelContentBuilder.call(
            delegate.scrollController.first,
            physics.first,
          );
        },
      ),
    );
  }

  factory SlidingPanel.multiScrollableContent({
    required SlidingPanelController controller,
    required SlidingPanelConfig config,
    required int scrollableChildCount,
    required MultiScrollableContentBuilder panelContentBuilder,
    Widget? pageContent,
    Widget? leading,
    BoxDecoration? decoration,
    VoidCallback? onDragStart,
    VoidCallback? onDragEnd,
    void Function(SlidingPanelDetail details)? onDragUpdate,
    List<ScrollController>? contentScrollController,
    List<ScrollPhysics>? contentScrollPhysics,
  }) {
    final delegate = ScrollablePanelContentDelegate(
      count: scrollableChildCount,
      scrollController: contentScrollController,
      physics: contentScrollPhysics,
    );

    return SlidingPanel(
      controller: controller,
      config: config,
      pageContent: pageContent,
      decoration: decoration,
      onDragStart: onDragStart,
      onDragEnd: onDragEnd,
      onDragUpdate: onDragUpdate,
      delegate: delegate,
      leading: leading,
      panelContent: ValueListenableBuilder<List<ScrollPhysics>>(
        valueListenable: delegate.physics,
        builder: (_, physics, __) {
          return panelContentBuilder.call(
            delegate.scrollController,
            physics,
          );
        },
      ),
    );
  }

  final SlidingPanelController controller;
  final SlidingPanelConfig config;
  final PanelContentDelegate? delegate;

  final Widget panelContent;
  final Widget? pageContent;
  final Widget? leading;
  final BoxDecoration? decoration;

  final VoidCallback? onDragStart;
  final VoidCallback? onDragEnd;
  final void Function(SlidingPanelDetail details)? onDragUpdate;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox.expand(
          child: Stack(
            children: [
              /* Page Content */
              Positioned(
                top: 0,
                child: SizedBox(
                  width: constraints.maxWidth,
                  height: constraints.minHeight,
                  child: pageContent,
                ),
              ),

              /* Panel */
              _PanelWidget(
                maxWidth: constraints.maxWidth,
                maxHeight: constraints.maxHeight,
                controller: controller,
                config: config,
                delegate: delegate,
                onDragStart: onDragStart,
                onDragEnd: onDragEnd,
                onDragUpdate: onDragUpdate,
                decoration: decoration,
                abovePanel: leading,
                child: panelContent,
              ),
            ],
          ),
        );
      },
    );
  }
}
