import 'package:flutter/material.dart';
import 'package:flutter_sliding_panel/flutter_sliding_panel.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('test SlidingPanelRefresherConfig', () {
    test(
      'when instantiated, should correctly define equality with other object',
      () {
        final val1 = SlidingPanelRefresherConfig(
          onRefresh: () async {},
          triggerOffset: 80,
          maxDisplacement: 100,
          displacementSpeed: 5,
          edgeOffset: 10,
          indicatorSize: const Size(42, 42),
          resetDuration: const Duration(milliseconds: 300),
          resetCurve: Curves.bounceOut,
        );

        final val2 = SlidingPanelRefresherConfig(
          onRefresh: () async {},
          triggerOffset: 90,
          maxDisplacement: 120,
          displacementSpeed: 10,
          edgeOffset: 15,
          indicatorSize: const Size(54, 54),
          resetDuration: const Duration(milliseconds: 200),
          resetCurve: Curves.easeIn,
        );

        expect(val1 != val2, true);
      },
    );
  });
}
