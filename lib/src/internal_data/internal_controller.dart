part of '../sliding_panel.dart';

class _InternalController extends ValueNotifier<_InternalDetail> {
  _InternalController() : super(const _InternalDetail());

  bool get isAnimating => value.isAnimating;

  @protected
  void setValue(_InternalDetail detail) {
    value = detail;
    notifyListeners();
  }

  @protected
  void setAnimatingStatus(bool isAnimating) {
    value = value.copyWith(isAnimating: isAnimating);
    notifyListeners();
  }
}
