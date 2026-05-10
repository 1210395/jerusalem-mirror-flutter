import 'package:flutter/material.dart';
import '../app_state.dart';
import '../theme.dart';
import '../widgets/glass_panel.dart';
import '../widgets/heritage_app_bar.dart';
import '../widgets/heritage_bottom_nav.dart';

class WelcomeScreen extends StatefulWidget {
  final AppState appState;

  const WelcomeScreen({super.key, required this.appState});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = widget.appState.locale == 'ar';
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: HeritageAppBar(appState: widget.appState),
      bottomNavigationBar: const HeritageBottomNav(activeIndex: 0),
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.2,
            colors: [
              Color(0xFF1F2111),
              HeritageColors.background,
              Color(0xFF0E0F03),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(),
              // Mirror frame: split-screen "You Now / You in History"
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                height: size.height * 0.42,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: HeritageColors.primaryContainer.withOpacity(0.3),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: HeritageColors.primaryContainer.withOpacity(0.15),
                      blurRadius: 30,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Row(
                    children: [
                      Expanded(child: _mirrorHalf(context, isPast: false)),
                      AnimatedBuilder(
                        animation: _controller,
                        builder: (_, __) => Container(
                          width: 2,
                          decoration: BoxDecoration(
                            color: HeritageColors.primaryContainer,
                            boxShadow: [
                              BoxShadow(
                                color: HeritageColors.primaryContainer.withOpacity(
                                  0.4 + 0.4 * _controller.value,
                                ),
                                blurRadius: 16,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(child: _mirrorHalf(context, isPast: true)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                isArabic ? 'المرآة الزمنية' : 'TEMPORAL MIRROR',
                style: HeritageTheme.displayHero(context, vhFactor: 0.045),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  isArabic
                      ? 'ادخل إلى تاريخ القدس الحي'
                      : "Step Into Jerusalem's Living History",
                  style: HeritageTheme.headlineMd(context),
                  textAlign: TextAlign.center,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => widget.appState.goToScreen(1),
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (_, __) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 56,
                      vertical: 18,
                    ),
                    decoration: BoxDecoration(
                      color: HeritageColors.primaryContainer,
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: [
                        BoxShadow(
                          color: HeritageColors.primaryContainer.withOpacity(
                            0.3 + 0.3 * _controller.value,
                          ),
                          blurRadius: 30,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Text(
                      isArabic ? 'ابدأ الرحلة' : 'START THE JOURNEY',
                      style: TextStyle(
                        color: HeritageColors.onPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.touch_app,
                    size: 14,
                    color: HeritageColors.primary.withOpacity(0.5),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isArabic ? 'انقر للبدء' : 'Tap to Begin Experience',
                    style: HeritageTheme.labelCaps(context, vhFactor: 0.011)
                        .copyWith(
                      color: HeritageColors.primary.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _mirrorHalf(BuildContext context, {required bool isPast}) {
    final label = isPast
        ? (widget.appState.locale == 'ar' ? 'في التاريخ' : 'YOU IN HISTORY')
        : (widget.appState.locale == 'ar' ? 'الآن' : 'YOU NOW');
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isPast
                  ? [
                      const Color(0xFF3A2814),
                      const Color(0xFF1B1D0E),
                    ]
                  : [
                      const Color(0xFF2A2B1B),
                      const Color(0xFF131407),
                    ],
            ),
          ),
        ),
        Center(
          child: Icon(
            isPast ? Icons.checkroom : Icons.person_outline,
            size: 80,
            color: HeritageColors.primaryContainer.withOpacity(0.3),
          ),
        ),
        Positioned(
          top: 16,
          left: 16,
          right: 16,
          child: GlassPanel(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: HeritageTheme.labelCaps(context, vhFactor: 0.013),
            ),
          ),
        ),
      ],
    );
  }
}
