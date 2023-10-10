import 'package:flutter/material.dart';
import 'package:flutter_sliding_panel/flutter_sliding_panel.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('test FlutterSlidingPanel', () {
    testWidgets(
      'when panel is dragged, should snap correctly',
      (tester) async {
        tester.binding.window.physicalSizeTestValue = const Size(300, 800);
        tester.binding.window.devicePixelRatioTestValue = 1.0;

        final controller = SlidingPanelController();

        await tester.pumpWidget(
          MaterialApp(
            home: _TestPage(
              controller: controller,
            ),
          ),
        );
        await tester.pumpAndSettle();

        // when dragged below threshold, should back to its original state
        await tester.dragFrom(const Offset(150, 600), const Offset(0, -10));
        await tester.pumpAndSettle();
        expect(controller.value.status, SlidingPanelStatus.anchored);

        // when dragged over threshold, should snap to other state
        await tester.dragFrom(const Offset(150, 600), const Offset(0, -100));
        await tester.pumpAndSettle();
        expect(controller.value.status, SlidingPanelStatus.expanded);

        // when FAB is tapped, panel should change state
        await tester.tap(find.byType(FloatingActionButton));
        await tester.pumpAndSettle();
        expect(controller.value.status, SlidingPanelStatus.anchored);

        // when dragged down and panel is anchored, shouldn't change state
        await tester.dragFrom(const Offset(150, 600), const Offset(0, 300));
        await tester.pumpAndSettle();
        expect(controller.value.status, SlidingPanelStatus.anchored);

        // when expanded and dragged down pass threshold,
        // panel should be anchored
        await tester.tap(find.byType(FloatingActionButton));
        await tester.pumpAndSettle();
        await tester.dragFrom(const Offset(150, 600), const Offset(0, 10));
        expect(controller.value.status, SlidingPanelStatus.anchored);
      },
    );

    testWidgets(
      'when panel with scrollable content is dragged, '
      'scrollview should behave as expected',
      (tester) async {
        tester.binding.window.physicalSizeTestValue = const Size(300, 800);
        tester.binding.window.devicePixelRatioTestValue = 1.0;

        final controller = SlidingPanelController();

        await tester.pumpWidget(
          MaterialApp(
            home: _ScrollableTestPage(
              controller: controller,
            ),
          ),
        );
        await tester.pumpAndSettle();

        // when dragged up to expanded, scrollview should not be scrollable
        await tester.dragFrom(const Offset(150, 600), const Offset(0, -100));
        await tester.pumpAndSettle();
        expect(controller.value.status, SlidingPanelStatus.expanded);

        // when dragged up again, scrollview should be scrollable
        await tester.dragFrom(const Offset(150, 600), const Offset(0, -100));
        await tester.pumpAndSettle();
        expect(controller.value.status, SlidingPanelStatus.expanded);

        // when dragged down, scrollview should stop scroll when
        // offset is zero and panel shouldn't be anchored
        await tester.dragFrom(const Offset(150, 600), const Offset(0, 150));
        await tester.pumpAndSettle();
        expect(controller.value.status, SlidingPanelStatus.expanded);

        // when dragged up, scrollview should be scrollable again
        await tester.dragFrom(const Offset(150, 600), const Offset(0, -100));
        await tester.pumpAndSettle();
        expect(controller.value.status, SlidingPanelStatus.expanded);

        // when FAB is tapped, panel scrollview should animate to 0 offset
        await tester.dragFrom(const Offset(150, 600), const Offset(0, -100));
        await tester.dragFrom(const Offset(150, 600), const Offset(0, -100));
        await tester.pumpAndSettle();
        await tester.tap(find.byType(FloatingActionButton));
        await tester.pumpAndSettle();
        expect(controller.value.status, SlidingPanelStatus.anchored);

        // when dragged down again, refresh indicator should be triggered
        await tester.dragFrom(const Offset(150, 600), const Offset(0, 250));
        await tester.pumpAndSettle();
        expect(controller.value.status, SlidingPanelStatus.anchored);

        // when anchored and dragged up then dragged down,
        // scrollview shouldn't be scrollable and
        // panel should be directly anchored after expanded
        await tester.tap(find.byType(FloatingActionButton));
        await tester.pumpAndSettle();
        await tester.dragFrom(const Offset(150, 600), const Offset(0, 150));
        await tester.pumpAndSettle();
        expect(controller.value.status, SlidingPanelStatus.anchored);
      },
    );

    testWidgets(
      'when panel with multi scrollable content is dragged, '
      'scrollview should behave as expected',
      (tester) async {
        tester.binding.window.physicalSizeTestValue = const Size(300, 800);
        tester.binding.window.devicePixelRatioTestValue = 1.0;

        final controller = SlidingPanelController(
          status: SlidingPanelStatus.expanded,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: _MultiScrollableTestPage(
              controller: controller,
            ),
          ),
        );
        await tester.pumpAndSettle();

        // when dragged up from expanded state, scrollview should be scrollable
        await tester.dragFrom(const Offset(150, 600), const Offset(0, -100));
        await tester.pumpAndSettle();
        expect(controller.value.status, SlidingPanelStatus.expanded);

        // when dragged down, scrollview should stop scroll when
        // offset is zero and panel shouldn't be anchored
        await tester.dragFrom(const Offset(150, 600), const Offset(0, 150));
        await tester.pumpAndSettle();
        expect(controller.value.status, SlidingPanelStatus.expanded);

        // when dragged up, scrollview should be scrollable again
        await tester.dragFrom(const Offset(150, 600), const Offset(0, -100));
        await tester.pumpAndSettle();
        expect(controller.value.status, SlidingPanelStatus.expanded);

        // when FAB is tapped, panel scrollview should animate to 0 offset
        await tester.dragFrom(const Offset(150, 600), const Offset(0, -100));
        await tester.dragFrom(const Offset(150, 600), const Offset(0, -100));
        await tester.pumpAndSettle();
        await tester.tap(find.byType(FloatingActionButton));
        await tester.pumpAndSettle();
        expect(controller.value.status, SlidingPanelStatus.anchored);

        // when dragged down again, refresh indicator should be triggered
        await tester.dragFrom(const Offset(150, 600), const Offset(0, 250));
        await tester.pumpAndSettle();
        expect(controller.value.status, SlidingPanelStatus.anchored);
      },
    );
  });
}

