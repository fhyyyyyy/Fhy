import 'package:isar/isar.dart';

part 'wrong_answer.g.dart';

/// 错误类型
enum WrongErrorType {
  spelling, // 拼写错
  synonym, // 同义替换不完整
  both, // 都不对
}

/// 错题记录
@collection
class WrongAnswer {
  Id id = Isar.autoIncrement;

  @Index()
  late int wordId;

  late String userInput; // 用户输入
  late String correctAnswer; // 正确答案
  @Enumerated(EnumType.name)
  late WrongErrorType errorType;

  @Index()
  late DateTime occurredAt;

  /// 是否已复习过（用户标"已掌握"）
  late bool resolved;

  WrongAnswer();
}
