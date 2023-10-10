import 'package:flutter/material.dart';
import 'package:flutter_sliding_panel/flutter_sliding_panel.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('test ScrollablePanelContentDelegate', () {
    group('test when physics != null', () {
      test(
        'when physics length != count, should throw exception',
        () {
          dynamic exception;

          try {
            ScrollablePanelContentDelegate(
              count: 3,
              physics: [const BouncingScrollPhysics()],
            );
          } catch (e) {
            exception = e;
          }

          expect(exception, isNotNull);
          expect(exception, isA<AssertionError>());
        },
      );
      test(
        'when constructed, should use physics passed from params',
        () {
          const physics = [
            BouncingScrollPhysics(),
            ClampingScrollPhysics(),
          ];

          final val = ScrollablePanelContentDelegate(
            count: 2,
            physics: physics,
          );

          expect(val.defaultPhysics[0] == physics[0], true);
          expect(val.defaultPhysics[1] == physics[1], true);
          expect(val.physics.value[0] == physics[0], true);
          expect(val.physics.value[1] == physics[1], true);
        },
      );
    });
    group('test when scrollController != null', () {
      test(
        'when scrollController length != count, should throw exception',
        () {
          dynamic exception;

          try {
            ScrollablePanelContentDelegate(
              count: 3,
              scrollController: [ScrollController()],
            );
          } catch (e) {
            exception = e;
          }

          expect(exception, isNotNull);
          expect(exception, isA<AssertionError>());
        },
      );
      test(
        'when constructed, should use scrollController passed from params',
        () {
          final scrollControllers = [
            ScrollController(),
            ScrollController(),
          ];

          final val = ScrollablePanelContentDelegate(
            count: 2,
            scrollController: scrollControllers,
          );

          expect(val.scrollController[0] == scrollControllers[0], true);
          expect(val.scrollController[1] == scrollControllers[1], true);
        },
      );
    });

    group('test when scrollController & physics is null', () {
      test('when constructed, should construct default value', () {
        final val = ScrollablePanelContentDelegate(
          count: 2,
        );

        expect(val.defaultPhysics.length, 2);
        expect(val.physics.value.length, 2);
        expect(val.scrollController.length, 2);
        expect(val.scrollController.first, isA<ScrollController>());
        expect(val.defaultPhysics.first, isA<ScrollPhysics>());
        expect(val.physics.value.first, isA<ScrollPhysics>());
      });
    });
  });
}
