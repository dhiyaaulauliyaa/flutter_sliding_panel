import 'package:flutter_sliding_panel/flutter_sliding_panel.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('test SlidingPanelDetail', () {
    test(
      'when getter is called, should return correct value',
      () {
        const val = SlidingPanelDetail(
          status: SlidingPanelStatus.anchored,
          position: 100,
          anchorPosition: 100,
          expandPosition: 200,
          lastSnapPosition: 100,
          lastSnapStatus: SlidingPanelStatus.anchored,
        );

        expect(val.isExpanded, false);
        expect(val.isAnchored, true);
        expect(val.dragRange, 100);
        expect(val.dragCompletionRate, 0);
      },
    );

    test(
      'when copyWith is called, should return correct value',
      () async {
        const val = SlidingPanelDetail(
          status: SlidingPanelStatus.anchored,
          position: 100,
          anchorPosition: 100,
          expandPosition: 200,
          lastSnapPosition: 100,
          lastSnapStatus: SlidingPanelStatus.anchored,
        );
        expect(val.isExpanded, false);
        expect(val.isAnchored, true);
        expect(val.dragRange, 100);
        expect(val.dragCompletionRate, 0);

        final valCopy1 = val.copyWith();
        expect(valCopy1.isExpanded, false);
        expect(valCopy1.isAnchored, true);
        expect(valCopy1.dragRange, 100);
        expect(valCopy1.dragCompletionRate, 0);

        final valCopy2 = val.copyWith(
          status: SlidingPanelStatus.onDrag,
          position: 350,
          anchorPosition: 200,
          expandPosition: 400,
          lastSnapPosition: 400,
          lastSnapStatus: SlidingPanelStatus.expanded,
        );
        expect(valCopy2.isExpanded, false);
        expect(valCopy2.isAnchored, false);
        expect(valCopy2.dragRange, 200);
        expect(valCopy2.dragCompletionRate, 0.25);
      },
    );

    test(
      'when instantiated, should correctly define equality with other object',
      () {
        const val1 = SlidingPanelDetail(
          status: SlidingPanelStatus.anchored,
          position: 100,
          anchorPosition: 100,
          expandPosition: 200,
          lastSnapPosition: 100,
          lastSnapStatus: SlidingPanelStatus.anchored,
        );
        const val1Clone = SlidingPanelDetail(
          status: SlidingPanelStatus.anchored,
          position: 100,
          anchorPosition: 100,
          expandPosition: 200,
          lastSnapPosition: 100,
          lastSnapStatus: SlidingPanelStatus.anchored,
        );
        const val2 = SlidingPanelDetail(
          status: SlidingPanelStatus.onDrag,
          position: 350,
          anchorPosition: 200,
          expandPosition: 400,
          lastSnapPosition: 400,
          lastSnapStatus: SlidingPanelStatus.expanded,
        );

        expect(val1 == val1Clone, true);
        expect(val1 != val2, true);
        expect(val1Clone != val2, true);
      },
    );
  });
}
