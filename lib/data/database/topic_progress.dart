import 'package:isar/isar.dart';

part 'topic_progress.g.dart';

@collection
class TopicProgress {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String topicId;

  bool isCompleted = false;
  int highScore = 0;

  // Total questions is always 20, but stored for display convenience
  int totalQuestions = 20;
  int totalAttempts = 0;

  DateTime? lastAttemptDate;

  // Computed helper — not stored
  double get highScorePercentage =>
      totalQuestions > 0 ? (highScore / totalQuestions) * 100 : 0;
}
