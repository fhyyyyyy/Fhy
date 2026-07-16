import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/isar_provider.dart';
import '../models/word.dart';

/// 单词仓库（面向业务层）
class WordRepository {
  WordRepository(this._wordDao);
  final dynamic _wordDao; // WordDao（避免循环 import 用 dynamic）

  Future<List<Word>> getByBook(WordBook book) async {
    return await _wordDao.getByBook(book);
  }

  Future<int> countByBook(WordBook book) async {
    return await _wordDao.countByBook(book);
  }

  Future<List<Word>> search(String query) async {
    return await _wordDao.search(query);
  }

  Future<Word?> getById(int id) async {
    return await _wordDao.getById(id);
  }
}

final wordRepositoryProvider = Provider<WordRepository>((ref) {
  return WordRepository(ref.watch(wordDaoProvider));
});
