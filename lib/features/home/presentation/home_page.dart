import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/models/word.dart';
import '../../../data/repositories/review_repository.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('雅思词汇'),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu_book),
            onPressed: () => context.pushNamed('library'),
            tooltip: '词库',
          ),
          IconButton(
            icon: const Icon(Icons.error_outline),
            onPressed: () => context.pushNamed('wrong-book'),
            tooltip: '错题本',
          ),
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () => context.pushNamed('stats'),
            tooltip: '统计',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _TodayProgressCard(),
          const SizedBox(height: 24),
          Text('开始学习', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          _BookCard(
            title: '雅思词汇真经',
            subtitle: '逻辑词群记忆法',
            icon: Icons.book,
            color: Colors.orange,
            book: WordBook.zhenjing,
          ),
          _BookCard(
            title: '听力 179 考点词',
            subtitle: '雅思听力必备',
            icon: Icons.headphones,
            color: Colors.green,
            book: WordBook.listening179,
          ),
          _BookCard(
            title: '阅读 538 同义替换',
            subtitle: '阅读核心词',
            icon: Icons.menu_book,
            color: Colors.purple,
            book: WordBook.reading538,
          ),
        ],
      ),
    );
  }
}

class _TodayProgressCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(reviewRepositoryProvider);
    return FutureBuilder<int>(
      future: _totalDue(repo),
      builder: (context, snap) {
        final due = snap.data ?? 0;
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('今日任务',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(
                  due == 0 ? '🎉 全部复习完成！' : '📚 待复习 $due 词',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<int> _totalDue(ReviewRepository repo) async {
    var total = 0;
    for (final b in WordBook.values) {
      total += (await repo.getDueWords(b, limit: 1000)).length;
    }
    return total;
  }
}

class _BookCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final WordBook book;

  const _BookCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.book,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.pushNamed('study', pathParameters: {
          'book': _bookSlug(book),
        }),
      ),
    );
  }

  static String _bookSlug(WordBook b) {
    switch (b) {
      case WordBook.zhenjing:
        return 'zhenjing';
      case WordBook.listening179:
        return 'listening179';
      case WordBook.reading538:
        return 'reading538';
    }
  }
}
