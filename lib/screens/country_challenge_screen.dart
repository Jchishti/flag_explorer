import 'dart:math';

import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';

import '../models/country.dart';
import '../models/country_data.dart';
import '../services/player_service.dart';

// ─── Medal logic ─────────────────────────────────────────────────────────────

enum Medal { none, bronze, silver, gold }

Medal medalFor(int score) {
  if (score >= 5) return Medal.gold;
  if (score >= 4) return Medal.silver;
  if (score >= 3) return Medal.bronze;
  return Medal.none;
}

String medalEmoji(Medal m) => switch (m) {
      Medal.gold => '🥇',
      Medal.silver => '🥈',
      Medal.bronze => '🥉',
      Medal.none => '',
    };

String _medalKey(String iso) => 'medal_$iso';

Medal _savedMedal(String iso) {
  final v = PlayerService.instance.bestFor(_medalKey(iso));
  if (v >= 5) return Medal.gold;
  if (v >= 4) return Medal.silver;
  if (v >= 3) return Medal.bronze;
  return Medal.none;
}

// ─── Challenge picker (continent → country grid) ─────────────────────────────

class CountryChallengeScreen extends StatefulWidget {
  const CountryChallengeScreen({super.key});

  @override
  State<CountryChallengeScreen> createState() => _CountryChallengeScreenState();
}

class _CountryChallengeScreenState extends State<CountryChallengeScreen> {
  Continent _continent = Continent.africa;

  @override
  Widget build(BuildContext context) {
    final countries = countriesFor(_continent);
    final totalGold =
        countries.where((c) => _savedMedal(c.isoCode) == Medal.gold).length;
    final totalMedals =
        countries.where((c) => _savedMedal(c.isoCode) != Medal.none).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Country Challenge'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 14),
              child: Text(
                '🥇 $totalGold / ${countries.length}',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Continent picker
          SizedBox(
            height: 52,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              scrollDirection: Axis.horizontal,
              itemCount: Continent.values.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final c = Continent.values[i];
                final isActive = c == _continent;
                return FilterChip(
                  selected: isActive,
                  label: Text('${c.emoji} ${c.label}',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight:
                              isActive ? FontWeight.bold : FontWeight.normal)),
                  selectedColor: c.color.withValues(alpha: 0.25),
                  checkmarkColor: c.color,
                  onSelected: (_) => setState(() => _continent = c),
                );
              },
            ),
          ),

          // Stats
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Text(
              '$totalMedals of ${countries.length} completed',
              style: TextStyle(fontSize: 13, color: Colors.grey[500]),
            ),
          ),

          // Country grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 120,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.85,
              ),
              itemCount: countries.length,
              itemBuilder: (_, i) {
                final c = countries[i];
                final medal = _savedMedal(c.isoCode);
                return _CountryTile(
                  country: c,
                  medal: medal,
                  onTap: () => _startChallenge(c),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _startChallenge(Country country) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _ChallengeQuizScreen(country: country),
      ),
    );
    setState(() {}); // Refresh medals
  }
}

class _CountryTile extends StatelessWidget {
  const _CountryTile({
    required this.country,
    required this.medal,
    required this.onTap,
  });

