import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/local/isar_service.dart';
import '../../data/datasources/seed/word_seed_loader.dart';

/// 应用启动初始化
///
/// 负责打开 Isar、首次启动时种入词库。
/// 后续可以加：通知初始化、用户偏好加载、Crashlytics 等。
Future<void> bootstrap() async {
  // 打开 Isar
  await IsarService.instance.open();

  // 检查是否需要种入词库（首次启动）
  await WordSeedLoader.instance.seedIfNeeded();
}

/// 业务启动后可访问的全局 Provider 容器
final bootstrapProvider = Provider<BootstrapState>((ref) => BootstrapState());

class BootstrapState {
  const BootstrapState();
}
