import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../models/subdivision.dart';
import '../models/subdivision_data.dart';
import '../widgets/state_flag.dart';

/// The 50 US states with flags.
final List<Subdivision> _usStates = subdivisionsFor('US')!;

enum _Mode { identifyState, pickFlag, speedRound }

class StateFlagChallengeScreen extends StatefulWidget {
  const StateFlagChallengeScreen({super.key});

  @override
  State<StateFlagChallengeScreen> createState() =>
      _StateFlagChallengeScreenState();
}

class _StateFlagChallengeScreenState extends State<StateFlagChallengeScreen> {
  _Mode? _mode;

  // Quiz state
  late _Q _question;
  int? _tappedIndex;
  int _streak = 0;
  int _bestStreak = 0;
  bool _alive = true;
  final _rng = Random();

  // Speed round
  int _speedScore = 0;
  int _speedBest = 0;
  int _secondsLeft = 60;
  Timer? _timer;
  bool _speedActive = false;

  _Q _build() {
    final correct = _usStates[_rng.nextInt(_usStates.length)];
    final pool = _usStates.where((s) => s != correct).toList()..shuffle(_rng);
    final wrongs = pool.take(3).toList();
    final opts = [...wrongs, correct]..shuffle(_rng);
    return _Q(
      correct: correct,
      options: opts,
      correctIndex: opts.indexOf(correct),
    );
  }

