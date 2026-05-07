import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/grammar_topics.dart';
import '../../core/theme/app_theme.dart';
import '../../data/database/topic_progress.dart';
import '../../shared/providers/app_providers.dart';
import '../quiz/quiz_screen.dart';
import '../theory/theory_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(allProgressProvider);

    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: progressAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error loading progress: $err')),
        data: (progressList) {
          final progressMap = {for (var p in progressList) p.topicId: p};
          final completedCount =
              progressList.where((p) => p.isCompleted).length;
          final total = kGrammarTopics.length;
          final completionFraction = completedCount / total;

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 180,
                pinned: true,
                backgroundColor: AppTheme.primary,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  title: Text(
                    'Grammar Master',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [AppTheme.primaryDark, Color(0xFF7C83E0)],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 70, 16, 52),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$completedCount of $total topics completed',
                            style: GoogleFonts.poppins(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: completionFraction,
                              minHeight: 6,
                              backgroundColor: Colors.white24,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Mixed Practice banner
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                sliver: SliverToBoxAdapter(
                  child: _MixedQuizBanner(
                    mixedProgress: progressMap['mixed_quiz'],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    'Choose a Topic',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final topic = kGrammarTopics[index];
                      final progress = progressMap[topic.id];
                      return _TopicCard(topic: topic, progress: progress);
                    },
                    childCount: kGrammarTopics.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.82,
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          );
        },
      ),
    );
  }
}

class _TopicCard extends StatelessWidget {
  final GrammarTopic topic;
  final TopicProgress? progress;

  const _TopicCard({required this.topic, this.progress});

  @override
  Widget build(BuildContext context) {
    final isCompleted = progress?.isCompleted ?? false;
    final score = progress?.highScore ?? 0;
    final total = progress?.totalQuestions ?? 20;
    final pct = isCompleted ? (score / total * 100).round() : 0;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => TheoryScreen(topic: topic)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: topic.color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      topic.emoji,
                      style: const TextStyle(fontSize: 22),
                    ),
                  ),
                  const Spacer(),
                  if (isCompleted)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppTheme.correctLight,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '$pct%',
                        style: const TextStyle(
                          color: AppTheme.correct,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                topic.title,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 4),
              Expanded(
                child: Text(
                  topic.shortDescription,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 11.5,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  if (isCompleted) ...[
                    const Icon(Icons.star_rounded,
                        size: 14, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      'Best: $score/$total',
                      style: TextStyle(
                          fontSize: 11, color: Colors.grey.shade600),
                    ),
                  ] else ...[
                    Icon(Icons.play_circle_outline_rounded,
                        size: 14, color: topic.color),
                    const SizedBox(width: 4),
                    Text(
                      'Start Learning',
                      style: TextStyle(
                        fontSize: 11,
                        color: topic.color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MixedQuizBanner extends StatelessWidget {
  final TopicProgress? mixedProgress;

  const _MixedQuizBanner({this.mixedProgress});

  @override
  Widget build(BuildContext context) {
    final isCompleted = mixedProgress?.isCompleted ?? false;
    final score = mixedProgress?.highScore ?? 0;
    final total = mixedProgress?.totalQuestions ?? 40;
    final pct = isCompleted ? (score / total * 100).round() : 0;

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF57F17), Color(0xFFFFCA28)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF57F17).withValues(alpha: 0.35),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => QuizScreen(topic: kMixedQuizTopic),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Text('🏆', style: TextStyle(fontSize: 36)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mixed Practice Test',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '40 Questions • All 21 Topics',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'TOEFL / IELTS Ready',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                if (isCompleted)
                  Column(
                    children: [
                      Text(
                        '$pct%',
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '$score/$total',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Start Test',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFF57F17),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
