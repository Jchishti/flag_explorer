import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';

import '../models/flag_template.dart';
import '../models/flag_templates_data.dart';
import '../widgets/flag_canvas.dart';

// ─── Color palette for the child ─────────────────────────────────────────────

const _paletteColors = <Color>[
  Color(0xFFCE1126), // Red
  Color(0xFF002395), // Blue
  Color(0xFF009246), // Green
  Color(0xFFFFD100), // Yellow
  Color(0xFFFF9933), // Orange
  Color(0xFFFFFFFF), // White
  Color(0xFF000000), // Black
  Color(0xFF75AADB), // Sky blue
  Color(0xFF006A4E), // Dark green
  Color(0xFF800080), // Purple
  Color(0xFF005BBB), // Ukraine blue
  Color(0xFF003DA5), // Dutch blue
];

// ─── Flag picker (grid of flags to choose from) ──────────────────────────────

class FlagColoringScreen extends StatefulWidget {
  const FlagColoringScreen({super.key});

  @override
  State<FlagColoringScreen> createState() => _FlagColoringScreenState();
}

class _FlagColoringScreenState extends State<FlagColoringScreen> {
  FlagTemplate? _activeTemplate;

  void _pick(FlagTemplate t) => setState(() => _activeTemplate = t);
  void _back() => setState(() => _activeTemplate = null);

  @override
  Widget build(BuildContext context) {
    if (_activeTemplate != null) {
      return _ColoringView(
        template: _activeTemplate!,
        onBack: _back,
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Color a Flag')),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 180,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.1,
        ),
        itemCount: allFlagTemplates.length,
        itemBuilder: (context, i) {
          final t = allFlagTemplates[i];
          return _FlagPickerCard(template: t, onTap: () => _pick(t));
        },
      ),
    );
  }
}

class _FlagPickerCard extends StatelessWidget {
  const _FlagPickerCard({required this.template, required this.onTap});

  final FlagTemplate template;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CountryFlag.fromCountryCode(
                template.isoCode,
                theme: const ImageTheme(
                  width: 64,
                  height: 44,
                  shape: RoundedRectangle(6),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                template.countryName,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Coloring view ───────────────────────────────────────────────────────────

class _ColoringView extends StatefulWidget {
  const _ColoringView({required this.template, required this.onBack});

  final FlagTemplate template;
  final VoidCallback onBack;

  @override
  State<_ColoringView> createState() => _ColoringViewState();
}

class _ColoringViewState extends State<_ColoringView> {
  late List<Color?> _regionColors;
  Color _selectedColor = _paletteColors.first;
  final List<_UndoEntry> _undoStack = [];

  @override
  void initState() {
    super.initState();
    _regionColors = List.filled(widget.template.regions.length, null);
  }

  void _fillRegion(int index) {
    setState(() {
      _undoStack.add(_UndoEntry(index, _regionColors[index]));
      _regionColors[index] = _selectedColor;
    });
  }

  void _undo() {
    if (_undoStack.isEmpty) return;
    setState(() {
      final entry = _undoStack.removeLast();
      _regionColors[entry.index] = entry.previousColor;
    });
  }

  void _clear() {
    setState(() {
      _undoStack.clear();
      _regionColors = List.filled(widget.template.regions.length, null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack,
        ),
        title: Text('Color: ${widget.template.countryName}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.undo),
            tooltip: 'Undo',
            onPressed: _undoStack.isEmpty ? null : _undo,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Clear all',
            onPressed: _clear,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),

            // ── Reference flag (small, top-right corner) ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    'Reference:',
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 80,
                    child: FlagCanvas(
                      template: widget.template,
                      regionColors: List.filled(
                        widget.template.regions.length,
                        null,
                      ),
                      onRegionTap: (_) {},
                      showOutlinesOnly: true,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // ── Coloring canvas ──
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: FlagCanvas(
                      template: widget.template,
                      regionColors: _regionColors,
                      onRegionTap: _fillRegion,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // ── Color palette ──
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: _paletteColors.map((color) {
                  final isSelected = color == _selectedColor;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedColor = color),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? Colors.blue : Colors.grey.shade400,
                          width: isSelected ? 3 : 1.5,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: Colors.blue.withValues(alpha: 0.3),
                                  blurRadius: 6,
                                  spreadRadius: 1,
                                ),
                              ]
                            : null,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Undo support ────────────────────────────────────────────────────────────

class _UndoEntry {
  const _UndoEntry(this.index, this.previousColor);
  final int index;
  final Color? previousColor;
}
