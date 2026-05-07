import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/grammar_topics.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/providers/app_providers.dart';
import 'quiz_result_screen.dart';
import 'quiz_state.dart';

class QuizScreen extends ConsumerStatefulWidget {
  final GrammarTopic topic;

  const QuizScreen({super.key, required this.topic});

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(quizNotifierProvider(widget.topic.id).notifier)
          .generateQuestions(widget.topic);
    });
  }

  void _showExplanationSheet(QuizState state) {
    if (!mounted) return;
    final question = state.questions[state.currentIndex];
    final correctAnswer = question.options[question.correctIndex];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _ExplanationSheet(
        correctAnswer: correctAnswer,
        explanation: question.explanation,
        onDismiss: () {
          Navigator.of(ctx).pop();
          ref
              .read(quizNotifierProvider(widget.topic.id).notifier)
              .dismissExplanation();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(quizNotifierProvider(widget.topic.id));

    ref.listen(quizNotifierProvider(widget.topic.id), (prev, next) {
      if (next.showExplanation && !(prev?.showExplanation ?? false)) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showExplanationSheet(next);
        });
      }

      if (prev?.status != QuizStatus.completed &&
          next.status == QuizStatus.completed) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => QuizResultScreen(
                topic: widget.topic,
                score: next.score,
                total: next.questions.length,
                userAnswers: next.userAnswers,
                questions: next.questions,
              ),
            ),
          );
        });
      }
    });

    return PopScope(
      canPop: state.status == QuizStatus.loading ||
          state.status == QuizStatus.error,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _showLeaveDialog();
      },
      child: Scaffold(
        backgroundColor: AppTheme.surface,
        appBar: AppBar(
          title: Text(widget.topic.title),
          backgroundColor: widget.topic.color,
          foregroundColor: Colors.white,
          elevation: 0,
          bottom: state.status == QuizStatus.active
              ? PreferredSize(
                  preferredSize: const Size.fromHeight(6),
                  child: _QuizProgressBar(
                    current: state.currentIndex + 1,
                    total: state.questions.length,
                    color: widget.topic.color,
                  ),
                )
              : null,
        ),
        body: switch (state.status) {
          QuizStatus.loading => _buildLoading(),
          QuizStatus.active => _buildActive(state),
          QuizStatus.completed => _buildCompleting(),
          QuizStatus.error => _buildError(state),
        },
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(widget.topic.emoji, style: const TextStyle(fontSize: 56)),
          const SizedBox(height: 24),
          const CircularProgressIndicator(),
          const SizedBox(height: 24),
          Text(
            'Generating your quiz…',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActive(QuizState state) {
    final question = state.questions[state.currentIndex];
    final isAnswered = state.isAnswered;
    final correctIndex = question.correctIndex;
    final selectedIndex = state.selectedAnswerIndex;

    return Column(
      children: [
        // Question counter chip
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: widget.topic.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Question ${state.currentIndex + 1} of ${state.questions.length}',
                  style: TextStyle(
                    color: widget.topic.color,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Question card
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                // Question text
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    key: ValueKey(state.currentIndex),
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      question.question,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        height: 1.6,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Options
                ...question.options.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final optionText = entry.value;

                  Color bgColor = Colors.white;
                  Color borderColor = Colors.grey.shade300;
                  Color textColor = Colors.grey.shade800;
                  Widget? trailingIcon;

                  if (isAnswered) {
                    if (idx == correctIndex) {
                      bgColor = AppTheme.correctLight;
                      borderColor = AppTheme.correct;
                      textColor = AppTheme.correct;
                      trailingIcon = const Icon(Icons.check_circle_rounded,
                          color: AppTheme.correct, size: 20);
                    } else if (idx == selectedIndex) {
                      bgColor = AppTheme.incorrectLight;
                      borderColor = AppTheme.incorrect;
                      textColor = AppTheme.incorrect;
                      trailingIcon = const Icon(Icons.cancel_rounded,
                          color: AppTheme.incorrect, size: 20);
                    }
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: isAnswered
                          ? null
                          : () => ref
                              .read(quizNotifierProvider(widget.topic.id)
                                  .notifier)
                              .selectAnswer(idx),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: borderColor, width: 1.5),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: isAnswered
                                    ? borderColor.withValues(alpha: 0.15)
                                    : widget.topic.color
                                        .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  ['A', 'B', 'C', 'D'][idx],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: isAnswered
                                        ? borderColor
                                        : widget.topic.color,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                optionText,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: textColor,
                                  fontWeight: isAnswered && idx == correctIndex
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                            if (trailingIcon != null) ...[
                              const SizedBox(width: 8),
                              trailingIcon,
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 8),
              ],
            ),
          ),
        ),

        // Next / Finish button
        if (isAnswered)
          Padding(
            padding: EdgeInsets.fromLTRB(
                16, 8, 16, MediaQuery.of(context).padding.bottom + 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.topic.color,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => ref
                    .read(quizNotifierProvider(widget.topic.id).notifier)
                    .nextQuestion(),
                icon: Icon(
                  state.isLastQuestion
                      ? Icons.check_circle_rounded
                      : Icons.arrow_forward_rounded,
                  size: 18,
                ),
                label: Text(
                  state.isLastQuestion ? 'Finish Quiz' : 'Next Question',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCompleting() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildError(QuizState state) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 56, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'Could not generate quiz',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              state.errorMessage ?? 'Unknown error',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => ref
                  .read(quizNotifierProvider(widget.topic.id).notifier)
                  .retry(widget.topic),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  void _showLeaveDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Leave Quiz?'),
        content: const Text(
            'Your progress will be lost. Are you sure you want to leave?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Stay')),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Leave',
                style: TextStyle(color: AppTheme.incorrect)),
          ),
        ],
      ),
    );
  }
}

class _QuizProgressBar extends StatelessWidget {
  final int current;
  final int total;
  final Color color;

  const _QuizProgressBar(
      {required this.current, required this.total, required this.color});

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: current / total,
      backgroundColor: Colors.white24,
      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      minHeight: 5,
    );
  }
}

class _ExplanationSheet extends StatelessWidget {
  final String correctAnswer;
  final String explanation;
  final VoidCallback onDismiss;

  const _ExplanationSheet({
    required this.correctAnswer,
    required this.explanation,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.fromLTRB(
          20, 20, 20, MediaQuery.of(context).padding.bottom + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.incorrectLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.close_rounded,
                    color: AppTheme.incorrect, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                'Not quite right',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.correctLight,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: AppTheme.correct.withValues(alpha: 0.3)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.check_circle_rounded,
                    color: AppTheme.correct, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Correct Answer',
                        style: TextStyle(
                          color: AppTheme.correct,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        correctAnswer,
                        style: const TextStyle(
                          color: AppTheme.correct,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Explanation',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            explanation,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onDismiss,
              child: const Text('Got it — Continue'),
            ),
          ),
        ],
      ),
    );
  }
}
