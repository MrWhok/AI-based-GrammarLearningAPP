class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  const QuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    final rawOptions = json['options'];
    final List<String> options = rawOptions is List
        ? rawOptions.map((e) => e.toString()).toList()
        : <String>[];

    return QuizQuestion(
      question: json['question'] as String,
      options: options,
      correctIndex: (json['correct_index'] as num).toInt(),
      explanation: json['explanation'] as String,
    );
  }
}