  void _pickMode(_Mode m) {
    setState(() {
      _mode = m;
      _streak = 0;
      _alive = true;
      _tappedIndex = null;
      _question = _build();
      if (m == _Mode.speedRound) {
        _speedScore = 0;
        _secondsLeft = 60;
        _speedActive = true;
        _startTimer();
      }
    });
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_secondsLeft <= 1) {
        _timer?.cancel();
        setState(() {
          _speedActive = false;
          _secondsLeft = 0;
          if (_speedScore > _speedBest) _speedBest = _speedScore;
        });
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  void _answer(int i) {
    if (_tappedIndex != null) return;
    final ok = i == _question.correctIndex;

    if (_mode == _Mode.speedRound) {
      // Speed round: instant next question, no reveal
      if (ok) {
        setState(() {
          _speedScore++;
          _question = _build();
        });
      } else {
        // Wrong: flash red briefly, same question
        setState(() => _tappedIndex = i);
        Future.delayed(const Duration(milliseconds: 400), () {
          if (mounted) setState(() => _tappedIndex = null);
        });
      }
      return;
    }

    // Normal modes
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

  void _backToModes() {
    _timer?.cancel();
    setState(() {
      _mode = null;
      _speedActive = false;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_mode == null
            ? 'US State Flags'
            : _mode == _Mode.speedRound
                ? 'Speed Round'
                : _mode == _Mode.identifyState
                    ? 'Name That State'
                    : 'Pick The Flag'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed:
              _mode != null ? _backToModes : () => Navigator.pop(context),
        ),
        actions: [
          if (_mode == _Mode.speedRound && _speedActive)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.timer, color: Colors.deepOrange, size: 20),
                  const SizedBox(width: 4),
                  Text('$_secondsLeft s',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color:
                            _secondsLeft <= 10 ? Colors.red : Colors.black87,
                      )),
                  const SizedBox(width: 12),
                  Text('$_speedScore',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                ]),
              ),
            ),
          if (_mode != null && _mode != _Mode.speedRound)
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
      body: _mode == null ? _modePicker() : _quizView(),
    );
  }

  // ── Mode picker ──

  Widget _modePicker() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 16),
          const Text('🇺🇸 State Flag Challenge',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text('How well do you know the 50 state flags?',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              textAlign: TextAlign.center),
          const SizedBox(height: 32),
          _modeButton(
            icon: Icons.flag,
            title: 'Name That State',
            subtitle: 'See a flag → pick the state',
            color: Colors.blue,
            mode: _Mode.identifyState,
          ),
          const SizedBox(height: 14),
          _modeButton(
            icon: Icons.image_search,
            title: 'Pick The Flag',
            subtitle: 'See a state → pick its flag',
            color: Colors.orange,
            mode: _Mode.pickFlag,
          ),
          const SizedBox(height: 14),
          _modeButton(
            icon: Icons.speed,
            title: 'Speed Round ⚡',
            subtitle: '60 seconds — how many can you get?',
            color: Colors.red,
            mode: _Mode.speedRound,
          ),
          if (_speedBest > 0) ...[
            const SizedBox(height: 16),
            Text('Speed best: $_speedBest',
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w600)),
          ],
        ],
      ),
    );
  }

  Widget _modeButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required _Mode mode,
  }) {
    return Material(
      color: color.withValues(alpha: 0.10),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _pickMode(mode),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: color)),
                    Text(subtitle,
                        style:
                            TextStyle(fontSize: 13, color: Colors.grey[600])),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: color),
            ],
          ),
        ),
      ),
    );
  }

  // ── Quiz view ──

  Widget _quizView() {
    // Speed round: time's up
    if (_mode == _Mode.speedRound && !_speedActive) {
      return _speedResults();
    }

    final q = _question;
    final answered = _tappedIndex != null;
    final isIdentify = _mode == _Mode.identifyState;
    final isSpeed = _mode == _Mode.speedRound;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Streak broken
          if (!isSpeed && answered && _tappedIndex != q.correctIndex && !_alive)
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
              color: (isSpeed ? Colors.red : Colors.blue)
                  .withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                if (isIdentify || isSpeed)
                  // Show the flag, ask for state name
                  StateFlag(
                    flagCode: q.correct.flagCode!,
                    width: 140,
                    height: 93,
                    borderRadius: 10,
                  )
                else
                  // Show state name, ask for flag
                  Text(
                    q.correct.name,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                const SizedBox(height: 10),
                Text(
                  isIdentify || isSpeed
                      ? 'Which state has this flag?'
                      : 'Which flag belongs to this state?',
                  style: TextStyle(fontSize: 15, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Options
          ...List.generate(q.options.length, (i) {
            final opt = q.options[i];
            final isCorrect = i == q.correctIndex;
            final isTapped = i == _tappedIndex;

            Color? bg;
            if (answered) {
              if (isCorrect && !isSpeed) {
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
                  onTap: (answered && !isSpeed) ? null : () => _answer(i),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    child: Row(
                      children: [
                        if (isIdentify || isSpeed)
                          // Text options
                          Expanded(
                            child: Text(opt.name,
                                style: const TextStyle(fontSize: 18)),
                          )
                        else ...[
                          // Flag options
                          StateFlag(
                            flagCode: opt.flagCode!,
                            width: 56,
                            height: 38,
                          ),
                          if (answered)
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 12),
                                child: Text(opt.name,
                                    style: const TextStyle(fontSize: 18)),
                              ),
                            )
                          else
                            const Spacer(),
                        ],
                        if (answered && isCorrect && !isSpeed)
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

          // Post-answer (non-speed)
          if (answered && !isSpeed) ...[
            const SizedBox(height: 8),
            Text(
              _tappedIndex == q.correctIndex
                  ? 'Correct! Streak: $_streak'
                  : 'That\'s ${q.correct.name}.',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _tappedIndex == q.correctIndex
                    ? Colors.green
                    : Colors.red,
              ),
            ),
            const SizedBox(height: 14),
            if (!_alive)
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  minimumSize: const Size(200, 52),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  textStyle: const TextStyle(fontSize: 17),
                ),
                icon: const Icon(Icons.replay),
                label: const Text('New Streak'),
                onPressed: _restart,
              )
            else
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(200, 52),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  textStyle: const TextStyle(fontSize: 17),
                ),
                icon: const Icon(Icons.arrow_forward_rounded),
                label: const Text('Next'),
                onPressed: _next,
              ),
          ],
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ── Speed round results ──

  Widget _speedResults() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.timer_off, size: 60, color: Colors.red),
            const SizedBox(height: 16),
            const Text("Time's up!",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text('You got $_speedScore correct!',
                style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 4),
            Text('Best: $_speedBest',
                style: TextStyle(fontSize: 16, color: Colors.grey[600])),
            const SizedBox(height: 24),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: const Size(200, 56),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                textStyle: const TextStyle(fontSize: 18),
              ),
              icon: const Icon(Icons.replay),
              label: const Text('Try Again'),
              onPressed: () => _pickMode(_Mode.speedRound),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: _backToModes,
              child: const Text('Pick a different mode'),
            ),
          ],
        ),
      ),
    );
  }
}

class _Q {
  const _Q(
      {required this.correct,
      required this.options,
      required this.correctIndex});
  final Subdivision correct;
  final List<Subdivision> options;
  final int correctIndex;
}
