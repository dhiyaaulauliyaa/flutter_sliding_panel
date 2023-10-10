import 'package:flutter_sliding_panel/src/entities/internal/internal_controller.dart';
import 'package:flutter_sliding_panel/src/entities/internal/internal_detail.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late InternalController internalController;
  var emittedValues = <InternalDetail>[];
  void listener() => emittedValues.add(internalController.value);

  setUp(() {
    internalController = InternalController()..addListener(listener);
  });

  tearDown(() {
    emittedValues = [];
    internalController.removeListener(listener);
  });

  group('test InternalController', () {
    test(
      'when isAnimating is called, should return correct value',
      () async {
        internalController.setValue(const InternalDetail(isAnimating: true));
        expect(internalController.isAnimating, true);
      },
    );
    test(
      'when setValue is called, should update the controller value and notify listener',
      () async {
        internalController.setValue(const InternalDetail(isAnimating: true));
        expect(emittedValues.last.isAnimating, true);

        internalController.setValue(const InternalDetail());
        expect(emittedValues.last.isAnimating, false);
      },
    );
    test(
      'when setAnimatingStatus is called, should update the controller value and notify listener',
      () async {
        internalController.setAnimatingStatus(true);
        expect(emittedValues.last.isAnimating, true);

        internalController.setAnimatingStatus(false);
        expect(emittedValues.last.isAnimating, false);
      },
    );
  });
}
