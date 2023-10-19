part of '../../sliding_panel.dart';

/// Control & animate sliding panel position.
class SlidingPanelController extends ValueNotifier<SlidingPanelDetail> {
  SlidingPanelController({
    SlidingPanelStatus status = SlidingPanelStatus.anchored,
  }) : super(
          SlidingPanelDetail(
            status: status,
            position: 0,
            anchorPosition: 0,
            expandPosition: 0,
            lastSnapPosition: 0,
            lastSnapStatus: status,
          ),
        );

  SlidingPanelStatus get status => value.status;

  @visibleForTesting
  void initValue(SlidingPanelDetail detail) => value = detail;

  @visibleForTesting
  void setValue(SlidingPanelDetail detail) {
    value = detail;
    notifyListeners();
  }

  @visibleForTesting
  void setStatus(SlidingPanelStatus newStatus) {
    if (newStatus != status) {
      value = value.copyWith(status: newStatus);
      notifyListeners();
    }
  }

  ///Expand the panel
  void expand() {
    value = value.copyWith(status: SlidingPanelStatus.expanded);
    notifyListeners();
  }

  ///Anchor the panel
  void anchor() {
    value = value.copyWith(status: SlidingPanelStatus.anchored);
    notifyListeners();
  }
}