  final Country country;
  final Medal medal;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: medal == Medal.gold
          ? Colors.amber.withValues(alpha: 0.12)
          : medal != Medal.none
              ? country.continent.color.withValues(alpha: 0.06)
              : Colors.grey.withValues(alpha: 0.04),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CountryFlag.fromCountryCode(
                country.isoCode,
                theme: const ImageTheme(
                  width: 44,
                  height: 30,
                  shape: RoundedRectangle(4),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                country.name,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (medal != Medal.none)
                Text(medalEmoji(medal), style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Challenge quiz (5 questions about one country) ──────────────────────────

enum _QType { capital, flag, language, greeting, continent }

class _ChallengeQuizScreen extends StatefulWidget {
  const _ChallengeQuizScreen({required this.country});
  final Country country;

  @override
  State<_ChallengeQuizScreen> createState() => _ChallengeQuizScreenState();
}

class _ChallengeQuizScreenState extends State<_ChallengeQuizScreen> {
  final _rng = Random();
  late List<_CQ> _questions;
  int _current = 0;
  int _score = 0;
  int? _tappedIndex;
  bool _finished = false;

  @override
  void initState() {
    super.initState();
    _questions = _generateQuestions();
  }

  List<_CQ> _generateQuestions() {
    final c = widget.country;
    final others = allCountries.where((x) => x != c).toList()..shuffle(_rng);

    List<String> pick3(String Function(Country) extract) {
      final seen = <String>{extract(c)};
      final result = <String>[];
      for (final o in others) {
        final v = extract(o);
        if (!seen.contains(v)) {
          seen.add(v);
          result.add(v);
          if (result.length == 3) break;
        }
      }
      return result;
    }

    // Q1: Capital
    final capWrongs = pick3((x) => x.capital);
    final capOpts = [...capWrongs, c.capital]..shuffle(_rng);

    // Q2: Flag (show 4 flags, pick the right one)
    final flagWrongs = others.take(3).map((x) => x.isoCode).toList();
    final flagOpts = [...flagWrongs, c.isoCode]..shuffle(_rng);

    // Q3: Language
    final langWrongs = pick3((x) => x.language);
    final langOpts = [...langWrongs, c.language]..shuffle(_rng);

    // Q4: Greeting
    final greetWrongs = pick3((x) => x.greeting);
    final greetOpts = [...greetWrongs, c.greeting]..shuffle(_rng);

    // Q5: Continent
    final contOpts = Continent.values.map((x) => x.label).toList()
      ..shuffle(_rng);

    return [
      _CQ(
        type: _QType.capital,
        question: 'What is the capital of ${c.name}?',
        options: capOpts,
        correctIndex: capOpts.indexOf(c.capital),
      ),
      _CQ(
        type: _QType.flag,
        question: 'Which flag belongs to ${c.name}?',
        options: flagOpts,
        correctIndex: flagOpts.indexOf(c.isoCode),
      ),
      _CQ(
        type: _QType.language,
        question: 'What language do they speak in ${c.name}?',
        options: langOpts,
        correctIndex: langOpts.indexOf(c.language),
      ),
      _CQ(
        type: _QType.greeting,
        question: 'How do you say hello in ${c.name}?',
        options: greetOpts,
        correctIndex: greetOpts.indexOf(c.greeting),
      ),
      _CQ(
        type: _QType.continent,
        question: 'Which continent is ${c.name} in?',
        options: contOpts,
        correctIndex: contOpts.indexOf(c.continent.label),
      ),
    ];
  }

  void _answer(int i) {
    if (_tappedIndex != null) return;
    setState(() {
      _tappedIndex = i;
      if (i == _questions[_current].correctIndex) _score++;
    });
  }

  void _next() {
    if (_current >= 4) {
      // Save medal
      PlayerService.instance.recordStreak(_medalKey(widget.country.isoCode), _score);
      setState(() => _finished = true);
      return;
    }
    setState(() {
      _current++;
      _tappedIndex = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.country.continent.color;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.country.name),
        backgroundColor: color.withValues(alpha: 0.12),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text('${_current + 1} / 5',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
      body: _finished ? _resultsView(color) : _questionView(color),
    );
  }

  Widget _questionView(Color color) {
    final q = _questions[_current];
    final answered = _tappedIndex != null;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Progress dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (i) {
              Color dotColor;
              if (i < _current) {
                dotColor = Colors.green;
              } else if (i == _current) {
                dotColor = color;
              } else {
                dotColor = Colors.grey.shade300;
              }
              return Container(
                width: 12,
                height: 12,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: dotColor),
              );
            }),
          ),
          const SizedBox(height: 20),

          // Question
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(q.question,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center),
          ),
          const SizedBox(height: 16),

          // Options
          ...List.generate(q.options.length, (i) {
            final isCorrect = i == q.correctIndex;
            final isTapped = i == _tappedIndex;

            Color? bg;
            if (answered) {
              if (isCorrect) {
                bg = Colors.green.withValues(alpha: 0.15);
              } else if (isTapped) {
                bg = Colors.red.withValues(alpha: 0.15);
              }
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Material(
                color: bg ?? Colors.grey.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(14),
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: answered ? null : () => _answer(i),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    child: Row(
                      children: [
                        if (q.type == _QType.flag)
                          CountryFlag.fromCountryCode(
                            q.options[i],
                            theme: const ImageTheme(
                              width: 56,
                              height: 38,
                              shape: RoundedRectangle(6),
                            ),
                          )
                        else
                          Expanded(
                            child: Text(q.options[i],
                                style: const TextStyle(fontSize: 18)),
                          ),
                        if (q.type == _QType.flag) const Spacer(),
                        if (answered && isCorrect)
                          const Icon(Icons.check_circle,
                              color: Colors.green, size: 26),
                        if (answered && isTapped && !isCorrect)
                          const Icon(Icons.cancel,
                              color: Colors.red, size: 26),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),

          if (answered) ...[
            const SizedBox(height: 12),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: color,
                minimumSize: const Size(200, 52),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                textStyle: const TextStyle(fontSize: 17),
              ),
              icon: Icon(_current < 4
                  ? Icons.arrow_forward_rounded
                  : Icons.emoji_events),
              label: Text(_current < 4 ? 'Next' : 'See Results'),
              onPressed: _next,
            ),
          ],
        ],
      ),
    );
  }

  Widget _resultsView(Color color) {
    final medal = medalFor(_score);
    final prevMedal = _savedMedal(widget.country.isoCode);
    final isNew = medal.index > prevMedal.index;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CountryFlag.fromCountryCode(
              widget.country.isoCode,
              theme: const ImageTheme(
                width: 100,
                height: 67,
                shape: RoundedRectangle(10),
              ),
            ),
            const SizedBox(height: 16),
            Text(widget.country.name,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Text(
              '$_score / 5',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: medal == Medal.gold
                    ? Colors.amber[700]
                    : medal != Medal.none
                        ? color
                        : Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            if (medal != Medal.none)
              Text(
                '${medalEmoji(medal)} ${medal.name.toUpperCase()} MEDAL${isNew ? " — NEW!" : ""}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: medal == Medal.gold ? Colors.amber[700] : color,
                ),
              )
            else
              Text('Keep trying! Need 3/5 for bronze.',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600])),
            const SizedBox(height: 24),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: color,
                minimumSize: const Size(200, 52),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                textStyle: const TextStyle(fontSize: 17),
              ),
              icon: const Icon(Icons.replay),
              label: const Text('Try Again'),
              onPressed: () {
                setState(() {
                  _questions = _generateQuestions();
                  _current = 0;
                  _score = 0;
                  _tappedIndex = null;
                  _finished = false;
                });
              },
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Back to countries'),
            ),
          ],
        ),
      ),
    );
  }
}

class _CQ {
  const _CQ({
    required this.type,
    required this.question,
    required this.options,
    required this.correctIndex,
  });
  final _QType type;
  final String question;
  final List<String> options;
  final int correctIndex;
}
