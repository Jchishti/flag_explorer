import 'package:flutter_tts/flutter_tts.dart';

import '../models/country.dart';

class GreetingService {
  GreetingService._();

  static final GreetingService instance = GreetingService._();

  final FlutterTts _tts = FlutterTts();
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    await _tts.setIosAudioCategory(
      IosTextToSpeechAudioCategory.playback,
      [IosTextToSpeechAudioCategoryOptions.mixWithOthers],
    );
    await _tts.setSpeechRate(0.45); // Slower for a child to hear clearly
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);
    _initialized = true;
  }

  /// Speaks the greeting for [country] in its native locale.
  Future<void> speakGreeting(Country country) async {
    await init();
    await _tts.setLanguage(country.ttsLocale);
    await _tts.speak(country.greeting);
  }

  /// Speaks arbitrary [text] in the given [locale].
  Future<void> speak(String text, {String locale = 'en'}) async {
    await init();
    await _tts.setLanguage(locale);
    await _tts.speak(text);
  }

  Future<void> stop() async {
    await _tts.stop();
  }
}
