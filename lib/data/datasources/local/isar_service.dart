import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../models/review_state.dart';
import '../../models/study_session.dart';
import '../../models/word.dart';
import '../../models/wrong_answer.dart';

/// Isar 单例
class IsarService {
  IsarService._();
  static final IsarService instance = IsarService._();

  Isar? _isar;

  Isar get isar {
    final i = _isar;
    if (i == null) {
      throw StateError('Isar 未打开，请先调用 IsarService.instance.open()');
    }
    return i;
  }

  Future<void> open() async {
    if (_isar != null) return;
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [WordSchema, ReviewStateSchema, StudySessionSchema, WrongAnswerSchema],
      directory: dir.path,
      name: 'ielts_app',
    );
  }

  Future<void> close() async {
    await _isar?.close();
    _isar = null;
  }
}
