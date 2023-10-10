import 'package:equatable/equatable.dart';
class InternalDetail extends Equatable {
  const InternalDetail({
    this.isAnimating = false,
  });

  final bool isAnimating;

  InternalDetail copyWith({
    bool? isAnimating,
  }) =>
      InternalDetail(
        isAnimating: isAnimating ?? this.isAnimating,
      );

  @override
  List<Object?> get props => [isAnimating];
}
