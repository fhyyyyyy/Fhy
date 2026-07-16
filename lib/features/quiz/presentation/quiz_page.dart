import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/word.dart';
import '../../../data/repositories/review_repository.dart';

/// 测验页：多选 + 同义替换匹配
class QuizPage extends ConsumerStatefulWidget {
  final WordBook book;
  const QuizPage({required this.book, super.key});

  @override
  ConsumerState<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends ConsumerState<QuizPage> {
  // 占位实现：复用 StudyPage 的逻辑
  // 后续可扩展为：四选一选义、多选选同义替换
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('测验')),
      body: const Center(
        child: Text('测验模式开发中\n将包含：四选一选义、匹配同义替换',
            textAlign: TextAlign.center),
      ),
    );
  }
}
