import 'dart:math';

import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';

import '../models/country.dart';
import '../models/country_data.dart';
import '../services/greeting_service.dart';

// ─── Quiz enums ──────────────────────────────────────────────────────────────

enum QuizMode { teacher, solo }

enum QuizCategory {
  capital('What\'s the capital?', Icons.location_city, Colors.blue),
  flag('What\'s the flag?', Icons.flag, Colors.orange),
  greeting('How do you say hello?', Icons.chat_bubble_outline, Colors.green),
  language('What language?', Icons.translate, Colors.purple);

  const QuizCategory(this.label, this.icon, this.color);
  final String label;
  final IconData icon;
  final Color color;
}

// ─── Quiz screen ─────────────────────────────────────────────────────────────

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  // Navigation: null → mode picker, then category picker, then questions.
  QuizMode? _mode;
  QuizCategory? _category;
  late _QuizQuestion _question;
  int? _tappedIndex;

  // Shared score.
  int _score = 0;
  int _total = 0;

  // Solo streak.
  int _streak = 0;
  int _bestStreak = 0;
  bool _streakAlive = true;

  final _rng = Random();

  // ── Question builder ──

  _QuizQuestion _buildQuestion() {
    final correct = allCountries[_rng.nextInt(allCountries.length)];
    // For language category, pick wrong answers with *different* languages.
    List<Country> pool;
    if (_category == QuizCategory.language) {
      pool = allCountries
          .where((c) => c != correct && c.language != correct.language)
          .toList()
        ..shuffle(_rng);
    } else {
      pool = allCountries.where((c) => c != correct).toList()..shuffle(_rng);
    }
    final wrongs = pool.take(3).toList();
    final options = [...wrongs, correct]..shuffle(_rng);
    return _QuizQuestion(
      country: correct,
      options: options,
      correctIndex: options.indexOf(correct),
    );
  }

  // ── State transitions ──

  void _pickMode(QuizMode m) => setState(() => _mode = m);

  void _pickCategory(QuizCategory c) {
    setState(() {
      _category = c;
      _tappedIndex = null;
      _score = 0;
      _total = 0;
      _streak = 0;
      _streakAlive = true;
      _question = _buildQuestion();
    });
  }

  void _nextQuestion() {
    setState(() {
      _tappedIndex = null;
      _question = _buildQuestion();
    });
  }

  void _selectAnswer(int index) {
    if (_tappedIndex != null) return;
    final correct = index == _question.correctIndex;
    setState(() {
      _tappedIndex = index;
      _total++;
      if (correct) {
        _score++;
        if (_mode == QuizMode.solo && _streakAlive) {
          _streak++;
          if (_streak > _bestStreak) _bestStreak = _streak;
        }
      } else if (_mode == QuizMode.solo) {
        _streakAlive = false;
      }
    });
  }

  void _restartStreak() {
    setState(() {
      _streak = 0;
      _streakAlive = true;
      _tappedIndex = null;
      _score = 0;
      _total = 0;
      _question = _buildQuestion();
    });
  }

  void _backToCategories() => setState(() {
        _category = null;
        _score = 0;
        _total = 0;
        _streak = 0;
        _streakAlive = true;
      });

  void _backToModes() => setState(() {
        _mode = null;
        _category = null;
      });

  // ── Build ──

  @override
  Widget build(BuildContext context) {
    final String title;
    if (_category != null) {
      title = _category!.label;
    } else if (_mode != null) {
      title = _mode == QuizMode.teacher ? 'Quiz Me!' : 'My Challenge';
    } else {
      title = 'Quiz';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: _mode != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _category != null ? _backToCategories : _backToModes,
              )
            : null,
        actions: [
          if (_category != null && _mode == QuizMode.solo)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.local_fire_department,
                        color: Colors.deepOrange, size: 22),
                    const SizedBox(width: 4),
                    Text(
                      '$_streak',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 12),
                    Icon(Icons.emoji_events,
                        color: Colors.amber[700], size: 20),
                    const SizedBox(width: 2),
                    Text(
                      '$_bestStreak',
                      style: TextStyle(
                          fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
          if (_category != null && _mode == QuizMode.teacher)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Text('$_score / $_total',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
        ],
      ),
      body: _mode == null
          ? _buildModePicker()
          : _category == null
              ? _buildCategoryPicker()
              : _buildQuestionView(),
    );
  }

  // ── Mode picker ──

  Widget _buildModePicker() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 24),
          const Text('How do you want to play?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center),
          const SizedBox(height: 32),
          _BigModeCard(
            icon: Icons.school,
            title: 'Quiz Me!',
            subtitle: 'You\'re the teacher — quiz your grown-up!',
            color: Colors.orange,
            onTap: () => _pickMode(QuizMode.teacher),
          ),
          const SizedBox(height: 16),
          _BigModeCard(
            icon: Icons.local_fire_department,
            title: 'My Challenge',
            subtitle: 'Test yourself and build a streak!',
            color: Colors.deepPurple,
            onTap: () => _pickMode(QuizMode.solo),
          ),
        ],
      ),
    );
  }

  // ── Category picker ──

  Widget _buildCategoryPicker() {
    final isSolo = _mode == QuizMode.solo;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Text(
            isSolo ? 'Pick your challenge!' : 'You\'re the teacher!',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            isSolo
                ? 'How long a streak can you build?'
                : 'Pick a quiz, then ask your grown-up the questions.',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ...QuizCategory.values.map(
            (cat) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: SizedBox(
                width: double.infinity,
                height: 72,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: cat.color,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  icon: Icon(cat.icon, size: 28),
                  label: Text(cat.label),
                  onPressed: () => _pickCategory(cat),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Question view ──

  Widget _buildQuestionView() {
    final cat = _category!;
    final q = _question;
    final answered = _tappedIndex != null;
    final isSolo = _mode == QuizMode.solo;
    final wasCorrect = _tappedIndex == q.correctIndex;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Streak broken banner (solo only)
          if (isSolo && answered && !wasCorrect && !_streakAlive)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.heart_broken, color: Colors.red),
                  const SizedBox(width: 8),
                  Text(
                    'Streak ended at $_streak!  Best: $_bestStreak',
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                ],
              ),
            ),

          // Prompt
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cat.color.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(
                  _promptText(cat, q.country),
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                // Read the question aloud
                GestureDetector(
                  onTap: () => GreetingService.instance
                      .speak(_promptText(cat, q.country)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.volume_up_rounded,
                          size: 18, color: cat.color),
                      const SizedBox(width: 4),
                      Text('Read aloud',
                          style: TextStyle(
                              fontSize: 13, color: cat.color)),
                    ],
                  ),
                ),
                if (!isSolo) ...[
                  const SizedBox(height: 6),
                  Text('Ask your grown-up, then tap their answer!',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      textAlign: TextAlign.center),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Options
          ...List.generate(q.options.length, (i) {
            final opt = q.options[i];
            final isCorrect = i == q.correctIndex;
            final isTapped = i == _tappedIndex;

            Color? bgColor;
            if (answered) {
              if (isCorrect) {
                bgColor = Colors.green.withValues(alpha: 0.15);
              } else if (isTapped) {
                bgColor = Colors.red.withValues(alpha: 0.15);
              }
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Material(
                color: bgColor ?? Colors.grey.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(14),
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: answered ? null : () => _selectAnswer(i),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    child: Row(
                      children: [
                        if (cat == QuizCategory.flag)
                          CountryFlag.fromCountryCode(
                            opt.isoCode,
                            theme: const ImageTheme(
                              width: 56,
                              height: 38,
                              shape: RoundedRectangle(6),
                            ),
                          )
                        else ...[
                          Expanded(
                            child: Text(_optionText(cat, opt),
                                style: const TextStyle(fontSize: 18)),
                          ),
                          // Read option aloud
                          GestureDetector(
                            onTap: () => GreetingService.instance
                                .speak(_optionText(cat, opt)),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 4),
                              child: Icon(Icons.volume_up_rounded,
                                  size: 20, color: Colors.grey[400]),
                            ),
                          ),
                        ],
                        // Only reveal country name after answering
                        if (cat == QuizCategory.flag && answered)
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: Text(opt.name,
                                  style: const TextStyle(fontSize: 18)),
                            ),
                          )
                        else if (cat == QuizCategory.flag)
                          const Spacer(),
                        if (answered && isCorrect)
                          const Icon(Icons.check_circle,
                              color: Colors.green, size: 28),
                        if (answered && isTapped && !isCorrect)
                          const Icon(Icons.cancel,
                              color: Colors.red, size: 28),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),

          // Post-answer
          if (answered) ...[
            const SizedBox(height: 8),
            Text(
              wasCorrect
                  ? (isSolo ? 'Correct! Streak: $_streak' : 'They got it right!')
                  : (isSolo
                      ? 'Not quite — it\'s ${q.country.capital}.'
                      : 'Oops! Teach them the right answer.'),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: wasCorrect ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 16),

            // Teach / hear greeting
            if (cat == QuizCategory.greeting)
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(200, 50),
                  side: BorderSide(color: cat.color),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.volume_up_rounded),
                label: Text('Say "${q.country.greeting}"',
                    style: TextStyle(fontSize: 16, color: cat.color)),
                onPressed: () =>
                    GreetingService.instance.speakGreeting(q.country),
              ),

            const SizedBox(height: 12),

            // Solo: restart streak if broken, otherwise next
            if (isSolo && !_streakAlive) ...[
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  minimumSize: const Size(200, 56),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                icon: const Icon(Icons.replay),
                label: const Text('New Streak'),
                onPressed: _restartStreak,
              ),
            ] else ...[
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: cat.color,
                  minimumSize: const Size(200, 56),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                icon: const Icon(Icons.arrow_forward_rounded),
                label: const Text('Next Question'),
                onPressed: _nextQuestion,
              ),
            ],

            const SizedBox(height: 8),
            TextButton(
              onPressed: _backToCategories,
              child: const Text('Pick a different quiz'),
            ),
          ],
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ── Helpers ──

  String _promptText(QuizCategory cat, Country country) => switch (cat) {
        QuizCategory.capital => 'What is the capital of ${country.name}?',
        QuizCategory.flag => 'Which flag belongs to ${country.name}?',
        QuizCategory.greeting =>
          'How do you say hello in ${country.language}?\n(${country.name})',
        QuizCategory.language =>
          'What language do they speak in ${country.name}?',
      };

  String _optionText(QuizCategory cat, Country opt) => switch (cat) {
        QuizCategory.capital => opt.capital,
        QuizCategory.flag => opt.name,
        QuizCategory.greeting =>
          '${opt.greeting}  (${opt.greetingPronunciation})',
        QuizCategory.language => opt.language,
      };
}

// ─── Mode card widget ────────────────────────────────────────────────────────

class _BigModeCard extends StatelessWidget {
  const _BigModeCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: 0.10),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Row(
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: color)),
                    const SizedBox(height: 4),
                    Text(subtitle,
                        style:
                            TextStyle(fontSize: 14, color: Colors.grey[600])),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: color, size: 28),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Internal question model ─────────────────────────────────────────────────

class _QuizQuestion {
  const _QuizQuestion({
    required this.country,
    required this.options,
    required this.correctIndex,
  });

  final Country country;
  final List<Country> options;
  final int correctIndex;
}
