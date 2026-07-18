import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/local/isar_service.dart';
import '../../data/datasources/seed/word_seed_loader.dart';

class BootstrapResult {
  final bool isarOpened;
  final bool seedCompleted;
  final String? error;

  const BootstrapResult({
    required this.isarOpened,
    required this.seedCompleted,
    this.error,
  });
}

/// 应用启动初始化
///
/// 负责打开 Isar、首次启动时种入词库。
/// 任何步骤失败都不会阻塞 UI——错误会被记录并展示。
Future<BootstrapResult> bootstrap() async {
  bool isarOk = false;
  bool seedOk = false;
  String? error;

  try {
    await IsarService.instance.open();
    isarOk = true;
    debugPrint('[bootstrap] Isar opened');
  } catch (e, st) {
    error = 'Isar 打开失败: $e';
    debugPrint('[bootstrap] Isar FAILED: $e\n$st');
  }

  if (isarOk) {
    try {
      await WordSeedLoader.instance.seedIfNeeded();
      seedOk = true;
      debugPrint('[bootstrap] Seed completed');
    } catch (e, st) {
      error = (error == null ? '' : '$error\n') + '词库种入失败: $e';
      debugPrint('[bootstrap] Seed FAILED: $e\n$st');
    }
  }

  return BootstrapResult(
    isarOpened: isarOk,
    seedCompleted: seedOk,
    error: error,
  );
}

/// 业务启动后可访问的全局 Provider 容器
final bootstrapProvider = Provider<BootstrapResult>((ref) {
  throw UnimplementedError('bootstrapProvider should be overridden in main()');
});
