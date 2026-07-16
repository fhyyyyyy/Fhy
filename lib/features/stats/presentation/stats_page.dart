import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/word.dart';
import '../../../data/repositories/review_repository.dart';

class StatsPage extends ConsumerWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(reviewRepositoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('统计')),
      body: FutureBuilder<List<int>>(
        future: _loadStats(repo),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final counts = snap.data!;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              for (var i = 0; i < WordBook.values.length; i++)
                Card(
                  child: ListTile(
                    title: Text(_bookName(WordBook.values[i])),
                    subtitle: Text('已学习 ${counts[i]} 词'),
                    leading: const Icon(Icons.book),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Future<List<int>> _loadStats(ReviewRepository repo) async {
    final result = <int>[];
    for (final b in WordBook.values) {
      result.add(await repo.countLearned(b));
    }
    return result;
  }

  String _bookName(WordBook b) {
    switch (b) {
      case WordBook.zhenjing:
        return '词汇真经';
      case WordBook.listening179:
        return '听力 179';
      case WordBook.reading538:
        return '阅读 538';
    }
  }
}
