import '../../data/models/quiz_question.dart';

enum QuizStatus { loading, active, completed, error }

class QuizState {
  final QuizStatus status;
  final List<QuizQuestion> questions;
  final int currentIndex;

  // null = not yet answered for this question
  final int? selectedAnswerIndex;

  // tracks user's answer for every question (-1 = skipped/unanswered)
  final List<int> userAnswers;

  final bool showExplanation;
  final String? errorMessage;

  const QuizState({
    required this.status,
    this.questions = const [],
    this.currentIndex = 0,
    this.selectedAnswerIndex,
    this.userAnswers = const [],
    this.showExplanation = false,
    this.errorMessage,
  });

  const QuizState.initial()
      : status = QuizStatus.loading,
        questions = const [],
        currentIndex = 0,
        selectedAnswerIndex = null,
        userAnswers = const [],
        showExplanation = false,
        errorMessage = null;

  QuizState copyWith({
    QuizStatus? status,
    List<QuizQuestion>? questions,
    int? currentIndex,
    int? selectedAnswerIndex,
    bool clearSelectedAnswer = false,
    List<int>? userAnswers,
    bool? showExplanation,
    String? errorMessage,
  }) {
    return QuizState(
      status: status ?? this.status,
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      selectedAnswerIndex: clearSelectedAnswer
          ? null
          : (selectedAnswerIndex ?? this.selectedAnswerIndex),
      userAnswers: userAnswers ?? this.userAnswers,
      showExplanation: showExplanation ?? this.showExplanation,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  bool get isAnswered => selectedAnswerIndex != null;

  bool get isLastQuestion => currentIndex == questions.length - 1;

  bool get isCorrect =>
      selectedAnswerIndex != null &&
      selectedAnswerIndex == questions[currentIndex].correctIndex;

  int get score => userAnswers
      .asMap()
      .entries
      .where((e) =>
          e.key < questions.length &&
          e.value == questions[e.key].correctIndex)
      .length;
}
