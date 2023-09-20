part of '../../sliding_panel.dart';

abstract class PanelContentDelegate {}

class ScrollablePanelContentDelegate extends PanelContentDelegate {
  ScrollablePanelContentDelegate({
    int count = 1,
    List<ScrollController>? scrollController,
    List<ScrollPhysics>? physics,
  })  : assert(physics != null && physics.length == count || physics == null),
        assert(
          scrollController != null && scrollController.length == count ||
              scrollController == null,
        ) {
    this.scrollController = scrollController ??
        List.generate(
          count,
          (_) => ScrollController(),
        );

    this.physics = ValueNotifier(
      physics ??
          List.generate(
            count,
            (index) => const BouncingScrollPhysics(),
          ),
    );

    defaultPhysics = physics ??
        List.generate(
          count,
          (index) => const BouncingScrollPhysics(),
        );
  }

  late final List<ScrollController> scrollController;
  late final ValueNotifier<List<ScrollPhysics>> physics;
  late final List<ScrollPhysics> defaultPhysics;
}
