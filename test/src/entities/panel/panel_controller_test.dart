import 'package:flutter_sliding_panel/flutter_sliding_panel.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late SlidingPanelController panelController;
  var emittedValues = <SlidingPanelDetail>[];
  void listener() => emittedValues.add(panelController.value);

  setUp(() {
    panelController = SlidingPanelController()..addListener(listener);
  });

  tearDown(() {
    emittedValues = [];
    panelController.removeListener(listener);
  });

  group('test SlidingPanelController', () {
    test(
      'when status is called, should return correct value',
      () => expect(
        panelController.status,
        SlidingPanelStatus.anchored,
      ),
    );

    test(
      'when initValue is called, should update the controller value and notify listener',
      () async {
        const newValue = SlidingPanelDetail(
          status: SlidingPanelStatus.anchored,
          position: 100,
          anchorPosition: 100,
          expandPosition: 200,
          lastSnapPosition: 100,
          lastSnapStatus: SlidingPanelStatus.anchored,
        );
        panelController.initValue(newValue);

        expect(emittedValues.last.status, newValue.status);
        expect(emittedValues.last.position, newValue.position);
        expect(emittedValues.last.anchorPosition, newValue.anchorPosition);
        expect(emittedValues.last.expandPosition, newValue.expandPosition);
        expect(emittedValues.last.lastSnapPosition, newValue.lastSnapPosition);
        expect(emittedValues.last.lastSnapStatus, newValue.lastSnapStatus);
      },
    );

    test(
      'when setValue is called, should update the controller value and notify listener',
      () async {
        const newValue = SlidingPanelDetail(
          status: SlidingPanelStatus.anchored,
          position: 100,
          anchorPosition: 100,
          expandPosition: 200,
          lastSnapPosition: 100,
          lastSnapStatus: SlidingPanelStatus.anchored,
        );
        panelController.setValue(newValue);

        expect(emittedValues.last.status, newValue.status);
        expect(emittedValues.last.position, newValue.position);
        expect(emittedValues.last.anchorPosition, newValue.anchorPosition);
        expect(emittedValues.last.expandPosition, newValue.expandPosition);
        expect(emittedValues.last.lastSnapPosition, newValue.lastSnapPosition);
        expect(emittedValues.last.lastSnapStatus, newValue.lastSnapStatus);
      },
    );

    test(
      'when setStatus is called, should update the controller value and notify listener',
      () async {
        panelController.setStatus(SlidingPanelStatus.onDrag);
        expect(emittedValues.last.status, SlidingPanelStatus.onDrag);
      },
    );

    test(
      'when expand is called, should update the controller value and notify listener',
      () async {
        panelController.expand();
        expect(emittedValues.last.status, SlidingPanelStatus.expanded);
      },
    );

    test(
      'when anchor is called, should update the controller value and notify listener',
      () async {
        panelController.anchor();
        expect(emittedValues.last.status, SlidingPanelStatus.anchored);
      },
    );
  });
}
