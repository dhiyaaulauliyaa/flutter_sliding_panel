import 'package:flutter_sliding_panel/flutter_sliding_panel.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('test SlidingPanelSnapingBehavior', () {
    test(
      'when isAlternating is called, should return correct value',
      () {
        const val1 = SlidingPanelSnapingBehavior.alternating;
        const val2 = SlidingPanelSnapingBehavior.fixed;

        expect(val1.isAlternating, true);
        expect(val2.isAlternating, false);
      },
    );
    test(
      'when isFixed is called, should return correct value',
      () {
        const val1 = SlidingPanelSnapingBehavior.alternating;
        const val2 = SlidingPanelSnapingBehavior.fixed;

        expect(val1.isFixed, false);
        expect(val2.isFixed, true);
      },
    );
  });
}
