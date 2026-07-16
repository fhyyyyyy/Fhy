import 'package:isar/isar.dart';

import '../../../core/utils/isar_provider.dart';
import '../../models/review_state.dart';
import '../../models/word.dart';

/// 复习状态 DAO
class ReviewDao {
  ReviewDao(this._isar);
  final Isar _isar;

  /// 根据 wordId 取复习状态
  Future<ReviewState?> getByWordId(int wordId) {
    return _isar.reviewStates.filter().wordIdEqualTo(wordId).findFirst();
  }

  /// 取出到期需复习的词（dueDate < now），按词库过滤
  Future<List<ReviewState>> getDueStates(WordBook book, DateTime now,
      {int limit = 50}) async {
    // 1. 拿到该词库下所有到期状态的 wordId
    final states = await _isar.reviewStates
        .filter()
        .dueDateLessThan(now)
        .limit(limit)
        .findAll();
    return states;
  }

  /// 写入/更新
  Future<void> put(ReviewState state) async {
    await _isar.writeTxn(() async {
      await _isar.reviewStates.put(state);
    });
  }

  /// 某词库总学习数
  Future<int> countLearned(WordBook book) async {
    // 通过 word join 统计：所有有 ReviewState 记录且 word 属于该词库
    final wordDao = WordDao(_isar);
    final words = await wordDao.getByBook(book);
    final ids = words.map((w) => w.id).toList();
    if (ids.isEmpty) return 0;
    return _isar.reviewStates
        .filter()
        .anyOf(ids, (q, id) => q.wordIdEqualTo(id))
        .count();
  }
}
