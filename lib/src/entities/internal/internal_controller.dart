import 'package:flutter/material.dart';
import 'package:flutter_sliding_panel/src/entities/internal/internal_detail.dart';

class InternalController extends ValueNotifier<InternalDetail> {
  InternalController() : super(const InternalDetail());

  bool get isAnimating => value.isAnimating;

  void setValue(InternalDetail detail) {
    value = detail;
    notifyListeners();
  }

  void setAnimatingStatus(bool isAnimating) {
    value = value.copyWith(isAnimating: isAnimating);
    notifyListeners();
  }
}
