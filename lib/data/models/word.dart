import 'package:isar/isar.dart';

part 'word.g.dart';

/// 词库来源
enum WordBook {
  zhenjing, // 雅思词汇真经
  listening179, // 听力 179 考点词
  reading538, // 阅读 538 同义替换
}

/// 单词主数据（Isar Collection）
@collection
class Word {
  Id id = Isar.autoIncrement;

  /// 单词本身（小写）
  @Index(unique: true, replace: true)
  late String word;

  /// 所属词库
  @Enumerated(EnumType.name)
  @Index()
  late WordBook book;

  /// 词性 v. n. adj. ...
  late String type;

  /// 词义（中文）
  late String meaning;

  /// 同义替换词列表
  late List<String> replace;

  /// 音频资源路径（Flutter asset 路径）
  /// 例如：assets/audio/179/reserve.mp3
  @Index()
  late String audioPath;

  Word();

  /// JSON 反序列化（种子用）
  factory Word.fromJson(
    Map<String, dynamic> json, {
    required WordBook book,
    required String audioPath,
  }) {
    return Word()
      ..word = (json['word'] as String).toLowerCase().trim()
      ..book = book
      ..type = (json['type'] as String?) ?? ''
      ..meaning = (json['meaning'] as String?) ?? ''
      ..replace = ((json['replace'] as List?) ?? const [])
          .map((e) => (e as String).toLowerCase().trim())
          .toList()
      ..audioPath = audioPath;
  }
}
