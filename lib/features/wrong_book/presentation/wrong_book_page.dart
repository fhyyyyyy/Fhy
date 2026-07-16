import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/word.dart';
import '../../../data/models/wrong_answer.dart';
import '../../../data/repositories/word_repository.dart';
import '../../../data/repositories/wrong_answer_repository.dart';

/// 错题本页面
class WrongBookPage extends ConsumerWidget {
  const WrongBookPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(wrongAnswerRepositoryProvider);
    final wordRepo = ref.watch(wordRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('错题本'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            tooltip: '清空已掌握',
            onPressed: () async {
              await repo.clearResolved();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('已清空已掌握的错题')),
                );
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<List<WrongAnswer>>(
        future: repo.getUnresolved(),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final wrongs = snap.data!;
          if (wrongs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.celebration, size: 64, color: Colors.green),
                  SizedBox(height: 16),
                  Text('🎉 没有错题！', style: TextStyle(fontSize: 18)),
                ],
              ),
            );
          }
          return ListView.separated(
            itemCount: wrongs.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, i) {
              final w = wrongs[i];
              return FutureBuilder<Word?>(
                future: wordRepo.getById(w.wordId),
                builder: (context, ws) {
                  final word = ws.data;
                  return ListTile(
                    leading: _ErrorIcon(type: w.errorType),
                    title: Text(
                      word?.word ?? '(已删除)',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (word != null)
                          Text('${word.type}  ${word.meaning}'),
                        if (w.userInput.isNotEmpty &&
                            w.userInput.toLowerCase() != w.correctAnswer)
                          Text(
                            '你写的: ${w.userInput}',
                            style: const TextStyle(color: Colors.red),
                          ),
                        Text(
                          _errorTypeText(w.errorType),
                          style: const TextStyle(
                              fontSize: 11, color: Colors.grey),
                        ),
                      ],
                    ),
                    isThreeLine: true,
                    trailing: IconButton(
                      icon: const Icon(Icons.check),
                      tooltip: '标为已掌握',
                      onPressed: () async {
                        await repo.markResolved(w.id);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('已掌握 ✓')),
                          );
                        }
                      },
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  String _errorTypeText(WrongErrorType t) {
    switch (t) {
      case WrongErrorType.spelling:
        return '拼写错误';
      case WrongErrorType.synonym:
        return '同义替换不完整';
      case WrongErrorType.both:
        return '拼写+同义都有错';
    }
  }
}

class _ErrorIcon extends StatelessWidget {
  final WrongErrorType type;
  const _ErrorIcon({required this.type});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;
    switch (type) {
      case WrongErrorType.spelling:
        icon = Icons.text_fields;
        color = Colors.red;
        break;
      case WrongErrorType.synonym:
        icon = Icons.compare_arrows;
        color = Colors.orange;
        break;
      case WrongErrorType.both:
        icon = Icons.error;
        color = Colors.deepOrange;
        break;
    }
    return CircleAvatar(
      backgroundColor: color.withOpacity(0.2),
      child: Icon(icon, color: color, size: 20),
    );
  }
}
