import 'dart:math';

import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';

import '../models/subdivision.dart';

class SubdivisionQuizScreen extends StatefulWidget {
  const SubdivisionQuizScreen({
    super.key,
    required this.countryName,
    required this.subdivisions,
    required this.color,
    required this.hasFlags,
  });

  final String countryName;
  final List<Subdivision> subdivisions;
  final Color color;

  /// Whether subdivisions have flag codes (enables flag quiz category).
  final bool hasFlags;

  @override
  State<SubdivisionQuizScreen> createState() => _SubdivisionQuizScreenState();
}

enum _SubCat { capital, flag }

class _SubdivisionQuizScreenState extends State<SubdivisionQuizScreen> {
  _SubCat? _cat;
  late _Q _question;
  int? _tappedIndex;
  int _streak = 0;
  int _bestStreak = 0;
  bool _alive = true;
  final _rng = Random();

  _Q _build() {
    final subs = widget.subdivisions;
    final correct = subs[_rng.nextInt(subs.length)];
    final pool = subs.where((s) => s != correct).toList()..shuffle(_rng);
    final wrongs = pool.take(3).toList();
    final opts = [...wrongs, correct]..shuffle(_rng);
    return _Q(correct: correct, options: opts, correctIndex: opts.indexOf(correct));
  }

  void _pickCat(_SubCat c) {
    setState(() {
      _cat = c;
      _streak = 0;
      _alive = true;
      _tappedIndex = null;
      _question = _build();
    });
  }

  void _answer(int i) {
    if (_tappedIndex != null) return;
    final ok = i == _question.correctIndex;
    setState(() {
      _tappedIndex = i;
      if (ok && _alive) {
        _streak++;
        if (_streak > _bestStreak) _bestStreak = _streak;
      } else if (!ok) {
        _alive = false;
      }
    });
  }

  void _next() => setState(() {
        _tappedIndex = null;
        _question = _build();
      });

  void _restart() => setState(() {
        _streak = 0;
        _alive = true;
        _tappedIndex = null;
        _question = _build();
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_cat == null
            ? '${widget.countryName} Quiz'
            : '${widget.countryName} — ${_cat == _SubCat.capital ? "Capitals" : "Flags"}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _cat != null
              ? () => setState(() => _cat = null)
              : () => Navigator.pop(context),
        ),
        actions: [
          if (_cat != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.local_fire_department,
                      color: Colors.deepOrange, size: 22),
                  const SizedBox(width: 4),
                  Text('$_streak',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 12),
                  Icon(Icons.emoji_events, color: Colors.amber[700], size: 20),
                  const SizedBox(width: 2),
                  Text('$_bestStreak',
                      style:
                          TextStyle(fontSize: 14, color: Colors.grey[600])),
                ]),
              ),
            ),
        ],
      ),
      body: _cat == null ? _catPicker() : _questionView(),
    );
  }

  Widget _catPicker() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 24),
          Text('${widget.countryName} Deep Dive!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text(
              '${widget.subdivisions.length} states & provinces to learn.',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              textAlign: TextAlign.center),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 72,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: widget.color,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                textStyle: const TextStyle(fontSize: 20),
              ),
              icon: const Icon(Icons.location_city, size: 28),
              label: const Text('Capital Quiz'),
              onPressed: () => _pickCat(_SubCat.capital),
            ),
          ),
          if (widget.hasFlags) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 72,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  textStyle: const TextStyle(fontSize: 20),
                ),
                icon: const Icon(Icons.flag, size: 28),
                label: const Text('Flag Quiz'),
                onPressed: () => _pickCat(_SubCat.flag),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _questionView() {
    final q = _question;
    final answered = _tappedIndex != null;
    final wasCorrect = _tappedIndex == q.correctIndex;
    final isFlag = _cat == _SubCat.flag;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Streak broken
          if (answered && !wasCorrect && !_alive)
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
                  Text('Streak ended at $_streak!  Best: $_bestStreak',
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.red)),
                ],
              ),
            ),

          // Prompt
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: widget.color.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              isFlag
                  ? 'Which flag belongs to ${q.correct.name}?'
                  : 'What is the capital of ${q.correct.name}?',
              style:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),

          // Options
          ...List.generate(q.options.length, (i) {
            final opt = q.options[i];
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
              padding: const EdgeInsets.only(bottom: 12),
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
                        if (isFlag && opt.flagCode != null)
                          CountryFlag.fromCountryCode(
                            opt.flagCode!,
                            theme: const ImageTheme(
                              width: 56,
                              height: 38,
                              shape: RoundedRectangle(6),
                            ),
                          )
                        else
                          Expanded(
                            child: Text(
                              isFlag ? opt.name : opt.capital,
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        if (isFlag && answered)
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: Text(opt.name,
                                  style: const TextStyle(fontSize: 18)),
                            ),
                          )
                        else if (isFlag)
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
                  ? 'Correct! Streak: $_streak'
                  : 'The answer is ${q.correct.capital}.',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: wasCorrect ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 16),
            if (!_alive)
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
                onPressed: _restart,
              )
            else
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: widget.color,
                  minimumSize: const Size(200, 56),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                icon: const Icon(Icons.arrow_forward_rounded),
                label: const Text('Next Question'),
                onPressed: _next,
              ),
          ],
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _Q {
  const _Q({required this.correct, required this.options, required this.correctIndex});
  final Subdivision correct;
  final List<Subdivision> options;
  final int correctIndex;
}
