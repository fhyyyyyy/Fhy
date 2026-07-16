import 'package:flutter_test/flutter_test.dart';
import 'package:ielts_app/domain/algorithms/sm2.dart';

void main() {
  group('SM-2 算法', () {
    final now = DateTime(2026, 7, 20);

    test('首次答对 (q=5) → interval=1, EF≈2.6', () {
      final r = Sm2.compute(Sm2Input(
        previousEf: 2.5,
        previousInterval: 0,
        previousRepetition: 0,
        quality: 5,
        now: now,
      ));
      expect(r.newInterval, 1);
      expect(r.newRepetition, 1);
      expect(r.newEf, closeTo(2.6, 0.01));
    });

    test('第二次答对 (q=4) → interval=6, repetition=2', () {
      final r = Sm2.compute(Sm2Input(
        previousEf: 2.5,
        previousInterval: 1,
        previousRepetition: 1,
        quality: 4,
        now: now,
      ));
      expect(r.newInterval, 6);
      expect(r.newRepetition, 2);
    });

    test('答错 (q=2) → 重置 interval=1, repetition=0, EF 下降', () {
      final r = Sm2.compute(Sm2Input(
        previousEf: 2.5,
        previousInterval: 10,
        previousRepetition: 5,
        quality: 2,
        now: now,
      ));
      expect(r.newInterval, 1);
      expect(r.newRepetition, 0);
      expect(r.newEf, lessThan(2.5));
    });

    test('EF 下限保护：连错多次 EF 不会低于 1.3', () {
      var ef = 2.5;
      for (var i = 0; i < 5; i++) {
        ef = Sm2.compute(Sm2Input(
          previousEf: ef,
          previousInterval: 1,
          previousRepetition: 0,
          quality: 0,
          now: now,
        )).newEf;
      }
      expect(ef, 1.3);
    });

    test('第三次答对 (q=5, prev=6) → interval=15 (≈ 6*2.6)', () {
      final r = Sm2.compute(Sm2Input(
        previousEf: 2.6,
        previousInterval: 6,
        previousRepetition: 2,
        quality: 5,
        now: now,
      ));
      expect(r.newInterval, closeTo(15, 1));
    });

    test('dueDate = now + interval 天', () {
      final r = Sm2.compute(Sm2Input(
        previousEf: 2.5,
        previousInterval: 0,
        previousRepetition: 0,
        quality: 4,
        now: now,
      ));
      expect(r.newDueDate.difference(now).inDays, r.newInterval);
    });

    test('isCorrect 标志正确', () {
      final wrong = Sm2.compute(Sm2Input(
        previousEf: 2.5,
        previousInterval: 5,
        previousRepetition: 3,
        quality: 2,
        now: now,
      ));
      expect(wrong.isCorrect, isFalse);

      final right = Sm2.compute(Sm2Input(
        previousEf: 2.5,
        previousInterval: 5,
        previousRepetition: 3,
        quality: 4,
        now: now,
      ));
      expect(right.isCorrect, isTrue);
    });
  });
}
