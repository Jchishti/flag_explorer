# Flag Explorer

A world geography learning app built for kids — designed for an 8-year-old who loves flags. Explore every country, learn greetings in dozens of languages, quiz yourself on capitals and flags, color simplified flag outlines, and tap countries on an interactive world map.

Built with Flutter. iOS-first, iPad-friendly.

## Features

### Explore Countries
- **195 countries** across 6 continents with flag, capital, language, native greeting (with phonetic pronunciation), and a fun fact
- **Text-to-speech** audio for "hello" in each country's language via `flutter_tts`
- **Regional organizations** shown per continent: European Union (with flag), African Union, ASEAN, Pacific Islands Forum
- Continent filter chips for quick navigation
- iPad master-detail layout via `LayoutBuilder`

### Quiz Me!
Two play modes:
- **Quiz Me!** — Role reversal: the child is the teacher. They pick a quiz, show questions on screen, and judge the grown-up's answer
- **My Challenge** — Solo streak mode with 🔥 current streak and 🏆 best streak tracking

Four quiz categories:
- **What's the capital?**
- **What's the flag?** (flags only shown, names revealed after answering)
- **How do you say hello?**
- **What language?**

### Subdivisions Deep Dive
- **36 countries** with states/provinces/regions data (~700 total entries)
- Browse any country's subdivisions with capitals
- **US state flags** rendered for all 50 states, **UK nation flags** for England/Scotland/Wales/Northern Ireland
- **Per-country streak quiz**: "What's the capital of California?" with 4 options
- US and UK also have a **flag quiz** variant for their subdivisions

Countries with subdivision data: US, Canada, UK, Australia, India, Mexico, Brazil, Germany, France, China, Japan, Russia, South Korea, Spain, Italy, Nigeria, Pakistan, South Africa, Egypt, Indonesia, Turkey, Thailand, Philippines, Argentina, Colombia, Peru, Chile, Poland, Ukraine, Sweden, Austria, Switzerland, Netherlands, New Zealand, Vietnam, Malaysia, Iran.

### Flag Coloring
- **20 simplified flag templates** (tricolors, bicolors, cross flags, circle flags)
- Tap-to-fill `CustomPainter` canvas with 12-color palette
- Reference flag shown for guidance
- Undo and clear buttons

### World Map
- Interactive pan/zoom world map via `interactive_world_map` package (no API key required)
- Continent zoom chips for quick navigation
- Tap any country → bottom sheet with flag, capital, language, greeting, audio button, and fun fact

## Tech Stack

- **Flutter 3.41.5** / Dart 3.11.3
- **country_flags** — SVG flags from ISO country codes (including US state and UK nation flags)
- **flutter_tts** — Text-to-speech in 40+ languages
- **interactive_world_map** — Pre-generated world map with country hit-testing
- **shared_preferences** — Local persistence
- Vanilla `StatefulWidget` state management (no external state library)

## Project Structure

```
lib/
├── main.dart
├── models/
│   ├── country.dart              # Country + Continent models
│   ├── country_data.dart         # 195 countries with full data
│   ├── flag_template.dart        # Flag coloring template model
│   ├── flag_templates_data.dart  # 20 flag coloring templates
│   ├── regional_org.dart         # EU, AU, ASEAN, PIF
│   ├── subdivision.dart          # Subdivision model
│   └── subdivision_data.dart     # 36 countries, ~700 subdivisions
├── screens/
│   ├── country_detail_screen.dart
│   ├── explore_screen.dart
│   ├── flag_coloring_screen.dart
│   ├── home_screen.dart
│   ├── quiz_screen.dart
│   ├── subdivision_quiz_screen.dart
│   ├── subdivisions_screen.dart
│   └── world_map_screen.dart
├── services/
│   └── greeting_service.dart     # TTS singleton
└── widgets/
    ├── country_card.dart
    └── flag_canvas.dart          # CustomPainter for flag coloring
```

## Running

```bash
flutter pub get
flutter run
```

For iOS device deployment:
```bash
flutter run --release -d <device-id>
```

## License

MIT
