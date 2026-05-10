import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import '../app_state.dart';
import '../data/costumes.dart';
import '../services/fal_ai.dart';
import '../theme.dart';
import '../widgets/glass_panel.dart';
import '../widgets/heritage_app_bar.dart';

class ProcessingScreen extends StatefulWidget {
  final AppState appState;

  const ProcessingScreen({super.key, required this.appState});

  @override
  State<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends State<ProcessingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _spin;
  int _statusIndex = 0;
  Timer? _statusTimer;
  String? _error;

  static const _statusesEn = [
    'Mapping your posture to historical silhouettes…',
    'Weaving Tatreez patterns into the digital mirror…',
    'Aligning era textures and lighting…',
    'Rendering your reflection across time…',
  ];
  static const _statusesAr = [
    'نقوم برسم وضعيتك بناءً على صور تاريخية…',
    'ننسج زخارف التطريز في المرآة الرقمية…',
    'نوائم بين الإضاءة وملمس الحقبة…',
    'نعرض انعكاسك عبر الزمن…',
  ];

  @override
  void initState() {
    super.initState();
    _spin = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat();
    _statusTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!mounted) return;
      setState(() {
        _statusIndex = (_statusIndex + 1) % _statusesEn.length;
      });
    });
    _startGeneration();
  }

  Future<void> _startGeneration() async {
    final c = widget.appState.selectedCostume;
    final photo = widget.appState.capturedPhotoPath;
    if (c == null || photo == null) {
      _bounceBack();
      return;
    }

    try {
      final bytes = await File(photo).readAsBytes();
      final base64Image = 'data:image/jpeg;base64,${base64Encode(bytes)}';

      final basePrompt = widget.appState.gender == 'female'
          ? c.aiPromptFemale
          : c.aiPromptMale;
      final prompt =
          'Transform the person in the photo into $basePrompt, set against ${c.aiBackground}. '
          'Cinematic museum-quality lighting, photorealistic, preserve facial features.';

      final url = await FalAiClient.generateImage(
        imageBase64: base64Image,
        prompt: prompt,
      );
      if (!mounted) return;
      widget.appState.generatedImageUrl = url;
      // Brief delay so the user sees the final status text.
      await Future.delayed(const Duration(milliseconds: 800));
      if (!mounted) return;
      widget.appState.goToScreen(6);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
    }
  }

  void _bounceBack() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => widget.appState.goToScreen(2),
    );
  }

  @override
  void dispose() {
    _spin.dispose();
    _statusTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = widget.appState.locale == 'ar';
    final statuses = isArabic ? _statusesAr : _statusesEn;

    return Scaffold(
      appBar: HeritageAppBar(
        appState: widget.appState,
        subtitle: isArabic ? 'المعالجة' : 'STEP 09: HERITAGE WEAVE',
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            radius: 1,
            colors: [
              Color(0xFF1F2111),
              HeritageColors.background,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Rotating compass-like ring
              SizedBox(
                width: 200,
                height: 200,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    RotationTransition(
                      turns: _spin,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: HeritageColors.primaryContainer
                                .withOpacity(0.4),
                            width: 2,
                          ),
                          gradient: SweepGradient(
                            colors: [
                              Colors.transparent,
                              HeritageColors.primaryContainer.withOpacity(0.6),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.account_balance,
                      size: 64,
                      color: HeritageColors.primaryContainer,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: GlassPanel(
                    borderColor: HeritageColors.accent,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Icon(Icons.error_outline,
                            color: HeritageColors.accentLight),
                        const SizedBox(height: 8),
                        Text(
                          isArabic
                              ? 'تعذّر إنشاء الصورة'
                              : 'Generation failed',
                          style: HeritageTheme.headlineMd(context),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _error!,
                          textAlign: TextAlign.center,
                          style: HeritageTheme.body(context, vhFactor: 0.014),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            setState(() => _error = null);
                            _startGeneration();
                          },
                          child: Text(isArabic ? 'إعادة المحاولة' : 'Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: Text(
                      statuses[_statusIndex],
                      key: ValueKey(_statusIndex),
                      style: HeritageTheme.headlineMd(context),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
