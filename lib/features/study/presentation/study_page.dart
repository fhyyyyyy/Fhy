import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import '../../../data/models/word.dart';
import '../../../data/models/wrong_answer.dart';
import '../../../data/repositories/review_repository.dart';
import '../../../data/repositories/wrong_answer_repository.dart';
import 'widgets/grade_buttons.dart';

class StudyPage extends ConsumerStatefulWidget {
  final WordBook book;
  const StudyPage({required this.book, super.key});

  @override
  ConsumerState<StudyPage> createState() => _StudyPageState();
}

class _StudyPageState extends ConsumerState<StudyPage> {
  final _player = AudioPlayer();
  final _spellingCtrl = TextEditingController();
  final _synonymCtrl = TextEditingController();
  final _focusNode = FocusNode();

  List<Word> _queue = const [];
  int _index = 0;
  int _correct = 0;
  int _error = 0;
  bool _loading = true;
  bool _revealed = false;

  @override
  void initState() {
    super.initState();
    _loadQueue();
  }

  Future<void> _loadQueue() async {
    final repo = ref.read(reviewRepositoryProvider);
    final due = await repo.getDueWords(widget.book, limit: 10);
    final fresh = await repo.getNewWords(widget.book, limit: 10);
    setState(() {
      _queue = [...due, ...fresh];
      _loading = false;
    });
    if (_queue.isNotEmpty) {
      _autoPlay();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _focusNode.requestFocus();
      });
    }
  }

  Word? get _current => _queue.isNotEmpty && _index < _queue.length
      ? _queue[_index]
      : null;

  Future<void> _autoPlay() async {
    final w = _current;
    if (w == null) return;
    try {
      await _player.setAsset(w.audioPath);
      await _player.play();
    } catch (_) {
      // 音频缺失不阻塞
    }
  }

  /// 提交：仅显示答案，让用户自评
  void _onSubmit() {
    setState(() {
      _revealed = true;
    });
  }

  /// 用户 4 档自评（核心 SM-2 输入）
  Future<void> _onUserGrade(int quality) async {
    final w = _current;
    if (w == null || !_revealed) return;
    final reviewRepo = ref.read(reviewRepositoryProvider);
    final wrongRepo = ref.read(wrongAnswerRepositoryProvider);

    await reviewRepo.gradeReview(
      wordId: w.id,
      quality: quality,
      now: DateTime.now(),
    );

    // quality < 3 视为错误，加入错题本
    if (quality < 3) {
      await wrongRepo.record(
        wordId: w.id,
        userInput: _spellingCtrl.text,
        correctAnswer: w.word,
        errorType: _detectErrorType(w),
        at: DateTime.now(),
      );
    }

    setState(() {
      if (quality >= 3) {
        _correct++;
      } else {
        _error++;
      }
    });

    _next();
  }

  WrongErrorType _detectErrorType(Word w) {
    final wordCorrect = _spellingCtrl.text.trim().toLowerCase() == w.word;
    if (!wordCorrect) return WrongErrorType.spelling;
    return WrongErrorType.synonym;
  }

  void _next() {
    setState(() {
      _index++;
      _revealed = false;
      _spellingCtrl.clear();
      _synonymCtrl.clear();
    });
    if (_index >= _queue.length) {
      _showSummary();
    } else {
      _autoPlay();
      _focusNode.requestFocus();
    }
  }

  void _showSummary() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('本次完成 🎉'),
        content: Text('良好 $_correct 个  错误 $_error 个'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('好的'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _player.dispose();
    _spellingCtrl.dispose();
    _synonymCtrl.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (_queue.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('学习')),
        body: const Center(child: Text('🎉 今日已无任务')),
      );
    }
    final w = _current!;
    final progress = (_index + 1) / _queue.length;
    final wordCorrect = _spellingCtrl.text.trim().toLowerCase() == w.word;
    final showError = _revealed && !wordCorrect;

    return Scaffold(
      appBar: AppBar(
        title: Text('${_index + 1} / ${_queue.length}'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(value: progress),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton.filled(
                  iconSize: 48,
                  icon: const Icon(Icons.volume_up),
                  onPressed: _autoPlay,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              w.meaning,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              w.type.isEmpty ? '' : '词性：${w.type}',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _spellingCtrl,
              focusNode: _focusNode,
              decoration: InputDecoration(
                labelText: '拼写单词',
                border: const OutlineInputBorder(),
                errorText: showError ? '正确答案: ${w.word}' : null,
                suffixIcon: _revealed
                    ? Icon(
                        wordCorrect ? Icons.check_circle : Icons.cancel,
                        color: wordCorrect ? Colors.green : Colors.red,
                      )
                    : null,
              ),
              autocorrect: false,
              textInputAction: TextInputAction.next,
              onChanged: (_) => setState(() {}), // 实时更新 suffixIcon
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _synonymCtrl,
              decoration: InputDecoration(
                labelText: '同义替换（多个用逗号分隔）',
                hintText: '例如: ${w.replace.take(2).join(', ')}',
                border: const OutlineInputBorder(),
                helperText: _revealed
                    ? '参考答案: ${w.replace.join(', ')}'
                    : null,
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 24),
            if (!_revealed)
              FilledButton.icon(
                onPressed: _onSubmit,
                icon: const Icon(Icons.visibility),
                label: const Text('提交 / 显示答案'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              )
            else ...[
              Card(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('单词: ${w.word}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                      if (w.replace.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            '同义替换: ${w.replace.join(', ')}',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ),
                      const SizedBox(height: 8),
                      const Text('你感觉如何？',
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              GradeButtons(onGrade: _onUserGrade),
            ],
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _Stat(label: '对', value: _correct, color: Colors.green),
                _Stat(label: '错', value: _error, color: Colors.red),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  const _Stat({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: TextStyle(color: color)),
        const SizedBox(width: 4),
        Text('$value', style: TextStyle(color: color, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
