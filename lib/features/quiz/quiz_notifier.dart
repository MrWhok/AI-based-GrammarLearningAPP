import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/grammar_topics.dart';
import '../../data/database/isar_service.dart';
import '../../data/services/gemini_service.dart';
import 'quiz_state.dart';

class QuizNotifier extends StateNotifier<QuizState> {
  final GeminiService _geminiService;
  final IsarService _isarService;
  final String _topicId;

  QuizNotifier({
    required GeminiService geminiService,
    required IsarService isarService,
    required String topicId,
  })  : _geminiService = geminiService,
        _isarService = isarService,
        _topicId = topicId,
        super(const QuizState.initial());

  Future<void> generateQuestions(GrammarTopic topic) async {
    state = const QuizState.initial();
    try {
      final questions = await _geminiService.generateQuestions(topic);
      state = QuizState(
        status: QuizStatus.active,
        questions: questions,
        userAnswers: List.filled(questions.length, -1),
      );
    } catch (e) {
      state = QuizState(
        status: QuizStatus.error,
        errorMessage: e.toString().replaceFirst('GeminiException: ', ''),
      );
    }
  }

  void selectAnswer(int answerIndex) {
    if (state.isAnswered || state.status != QuizStatus.active) return;

    final updatedAnswers = List<int>.from(state.userAnswers);
    updatedAnswers[state.currentIndex] = answerIndex;

    final isCorrect =
        answerIndex == state.questions[state.currentIndex].correctIndex;

    state = state.copyWith(
      selectedAnswerIndex: answerIndex,
      userAnswers: updatedAnswers,
      showExplanation: !isCorrect,
    );
  }

  void dismissExplanation() {
    state = state.copyWith(showExplanation: false);
  }

  Future<void> nextQuestion() async {
    if (!state.isAnswered) return;

    if (state.isLastQuestion) {
      await _completeQuiz();
      return;
    }

    state = state.copyWith(
      currentIndex: state.currentIndex + 1,
      clearSelectedAnswer: true,
      showExplanation: false,
    );
  }

  Future<void> _completeQuiz() async {
    final finalScore = state.score;
    await _isarService.saveQuizResult(
      topicId: _topicId,
      score: finalScore,
      totalQuestions: state.questions.length,
    );
    state = state.copyWith(status: QuizStatus.completed);
  }

  void retry(GrammarTopic topic) {
    generateQuestions(topic);
  }
}
