import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/isar_provider.dart';
import '../models/wrong_answer.dart';

/// 错题本仓库
class WrongAnswerRepository {
  WrongAnswerRepository(this._isar);
  final dynamic _isar; // Isar

  /// 记录一条错题
  Future<void> record({
    required int wordId,
    required String userInput,
    required String correctAnswer,
    required WrongErrorType errorType,
    required DateTime at,
  }) async {
    final wrong = WrongAnswer()
      ..wordId = wordId
      ..userInput = userInput
      ..correctAnswer = correctAnswer
      ..errorType = errorType
      ..occurredAt = at
      ..resolved = false;
    await _isar.writeTxn(() async {
      await _isar.wrongAnswers.put(wrong);
    });
  }

  /// 所有未解决的错题（按时间倒序）
  Future<List<WrongAnswer>> getUnresolved({int limit = 200}) async {
    return _isar.wrongAnswers
        .filter()
        .resolvedEqualTo(false)
        .sortByOccurredAtDesc()
        .limit(limit)
        .findAll();
  }

  /// 标为已掌握
  Future<void> markResolved(int id) async {
    await _isar.writeTxn(() async {
      final w = await _isar.wrongAnswers.get(id);
      if (w != null) {
        w.resolved = true;
        await _isar.wrongAnswers.put(w);
      }
    });
  }

  /// 错题数
  Future<int> countUnresolved() async {
    return _isar.wrongAnswers.filter().resolvedEqualTo(false).count();
  }

  /// 删除一条
  Future<void> delete(int id) async {
    await _isar.writeTxn(() async {
      await _isar.wrongAnswers.delete(id);
    });
  }

  /// 清空所有已解决
  Future<void> clearResolved() async {
    await _isar.writeTxn(() async {
      await _isar.wrongAnswers.filter().resolvedEqualTo(true).deleteAll();
    });
  }
}

final wrongAnswerRepositoryProvider = Provider<WrongAnswerRepository>((ref) {
  return WrongAnswerRepository(ref.watch(isarProvider));
});
