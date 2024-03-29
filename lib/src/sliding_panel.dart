import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_sliding_panel/src/entities/internal/internal_controller.dart';

part 'entities/panel/enums.dart';
part 'entities/panel/panel_config.dart';
part 'entities/panel/panel_controller.dart';
part 'entities/panel/panel_delegate.dart';
part 'entities/panel/panel_detail.dart';
part 'entities/refresher/refresher_config.dart';
part 'widgets/panel_widget.dart';
part 'widgets/refresher_widget.dart';

typedef ScrollableContentBuilder = Widget Function(
  ScrollController controller,
  ScrollPhysics physics,
);
typedef MultiScrollableContentBuilder = Widget Function(
  List<ScrollController> controller,
  List<ScrollPhysics> physics,
);

/// Create a slidable panel.
///
/// Typically used as a sub-page of a page.
/// This widget will appear above the main page.
///
/// Some of important params:
/// - [leading]: Used to display widget above the panel.
/// Typically used to show panel handle.
/// - [pageContent]: Used to display page behind sliding panel
/// - [panelContent]: Used to display content of the panel.
/// If the content is scrollable, its highly recommended to use
/// [SlidingPanel.scrollableContent] / [SlidingPanel.multiScrollableContent]
/// factory. The factory will handle the gesture to be as natural as possible.
class SlidingPanel extends StatelessWidget {
  SlidingPanel({
    super.key,
    required this.panelContent,
    required this.controller,
    required this.config,
    this.dragToRefreshConfig,
    this.leading,
    this.pageContent,
    this.decoration,
    this.onDragStart,
    this.onDragEnd,
    this.onDragUpdate,
    this.delegate,
  });

  /// A factory to handle usage of scrollable [panelContent] of [SlidingPanel].
  /// This factory will handle panel anchoring/expanding gesture combined with scroll gesture.
  ///
  /// To enable gesture handling, use scrollController & scrollPhysics
  /// provided by [panelContentBuilder]
  ///
  /// Pass [ScrollView]'s [ScrollController] to [contentScrollController],
  /// if null then this factory will instantiate it automatically
  ///
  /// Pass [ScrollView]'s [ScrollPhysics] to [contentScrollPhysics],
  /// if null then this factory will instantiate it automatically
  ///
  /// use [SlidingPanel.multiScrollableContent] if [panelContent]
  /// has multiple [ScrollView]
  factory SlidingPanel.scrollableContent({
    required SlidingPanelController controller,
    required SlidingPanelConfig config,
    required ScrollableContentBuilder panelContentBuilder,
    SlidingPanelRefresherConfig? dragToRefreshConfig,
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
      dragToRefreshConfig: dragToRefreshConfig,
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

  /// A factory to handle usage of scrollable [panelContent] of [SlidingPanel].
  /// This factory will handle panel anchoring/expanding gesture combined with scroll gesture.
  ///
  /// To enable gesture handling, use scrollController & scrollPhysics
  /// provided by [panelContentBuilder]
  ///
  /// Pass [ScrollView]'s [ScrollController] to [contentScrollController],
  /// if null then this factory will instantiate it automatically
  ///
  /// Pass [ScrollView]'s [ScrollPhysics] to [contentScrollPhysics],
  /// if null then this factory will instantiate it automatically
  ///
  /// use [SlidingPanel.scrollableContent] if [panelContent]
  /// has single [ScrollView]
  factory SlidingPanel.multiScrollableContent({
    required SlidingPanelController controller,
    required SlidingPanelConfig config,
    required int scrollableChildCount,
    required MultiScrollableContentBuilder panelContentBuilder,
    SlidingPanelRefresherConfig? dragToRefreshConfig,
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
      dragToRefreshConfig: dragToRefreshConfig,
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

  /// Control & animate sliding panel position.
  final SlidingPanelController controller;

  /// Set sliding panel configuration (position, animation, behavior).
  final SlidingPanelConfig config;

  /// Set [SlidingPanel]'s refresh indicator configuration.
  ///
  /// - If null, the refresh indicator won't be appear.
  /// - If not null, the refresh indicator will appear if panel is dragged
  /// down when it is anchored
  ///
  /// Defaults to null
  final SlidingPanelRefresherConfig? dragToRefreshConfig;

  /// A delegate to help build [panelContent].
  /// Typically used for [panelContent] with [ScrollView] type.
  final PanelContentDelegate? delegate;

  /// Used to display content of the panel.
  ///
  /// If the content is scrollable, its highly recommended to use
  /// [SlidingPanel.scrollableContent] / [SlidingPanel.multiScrollableContent]
  /// factory. The factory will handle the gesture to be as natural as possible.
  final Widget panelContent;

  /// Used to display page behind sliding panel
  final Widget? pageContent;

  /// Used to display widget above the panel.
  /// Typically used to show panel handle.
  final Widget? leading;

  /// Used to handle panel appearance.
  final BoxDecoration? decoration;

  /// Callback to be called when drag started.
  final VoidCallback? onDragStart;

  /// Callback to be called when drag ended.
  final VoidCallback? onDragEnd;

  /// Callback to be called when drag updated.
  final void Function(SlidingPanelDetail details)? onDragUpdate;

  final _internalController = InternalController();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox.expand(
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              /* Page Content */
              Positioned(
                top: 0,
                child: SizedBox(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  child: pageContent,
                ),
              ),

              /* Panel */
              PanelWidget(
                maxWidth: constraints.maxWidth,
                maxHeight: constraints.maxHeight,
                controller: controller,
                internalController: _internalController,
                config: config,
                delegate: delegate,
                onDragStart: onDragStart,
                onDragEnd: onDragEnd,
                onDragUpdate: onDragUpdate,
                decoration: decoration,
                abovePanel: leading,
                child: panelContent,
              ),

              /* Refresh Indicator */
              if (dragToRefreshConfig != null)
                RefresherWidget(
                  config: dragToRefreshConfig!,
                  panelController: controller,
                  internalController: _internalController,
                ),
            ],
          ),
        );
      },
    );
  }
}
