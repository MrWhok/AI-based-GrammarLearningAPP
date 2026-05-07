import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';
import '../../core/constants/grammar_topics.dart';
import '../models/quiz_question.dart';

class GeminiException implements Exception {
  final String message;
  const GeminiException(this.message);
  @override
  String toString() => 'GeminiException: $message';
}

class GeminiService {
  // Auto-retries once after 10 s on rate limit (429).
  Future<List<QuizQuestion>> generateQuestions(GrammarTopic topic) async {
    const maxAttempts = 2;

    for (var attempt = 1; attempt <= maxAttempts; attempt++) {
      try {
        return await _doRequest(topic);
      } on GeminiException catch (e) {
        if (e.message.contains('429') && attempt < maxAttempts) {
          await Future.delayed(const Duration(seconds: 10));
          continue;
        }
        rethrow;
      }
    }
    throw const GeminiException('Failed after retries.');
  }

  Future<List<QuizQuestion>> _doRequest(GrammarTopic topic) async {
    final response = await http
        .post(
          Uri.parse(ApiConstants.groqBaseUrl),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${ApiConstants.groqApiKey}',
          },
          body: jsonEncode({
            'model': ApiConstants.groqModel,
            'messages': [
              {'role': 'user', 'content': _buildPrompt(topic)}
            ],
            'response_format': {'type': 'json_object'},
            'temperature': 0.7,
            'max_tokens': 8192,
          }),
        )
        .timeout(const Duration(seconds: 60));

    if (response.statusCode != 200) {
      String apiMessage = 'Unknown error';
      try {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        apiMessage = body['error']?['message'] as String? ?? response.body;
      } catch (_) {
        apiMessage = response.body.length > 200
            ? '${response.body.substring(0, 200)}…'
            : response.body;
      }
      final code = response.statusCode;
      final friendlyMsg = switch (code) {
        429 => 'Rate limited (429). Retrying automatically…',
        401 =>
          'Invalid API key (401). Paste your key from console.groq.com into api_constants.dart.',
        403 => 'API key rejected (403). Check console.groq.com.',
        404 => 'Model not found (404): $apiMessage',
        400 => 'Bad request (400): $apiMessage',
        _ => 'HTTP $code: $apiMessage',
      };
      throw GeminiException(friendlyMsg);
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final choices = body['choices'] as List<dynamic>?;
    if (choices == null || choices.isEmpty) {
      throw const GeminiException('No response returned from API.');
    }

    final content = choices[0]['message']['content'] as String? ?? '';
    if (content.isEmpty) {
      throw const GeminiException('Empty response from API.');
    }

    final parsed = jsonDecode(content) as Map<String, dynamic>;
    final questionsList = parsed['questions'] as List<dynamic>?;
    if (questionsList == null || questionsList.isEmpty) {
      throw const GeminiException('No questions found in API response.');
    }

    final questions = questionsList
        .map((q) => QuizQuestion.fromJson(q as Map<String, dynamic>))
        .toList();

    if (questions.length < 20) {
      throw GeminiException(
          'Only ${questions.length}/20 questions were generated. Tap Try Again.');
    }

    // Trim silently if the model returned more than 20
    return questions.take(20).toList();
  }

  String _buildPrompt(GrammarTopic topic) => '''
You are an expert English grammar teacher and quiz designer.

Generate exactly 20 multiple-choice questions to test a student's understanding of the grammar topic: "${topic.title}".

Topic context:
- Description: ${topic.shortDescription}
- Grammar structure: ${topic.structure}
- Key use cases: ${topic.useCases.join('; ')}

REQUIREMENTS:
- Generate exactly 20 questions (no more, no less)
- Each question must have exactly 4 answer options
- Questions must range from beginner to advanced difficulty
- Test practical usage, not just definitions
- Include questions on: choosing correct tense/form, identifying errors, sentence completion, and transformation
- Options must NOT include letter prefixes like "A.", "B.", "C.", "D."
- Explanations must be 2–3 sentences explaining the rule clearly and mentioning the most common mistake
- correct_index is 0-based (0 = first option, 1 = second, 2 = third, 3 = fourth)

Return ONLY a valid JSON object in this exact schema:
{
  "questions": [
    {
      "question": "The question text here",
      "options": ["Option text", "Option text", "Option text", "Option text"],
      "correct_index": 0,
      "explanation": "Clear explanation of the grammar rule and why the correct answer is right."
    }
  ]
}

Return ONLY the JSON object. No markdown code fences, no extra text before or after.
''';
}
