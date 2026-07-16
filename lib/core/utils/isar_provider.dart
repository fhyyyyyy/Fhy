import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../../data/datasources/local/isar_service.dart';
import '../../data/datasources/local/review_dao.dart';
import '../../data/datasources/local/word_dao.dart';

/// 全局 Isar 实例 Provider
final isarProvider = Provider<Isar>((ref) {
  return IsarService.instance.isar;
});

final wordDaoProvider = Provider<WordDao>((ref) {
  return WordDao(ref.watch(isarProvider));
});

final reviewDaoProvider = Provider<ReviewDao>((ref) {
  return ReviewDao(ref.watch(isarProvider));
});
