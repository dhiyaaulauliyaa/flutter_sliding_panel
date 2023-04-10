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

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Sliding Panel')),
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
        pageContent: const Icon(Icons.bolt_rounded, size: 200),
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
      ),
    );
  }
}
