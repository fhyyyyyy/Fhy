import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:isar/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../local/isar_service.dart';
import '../../models/word.dart';

/// 词库种子加载器
///
/// 首次启动时从 assets/words/ 加载 JSON 并写入 Isar。
/// 用 SharedPreferences 记录 seedVersion，避免重复种入。
class WordSeedLoader {
  WordSeedLoader._();
  static final WordSeedLoader instance = WordSeedLoader._();

  static const _seedVersionKey = 'seed_version';
  static const _currentSeedVersion = 1;

  /// 检查并种入
  Future<void> seedIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    final lastVersion = prefs.getInt(_seedVersionKey) ?? 0;
    if (lastVersion >= _currentSeedVersion) return;

    await _seedAll();

    await prefs.setInt(_seedVersionKey, _currentSeedVersion);
  }

  /// 强制重新种入（调试用）
  Future<void> forceReseed() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_seedVersionKey);
    await _seedAll();
    await prefs.setInt(_seedVersionKey, _currentSeedVersion);
  }

  Future<void> _seedAll() async {
    final isar = IsarService.instance.isar;

    // 三个词库的 JSON（朗读由 TTS 实时合成，不再依赖音频文件）
    await _seedOne(isar, 'assets/words/zhenjing.json', WordBook.zhenjing);
    await _seedOne(isar, 'assets/words/listening179.json',
        WordBook.listening179);
    await _seedOne(isar, 'assets/words/reading538.json',
        WordBook.reading538);
  }

  Future<void> _seedOne(
    Isar isar,
    String jsonPath,
    WordBook book,
  ) async {
    final jsonStr = await rootBundle.loadString(jsonPath);
    final list = (jsonDecode(jsonStr) as List).cast<Map<String, dynamic>>();

    final words = list.map((m) {
      return Word.fromJson(m, book: book);
    }).toList();

    await isar.writeTxn(() async {
      await isar.words.putAll(words);
    });
  }
}
