import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'topic_progress.dart';

class IsarService {
  late Isar _isar;

  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [TopicProgressSchema],
      directory: dir.path,
    );
  }

  Future<TopicProgress?> getProgress(String topicId) {
    return _isar.topicProgress.getByTopicId(topicId);
  }

  Future<List<TopicProgress>> getAllProgress() {
    return _isar.topicProgress.where().findAll();
  }

  Future<void> saveQuizResult({
    required String topicId,
    required int score,
    required int totalQuestions,
  }) async {
    await _isar.writeTxn(() async {
      final existing = await _isar.topicProgress.getByTopicId(topicId);

      if (existing != null) {
        existing.totalAttempts++;
        existing.lastAttemptDate = DateTime.now();
        existing.isCompleted = true;
        if (score > existing.highScore) {
          existing.highScore = score;
        }
        await _isar.topicProgress.put(existing);
      } else {
        final progress = TopicProgress()
          ..topicId = topicId
          ..highScore = score
          ..totalQuestions = totalQuestions
          ..totalAttempts = 1
          ..isCompleted = true
          ..lastAttemptDate = DateTime.now();
        await _isar.topicProgress.put(progress);
      }
    });
  }
}
