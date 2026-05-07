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
    final isMixed = topic.id == 'mixed_quiz';
    final expectedCount = isMixed ? 40 : 20;

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
              {
                'role': 'user',
                'content':
                    isMixed ? _buildMixedPrompt() : _buildPrompt(topic)
              }
            ],
            'response_format': {'type': 'json_object'},
            'temperature': isMixed ? 0.9 : 0.7,
            'max_tokens': 8192,
          }),
        )
        .timeout(const Duration(seconds: 90));

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

    if (questions.length < expectedCount) {
      throw GeminiException(
          'Only ${questions.length}/$expectedCount questions were generated. Tap Try Again.');
    }

    // Trim silently if the model returned more than expected
    return questions.take(expectedCount).toList();
  }

  String _buildPrompt(GrammarTopic topic) => '''
You are an expert English grammar teacher and quiz designer.

Generate exactly 20 multiple-choice questions to test a student's understanding of the grammar topic: "${topic.title}".

Topic context:
- Description: ${topic.shortDescription}
- Grammar structure: ${topic.structure}
- Key use cases: ${topic.useCases.join('; ')}

THEME DIVERSITY — this is critical:
Each question must be set in a DIFFERENT real-world context. Draw from this wide pool (pick 20 different ones):
astronomy, baking, cycling, deep-sea diving, earthquake research, folk music, glacier hiking, hospital surgery, insect biology, jazz improvisation, knitting, lighthouse keeping, marathon running, neuroscience, ocean navigation, pottery, quantum physics, rainforest ecology, sandstorm survival, tea ceremony, urban farming, volcano monitoring, wildlife photography, xylophone performance, yoga instruction, zoology, ancient architecture, book translation, carnival preparation, documentary filmmaking, emergency rescue, forensic investigation, golden gate restoration, harbor fishing, ice sculpting, jungle expedition, kite surfing, lava flow study, museum curation, novel writing, oil painting, pasta making, quilt sewing, rocket engineering, solar panel installation, tidal wave prediction, underwater archaeology.

REQUIREMENTS:
- Generate exactly 20 questions (no more, no less)
- Every question MUST use a different context/subject from the theme list above — no two questions may share the same setting or protagonist
- All 20 questions must be unique — no two questions may test the same sentence, scenario, or sub-point
- Questions must range from beginner to advanced difficulty
- Test practical usage, not just definitions
- Include questions on: choosing correct tense/form, identifying errors, sentence completion, and transformation
- Options must NOT include letter prefixes like "A.", "B.", "C.", "D."
- Explanations must be 2–3 sentences explaining the rule clearly and mentioning the most common mistake
- correct_index is 0-based (0 = first option, 1 = second, 2 = third, 3 = fourth)
- BLANK RULE: When a question uses a blank (___), the blank represents the COMPLETE missing word or phrase. Never put part of the answer in the sentence stem. For example, if the answer is "will hire", the sentence must say "___ a new employee", NOT "will ___ a new employee".

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

  String _buildMixedPrompt() => '''
You are an expert English grammar teacher preparing a comprehensive TOEFL/IELTS grammar practice test.

Generate exactly 40 multiple-choice questions covering ALL of the following grammar topics. Include approximately 2 questions per topic:

1. Present Simple, 2. Present Continuous, 3. Past Simple, 4. Past Continuous,
5. Present Perfect, 6. Past Perfect, 7. Future (will / going to),
8. Zero & First Conditional, 9. Second & Third Conditional, 10. Modal Verbs,
11. Passive Voice, 12. Articles (a/an/the), 13. Prepositions (at/on/in),
14. Reported Speech, 15. Relative Clauses, 16. Subject-Verb Agreement,
17. Gerunds & Infinitives, 18. Perfect Continuous Tenses,
19. Noun Clauses, 20. Adverbial Clauses & Conjunctions,
21. Comparative & Superlative

THEME DIVERSITY — this is critical:
Each of the 40 questions must be set in a DIFFERENT real-world context. Use a wide, creative mix from domains such as:
astronomy, baking, cycling, deep-sea diving, earthquake research, folk music, glacier hiking, hospital surgery, insect biology, jazz improvisation, knitting, lighthouse keeping, marathon running, neuroscience, ocean navigation, pottery, quantum physics, rainforest ecology, sandstorm survival, tea ceremony, urban farming, volcano monitoring, wildlife photography, yoga instruction, zoology, ancient architecture, book translation, carnival preparation, documentary filmmaking, emergency rescue, forensic investigation, harbor fishing, ice sculpting, jungle expedition, kite surfing, lava flow study, museum curation, novel writing, oil painting, pasta making, quilt sewing, rocket engineering, solar panel installation, tidal wave prediction, underwater archaeology, cave exploration, cheese making, drone racing, elephant conservation, falconry, graffiti art, hot air ballooning, igloo construction, juggling, kayaking, lamp crafting, mime performance, noodle farming, origami, puppet theater, quicksand research, reef diving, shipwreck salvage, truffle hunting, unicycle racing.

No two questions may share the same context, setting, or protagonist. Do NOT use generic office/company/school settings unless combined with a unique context above.

REQUIREMENTS:
- Generate exactly 40 questions (no more, no less)
- Each question must have exactly 4 answer options
- All 40 questions must be unique — no two questions may use the same sentence, scenario, or test the same sub-point in the same way
- Mix difficulty: 30% beginner, 40% intermediate, 30% advanced
- Test practical usage: error identification, sentence completion, transformation
- Each question should clearly test ONE grammar point from the list above
- Options must NOT include letter prefixes like "A.", "B.", "C.", "D."
- Explanations must be 2–3 sentences, state the grammar rule tested
- correct_index is 0-based (0 = first option, 1 = second, 2 = third, 3 = fourth)
- BLANK RULE: When a question uses a blank (___), the blank represents the COMPLETE missing word or phrase. Never put part of the answer in the sentence stem. For example, if the answer is "will hire", the sentence must say "___ a new employee", NOT "will ___ a new employee".

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
