import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/word.dart';
import '../../features/home/presentation/home_page.dart';
import '../../features/library/presentation/library_page.dart';
import '../../features/quiz/presentation/quiz_page.dart';
import '../../features/stats/presentation/stats_page.dart';
import '../../features/study/presentation/study_page.dart';
import '../../features/wrong_book/presentation/wrong_book_page.dart';

/// 全局路由 Provider
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      // 学习（首页）
      GoRoute(
        path: '/',
        name: 'home',
        builder: (_, __) => const HomePage(),
        routes: [
          // 学习页
          GoRoute(
            path: 'study/:book',
            name: 'study',
            builder: (_, state) {
              final book = state.pathParameters['book']!;
              return StudyPage(book: _parseBook(book));
            },
          ),
          // 测验页
          GoRoute(
            path: 'quiz/:book',
            name: 'quiz',
            builder: (_, state) {
              final book = state.pathParameters['book']!;
              return QuizPage(book: _parseBook(book));
            },
          ),
        ],
      ),
      // 词库浏览
      GoRoute(
        path: '/library',
        name: 'library',
        builder: (_, __) => const LibraryPage(),
        routes: [
          GoRoute(
            path: ':book',
            name: 'library-book',
            builder: (_, state) {
              final book = state.pathParameters['book']!;
              return LibraryPage(book: _parseBook(book));
            },
          ),
        ],
      ),
      // 统计
      GoRoute(
        path: '/stats',
        name: 'stats',
        builder: (_, __) => const StatsPage(),
      ),
      // 错题本
      GoRoute(
        path: '/wrong-book',
        name: 'wrong-book',
        builder: (_, __) => const WrongBookPage(),
      ),
    ],
    errorBuilder: (_, state) => Scaffold(
      body: Center(child: Text('页面不存在: ${state.error}')),
    ),
  );
});

WordBook _parseBook(String s) {
  switch (s) {
    case 'zhenjing':
      return WordBook.zhenjing;
    case 'listening179':
      return WordBook.listening179;
    case 'reading538':
      return WordBook.reading538;
    default:
      throw ArgumentError('Unknown book: $s');
  }
}