class _TestPage extends StatelessWidget {
  const _TestPage({
    required this.controller,
  });

  final SlidingPanelController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: ValueListenableBuilder<SlidingPanelDetail>(
          valueListenable: controller,
          builder: (_, detail, __) {
            return Icon(
              detail.status == SlidingPanelStatus.anchored
                  ? Icons.keyboard_arrow_up_rounded
                  : Icons.keyboard_arrow_down_rounded,
            );
          },
        ),
        onPressed: () {
          if (controller.status == SlidingPanelStatus.anchored) {
            controller.expand();
          } else {
            controller.anchor();
          }
        },
      ),
      body: SlidingPanel(
        controller: controller,
        config: SlidingPanelConfig(
          anchorPosition: MediaQuery.of(context).size.height / 2,
          expandPosition: MediaQuery.of(context).size.height - 200,
          snapingBehavior: SlidingPanelSnapingBehavior.fixed,
        ),
        dragToRefreshConfig: SlidingPanelRefresherConfig(
          triggerOffset: 20,
          onRefresh: () async {
            await Future.delayed(const Duration(milliseconds: 1500), () {});
            return;
          },
        ),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
          boxShadow: const [
            BoxShadow(
              blurRadius: 5,
              spreadRadius: 2,
              color: Color(0x11000000),
            ),
          ],
        ),
        pageContent: Column(
          children: const [
            Icon(Icons.bolt_rounded, size: 200),
          ],
        ),
        leading: Container(
          width: 50,
          height: 8,
          margin: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        panelContent: Container(
          width: 100,
          height: 100,
          color: Colors.amber,
        ),
      ),
    );
  }
}

class _ScrollableTestPage extends StatelessWidget {
  const _ScrollableTestPage({
    required this.controller,
  });

