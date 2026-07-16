import 'package:isar/isar.dart';

import 'word.dart';

part 'study_session.g.dart';

/// 学习会话（统计用）
@collection
class StudySession {
  Id id = Isar.autoIncrement;

  @Index()
  late DateTime startAt;

  late DateTime? endAt;

  @Enumerated(EnumType.name)
  late WordBook book;

  late int newWordsCount; // 本次学的新词数
  late int reviewedCount; // 本次复习的词数
  late int correctCount; // 正确次数
  late int errorCount; // 错误次数

  StudySession();
}
