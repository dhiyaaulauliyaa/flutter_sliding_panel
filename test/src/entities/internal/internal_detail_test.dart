import 'package:flutter_sliding_panel/src/entities/internal/internal_detail.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('test InternalDetail', () {
    test(
      'when isAnimating is called, should return correct value',
      () async {
        const detail1 = InternalDetail(isAnimating: true);
        expect(detail1.isAnimating, true);

        const detail2 = InternalDetail();
        expect(detail2.isAnimating, false);
      },
    );
    test(
      'when copyWith is called, should return correct value',
      () async {
        const detail = InternalDetail(isAnimating: true);
        expect(detail.isAnimating, true);

        final detailCopy1 = detail.copyWith(isAnimating: false);
        final detailCopy2 = detail.copyWith(isAnimating: true);
        final detailCopy3 = detail.copyWith();
        expect(detailCopy1.isAnimating, false);
        expect(detailCopy2.isAnimating, true);
        expect(detailCopy3.isAnimating, true);
      },
    );
  });
}
