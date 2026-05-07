import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database/isar_service.dart';
import '../../data/database/topic_progress.dart';
import '../../data/services/gemini_service.dart';
import '../../features/quiz/quiz_notifier.dart';
import '../../features/quiz/quiz_state.dart';

// Initialized in main.dart and overridden in ProviderScope
final isarServiceProvider = Provider<IsarService>(
  (ref) => throw UnimplementedError('Override in ProviderScope'),
);

final geminiServiceProvider = Provider<GeminiService>(
  (ref) => GeminiService(),
);

// Progress for all topics — invalidate this after a quiz to refresh home screen
final allProgressProvider = FutureProvider<List<TopicProgress>>((ref) {
  final isar = ref.watch(isarServiceProvider);
  return isar.getAllProgress();
});

// Progress for a single topic
final topicProgressProvider =
    FutureProvider.family<TopicProgress?, String>((ref, topicId) {
  final isar = ref.watch(isarServiceProvider);
  return isar.getProgress(topicId);
});

// Quiz provider — scoped per topic, auto-disposed when quiz screen is popped
final quizNotifierProvider = StateNotifierProvider.autoDispose
    .family<QuizNotifier, QuizState, String>((ref, topicId) {
  return QuizNotifier(
    geminiService: ref.watch(geminiServiceProvider),
    isarService: ref.watch(isarServiceProvider),
    topicId: topicId,
  );
});
