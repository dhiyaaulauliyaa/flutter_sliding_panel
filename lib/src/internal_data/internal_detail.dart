part of '../sliding_panel.dart';

class _InternalDetail extends Equatable {
  const _InternalDetail({
    this.isAnimating = false,
  });

  final bool isAnimating;

  _InternalDetail copyWith({
    bool? isAnimating,
  }) =>
      _InternalDetail(
        isAnimating: isAnimating ?? this.isAnimating,
      );

  @override
  List<Object?> get props => [isAnimating];
}
