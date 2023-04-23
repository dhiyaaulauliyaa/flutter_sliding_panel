import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sliding_panel/flutter_sliding_panel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Sliding Panel',
      theme: ThemeData(brightness: Brightness.dark),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final controller = SlidingPanelController();
  int slidingPanelTypeChoice = 0;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Sliding Panel'),
        actions: [
          PopupMenuButton<int>(
            child: const Icon(Icons.more_vert),
            onSelected: (value) => setState(
              () => slidingPanelTypeChoice = value,
            ),
            itemBuilder: (BuildContext context) {
              return List.generate(
                3,
                (index) => PopupMenuItem<int>(
                  value: index,
                  child: Text(_getTypeFromIndex(index)),
                ),
              );
            },
          ),
        ],
      ),
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
      body: _slidingPanelWidget(),
    );
  }

  String _getTypeFromIndex(int index) {
    switch (index) {
      case 0:
        return 'Non-Scrollable';
      case 1:
        return 'Scrollable';
      case 2:
        return 'Multi Scrollable';
      default:
        return '';
    }
  }

  Widget _slidingPanelWidget() {
    switch (slidingPanelTypeChoice) {
      case 0:
        return SlidingPanelExample(controller: controller);
      case 1:
        return ScrollableContentSlidingPanelExample(controller: controller);
      case 2:
        return MultiScrollableContentSlidingPanelExample(
          controller: controller,
        );
      default:
        return const SizedBox();
    }
  }
}

class SlidingPanelExample extends StatelessWidget {
  const SlidingPanelExample({
    super.key,
    required this.controller,
  });

  final SlidingPanelController controller;

  @override
  Widget build(BuildContext context) {
    return SlidingPanel(
      controller: controller,
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
      panelContent: const Text(
        '\nDRAG ME!',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 40,
          letterSpacing: -1,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}

class ScrollableContentSlidingPanelExample extends StatelessWidget {
  const ScrollableContentSlidingPanelExample({
    super.key,
    required this.controller,
  });

  final SlidingPanelController controller;

  @override
  Widget build(BuildContext context) {
    return SlidingPanel.scrollableContent(
      controller: controller,
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
    );
  }
}

class MultiScrollableContentSlidingPanelExample extends StatefulWidget {
  const MultiScrollableContentSlidingPanelExample({
    super.key,
    required this.controller,
  });

  final SlidingPanelController controller;

  @override
  State<MultiScrollableContentSlidingPanelExample> createState() =>
      _MultiScrollableContentSlidingPanelExampleState();
}

class _MultiScrollableContentSlidingPanelExampleState
    extends State<MultiScrollableContentSlidingPanelExample>
    with SingleTickerProviderStateMixin {
  int tab = 0;
  late final TabController tabController;

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() => setState(() => tab = tabController.index));
  }

  @override
  Widget build(BuildContext context) {
    return SlidingPanel.multiScrollableContent(
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
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: CupertinoSlidingSegmentedControl(
              groupValue: tab,
              onValueChanged: (value) => setState(() {
                tab = value ?? 0;
                tabController.animateTo(tab);
              }),
              children: {
                0: Container(
                  width: double.maxFinite,
                  alignment: Alignment.center,
                  child: const Text('Tab 1'),
                ),
                1: Container(
                  width: double.maxFinite,
                  alignment: Alignment.center,
                  child: const Text('Tab 2'),
                ),
              },
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: List.generate(
                2,
                (index) => MultiScrollableChildTab(
                  controller: controller[index],
                  physics: physics[index],
                  tabIndex: index,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MultiScrollableChildTab extends StatefulWidget {
  const MultiScrollableChildTab({
    super.key,
    required this.controller,
    required this.physics,
    required this.tabIndex,
  });

  final ScrollController controller;
  final ScrollPhysics physics;
  final int tabIndex;

  @override
  State<MultiScrollableChildTab> createState() =>
      _MultiScrollableChildTabState();
}

class _MultiScrollableChildTabState extends State<MultiScrollableChildTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ListView.builder(
      controller: widget.controller,
      physics: widget.physics,
      itemBuilder: (context, index) => Container(
        height: 50,
        alignment: Alignment.center,
        color: Colors.white.withOpacity(index.isEven ? 0.2 : 0.3),
        child: Text('Tab ${widget.tabIndex + 1} Item $index'),
      ),
    );
  }
}
