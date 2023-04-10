import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'data/config.dart';
part 'data/controller.dart';
part 'data/detail.dart';
part 'data/enums.dart';

part 'widgets/panel_widget.dart';

class SlidingPanel extends StatelessWidget {
  const SlidingPanel({
    super.key,
    required this.panelContent,
    required this.controller,
    required this.config,
    this.pageContent,
    this.decoration,
    this.onDragStart,
    this.onDragEnd,
    this.onDragUpdate,
  });

  final SlidingPanelController controller;
  final SlidingPanelConfig config;

  final Widget? pageContent;
  final Widget panelContent;
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
                onDragStart: onDragStart,
                onDragEnd: onDragEnd,
                onDragUpdate: onDragUpdate,
                decoration: decoration,
                child: panelContent,
              ),
            ],
          ),
        );
      },
    );
  }
}
