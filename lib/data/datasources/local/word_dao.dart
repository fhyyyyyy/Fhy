import 'package:isar/isar.dart';

import '../../../core/utils/isar_provider.dart';
import '../../models/word.dart';

/// 单词 DAO
class WordDao {
  WordDao(this._isar);
  final Isar _isar;

  /// 批量写入
  Future<void> putAll(List<Word> words) async {
    await _isar.writeTxn(() async {
      await _isar.words.putAll(words);
    });
  }

  /// 某词库总数
  Future<int> countByBook(WordBook book) {
    return _isar.words.filter().bookEqualTo(book).count();
  }

  /// 某词库所有词
  Future<List<Word>> getByBook(WordBook book) {
    return _isar.words.filter().bookEqualTo(book).findAll();
  }

  /// 按 ID 取
  Future<Word?> getById(int id) => _isar.words.get(id);

  /// 模糊搜索
  Future<List<Word>> search(String query, {int limit = 50}) {
    final q = query.toLowerCase().trim();
    if (q.isEmpty) return Future.value(const []);
    return _isar.words
        .filter()
        .wordContains(q, caseSensitive: false)
        .limit(limit)
        .findAll();
  }
}
