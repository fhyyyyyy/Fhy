import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/word.dart';
import '../../../data/repositories/word_repository.dart';

class LibraryPage extends ConsumerStatefulWidget {
  final WordBook? book;
  const LibraryPage({super.key, this.book});

  @override
  ConsumerState<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends ConsumerState<LibraryPage> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(wordRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book == null ? '全部词库' : _bookName(widget.book!)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              decoration: const InputDecoration(
                hintText: '搜索单词...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<Word>>(
        future: _query.isEmpty
            ? (widget.book == null
                ? repo.getByBook(WordBook.zhenjing)
                : repo.getByBook(widget.book!))
            : repo.search(_query),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final words = snap.data!;
          if (words.isEmpty) return const Center(child: Text('无结果'));
          return ListView.separated(
            itemCount: words.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, i) => _WordTile(word: words[i]),
          );
        },
      ),
    );
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

class _WordTile extends StatelessWidget {
  final Word word;
  const _WordTile({required this.word});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.volume_up),
      title: Text(word.word,
          style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(
        '${word.type}  ${word.meaning}\n同义: ${word.replace.join(', ')}',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      isThreeLine: true,
    );
  }
}
