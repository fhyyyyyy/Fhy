import 'dart:math';

/// SM-2 算法的输入参数
class Sm2Input {
  final double previousEf;
  final int previousInterval;
  final int previousRepetition;
  final int quality; // 0-5: 0-2 答错，3-5 答对
  final DateTime now;

  const Sm2Input({
    required this.previousEf,
    required this.previousInterval,
    required this.previousRepetition,
    required this.quality,
    required this.now,
  });
}

class Sm2Output {
  final double newEf;
  final int newInterval;
  final int newRepetition;
  final int intervalIncrement; // 用于判断是否答错的标志
  final DateTime newDueDate;

  const Sm2Output({
    required this.newEf,
    required this.newInterval,
    required this.newRepetition,
    required this.intervalIncrement,
    required this.newDueDate,
  });

  bool get isCorrect => newRepetition > previousRepetition;
}

/// SM-2 标准算法（SuperMemo 2，1987）
/// 参考：https://super-memory.com/english/ol/sm2.htm
class Sm2 {
  static Sm2Output compute(Sm2Input input) {
    final q = input.quality;
    final prevRepetition = input.previousRepetition;

    // 1. 计算新的 easiness factor
    // EF' = EF + (0.1 - (5-q) * (0.08 + (5-q) * 0.02))
    final ef = max(
      1.3,
      input.previousEf + (0.1 - (5 - q) * (0.08 + (5 - q) * 0.02)),
    );

    // 2. 计算 repetition 和 interval
    int repetition;
    int interval;
    int intervalIncrement;

    if (q < 3) {
      // 答错：重置
      repetition = 0;
      interval = 1;
      intervalIncrement = 0;
    } else {
      repetition = prevRepetition + 1;
      if (repetition == 1) {
        interval = 1;
      } else if (repetition == 2) {
        interval = 6;
      } else {
        interval = (input.previousInterval * ef).round();
      }
      intervalIncrement = interval - input.previousInterval;
    }

    return Sm2Output(
      newEf: ef,
      newInterval: interval,
      newRepetition: repetition,
      intervalIncrement: intervalIncrement,
      newDueDate: input.now.add(Duration(days: interval)),
    );
  }
}
