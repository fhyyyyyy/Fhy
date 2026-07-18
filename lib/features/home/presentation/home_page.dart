import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/bootstrap.dart';
import '../../../data/models/word.dart';
import '../../../data/repositories/review_repository.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boot = ref.watch(bootstrapProvider);
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
          if (boot.error != null) _ErrorBanner(error: boot.error!),
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
                Text('今日任务', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 12),
                Text(
                  due == 0 ? '今日已全部完成！' : '待复习：$due 词',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<int> _totalDue(ReviewRepository repo) async {
    final z = await repo.totalDueForBook(WordBook.zhenjing);
    final l = await repo.totalDueForBook(WordBook.listening179);
    final r = await repo.totalDueForBook(WordBook.reading538);
    return z + l + r;
  }
}

class _BookCard extends StatelessWidget {
  const _BookCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.book,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final WordBook book;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.pushNamed('study', pathParameters: {'book': _bookKey(book)}),
      ),
    );
  }

  String _bookKey(WordBook b) {
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

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.error});
  final String error;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        border: Border.all(color: Colors.red.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber, color: Colors.red.shade700, size: 20),
              const SizedBox(width: 8),
              const Text('启动警告', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
            ],
          ),
          const SizedBox(height: 8),
          Text(error, style: const TextStyle(fontSize: 12, color: Colors.red)),
        ],
      ),
    );
  }
}
