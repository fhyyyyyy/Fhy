import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/isar_provider.dart';
import '../../domain/algorithms/sm2.dart';
import '../models/review_state.dart';
import '../models/word.dart';

/// 复习仓库：负责调度（取到期词）+ 评分（应用 SM-2）
class ReviewRepository {
  ReviewRepository(this._reviewDao, this._wordDao);
  final dynamic _reviewDao; // ReviewDao
  final dynamic _wordDao; // WordDao

  /// 取出指定词库中到期需复习的词（按 dueDate 升序）
  Future<List<Word>> getDueWords(WordBook book, {int limit = 20}) async {
    final now = DateTime.now();
    final states = await _reviewDao.getDueStates(book, now, limit: limit);
    if (states.isEmpty) return const [];

    final wordIds = states.map((s) => s.wordId).toList();
    final words = <Word>[];
    for (final id in wordIds) {
      final w = await _wordDao.getById(id);
      if (w != null && w.book == book) words.add(w);
    }
    return words;
  }

  /// 取出指定词库中"新词"（还没有 ReviewState 记录的）
  Future<List<Word>> getNewWords(WordBook book, {int limit = 20}) async {
    final allWords = await _wordDao.getByBook(book);
    final newWords = <Word>[];
    for (final w in allWords) {
      final state = await _reviewDao.getByWordId(w.id);
      if (state == null) {
        newWords.add(w);
        if (newWords.length >= limit) break;
      }
    }
    return newWords;
  }

  /// 评分一次复习：应用 SM-2，更新 ReviewState
  Future<Sm2Output> gradeReview({
    required int wordId,
    required int quality,
    required DateTime now,
  }) async {
    // 1. 读/创建 ReviewState
    var state = await _reviewDao.getByWordId(wordId);
    state ??= ReviewState.initial(wordId: wordId, now: now);

    // 2. 跑 SM-2
    final output = Sm2.compute(Sm2Input(
      previousEf: state.easinessFactor,
      previousInterval: state.interval,
      previousRepetition: state.repetition,
      quality: quality,
      now: now,
    ));

    // 3. 写回
    state
      ..easinessFactor = output.newEf
      ..interval = output.newInterval
      ..repetition = output.newRepetition
      ..lapses = state.lapses + (output.isCorrect ? 0 : 1)
      ..dueDate = output.newDueDate
      ..lastReview = now;
    await _reviewDao.put(state);

    return output;
  }

  /// 某词库的累计学习数（有 ReviewState 记录的）
  Future<int> countLearned(WordBook book) async {
    return await _reviewDao.countLearned(book);
  }
}

final reviewRepositoryProvider = Provider<ReviewRepository>((ref) {
  return ReviewRepository(
    ref.watch(reviewDaoProvider),
    ref.watch(wordDaoProvider),
  );
});