  final SlidingPanelController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: ValueListenableBuilder<SlidingPanelDetail>(
          valueListenable: controller,
          builder: (_, detail, __) {
            return Icon(
              detail.status == SlidingPanelStatus.anchored
                  ? Icons.keyboard_arrow_up_rounded
                  : Icons.keyboard_arrow_down_rounded,
            );
          },
        ),
        onPressed: () {
          if (controller.status == SlidingPanelStatus.anchored) {
            controller.expand();
          } else {
            controller.anchor();
          }
        },
      ),
      body: SlidingPanel.scrollableContent(
        controller: controller,
        config: SlidingPanelConfig(
          anchorPosition: MediaQuery.of(context).size.height / 2,
          expandPosition: MediaQuery.of(context).size.height - 200,
        ),
        dragToRefreshConfig: SlidingPanelRefresherConfig(
          maxDisplacement: 20,
          displacementSpeed: 100,
          indicatorChild: const SizedBox(width: 20, height: 20),
          indicatorRefreshChild: const SizedBox(width: 20, height: 20),
          onRefresh: () async {
            await Future.delayed(const Duration(milliseconds: 1500), () {});
            return;
          },
          indicatorSize: const Size(52, 52),
          indicatorBuilder: (context, isRefreshing, displacement) {
            return DecoratedBox(
              decoration: const BoxDecoration(
                color: Colors.amber,
                shape: BoxShape.circle,
              ),
              child: isRefreshing
                  ? Padding(
                      padding: const EdgeInsets.all(12),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Colors.grey[700],
                        ),
                      ),
                    )
                  : Transform.rotate(
                      angle: displacement * 0.05,
                      child: Icon(
                        Icons.refresh,
                        color: Colors.grey[700],
                      ),
                    ),
            );
          },
        ),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
          boxShadow: const [
            BoxShadow(
              blurRadius: 5,
              spreadRadius: 2,
              color: Color(0x11000000),
            ),
          ],
        ),
        pageContent: Column(
          children: const [
            Icon(Icons.bolt_rounded, size: 200),
          ],
        ),
        panelContentBuilder: (controller, physics) => Column(
          children: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 12),
              color: Colors.white.withOpacity(0.3),
              child: Container(
                height: 4,
                width: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.grey,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: controller,
                physics: physics,
                itemBuilder: (context, index) => Container(
                  height: 50,
                  alignment: Alignment.center,
                  color: Colors.white.withOpacity(index.isEven ? 0.2 : 0.3),
                  child: Text('$index'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MultiScrollableTestPage extends StatefulWidget {
  const _MultiScrollableTestPage({
    required this.controller,
  });

  final SlidingPanelController controller;

  @override
  State<_MultiScrollableTestPage> createState() =>
      _MultiScrollableTestPageState();
}

class _MultiScrollableTestPageState extends State<_MultiScrollableTestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: ValueListenableBuilder<SlidingPanelDetail>(
          valueListenable: widget.controller,
          builder: (_, detail, __) {
            return Icon(
              detail.status == SlidingPanelStatus.anchored
                  ? Icons.keyboard_arrow_up_rounded
                  : Icons.keyboard_arrow_down_rounded,
            );
          },
        ),
        onPressed: () {
          setState(() {
            if (widget.controller.status == SlidingPanelStatus.anchored) {
              widget.controller.expand();
            } else {
              widget.controller.anchor();
            }
          });
        },
      ),
      body: SlidingPanel.multiScrollableContent(
        controller: widget.controller,
        scrollableChildCount: 2,
        config: SlidingPanelConfig(
          anchorPosition: MediaQuery.of(context).size.height / 2,
          expandPosition: MediaQuery.of(context).size.height - 200,
        ),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
          boxShadow: const [
            BoxShadow(
              blurRadius: 5,
              spreadRadius: 2,
              color: Color(0x11000000),
            ),
          ],
        ),
        pageContent: Column(
          children: const [
            Icon(Icons.bolt_rounded, size: 200),
          ],
        ),
        leading: Container(
          width: 50,
          height: 8,
          margin: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        panelContentBuilder: (controller, physics) => Column(
          children: List.generate(
            2,
            (index) => Expanded(
              child: ListView.builder(
                controller: controller[index],
                physics: physics[index],
                itemBuilder: (context, index) => Container(
                  height: 50,
                  alignment: Alignment.center,
                  color: Colors.white.withOpacity(
                    index.isEven ? 0.2 : 0.3,
                  ),
                  child: Text('Tab ${index + 1} Item $index'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
