import 'package:isar/isar.dart';

part 'review_state.g.dart';

/// 每个单词的复习状态（独立 collection 以便高效查询）
@collection
class ReviewState {
  Id id = Isar.autoIncrement;

  /// 关联到 Word.id
  @Index(unique: true)
  late int wordId;

  // ===== SM-2 算法字段 =====

  /// E-Factor（容易度），默认 2.5，下限 1.3
  late double easinessFactor;

  /// 当前间隔（天）
  late int interval;

  /// 连续答对次数
  late int repetition;

  /// 累计遗忘次数
  late int lapses;

  // ===== 时间字段 =====

  /// 下次到期复习时间
  @Index()
  late DateTime dueDate;

  /// 上次复习时间
  late DateTime lastReview;

  ReviewState();

  /// 工厂：新建一条初始状态
  factory ReviewState.initial({
    required int wordId,
    required DateTime now,
  }) {
    return ReviewState()
      ..wordId = wordId
      ..easinessFactor = 2.5
      ..interval = 0
      ..repetition = 0
      ..lapses = 0
      ..dueDate = now // 立刻可学
      ..lastReview = now;
  }
}
