import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/utils/bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 锁定竖屏
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // 初始化 Isar 等（失败不阻塞 UI）
  final bootResult = await bootstrap();
  debugPrint('[main] bootstrap result: ${bootResult.error ?? "ok"}');

  runApp(
    ProviderScope(
      overrides: [
        bootstrapProvider.overrideWithValue(bootResult),
      ],
      child: const IeltsApp(),
    ),
  );
}
