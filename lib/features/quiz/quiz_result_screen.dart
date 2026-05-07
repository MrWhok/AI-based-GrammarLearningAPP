import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/grammar_topics.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/quiz_question.dart';
import '../../shared/providers/app_providers.dart';
import 'quiz_screen.dart';

class QuizResultScreen extends ConsumerStatefulWidget {
  final GrammarTopic topic;
  final int score;
  final int total;
  final List<int> userAnswers;
  final List<QuizQuestion> questions;

  const QuizResultScreen({
    super.key,
    required this.topic,
    required this.score,
    required this.total,
    required this.userAnswers,
    required this.questions,
  });

  @override
  ConsumerState<QuizResultScreen> createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends ConsumerState<QuizResultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scoreAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _scoreAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
    _animController.forward();

    // Refresh home screen progress after a short delay
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.invalidate(allProgressProvider);
      ref.invalidate(topicProgressProvider(widget.topic.id));
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  double get _percentage => widget.score / widget.total;

  Color get _scoreColor {
    if (_percentage >= 0.85) return AppTheme.correct;
    if (_percentage >= 0.6) return const Color(0xFFF57C00);
    return AppTheme.incorrect;
  }

  String get _resultLabel {
    if (_percentage >= 0.9) return 'Excellent! 🏆';
    if (_percentage >= 0.75) return 'Great Job! 🎉';
    if (_percentage >= 0.6) return 'Good Effort! 👍';
    return 'Keep Practicing! 💪';
  }

  @override
  Widget build(BuildContext context) {
    final incorrectQuestions = widget.questions
        .asMap()
        .entries
        .where((e) => widget.userAnswers[e.key] != e.value.correctIndex)
        .toList();

    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: widget.topic.color,
            foregroundColor: Colors.white,
            pinned: true,
            title: Text('Quiz Complete',
                style: GoogleFonts.poppins(
                    color: Colors.white, fontWeight: FontWeight.w600)),
            automaticallyImplyLeading: false,
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                // Score hero section
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [widget.topic.color, AppTheme.surface],
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
                  child: Column(
                    children: [
                      // Animated score circle
                      AnimatedBuilder(
                        animation: _scoreAnim,
                        builder: (context, child) {
                          return SizedBox(
                            width: 160,
                            height: 160,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: 160,
                                  height: 160,
                                  child: CircularProgressIndicator(
                                    value: _scoreAnim.value * _percentage,
                                    strokeWidth: 10,
                                    backgroundColor:
                                        Colors.white.withValues(alpha: 0.3),
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                    strokeCap: StrokeCap.round,
                                  ),
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '${widget.score}/${widget.total}',
                                      style: GoogleFonts.poppins(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      '${(_percentage * 100).round()}%',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      Text(
                        _resultLabel,
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.topic.title,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),

                // Stats row
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                  child: Row(
                    children: [
                      _StatCard(
                        label: 'Correct',
                        value: '${widget.score}',
                        icon: Icons.check_circle_rounded,
                        color: AppTheme.correct,
                      ),
                      const SizedBox(width: 12),
                      _StatCard(
                        label: 'Incorrect',
                        value: '${widget.total - widget.score}',
                        icon: Icons.cancel_rounded,
                        color: AppTheme.incorrect,
                      ),
                      const SizedBox(width: 12),
                      _StatCard(
                        label: 'Accuracy',
                        value: '${(_percentage * 100).round()}%',
                        icon: Icons.analytics_rounded,
                        color: _scoreColor,
                      ),
                    ],
                  ),
                ),

                // Review wrong answers
                if (incorrectQuestions.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                    child: Row(
                      children: [
                        Container(
                          width: 4,
                          height: 18,
                          decoration: BoxDecoration(
                            color: AppTheme.incorrect,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Review Mistakes',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.incorrectLight,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${incorrectQuestions.length}',
                            style: const TextStyle(
                              color: AppTheme.incorrect,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ...incorrectQuestions.map((entry) => _ReviewCard(
                        questionNumber: entry.key + 1,
                        question: entry.value,
                        userAnswerIndex: widget.userAnswers[entry.key],
                      )),
                ],

                const SizedBox(height: 24),

                // Action buttons
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      16, 0, 16, MediaQuery.of(context).padding.bottom + 24),
                  child: Column(
                    children: [
                      SizedBox(
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
                          onPressed: () => Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => QuizScreen(topic: widget.topic),
                            ),
                          ),
                          icon: const Icon(Icons.refresh_rounded, size: 18),
                          label: Text(
                            'Try Again',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600, fontSize: 15),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: widget.topic.color,
                            side:
                                BorderSide(color: widget.topic.color, width: 1.5),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () =>
                              Navigator.of(context).popUntil((r) => r.isFirst),
                          icon: const Icon(Icons.home_rounded, size: 18),
                          label: Text(
                            'Back to Topics',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600, fontSize: 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 6),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReviewCard extends StatefulWidget {
  final int questionNumber;
  final QuizQuestion question;
  final int userAnswerIndex;

  const _ReviewCard({
    required this.questionNumber,
    required this.question,
    required this.userAnswerIndex,
  });

  @override
  State<_ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<_ReviewCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final userAnswer = widget.userAnswerIndex >= 0
        ? widget.question.options[widget.userAnswerIndex]
        : 'No answer';
    final correctAnswer =
        widget.question.options[widget.question.correctIndex];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => setState(() => _expanded = !_expanded),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: AppTheme.incorrectLight,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: Text(
                          '${widget.questionNumber}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.incorrect,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        widget.question.question,
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w500),
                        maxLines: _expanded ? null : 2,
                        overflow: _expanded ? null : TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(
                      _expanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
            if (_expanded) ...[
              Divider(height: 1, color: Colors.grey.shade200),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _AnswerRow(
                        label: 'Your answer',
                        text: userAnswer,
                        isCorrect: false),
                    const SizedBox(height: 8),
                    _AnswerRow(
                        label: 'Correct answer',
                        text: correctAnswer,
                        isCorrect: true),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        widget.question.explanation,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade700,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _AnswerRow extends StatelessWidget {
  final String label;
  final String text;
  final bool isCorrect;

  const _AnswerRow(
      {required this.label, required this.text, required this.isCorrect});

  @override
  Widget build(BuildContext context) {
    final color = isCorrect ? AppTheme.correct : AppTheme.incorrect;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
          color: color,
          size: 16,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(
                      fontSize: 11,
                      color: color,
                      fontWeight: FontWeight.w600)),
              Text(text,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    );
  }
}
