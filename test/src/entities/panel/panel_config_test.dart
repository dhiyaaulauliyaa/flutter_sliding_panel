import 'package:flutter_sliding_panel/flutter_sliding_panel.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('test SlidingPanelConfig', () {
    test(
      'when snapingThreshold is out of bounds, should throw exception',
      () {
        dynamic exception;

        try {
          SlidingPanelConfig(
            anchorPosition: 100,
            expandPosition: 200,
            snapingThreshold: 2,
          );
        } catch (e) {
          exception = e;
        }

        expect(exception, isNotNull);
        expect(exception, isA<AssertionError>());
      },
    );
    test(
      'when innerDistance is called, should return correct value',
      () {
        const val = SlidingPanelConfig(
          anchorPosition: 100,
          expandPosition: 200,
        );
        expect(val.innerDistance, 100);
      },
    );
    test(
      'when instantiated, should correctly define equality with other object',
      () {
        const val1 = SlidingPanelConfig(
          anchorPosition: 100,
          expandPosition: 200,
        );
        const val1Clone = SlidingPanelConfig(
          anchorPosition: 100,
          expandPosition: 200,
        );
        const val2 = SlidingPanelConfig(
          anchorPosition: 200,
          expandPosition: 250,
        );

        expect(val1 == val1Clone, true);
        expect(val1 != val2, true);
        expect(val1Clone != val2, true);
      },
    );
  });
}
